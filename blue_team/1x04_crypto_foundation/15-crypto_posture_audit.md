# MedDefense Health Systems — Task 15: The Crypto Posture Audit

**Project:** 1x04 — Cryptographic Foundation
**Deliverable:** `15-crypto_posture_audit.md`
**Assessment date:** 6 November 2026
**Audience:** James Chen (Deputy CISO), Sarah Park (IT Director), EHR and Radiology data owners, Robert Kim (CFO), DPO and clinical leadership
**Status:** **Evidence-based baseline assessment and remediation plan — NOT evidence of production remediation.**

## Executive assessment

The authoritative baseline is [Task 0 — Data Protection Map](0-crypto_inventory.md): **7 data categories × 3 states = 21 cells**, comprising **3 Adequate, 3 Weak and 15 Absent**. This audit issues **CRYPTO-001 through CRYPTO-018**, exactly one for every originally Weak/Absent cell. Two VPN cells (CRYPTO-017/018) are **[N/A] bookkeeping placeholders** and are not claimed as real encryption defects. **CRYPTO-019** (patient portal) and **CRYPTO-020** (O365 patient-information message confidentiality) document confirmed, important *out-of-matrix* concerns without altering the 21-cell denominator.

**Posture score — remediation-path coverage:** **16 of 16 applicable Weak/Absent cells (100%) now have an explicit treatment or evidence-validation path**. This measures **plan completeness, not deployed protection**. The initial T0 *adequate protection* score remains **3/21 = 14.29%**; it cannot be increased without real production verification. The adjusted applicable-state denominator is **19 = 21 − 2 VPN N/A cells**; 3 were initially Adequate and 16 required treatment/validation. The two out-of-matrix findings also have documented paths, but are **excluded** from this percentage.

**Most consequential areas:** (1) unencrypted patient EHR storage and optional database TLS, linked to **RISK-001**; (2) unencrypted NAS backup storage and recovery dependency, linked to **RISK-003 / RISK-008**; (3) internet-facing patient portal's legacy TLS and certificate-renewal exposure, **F005/F013** (no direct 1x03 Risk Register row for the portal). Other serious issues include cleartext PACS DICOM transfer (**F024**) and weak AD credentials/protocols (**F007/F018**). Detailed ranking appears at the end.

## 1. Method, mapping rules, priorities and evidence limits

1. **Source of truth:** T0 status, evidence flags and the *same seven row names and three data states* are preserved. `Absent [UNVERIFIED]` means protection is **not evidenced**, not that plaintext or an exploit was proven. Do not convert a finding into a production test result.
2. **References:** `F###` are 1x02 vulnerability findings; `RISK-###` are 1x03 Task 10 register IDs. An **adjacent** reference describes risk context, not proof of the exact encryption defect. Algorithms and security status follow [T6](6-algorithm_landscape.md); encryption layer follows [T13](13-encryption_levels.md); access, rotation and recovery follow [T14](14-key_management.md).
3. **States:** At rest protects media/files; in transit protects links; **in use ordinarily requires plaintext for authorized processing**. Runtime protections are session locking, least privilege, protected key material, endpoint controls, controlled export and memory hygiene, not a fictitious always-encrypted display. AES-XTS provides disk confidentiality **without authenticated integrity**; AES-GCM is authenticated encryption for records, backup objects and supported protocols.
4. **Target algorithm notation:** `AES-256-XTS` means **two independent 256-bit AES keys / 512-bit combined XTS key material** on disk; `AES-256-GCM` means **one 256-bit content-encryption key with unique nonces and authentication tags**. For TLS, specify the supported **TLS 1.3 AES-256-GCM-SHA384** suite where appropriate, or **TLS 1.2 ECDHE + AES-128/256-GCM** after client compatibility tests. Native Microsoft/medical-device protocols may require platform/vendor-supported equivalents; no unsupported algorithm is asserted deployed.
5. **Priority:** **Immediate** = urgent investigation/mitigation and safe planned change for exposed sensitive flows; **Phase 1** = approved core remediation with change/restore testing; **Phase 2** = discovery, runtime governance and hardening. These are proposed sequencing bands, **not a claim of implementation or a mandatory unsafe overnight clinical cutover**.
6. **Ownership and budget:** Sarah is responsible for IT delivery, James for security prioritization and incident leadership, the Security Analyst for verification, EHR/Radiology owners for clinical access/continuity, DPO/Legal for PHI and regulatory review, and CEO/Finance for commitments. The six-month program shares **one $120,000 ceiling**; 1x03's proposed first-year cash portfolio is **$115,000**, not a separate crypto appropriation. Biomedical/vendor approval is required for any change touching medical equipment.

### 1.1 Exact T0-to-finding reconciliation

| T0 data category | At rest | In transit | In use | T0 Adequate cells (not reclassified) |
|---|---|---|---|---|
| Patient medical records (`ehr-db-01`) | CRYPTO-001 Absent | CRYPTO-002 Weak | CRYPTO-003 Absent | — |
| Financial/billing data (`billing-srv-01`) | CRYPTO-004 Absent | CRYPTO-005 Absent | CRYPTO-006 Absent | — |
| Medical images (`pacs-srv-01`) | CRYPTO-007 Absent | CRYPTO-008 Absent | CRYPTO-009 Absent | — |
| Credentials (AD / applications) | CRYPTO-010 Weak | CRYPTO-011 Weak | CRYPTO-012 Absent | — |
| Backup data (`NAS-01`) | CRYPTO-013 Absent | CRYPTO-014 Absent | CRYPTO-015 Absent | — |
| Email (O365) | Adequate | Adequate | CRYPTO-016 Absent | **2** |
| VPN traffic (site-to-site) | CRYPTO-017 Absent [N/A] | Adequate | CRYPTO-018 Absent [N/A] | **1** |
| **State totals** | **5 Absent + 1 Weak + 1 Adequate** | **3 Absent + 2 Weak + 2 Adequate** | **7 Absent** | **3 Adequate overall** |

**Reconciliation:** `5 + 3 + 7 = 15 Absent`; `1 + 2 = 3 Weak`; `1 + 2 = 3 Adequate`; **21 cells total**, including the two VPN N/A placeholders. This matches T0 exactly.

