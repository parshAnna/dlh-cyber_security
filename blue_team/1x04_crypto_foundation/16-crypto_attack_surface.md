# MedDefense Health Systems — Task 16: The Cryptographic Attack Surface

**Project:** 1x04 — Cryptographic Foundation
**Deliverable:** `16-crypto_attack_surface.md`
**Assessment date:** 6 November 2026
**Audience:** James Chen (Deputy CISO), Sarah Park (IT Director), Security Analyst, clinical data owners, Radiology/Biomedical Engineering and DPO
**Status:** Evidence-based attack-surface analysis and proposed controls; **no production exploitation or remediation is claimed**.

## 1. Executive assessment and evidence rules

Six named attack classes are assessed against the **documented MedDefense baseline**, not presumed attacker success. The authoritative sources are [T0's Data Protection Map](0-crypto_inventory.md), [T6's Algorithm Landscape](6-algorithm_landscape.md), the [1x02 triage](../1x02_the_weak_links/16-triage.md), [T15's crypto audit](15-crypto_posture_audit.md) and the [1x03 Risk Register](../1x03_defense_blueprint/10-risk_register.md).

**Interpretation of “Viable Today”:** **Yes** means the described configuration presents a credible **conditional** attack opportunity; it does **not** mean exploitation has occurred or that a specific victim/client would cooperate. **No** means the exact attack premise is not supported by the evidence; a related weakness may still require remediation. `CONFIRMED` means described by the scenario's audit; `CONFIGURED` means a protocol/algorithm is permitted but not necessarily negotiated; `UNVERIFIED` means a required operational precondition was not tested. The production state may have changed after the baseline audit and must be rechecked before closure.

| # | Attack | Viable Today? | MedDefense exposure and evidence confidence | Priority |
|---:|---|---|---|---|
| 1 | TLS Downgrade | **Yes — conditional** | Patient portal permits TLS 1.0; real client fallback/negotiated suites **unverified** (F005/T0). | **Immediate** |
| 2 | Collision Attack (MD5 in Kerberos tickets) | **No — premise incorrect** | RC4-HMAC uses **keyed HMAC-MD5** and an MD4-derived service key; no unkeyed MD5 ticket-authentication collision is established (T0/T6). | **Phase 1** for related legacy authentication |
| 3 | Birthday Attack | **No — not evidenced on a production flow** | Needs an applicable short block cipher/high same-key volume; 3DES/Blowfish negotiation **unverified**. | **Phase 2** inventory; escalate if confirmed |
| 4 | Kerberoasting | **Yes — conditional** | DES/RC4 are enabled in AD; real RC4/DES **issued service tickets**, SPNs and password weakness are **unverified** (F018). | **Phase 1** |
| 5 | On-path / MITM on cleartext channels | **Yes — conditional on path position** | Cleartext DICOM and billing app-to-MySQL path **confirmed**; EHR PostgreSQL accepts non-TLS but actual sessions unverified (F024/F006/F003). | **Immediate** |
| 6 | Key Recovery from Memory on `billing-srv-01` | **No — as a demonstrated AES-key extraction today; conditional if keys exist in RAM** | Billing database at rest is reported **unencrypted**; no loaded AES database key is evidenced. Root compromise can nevertheless read plaintext and any accessible secrets. | **Phase 1** host hardening and future key isolation |

**Critical correction to the assignment premise:** “MD5 in Kerberos tickets” is **not** an identified straightforward MD5 collision attack. RFC 4757 specifies RC4-HMAC Kerberos with **HMAC-MD5** for integrity and an **MD4-based NT password hash** for its long-term key; that is different from using an unkeyed MD5 digest as a collision-resistant digital signature. Kerberoasting is primarily **offline password/key guessing from a service ticket**, not a collision attack. [S1, S2]

## 2. Attack-by-attack assessment

### 2.1 TLS Downgrade — patient portal

- **Attack:** TLS Downgrade (forcing an older TLS version on the patient portal).
- **Mechanism:** An on-path attacker may exploit a client's insecure retry/fallback behavior or legacy protocol handling to make a connection negotiate an older permitted TLS version instead of the strongest mutually supported version. A server that accepts TLS 1.0 retains an obsolete negotiation option, but **server support alone does not prove that a modern client can be forcibly downgraded**; client behavior, protocol protections and negotiated cipher suites matter.
- **MedDefense Vulnerability:** `web-srv-01` patient portal; audit reports **TLS 1.0 and TLS 1.2 enabled, TLS 1.3 disabled**; lack of HSTS and automated certificate renewal adds separate transport/availability concerns.
- **Evidence:** **1x02 Finding 005** (legacy TLS), **Finding 013** (certificate renewal/relative expiry), T0 §Patient Portal (outside its 21-cell grid), T6 GAP-CRYPTO-04, T15 `CRYPTO-019`. No baseline packet capture proves an attacker-triggered downgrade or a particular vulnerable legacy cipher suite.
- **Viable Today:** **Yes (conditional exposure)**: TLS 1.0 is permitted by the reported server configuration, so a susceptible legacy/fallback client could use it; **not proven** against up-to-date browsers or all clinical clients.
- **Mitigation:** After patient-client compatibility checks, enforce **TLS 1.3 (AES-128/256-GCM or ChaCha20-Poly1305)** and approved **TLS 1.2 AEAD** only; **disable TLS 1.0/1.1** and legacy suites on every virtual host/termination tier. Configure HSTS only after HTTPS end-to-end readiness, automate CA-issued certificate renewal and alert on expiry; confirm legacy versions fail and approved clinical workflows succeed, with rollback and Sarah/clinical sign-off.

### 2.2 Collision Attack — alleged MD5 in Kerberos tickets

- **Attack:** Collision Attack (assignment example: exploiting MD5 in Kerberos tickets).
- **Mechanism:** A cryptographic hash collision occurs when two distinct inputs produce the same digest; broken **unkeyed MD5** collision resistance is dangerous where a system relies on it to establish document or signature identity. **Kerberos RC4-HMAC instead uses keyed HMAC-MD5 and a password-derived key**, so showing an ordinary MD5 collision does not forge a Kerberos service ticket or reveal that key.
- **MedDefense Vulnerability:** `ad-dc-01`/`ad-dc-02` permit legacy **RC4/DES Kerberos** and retain **MD4 NT hashes** for NTLM compatibility; the scenario **does not** identify an unkeyed MD5 ticket-signing/checksum validation path vulnerable to known collision techniques.
- **Evidence:** T0 §Credentials, T6 §§4 and 6 (distinguishing MD5, MD4, HMAC-SHA-1 and RC4), **1x02 Finding 018** (legacy Kerberos encryption), **Finding 007** (LDAP signing gap, separate from hash collisions). RFC 4757 documents the HMAC-MD5/MD4 design [S1]; no ticket-collision exploit or actual MD5-signed artifact is evidenced.
- **Viable Today:** **No (as specified).** The MD5-collision-to-ticket-forgery premise is unsupported; **RC4/DES and weak service-account credentials remain separately actionable** under Kerberoasting.
- **Mitigation:** Audit AD service ticket encryption types; phase out **RC4 and DES**, use **AES-128/256 Kerberos** with strong managed service credentials or **gMSAs** where supported, and reduce NTLM dependency after vendor/clinical compatibility testing. Do not misconfigure Windows by trying to replace its native NT hashes with Argon2id; apply Argon2id only to separate custom application passwords and use modern hashes/signatures for content-integrity workflows.

### 2.3 Birthday Attack — short block-size collision risk

- **Attack:** Birthday Attack (theoretical short-block-cipher and generic collision bound).
- **Mechanism:** With uniformly distributed **n-bit outputs**, collisions become likely after roughly **2^(n/2)** samples, not 2^n; the more precise ~50% probability threshold is approximately **1.177 × 2^(n/2)** samples. For a **64-bit block cipher**, 2^32 blocks × 8 bytes = **2^35 bytes ≈ 32 GiB** of data under the same key, making CBC-style collisions a concern in long sessions; **AES has a 128-bit block**, so the comparable approximate threshold is **2^64 blocks (256 EiB)**, vastly larger. [S3, S4]
- **MedDefense Vulnerability:** The portal's TLS 1.0 support makes **legacy-suite discovery important**, but no supplied evidence shows it negotiates **3DES-CBC** or **Blowfish-CBC**; the NAS supports an optional **AES-256-CBC** feature that is disabled, and AES uses 128-bit blocks. Reported VPN **AES-256** does not itself establish a Sweet32-style 64-bit block exposure.
- **Evidence:** T0 §Patient Portal/§Backup Data/§VPN, T6 tables for 3DES/Blowfish/AES and the warning that unverified suites must not be called deployed; F005 confirms TLS 1.0 but **not** 3DES; research reference [S3].
- **Viable Today:** **No confirmed viable Sweet32/birthday exploitation path** because a 64-bit CBC suite and suitable same-key data volume have **not** been established. **Conditional Yes if** a production endpoint actually permits substantial repeated traffic under 3DES/Blowfish-CBC.
- **Mitigation:** Inventory **actually negotiated** TLS/VPN ciphers (not merely protocol versions), eliminate **3DES, DES, Blowfish and 64-bit CBC modes** from protected flows, and prefer TLS 1.3 AEAD; use suitable **AES-XTS** for volume confidentiality and **AES-GCM** for authenticated files/records. Set data/key-use limits and rekey policies appropriate to the real algorithm; validate vendor compatibility before touching clinical links.

### 2.4 Kerberoasting — offline service-ticket password guessing

- **Attack:** Kerberoasting exploiting Kerberos RC4/DES and weak service-account secrets.
- **Mechanism:** A domain-authenticated attacker can request legitimate service tickets for SPN-backed service accounts and analyze ticket ciphertext **offline**, trying candidate passwords until a matching key is found. RC4 service-ticket keys derive directly from NT hashes and are especially attractive for password guessing; **AES Kerberos reduces the specific RC4 exposure but does not make guessable service passwords safe**.
- **MedDefense Vulnerability:** Active Directory on `ad-dc-01`/`ad-dc-02` reportedly allows **RC4 and DES** alongside AES, with broader shared-identity and authentication governance weaknesses (GAP-011); a successful attack still requires suitable service principal names, issued ticket types and crackable passwords.
- **Evidence:** **1x02 Finding 018** (legacy Kerberos types), **Finding 007** (adjacent LDAP/AD hardening), T0 §Credentials, T6 GAP-CRYPTO-01/02/03; **1x03 RISK-002** (domain compromise and lateral movement). Microsoft documents RC4 risk and event **4769** monitoring [S2].
- **Viable Today:** **Yes (conditional)** as a credible threat path in the documented AD configuration; no ticket extraction, password cracking, compromised account or confirmed RC4/DES service-ticket issuance is claimed.
- **Mitigation:** Inventory **SPNs** and domain controller events **4769/4768** for actual encryption types; use **gMSAs** or long random automatically rotated service passwords, minimum service privilege, strong account controls and monitoring of unusual service-ticket requests. Transition supported services to **AES-128/256**, then disable **DES/RC4** with a staged rollback for legacy MRI/clinical/vendor dependencies; review privileged access, MFA and segmentation to constrain lateral movement.

### 2.5 On-path / Man-in-the-Middle — unencrypted medical and SQL traffic

- **Attack:** On-path/MITM, passive eavesdropping and active alteration of unencrypted channels.
- **Mechanism:** An attacker positioned on the same network path can observe application payloads when no authenticated channel encryption is present; without effective message/channel authentication, the attacker may also alter or relay data. This requires a **network-path foothold or routing/interception capability**; an exposed port or a permissive TLS setting alone does not prove such access.
- **MedDefense Vulnerability:** `pacs-srv-01` receives **plaintext DICOM** images/identifying headers over **TCP 4242/11112**; `billing-srv-01` MySQL app-to-DB connections are documented **plaintext** with SSL not required; `ehr-db-01` has both PostgreSQL `hostssl` and `hostnossl` entries, allowing non-TLS sessions **without proving which actual sessions are cleartext**.
- **Evidence:** **1x02 Finding 024** (DICOM cleartext), **Finding 006** (MySQL network reachability, adjacent to separate audit confirmation of plaintext), **Finding 003** (broad PostgreSQL access, adjacent to T0 optional TLS); T0 §§Medical Images/Financial Data/Patient Data; T6 GAP-CRYPTO-05/06/07; **RISK-003, RISK-008 and RISK-001** (related consequences, not proof of interception).
- **Viable Today:** **Yes (conditional on obtaining an on-path vantage point)** for the documented plaintext DICOM and billing paths. For EHR, **non-TLS is permitted**, but actual downgrade, session usage and capture remain **unverified**.
- **Mitigation:** Enable **vendor-approved DICOM over TLS 1.2/1.3** with peer authentication/certificate validation, preserving MRI/PACS compatibility and patient safety; **require authenticated TLS** for MySQL (supported server/client configuration, certificate validation) and PostgreSQL (`hostssl`-only approved identities, `sslmode=verify-full` for clients). Restrict database/PACS source IPs and VLAN routes, monitor failures, and verify that approved application workflows pass while **plaintext attempts fail**, using synthetic data and clinical/Biomedical change approval.

### 2.6 Key Recovery from Memory — hypothetical root on billing server

- **Attack:** Key Recovery from Memory after root compromise of `billing-srv-01`.
- **Mechanism:** A sufficiently privileged attacker may inspect a running process's address space, memory dumps or accessible secret material and obtain **keys actually present in software memory**, even if those keys were encrypted on disk. Hardware-backed KMS/HSM can keep **non-exportable master keys** off-host, but a compromised authorized workload may still request decryption or obtain **plaintext/temporary data keys**; an HSM does not make a root-compromised application safe.
- **MedDefense Vulnerability:** The baseline says `billing-srv-01` has **unencrypted MySQL files** and a plaintext billing database connection; **no AES database-at-rest key or live key bytes have been observed**. Root compromise is plausible in the broader threat model (1x02 **F001/F002** software exposures), but it is not a verified event and the attacker could read billing data directly even without recovering an AES key.
- **Evidence:** T0 §Financial Data, T6 mode/key discussion, **1x02 Findings 001/002** (billing software exploit chain) and **006** (DB reachability), **1x03 RISK-008** (billing interruption); T13 **Database** encryption target, T14 key-custody plan; key-memory guidance [S5]. No RAM artifact, root shell or successful key extraction is provided.
- **Viable Today:** **No as a demonstrated recovery of a current billing AES-at-rest key** (the record does not establish that such a key exists). **Yes as a general conditional attack** if the adversary obtains root and a reachable process actually holds AES/TLS/backup keys or bearer credentials; current plaintext billing files are already exposed to such a compromise.
- **Mitigation:** Prioritize patching/isolating vulnerable services and least-privilege administration; deploy compatible **MySQL tablespace encryption** plus separate encrypted logical backups; place wrapping/master keys in a **restricted KMS/HSM** with workload identity and separate recovery escrow, **not plaintext on billing-srv-01**. Reduce secret lifetime in RAM, restrict debug/core dumps and swap, monitor anomalous KMS decrypt operations, rotate exposed keys after containment, and test that a compromised application cannot exercise unlimited decrypt authority. These measures **reduce exposure, not eliminate plaintext access after host compromise**.

## 3. Risk mapping and remediation order

| Operational rank | Attack surface / target | Risk Register relationship | Required verification and closure evidence | Accountable delivery and gate |
|---:|---|---|---|---|
| **1 — Immediate** | Plaintext **DICOM / billing SQL** (Attack 5) | **RISK-003** PACS clinical continuity; **RISK-008** billing ransomware; EHR optional TLS adjacent **RISK-001** | Vendor-safe captured handshake metadata, approved TLS tests, rejected plaintext clients, authenticated clinical imaging and billing regression tests. | **Sarah Park**; Radiology/Biomedical, clinical owner and DPO consulted. |
| **2 — Immediate** | **Patient portal TLS 1.0** (Attack 1) | Patient confidentiality/availability relevant to EHR/portal workflows; **no unique portal Risk Register ID is invented** | Verified real protocol negotiation and certificate chain; legacy-version rejection, TLS 1.2/1.3 success, 800-patient compatibility and renewal/rollback test. | Sarah/web owner with **James Chen** security oversight and clinical approval. |
| **3 — Phase 1** | **RC4/DES service accounts** (Attack 4; related concern in Attack 2) | **RISK-002** VPN/AD compromise (ALE $2,864,400/year is a compound *classroom* scenario, not Kerberoasting-only ALE) | Service-ticket enctypes in 4769, SPN inventory, managed passwords, blocked weak types and valid clinical/vendor service logons. | Sarah/AD team; James Security; Biomedical for legacy dependencies. |
| **4 — Phase 1** | **Billing root/keys in RAM** (Attack 6) | **RISK-008** ($135,143/year classroom billing-outage ALE, not key-theft ALE) | Host patch/containment evidence, key location map, denied unauthorized KMS unwrap, secure backup+restore and controlled memory/swap policy. | Sarah/DB owner; **Robert Kim** consulted on continuity. |
| **5 — Phase 2** | **64-bit CBC inventory** (Attack 3) | No currently established separate Sweet32 Risk Register event | Cipher negotiation inventory; no approved 3DES/Blowfish-CBC; approved AEAD/key-lifetime policy. | Sarah/network/PKI; Biomedical for unsupported endpoints. |

**Economic integrity:** The RISK-001 EHR ALE of **$3,025,000/year**, RISK-002 combined VPN ALE **$2,864,400/year**, and RISK-008 billing ALE **$135,143/year** come from 1x03 scenario modeling. They are uncertain, **overlapping in part**, and must **not** be added or represented as savings specifically attributable to a cryptographic configuration fix. Attack feasibility and clinical urgency are not inferred solely from ALE. [T5/T6 in 1x03]

## 4. Safe validation protocol and residual-risk rules

1. **Before touching production:** Sarah obtains a dated configuration snapshot, asset/traffic owner, change window, tested rollback and clinical/Biomedical sign-off where required. Do not intentionally negotiate insecure patient sessions or intercept actual PHI without a formally approved test plan.
2. **Portal:** Confirm TLS 1.0 is enabled on the *current* termination endpoint, inventory negotiated cipher suites with controlled clients, verify certificate issuance/renewal, stage hardened TLS and retain only permitted versions after compatibility tests.
3. **Directory:** Review event **4769** and service-account encryption settings for RC4/DES actually issued; assess service-account password lifecycle and legacy device dependencies **without extracting or cracking live staff tickets**.
4. **Network:** Inventory DICOM, MySQL and PostgreSQL pathways; verify TLS/certificate requirements in a staging or authorized test path with synthetic data, ensure plain client connection attempts are refused, and measure clinical throughput/availability.
5. **Billing host:** Conduct a configuration and authorized memory-secret handling review **without dumping patient/financial secrets**, inventory which keys/services are resident, and validate KMS access-policy denials and recovery with synthetic ciphertext.
6. **Close findings only on evidence:** Log configuration, observed cipher/protocol, denial and positive-use tests, owner signatures, key custody and restore proof; update T0/T6/T15 and the 1x03 Risk Register. Document remaining approved legacy exceptions with expiry and compensating controls.

**Residual risk:** Strong AES-XTS/TDE protects stolen offline media but not an unlocked root-compromised server; AES-GCM/TLS protects network contents but not an authorized malicious endpoint or application; KMS/HSM reduces key export but cannot universally prevent decryption under an abused authorized identity. Segmentation, credential hardening, least privilege, monitoring, immutable backups and clinical-safe recovery remain required.

## 5. Evidence and reference index

**MedDefense primary project sources (baseline, not live retesting):**

- [T0 — Data Protection Map](0-crypto_inventory.md): matrix and audit-source distinctions; confirmed portal TLS 1.0, AD RC4/DES permissions, plaintext billing SQL/DICOM and unencrypted billing files.
- [T6 — Algorithm Landscape](6-algorithm_landscape.md): legacy cipher/hash assessment, TLS 1.0 PRF versus Kerberos HMAC, 64-bit versus 128-bit block size, no assumed 3DES deployments.
- [T15 — Crypto Posture Audit](15-crypto_posture_audit.md): `CRYPTO-004/005/006` (billing), `CRYPTO-008` (DICOM), `CRYPTO-011` (AD), `CRYPTO-019` (portal), and evidence-dependent remediation gates.
- [1x02 — Vulnerability Triage](../1x02_the_weak_links/16-triage.md): F001/002, F003, F005, F006, F007, F013, F018 and F024 as **direct or adjacent** evidence as labeled above.
- [1x03 — Risk Register](../1x03_defense_blueprint/10-risk_register.md), [Risk Equation](../1x03_defense_blueprint/5-risk_equation.md): RISK-001/002/003/008 and non-additive ALE assumptions.
- [T13 — Encryption Levels](13-encryption_levels.md), [T14 — Key Management](14-key_management.md): recommended Database/Volume/File/Record protection and KMS/HSM key lifecycle, **not deployed state**.

**Published technical references (not evidence that MedDefense was attacked):**

- **[S1]** [RFC 4757 — The RC4-HMAC Kerberos Encryption Types](https://www.rfc-editor.org/rfc/rfc4757): RC4 key derived through MD4 NT hash; HMAC-MD5 for RC4 Kerberos integrity; not an ordinary unkeyed MD5 ticket collision.
- **[S2]** [Microsoft — Detect and Remediate RC4 Usage in Kerberos](https://learn.microsoft.com/en-us/windows-server/security/kerberos/detect-remediate-rc4-kerberos): event 4768/4769, RC4 usage and safe migration.
- **[S3]** [Sweet32 research — Birthday attacks on 64-bit block ciphers](https://sweet32.info/): 2^32-block issue with 64-bit block ciphers under repeated same-key encryption, required attack preconditions.
- **[S4]** [RFC 8996 — Deprecating TLS 1.0 and 1.1](https://www.rfc-editor.org/rfc/rfc8996): prohibition of TLS 1.0/1.1 negotiation, AEAD modern alternatives, downgrade concern.
- **[S5]** [OWASP — Key Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Key_Management_Cheat_Sheet.html): protection and zeroization of keys in memory, avoiding plaintext keys on the host.

## 6. Review status

| Reviewer | Acceptance responsibility | Status |
|---|---|---|
| James Chen — Deputy CISO | Attack reasoning, risk priority, incident ownership | **Pending** |
| Sarah Park — IT Director | Configuration evidence, technical feasibility, rollback and validation | **Pending** |
| EHR/PACS owners + Biomedical Engineering | Clinical workflows, vendor support and safe commissioning | **Pending** |
| DPO / Legal | PHI handling, lawful testing and breach obligations | **Pending** |

**Final scope boundary:** All six requested attacks have explicit **Attack, Mechanism, MedDefense Vulnerability, Evidence, Viable Today and Mitigation** fields. No offensive exploit, successful interception, Kerberos ticket crack, MD5 ticket forgery, root access or AES-key extraction is asserted as observed.