## 2. Part 1 — Crypto findings: every T0 Weak or Absent cell

### CRYPTO-001 — EHR patient records, unencrypted PostgreSQL storage

- **Finding ID:** CRYPTO-001
- **Data Category:** Patient medical records — `ehr-db-01` / `ehr-srv-01`.
- **Data State:** At rest — **Absent [CONFIRMED]**.
- **Current Protection:** None; PostgreSQL 14 data directory resides on unencrypted ext4 in Sarah Park's audit.
- **Vulnerability Reference:** F003 (adjacent excessively broad authenticated network reachability, **not** proof of disk encryption status); T0 Audit §Patient Data directly proves the at-rest gap.
- **Risk Reference:** **RISK-001** (EHR patient-record exfiltration; 1x03 modeled baseline **$3,025,000/year ALE**, conditional on a full breach). RISK-002 is an overlapping possible access path, not additive.
- **Algorithm Assessment:** **No at-rest cipher to assess**; T6 rates AES current, disk AES-XTS appropriate for confidentiality, not as a MAC or protection against authorized SQL queries.
- **Recommended Protection:** Encrypt EHR data, WAL, temporary storage, snapshots and backups with **LUKS2/dm-crypt AES-256-XTS (512-bit combined XTS keys)**; add selective sensitive-field **AES-256-GCM** at the application layer with independent KEKs, if workflow allows.
- **Encryption Level:** **Volume**, complemented by selective **Record** ([T13](13-encryption_levels.md)).
- **Key Management:** T14: LUKS unlock secret outside DB host with dual-controlled offline escrow; application DEKs wrapped by centrally controlled KEK, preferably a pilot HSM-backed KMS; KEK review/rotation annually and rehearsed full database/WAL recovery.
- **Implementation Priority:** **Immediate** — stage encrypted migration, restrict source networks, obtain EHR data-owner/DPO approval.
- **Closure Evidence:** Volume/backup configuration, unauthorized media-read denial, permitted SQL workload, PHI field access tests, isolated full restore and separate key custody.

### CRYPTO-002 — EHR PostgreSQL encryption is optional

- **Finding ID:** CRYPTO-002
- **Data Category:** Patient medical records — application ↔ PostgreSQL.
- **Data State:** In transit — **Weak [CONFIRMED configuration; session usage UNVERIFIED]**.
- **Current Protection:** `ssl=on`, but both `hostssl` and `hostnossl` entries permit protected/unprotected client classes; actual negotiated session inventory absent.
- **Vulnerability Reference:** F003 (broad allowed source range, adjacent); Audit §Patient Data directly evidences permissive TLS.
- **Risk Reference:** **RISK-001** (EHR exfiltration), with overlapping RISK-002 lateral exposure.
- **Algorithm Assessment:** TLS cipher/version used by clients is **unknown**; T6: AES-GCM current, legacy TLS/obsolete suites inappropriate; merely enabling TLS does not require it.
- **Recommended Protection:** Mandatory authenticated **TLS 1.3 / AES-256-GCM-SHA384** where PostgreSQL 14/client versions support it; otherwise hardened **TLS 1.2 ECDHE + AES-128/256-GCM**; restrict `pg_hba.conf` to verified `hostssl` sources, client-side `sslmode=verify-full`, trusted CA and host validation.
- **Encryption Level:** **Transport/session** complementary to T13 **Volume + Record**; six at-rest levels do not substitute for TLS.
- **Key Management:** T14 controlled server TLS private key and certificate renewal, restricted PKI operators, monitor expiration; service identity and CA trust anchored in managed config, not plaintext credentials in repo.
- **Implementation Priority:** **Immediate** after authorized clinical compatibility test.
- **Closure Evidence:** Enumerated active connections and TLS versions; legitimate `verify-full` client works; plaintext/nonapproved client rejected; no care interruption.

### CRYPTO-003 — EHR data in use: screen/session exposure

- **Finding ID:** CRYPTO-003
- **Data Category:** Patient medical records — EHR application and workstations.
- **Data State:** In use — **Absent [confirmed screen-lock setting; broader runtime controls UNVERIFIED]**.
- **Current Protection:** No runtime cryptographic control documented; workstation screen lock configured as **Never**.
- **Vulnerability Reference:** No direct 1x02 crypto finding; GAP-011 and excessive exports (1x00 GAP-017) are contextual.
- **Risk Reference:** **RISK-007** (negligent disclosure) and **RISK-001** (patient-data exposure).
- **Algorithm Assessment:** **N/A** for authorized plaintext on screen/in RAM; neither AES-XTS nor GCM keeps actively displayed records encrypted. T6's authenticated encryption remains relevant for export, not raw screen rendering.
- **Recommended Protection:** Enforce screen/session locking, minimum patient-record access, session timeout, secure browser/endpoints, monitored exports; use **AES-256-GCM** for PHI exported outside the trusted workflow, and **AES-256-XTS** for endpoint swap/media as applicable.
- **Encryption Level:** **Record** for protected exports/selected app fields, complementing T13 EHR **Volume**; runtime access control is not one of the six at-rest levels.
- **Key Management:** T14: fine-grained application KMS authorization; short-lived decrypt rights, audit, separated KEKs and no plaintext key storage on terminals.
- **Implementation Priority:** **Phase 1**.
- **Closure Evidence:** Lock policy, timed auto-lock demonstration, least-privilege and denied bulk-export tests, clinical staff acceptance.

### CRYPTO-004 — Billing MySQL files are unencrypted

- **Finding ID:** CRYPTO-004
- **Data Category:** Financial/billing data — `billing-srv-01` MySQL.
- **Data State:** At rest — **Absent [CONFIRMED]**.
- **Current Protection:** None; ext4 MySQL files reportedly accessible without a MySQL credential in the forensic scenario.
- **Vulnerability Reference:** F006 (adjacent exposed DB listener, not an at-rest test); Audit §Financial Data.
- **Risk Reference:** **RISK-008** (billing ransomware; baseline **$135,143/year ALE**), with confidentiality exposure requiring separate assessment.
- **Algorithm Assessment:** No cipher deployed on described files; T6 supports AES for modern at-rest protection; engine-specific MySQL TDE algorithm and keyring compatibility must be checked.
- **Recommended Protection:** MySQL **InnoDB tablespace/database encryption** targeting engine-supported **AES-256-CBC (256-bit key, if supported by the deployed MySQL/version-keyring combination)**; do not substitute an arbitrary SQL-level CBC implementation or assume integrity authentication; protected redo/undo/binlogs, temporary files, dumps and snapshots; underlying LUKS2 **AES-256-XTS** volume as defense in depth.
- **Encryption Level:** **Database**, with supplementary **Volume** ([T13](13-encryption_levels.md)).
- **Key Management:** T14 external KMS/keyring or separately protected key source, not plaintext `my.cnf`; restricted MySQL service role; yearly master-key review with version-retention and restore tests.
- **Implementation Priority:** **Phase 1**.
- **Closure Evidence:** Version/keyring compatibility test, encrypted tablespace/redo coverage, verified logical-backup encryption, application and recovery tests.

### CRYPTO-005 — Billing application-to-MySQL plaintext protocol

- **Finding ID:** CRYPTO-005
- **Data Category:** Financial/billing data — billing app ↔ MySQL.
- **Data State:** In transit — **Absent [CONFIRMED for documented path]**.
- **Current Protection:** MySQL SSL not required; billing application uses an unencrypted database protocol.
- **Vulnerability Reference:** **F006** (MySQL bound to `0.0.0.0`, reachability context); Audit §Financial Data.
- **Risk Reference:** **RISK-008**; adjacent **RISK-002** if an attacker traverses weak boundaries.
- **Algorithm Assessment:** No transport cipher is used for that path; T6 endorses AEAD and rejects legacy protocols, not plaintext MySQL.
- **Recommended Protection:** Require server-validated **TLS 1.3 AES-256-GCM-SHA384** or tested **TLS 1.2 ECDHE AES-128/256-GCM**, restrict DB listener to approved sources, and require client hostname/CA verification.
- **Encryption Level:** **Transport/session** complement to T13 **Database** encryption.
- **Key Management:** T14 application workload credential in approved vault, protected TLS key on server, managed certificate renewal, separate DB master-key lifecycle.
- **Implementation Priority:** **Phase 1** (urgent compensating network allowlisting pending cutover).
- **Closure Evidence:** Encrypted authorized sessions and rejected unencrypted ones, correct certificate validation, end-to-end billing transaction reconciliation.

### CRYPTO-006 — Billing data in use is undocumented

- **Finding ID:** CRYPTO-006
- **Data Category:** Financial/billing data — MySQL/application runtime.
- **Data State:** In use — **Absent [UNVERIFIED: evidence gap]**.
- **Current Protection:** None documented; no claim that every session, process or RAM region is presently exposed.
- **Vulnerability Reference:** F006 is adjacent DB reachability, **not** proof of a runtime key disclosure.
- **Risk Reference:** **RISK-008** (availability and financial data integrity), RISK-002 (adjacent compromised host).
- **Algorithm Assessment:** Runtime plaintext is unavoidable for authorized SQL; **N/A** as a standalone encryption mode. T6 AES-GCM is suitable only for separately encrypted exports/records.
- **Recommended Protection:** Audit privileged SQL/session rights, application secrets, logging, endpoint locking and DLP; apply **AES-256-GCM** to exported financial packages and **AES-256-XTS** to server swap/dump storage if in scope.
- **Encryption Level:** **Database** T13 plus selective **Record/File** only if exposure analysis warrants it.
- **Key Management:** T14 service-only unwrap/DB permissions, JIT admin changes and restricted audit, annual keyring KEK review.
- **Implementation Priority:** **Phase 2** (verify before declaring an implemented weakness).
- **Closure Evidence:** Privilege inventory, denied unauthorized queries/export, no secrets in config files or logs, approved controls recorded.

### CRYPTO-007 — PACS image store lacks at-rest encryption

- **Finding ID:** CRYPTO-007
- **Data Category:** Medical images — `pacs-srv-01` DICOM store.
- **Data State:** At rest — **Absent [CONFIRMED]**.
- **Current Protection:** PACS images on local unencrypted disk; independent PACS restore capability also unproven.
- **Vulnerability Reference:** F024 concerns network DICOM plaintext (adjacent); Audit §Medical Images proves storage gap.
- **Risk Reference:** **RISK-003** (PACS outage/extortion, **ALE not quantified**); Radiology continuity is patient-safety material.
- **Algorithm Assessment:** No at-rest cipher to assess; T6 AES-XTS is an appropriate disk confidentiality mode, not authenticated DICOM integrity.
- **Recommended Protection:** PACS image, index and metadata **Volume** encryption using LUKS2 **AES-256-XTS (512-bit combined key)** or fully vendor-approved equivalent; **AES-256-GCM** for exported objects where interoperability permits; integrity checks on study recovery.
- **Encryption Level:** **Volume**, plus **File** for exports per T13.
- **Key Management:** T14 centralized restricted vault/KMS and geographically separate escrow; PACS restore must include catalog, database, patient linkage and key versions.
- **Implementation Priority:** **Phase 1**, after Radiology/Siemens/vendor workflow approval.
- **Closure Evidence:** Encrypted powered-off media test, PACS throughput/clinical viewing test, successful isolated image+metadata restore.

### CRYPTO-008 — DICOM traffic crosses the network in cleartext

- **Finding ID:** CRYPTO-008
- **Data Category:** Medical images — MRI/radiology ↔ PACS.
- **Data State:** In transit — **Absent [CONFIRMED]**.
- **Current Protection:** DICOM studies plus identifying headers transmitted unencrypted over TCP **4242/11112** per T0/F024.
- **Vulnerability Reference:** **F024** (direct); legacy MRI XP controller F004 is an adjacent compatibility/risk dependency.
- **Risk Reference:** **RISK-003** (PACS disclosure/outage), **RISK-006** (legacy MRI foothold); no separate DICOM-specific ALE.
- **Algorithm Assessment:** Plaintext has no algorithm; T6 recommends supported TLS AEAD, not retrofitting arbitrary ciphertext into medical-imaging protocols.
- **Recommended Protection:** **DICOM over authenticated TLS 1.2 or 1.3**, with **ECDHE + AES-128/256-GCM** (or vendor-approved modern equivalent), mutual endpoint authentication when supported; use a vendor-approved TLS gateway if the legacy device cannot implement TLS.
- **Encryption Level:** **Transport/session** complementing T13 PACS **Volume + File**.
- **Key Management:** T14-style restricted clinical PKI/cert inventory, protected private keys, monitored expiry and documented key replacement; manufacturer/Biomedical sign-off mandatory.
- **Implementation Priority:** **Immediate** containment of unencrypted paths; staged vendor-safe TLS rollout.
- **Closure Evidence:** Packet inspection confirms no patient DICOM in cleartext, authorized modality success, unauthorized peer rejection, clinical sign-off and rollback.

### CRYPTO-009 — PACS in-use viewing controls not assessed

- **Finding ID:** CRYPTO-009
- **Data Category:** Medical images — PACS workstation/viewer.
- **Data State:** In use — **Absent [UNVERIFIED: evidence gap]**.
- **Current Protection:** No controls documented for image viewer sessions, memory, displays or privileged image export.
- **Vulnerability Reference:** No directly applicable 1x02 runtime cryptographic finding; F024 relates to transport only.
- **Risk Reference:** **RISK-003**, adjacent RISK-007 for mishandled PHI.
- **Algorithm Assessment:** **N/A** for authorized decrypted DICOM viewing; T6 algorithms do not replace clinical authorization.
- **Recommended Protection:** Verify viewer authentication/timeout and access audit, limit image exports; protect generated portable DICOM files with **AES-256-GCM** where supported and portable storage with **AES-256-XTS**.
- **Encryption Level:** **File** for exports, **Volume** for PACS repository (T13).
- **Key Management:** T14 separated export DEKs/KEKs with recipient-specific permissions and external recovery escrow; do not give every radiology viewer master-key rights.
- **Implementation Priority:** **Phase 2**.
- **Closure Evidence:** Document viewer ACLs, inactivity lock, audit trails, safe DICOM export/readability tests.

### CRYPTO-010 — AD credentials retain MD4-derived NT hashes

- **Finding ID:** CRYPTO-010
- **Data Category:** Credentials — AD `ad-dc-01` / `ad-dc-02` and application passwords.
- **Data State:** At rest — **Weak [CONFIRMED for AD; other applications UNVERIFIED]**.
- **Current Protection:** Windows NT password hashes use unsalted MD4/NT hash for NTLM compatibility; app password storage unknown. **This is password hashing, not reversible encryption.**
- **Vulnerability Reference:** 1x00 GAP-011 (identity); no direct 1x02 finding proves a dump of NT hashes; F018 concerns Kerberos algorithms, not MD4 storage.
- **Risk Reference:** **RISK-002** (domain compromise) and **RISK-007** (access accountability, indirectly).
- **Algorithm Assessment:** T6 rates **MD4 broken/unsuitable** as a modern password verifier; **Argon2id current** for *new custom apps*, but native AD NT hashing cannot be replaced by installing Argon2id.
- **Recommended Protection:** Reduce/retire NTLM after service inventory and compatibility review; long unique passwords, managed service accounts, MFA and privileged identity protection. For independent new apps use **Argon2id** (minimum **19 MiB, t=2, p=1** as a starting OWASP profile; tune and store unique salts), or reviewed PBKDF2-HMAC-SHA256 for specific compliance contexts.
- **Encryption Level:** **Record/credential-verifier protection** (T13's record-level analogy; password hashing is a distinct mechanism), plus protected AD volume.
- **Key Management:** T14 TPM-backed endpoint and KMS-protected app secrets; credential issuance/rotation on suspected compromise, no plaintext passwords in files.
- **Implementation Priority:** **Phase 1** with legacy clinical-service impact review.
- **Closure Evidence:** NTLM audit and phased denials, no legacy authentication for approved migration targets, MFA/gMSA evidence, native AD operational compatibility.

### CRYPTO-011 — Legacy Kerberos and LDAP transport security

- **Finding ID:** CRYPTO-011
- **Data Category:** Credentials — AD Kerberos/LDAP authentication flows.
- **Data State:** In transit — **Weak [CONFIRMED configuration]**.
- **Current Protection:** Kerberos **AES-128/256** available but **DES and RC4 enabled**; LDAP signing not required, and LDAP transport encryption is not assured.
- **Vulnerability Reference:** **F018** (legacy Kerberos types), **F007** (LDAP signing); signing protects integrity, **not confidentiality**.
- **Risk Reference:** **RISK-002** (VPN→AD lateral compromise), with identity exposure affecting RISK-001 access paths.
- **Algorithm Assessment:** T6: **DES broken**, **RC4 broken**, **AES-128/256 current** in compatible Kerberos modes. Do not confuse Kerberos AES-HMAC-SHA1 use with weak SHA-1 certificate signatures.
- **Recommended Protection:** Phase out DES/RC4 tickets through audited, vendor-approved transition to **Kerberos AES-256/AES-128**; enable **LDAPS/StartTLS TLS 1.2/1.3 with ECDHE AES-128/256-GCM**, require LDAP signing/channel binding as appropriate and validate server identity.
- **Encryption Level:** **Transport/session** and identity controls; T13 storage encryption levels do **not** by themselves fix Kerberos or LDAP.
- **Key Management:** T14 controlled AD service identities/gMSA, CA private-key custody, monitored cert lifecycles, compromise-triggered credential reset, no untracked shared secrets.
- **Implementation Priority:** **Phase 1**, with urgent audit and isolation; avoid unsafe abrupt disabling for medical/legacy clients.
- **Closure Evidence:** Kerberos ticket-type audits, successful authorized service tickets, rejected DES/RC4 where approved, LDAP TLS + signing tests and clinical interoperability evidence.

### CRYPTO-012 — In-memory credentials/tickets not evidenced as protected

- **Finding ID:** CRYPTO-012
- **Data Category:** Credentials — runtime tickets, cached auth material and privileged sessions.
- **Data State:** In use — **Absent [UNVERIFIED: evidence gap]**.
- **Current Protection:** No memory/ticket/session isolation mechanism documented; not proof that all passwords are exposed.
- **Vulnerability Reference:** No direct runtime-credential finding; F007/F018 are adjacent protocol/configuration issues.
- **Risk Reference:** **RISK-002**; RISK-007 (weak attribution and mistaken access) indirectly.
- **Algorithm Assessment:** **N/A** for plaintext session secrets; applying AES to a password verifier or live token alone is not a complete memory-protection strategy.
- **Recommended Protection:** Validate Windows Credential Guard/LSASS controls where supported, privileged access workstations, MFA, short ticket lifetimes per policy and session isolation; use **AES-256-GCM** for encrypted export of stored recovery secrets, not a blanket promise of encrypted working RAM.
- **Encryption Level:** **File/Record** protection for any secret exports; **Volume** for protected host storage, plus runtime hardening outside T13 taxonomy.
- **Key Management:** T14 per-service authorization, TPM/protected keystores, JIT human administration, prompt revoke and reissue after suspected compromise.
- **Implementation Priority:** **Phase 1** discovery and privileged-identity containment.
- **Closure Evidence:** Approved endpoint/AD settings, negative test for unauthorized credential use, log review, no exposed secrets in dumps or backup copies.

### CRYPTO-013 — NAS-01 backups are stored in plaintext

- **Finding ID:** CRYPTO-013
- **Data Category:** Backup data — Synology `NAS-01`.
- **Data State:** At rest — **Absent [CONFIRMED]**.
- **Current Protection:** RAID-5 files and SQL dumps are plaintext; optional Synology **AES-256-CBC** shared-folder encryption is supported but **disabled**. RAID is not encryption or immutability.
- **Vulnerability Reference:** **F015** (exposed NAS management, adjacent access path); 1x00 GAP-007 and C-022 document backup single-failure-domain concerns.
- **Risk Reference:** **RISK-008** (billing recovery), **RISK-003** (PACS recovery), overlapping RISK-002 ransomware. RISK-003 has **no quantified ALE**.
- **Algorithm Assessment:** **No encryption in use**; T6 does not classify the **disabled** AES-CBC option as deployed. For newly encrypted portable backup objects prefer authenticated **AES-256-GCM**; for encrypted storage **AES-256-XTS** where platform-supported.
- **Recommended Protection:** Approved **Volume** encryption on NAS backup pool; independently encrypt each backup **before** replication using **AES-256-GCM, 256-bit per-backup DEK and nonce discipline**; immutable/offline, versioned, application-consistent recovery copies; separate transport TLS.
- **Encryption Level:** **Volume + File/backup-object** (T13/T12). Online unlocked NAS remains accessible to a sufficiently privileged attacker.
- **Key Management:** T14 mandates **NOT on the NAS** for plaintext unlock secrets/KEKs; MedDefense-controlled KMS/HSM KEK, wrapped DEKs, separate two-person offline escrow, separate backup and restore identities, quarterly isolated restores and key-retention tests.
- **Implementation Priority:** **Immediate**, tied to 1x03 proposed C4 (not yet deployed).
- **Closure Evidence:** Ciphertext inspection of offline copies, NAS unlock/key separation, cloud ciphertext and recoverable keys, immutable-copy test, full EHR/billing/PACS restore and clinical sign-off.

### CRYPTO-014 — Backup transport and replication crypto undocumented

- **Finding ID:** CRYPTO-014
- **Data Category:** Backup data — NAS source→replica/backup agent.
- **Data State:** In transit — **Absent [UNVERIFIED: evidence gap]**.
- **Current Protection:** None **documented**; T0 expressly says backup transport protocol is unknown, **not** that packets are proven plaintext.
- **Vulnerability Reference:** F015 is adjacent NAS management exposure; no scan proof of unencrypted backup payload transfer.
- **Risk Reference:** **RISK-008** and **RISK-003** (restoration and possible confidentiality dependencies).
- **Algorithm Assessment:** Negotiated cipher **unknown**; per T6 use AEAD-capable protocols and authenticated endpoints rather than assume TLS is absent.
- **Recommended Protection:** Inventory transport paths and captures using **synthetic data only**; require mutually authenticated **TLS 1.3 AES-256-GCM** or compatible **TLS 1.2 ECDHE AES-GCM**; apply **AES-256-GCM client-side backup-object encryption** independently of the transport channel.
- **Encryption Level:** T13 **Volume** on source and **File/backup-object** on replicated payload; link TLS is a distinct transport layer.
- **Key Management:** T14 dedicated backup identity, separate destination/service identity and KMS-controlled wrapped DEKs; credentials never saved plaintext on the NAS.
- **Implementation Priority:** **Phase 1** validation, followed by remedial change only if actual insecure transport is confirmed.
- **Closure Evidence:** Versioned settings/packet evidence, authorized transfer and rejected downgrade, restore from remote ciphertext with independently recoverable key.

### CRYPTO-015 — NAS restore/runtime secrets and mounts are not assessed

- **Finding ID:** CRYPTO-015
- **Data Category:** Backup data — active backup/restore agents and mounted media.
- **Data State:** In use — **Absent [UNVERIFIED: evidence gap]**.
- **Current Protection:** None documented for decrypted restores, unlock sessions or active mount/key separation.
- **Vulnerability Reference:** F015 adjacent NAS management; no proven plaintext passphrase capture.
- **Risk Reference:** **RISK-008**, **RISK-003**, and overlapping RISK-002.
- **Algorithm Assessment:** **N/A** for plaintext during authorized restore; T6 AES-GCM protects backup objects before and after authorized decryption, not a live restore display.
- **Recommended Protection:** Dedicated restore identity and isolated recovery hosts, restrict plaintext recovery staging, minimize key memory exposure, expire mounts/tokens; re-encrypt recovered exports with **AES-256-GCM** or put them on **AES-256-XTS** controlled storage.
- **Encryption Level:** T13 **Volume + File/backup-object**; runtime least privilege is complementary.
- **Key Management:** T14 two-person escrow and separate restore identity; validate old key versions and disaster procedures, audit unwrap/delete calls.
- **Implementation Priority:** **Phase 2**.
- **Closure Evidence:** Isolated restore drill, temporary plaintext cleanup, role separation, KMS access logs, key-loss recovery test.

### CRYPTO-016 — O365 decrypted content and PHI-handling protections not evidenced

- **Finding ID:** CRYPTO-016
- **Data Category:** Email — Microsoft 365 / Exchange Online.
- **Data State:** In use — **Absent [UNVERIFIED runtime; confirmed message-policy gap]**.
- **Current Protection:** O365 at-rest BitLocker/mailbox encryption and transport TLS 1.2 are **Adequate in T0**; no endpoint runtime protection evidenced; no S/MIME/OME configured and PHI sometimes emailed as ordinary content.
- **Vulnerability Reference:** No direct 1x02 crypto Finding ID for O365 messages.
- **Risk Reference:** **RISK-007** (negligent PHI disclosure); RISK-001 only if EHR records are exported into email.
- **Algorithm Assessment:** O365 platform-managed at-rest and TLS algorithms are audit-reported; **in-use plaintext cannot be eliminated by a blanket cipher**. T6 supports **AES-256-GCM** for separately encrypted PHI attachments where supported.
- **Recommended Protection:** DPO-approved sensitivity labels, encrypted message/attachment or secure portal workflows, recipient validation, managed endpoint locks and DLP; use vendor-supported message protection, with **AES-256-GCM** for independently encrypted external PHI packages where interoperable.
- **Encryption Level:** T13 **service/mailbox-level** baseline plus **File/message-level** for sensitive exports; no false claim of changing provider disk crypto.
- **Key Management:** T14 tenant identity/role restrictions, provider/customer key responsibilities validated; for separately encrypted files use KMS-managed DEKs/KEKs and recipient/recovery access controls.
- **Implementation Priority:** **Phase 1** — implement PHI message-handling policy first; endpoint runtime assurance continues as a later Phase 2 verification activity.
- **Closure Evidence:** External recipient test, attempted unprotected PHI send blocked/warned, sender/recipient access audit, DPO approval.

### CRYPTO-017 — VPN payload at rest: not a meaningful dataset

- **Finding ID:** CRYPTO-017
- **Data Category:** VPN traffic — Central↔Westside / Central↔HQ.
- **Data State:** At rest — T0 **Absent [N/A placeholder]**, **not a confirmed security defect**.
- **Current Protection:** No stored VPN payload is defined; an IPsec tunnel is a transport path. Firewall configuration backups and traffic logs are separate data assets.
- **Vulnerability Reference:** F014 (Westside router security, adjacent only); no F### proves missing encryption on a fictitious stored VPN payload.
- **Risk Reference:** **RISK-002** (tunnel misuse/lateral attack), but **no specific at-rest VPN-payload risk**.
- **Algorithm Assessment:** **N/A**; T6 reports **IPsec AES-256/SHA-256/IKEv2/DH14** in transit as Adequate configuration, not a stored-file cipher.
- **Recommended Protection:** **No encryption of a nonexistent object.** Inventory actual exported firewall configs, certificates and logs; **if found**, encrypt their storage with **AES-256-XTS** and sensitive exported backup files with **AES-256-GCM**.
- **Encryption Level:** **N/A** until a real asset is found; T13 **File/Volume** would then apply to exported configs/logs.
- **Key Management:** T14 VPN keys in controlled device keystore/vault, cert/PSK rotation and emergency recovery; no ephemeral SA keys in repo.
- **Implementation Priority:** **Phase 2 — informational inventory only, not an actionable encryption gap.**
- **Closure Evidence:** Asset inventory confirms N/A or creates **new** separate finding for an actual unencrypted configuration/log asset.

### CRYPTO-018 — VPN payload in use: decrypted traffic is necessary

- **Finding ID:** CRYPTO-018
- **Data Category:** VPN traffic — site-to-site packet processing.
- **Data State:** In use — T0 **Absent [N/A placeholder]**, **not a confirmed security defect**.
- **Current Protection:** IPsec packets are decrypted at the tunnel endpoint so authorized applications can process traffic; no endpoint-memory assessment exists.
- **Vulnerability Reference:** F014 is adjacent router management/firmware risk, not evidence that decrypting traffic is inherently a crypto weakness.
- **Risk Reference:** **RISK-002** only as broader incident context.
- **Algorithm Assessment:** **N/A** for authorized endpoint plaintext; reported AES-256 IPsec remains suitable per T6 subject to peer/lifetime validation.
- **Recommended Protection:** **No separate encryption of necessary in-memory endpoint plaintext**; review appliance hardening and firmware, restrict administration and capture, require end-to-end **TLS 1.3 AES-256-GCM** for sensitive applications even within VPN where supported.
- **Encryption Level:** **N/A** for live tunnel plaintext; source/destination application **Transport/Volume** as separately applicable.
- **Key Management:** T14 device keystore for long-term identity, negotiated short-lived IKE/CHILD SA rekey, replace compromised peers/PSKs at both ends.
- **Implementation Priority:** **Phase 2 — informational validation, no invented vulnerability.**
- **Closure Evidence:** Firmware/peer auth review; a real endpoint or logging weakness, if found, gets its own actionable ticket.

## 3. Out-of-matrix but material cryptographic gaps (do not change T0 count)

### CRYPTO-019 — Patient portal exposes legacy TLS and certificate-lifecycle risk

- **Finding ID:** CRYPTO-019 — **SUPPLEMENTAL, NOT ONE OF 21 T0 CELLS**.
- **Data Category:** Patient portal `web-srv-01`.
- **Data State:** In transit — **Weak** in the T0 separate patient-portal assessment.
- **Current Protection:** TLS **1.0 and 1.2** enabled; TLS 1.3 absent, HSTS/OCSP stapling not set, full cipher list unverified. Certificate was reported **18 days from expiry at the original Week 5 audit**, with no automatic renewal; **this is not a verified expiration date as of 6 Nov 2026**.
- **Vulnerability Reference:** **F005** (TLS 1.0) and **F013** (certificate expiration/renewal). Neither proves a presently expired certificate or negotiation of a particular weak cipher suite.
- **Risk Reference:** **No direct portal-specific RISK-### entry** in 1x03 Task 10; potential PHI access and patient-service continuity harm requires a separately registered risk. Do not label RISK-001 a direct portal finding.
- **Algorithm Assessment:** T6 identifies obsolete **TLS 1.0** and its MD5/SHA-1-based PRF; it does **not** prove MD5-signed certs, RC4 or 3DES were negotiated. TLS 1.2 AEAD can be acceptable if properly configured.
- **Recommended Protection:** Prefer **TLS 1.3 AES-256-GCM-SHA384** or **AES-128-GCM-SHA256**, and allow hardened **TLS 1.2 ECDHE AES-GCM** for required clients; disable TLS 1.0 after compatibility tests; issue valid public-CA cert, automate renewal and monitor expiry/chain.
- **Encryption Level:** **Transport/session**; T13 six-level at-rest table does not cover network TLS.
- **Key Management:** T14: portal signing key in restricted reverse-proxy store/HSM provider where compatible; issue a **new private key** on replacement; promptly rotate/revoke on compromise; do **not** deploy the Task 10 `.local` lab CSR/key.
- **Implementation Priority:** **Immediate**, Internet-exposed patient-service dependency.
- **Closure Evidence:** Fresh hostname/chain/`notAfter`, successful TLS 1.3 and approved TLS 1.2, rejection of TLS 1.0, working automated renewals and clinical-access acceptance.

### CRYPTO-020 — O365 mail-message confidentiality is separate from TLS

- **Finding ID:** CRYPTO-020 — **SUPPLEMENTAL, NOT ONE OF 21 T0 CELLS**.
- **Data Category:** Email — protected patient information in external messages.
- **Data State:** In transit / recipient content — **message-level gap** even though T0 classifies O365 **transport TLS as Adequate**.
- **Current Protection:** Transport TLS 1.2 and provider storage encryption exist, but no S/MIME/OME is configured; PHI sometimes leaves as an ordinary email body/attachment.
- **Vulnerability Reference:** No direct 1x02 finding.
- **Risk Reference:** **RISK-007** (negligent PHI disclosure).
- **Algorithm Assessment:** TLS protects hops, **not end-to-end content**; T6 AES-GCM can protect separately encrypted message/attachment objects but O365 native algorithms must be verified, not invented.
- **Recommended Protection:** DPO-approved Microsoft Purview encryption or interoperable **S/MIME** for relevant flows, or patient portal exchange; when implementing independent file payload protection use **AES-256-GCM** with authorized recipient key wrapping and tested recovery.
- **Encryption Level:** T13 **File/message-level** complement to service/mailbox protection.
- **Key Management:** Tenant-controlled approved recipient grants, separate KMS/PKI for optional external package/S/MIME, revoke sharing and preserve lawful archival/recovery requirements.
- **Implementation Priority:** **Phase 1**.
- **Closure Evidence:** External recipient decrypt test, disallowed/unprotected PHI flow caught, clinical policy and DPO sign-off.

## 4. Posture Score — calculation and interpretation

| Metric | Numerator | Denominator | Score | Interpretation |
|---|---:|---:|---:|---|
| **T0 initially Adequate cryptographic protection** | 3 | 21 | **14.29%** | Original baseline only; **not upgraded** by lab work or recommendations. |
| T0 Weak/Absent requiring one finding each | 18 | 21 | **85.71%** | Includes **two VPN N/A placeholders**; not 18 verified exposures. |
| **Applicable Weak/Absent cells with clear remediation/evidence-validation paths** | **16** | **16** | **100%** | **Primary Task 15 Posture Score**: audit-plan coverage, **NOT actual deployed encryption**. |
| Applicable T0 cells evaluated (Adequate or actionably Weak/Absent) | 19 | 19 | **100%** | Mapping completeness; excludes two N/A. |
| Production remediation verified closed by this task | 0 | 16 | **0% evidenced here** | No new production implementation/test evidence was supplied; **not** a claim that the organization has literally installed zero controls since T0. |

**Exact arithmetic:** `7 × 3 = 21`; `3 Adequate + 3 Weak + 15 Absent = 21`; `3 Weak + 15 Absent = 18 flagged`; `18 − 2 VPN N/A = 16 applicable`; `16/16 × 100 = 100%`. **The Posture Score answers “what percentage now have a clear remediation path?”, not “what percentage are now encrypted?”** Every one of these 16 has an explicit recommendation, owner/process linkage, priority and closure test. The six in-use/evidence-gap cells are **validation-first**, not falsely certified unencrypted. Supplemental CRYPTO-019/020 are deliberately **outside** both numerator and denominator.

## 5. Top 3 Crypto Risks — combined impact ranking

**Method:** Rank **clinical/patient impact (C)**, **exploit/access likelihood or exposure (E)** and **recovery/operational dependency (D)** using an analyst's **1–5 ordinal scale**. This is a **prioritization aid, not the 1x03 1–25 formal Risk Register score or a monetary ALE formula**. Use explicit case evidence and avoid claiming numeric accuracy where data are unverified.

| Rank | Crypto finding | C | E | D | Indicative C+E+D | Why it ranks here and evidence boundary |
|---:|---|---:|---:|---:|---:|---|
| **1** | **CRYPTO-001 — EHR unencrypted storage** | 5 | 4 | 5 | **14/15** | 50,000 PHI records; confirmed plaintext files and adjacency to overbroad authenticated DB path F003; **RISK-001 $3.025m/y ALE** is a teaching full-breach scenario, **not** the attributable loss avoided by disk encryption. |
| **2** | **CRYPTO-013 — NAS-01 plaintext backups** | 5 | 4 | 5 | **14/15** | No at-rest encryption, exposed management F015 and a shared backup-recovery dependency; a compromise can remove the ability to restore PACS/billing and expose copied datasets. **Ranking applies clinical recovery weight beyond the raw sum**; RISK-003 is **NQ**, RISK-008 $135,143/y relates to billing outage, not standalone NAS-key loss. |
| **3** | **CRYPTO-019 — patient portal TLS/certificate** | 5 | 5 | 3 | **13/15** | External exposure plus confirmed TLS 1.0 configuration F005 and historical certificate-renewal deficiency F013; imminent expiry was reported **relative to original audit**, not verified today. **Supplemental finding outside the 21-cell score**; no direct portal ALE. |

**Ranking resolution:** EHR and NAS both score **14/15**, so **the tie is broken in favor of EHR** because its direct patient-record exposure is supported by the quantified RISK-001 classroom scenario; NAS recovery failure remains almost equally urgent and must not be delayed. The scores are qualitative judgments, not measured attack probabilities. **Next in queue:** CRYPTO-008 cleartext DICOM/F024, CRYPTO-011 AD DES/RC4/LDAP/F007/F018 and CRYPTO-002 permissive PostgreSQL TLS. Never sum overlapping **RISK-001 ($3.025m)** and **RISK-002 ($2.8644m)** as an enterprise ALE.

## 6. Proposed remediation sequence, owners and acceptance gates

| Wave | Finding IDs | Responsible / consulted | Must demonstrate before closure |
|---|---|---|---|
| **Immediate** | 001, 002, 008, 013, **019 (supplemental)** | Sarah + James; EHR data owner/DPO; Radiology/Biomedical/vendor; backup/PKI leads | Safe EHR/portal clinical testing, denied plaintext network paths, NAS offsite key separation and isolated restore, DICOM compatibility; phased change tickets/rollback. |
| **Phase 1** | 003, 004, 005, 007, 010, 011, 012, 014, 016, **020 (supplemental)** | IT/DB/AD/PKI, clinical owners, DPO, Robert Kim for finance continuity | Database/TLS proof, keyring/escrow, AD legacy protocol audit, protected email evidence; verify unknown backup transfer before asserting exposure. |
| **Phase 2** | 006, 009, 015, 017*, 018* | IT Security Analyst and custodians | Runtime permissions and secrets assessment, tested restore hygiene; *VPN N/A informational closure without needless crypto deployment*. |

**Before marking a finding resolved:** (a) confirm production scope and system owner; (b) obtain change, clinical and privacy approvals; (c) test authorized workflows and negative cases without actual patient data where feasible; (d) verify cryptographic configuration and algorithm negotiation; (e) restore from encrypted copy using independent recovery keys; (f) update T0 matrix, 1x03 Risk Register, runbook and evidence index; (g) obtain James/Sarah and relevant data-owner sign-off. Incident response must preserve forensic evidence and avoid deleting the last usable KEK/key version. **Neither Task 12's local 500 MiB LUKS lab nor T14's proposed HSM pilot establishes production adoption.**

## 7. References and evidence traceability

### MedDefense primary evidence

- [T0 — Data Protection Map](0-crypto_inventory.md): **authoritative 21-cell matrix** and the Sarah Park crypto-audit baseline; 3 Adequate, 3 Weak, 15 Absent, two explicit VPN N/A.
- [T6 — Algorithm Landscape](6-algorithm_landscape.md): DES/RC4/MD4, AES/XTS/GCM, legacy TLS and modern algorithm suitability; distinguishes unverified use from supported configuration.
- [T12 — Disk Encryption Lab](12-disk_encryption.md): tested **lab** LUKS2 and safety boundaries, not MedDefense NAS deployed evidence.
- [T13 — Encryption Levels](13-encryption_levels.md): EHR Volume+Record, backup Volume+File/object, billing Database, PACS Volume+File, email service/content, endpoint full-disk.
- [T14 — Key Management](14-key_management.md): external KMS/HSM/TPM protection, recovery escrow, authorized identities, rotation and compromised/lost keys; pending approval.
- [1x02 — Vulnerability Triage](../1x02_the_weak_links/16-triage.md): F003/F004/F005/F006/F007/F013/F014/F015/F018/F024, with direct vs adjacent claims distinguished above.
- [1x03 — Risk Register](../1x03_defense_blueprint/10-risk_register.md): **RISK-001, 002, 003, 006, 007, 008**; scores, owners and `NQ` handling.
- [1x03 — ALE Workshop](../1x03_defense_blueprint/6-ale_workshop.md): EHR $3,025,000/y, billing $135,143/y, VPN $2,864,400/y, non-additivity and assumption limits.
- [1x03 — Governance Architecture](../1x03_defense_blueprint/4-governance_architecture.md): James, Sarah, CEO, Finance, Clinical/Biomedical and DPO authority.

### Public algorithm/protocol references (design guidance, not MedDefense deployment evidence)

- [NIST SP 800-38E — XTS-AES storage confidentiality](https://csrc.nist.gov/pubs/sp/800/38/e/final): XTS protects storage confidentiality **without authentication**.
- [RFC 8996 — TLS 1.0 / 1.1 deprecated](https://www.rfc-editor.org/rfc/rfc8996.html); [RFC 8446 — TLS 1.3](https://www.rfc-editor.org/rfc/rfc8446): protocol migration and modern AEAD.
- [PostgreSQL — Client Authentication / `pg_hba.conf`](https://www.postgresql.org/docs/14/auth-pg-hba-conf.html): `hostssl` and `hostnossl` semantics (version-aligned to T0's PostgreSQL 14).
- [Microsoft Learn — Detect and Remediate RC4 Usage in Kerberos](https://learn.microsoft.com/en-us/windows-server/security/kerberos/detect-remediate-rc4-kerberos): audit dependencies before migration.
- [NIST SP 800-57 Part 1 Rev. 5 — Key Management](https://csrc.nist.gov/pubs/sp/800/57/pt1/r5/final): key lifecycle, cryptoperiod, compromise and recovery.

## 8. Sign-off status

| Reviewer | Approval gate | Status |
|---|---|---|
| **Sarah Park** — IT Director | Technical scope, change/rollback, approved test environment | **Pending** |
| **James Chen** — Deputy CISO | Risk ranking, operational priorities and key custody | **Pending** |
| **EHR Clinical Owner / Radiology / Biomedical** | Patient-care compatibility, clinical recovery | **Pending** |
| **DPO / Legal** | Patient-information and cross-site/cloud key governance | **Pending** |
| **Robert Kim / CEO** | Shared program ceiling, budget and formal risk acceptance | **Pending** |

**Final audit conclusion:** The **remediation roadmap covers every applicable T0 Weak/Absent cell (100%)** and independently records two additional gaps; **no production finding can be closed on the evidence currently available**. Recompute the *actual protection* score only after approved implementation and independent verification.
