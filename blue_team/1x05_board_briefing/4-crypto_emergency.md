# MedDefense Health Systems — Task 4: The Crypto Emergency

**Project:** 1x05 — Emergency Board Briefing
**Deliverable:** `blue_team/1x05_board_briefing/4-crypto_emergency.md`
**Assessment date:** 12 November 2026 (scenario clock: Tuesday, 18:47, four hours after the emergency advisory)
**Audience:** James Chen, Deputy CISO; Sarah Park, IT Director; Dr. Patricia Morales, CEO; Robert Kim, CFO; DPO, EHR and Radiology owners
**Status:** **Proposed emergency decisions, NOT confirmed production remediations or evidence that Crimson Tide has compromised MedDefense.**

## Executive decision

**Accelerate preservation of independent, recoverable backups first; contain and investigate FortiGate SSL-VPN exposure as the overriding non-cryptographic emergency; start verified EHR transport and storage/key-custody work in parallel without a rushed production database migration.** The concrete cryptographic chain weaknesses are (a) **legacy Kerberos RC4/DES** exposure, (b) **unencrypted `ehr-db-01` PostgreSQL storage**, and (c) **unencrypted `NAS-01` backup copies**. Optional EHR PostgreSQL TLS is another proven configuration weakness, although the supplied scenario does **not** prove an attacker used a network sniffer or TLS downgrade. Encryption is a confidentiality control, not a substitute for access controls, patching, immutability or incident response. A compromised privileged session may still export plaintext from a live database even if its disk is encrypted.

**Immediate priority decision:** Preserve a last-known-good offline/immutable recovery copy *without silently stopping critical backup jobs*; verify and safely isolate any Internet-reachable vulnerable SSL-VPN service in parallel. Do not use all two IT staff on a full-disk migration tonight. The original 1x04 playbook ranks by long-term impact; the list in Part 2 ranks emergency *threat-specific importance*, while its separate schedule reflects what can safely be achieved within 72 hours.

### Evidence boundary and phase numbering

- **Scenario:** Crimson Tide allegedly attacks regional hospitals by FortiGate entry, internal movement, Kerberoasting, patient-data theft, reachable-backup destruction and ransomware. These claims are *course-provided exercise inputs*, not verified live findings or independently authenticated public reporting about this named campaign.
- **Phase conflict:** [1x05 Task 0](0-advisory_analysis.md) used **working phases 1 entry / 2 foothold / 3 lateral movement / 4 Kerberoasting / 5 EHR exfiltration / 6 backup destruction / 7 ransomware**. The current Task 4 asks what disk encryption changes about **“Phase 4”** during *patient-data exfiltration*. **Those labels conflict.** In Part 3, “the assignment's Phase 4 exfiltration scenario” is analyzed as **the patient-data theft stage, Phase 5 in our existing Task 0**, without silently relabeling or overwriting the earlier crosswalk. The original signed course advisory was not available to verify its exact headings/order; James must reconcile numbering with the authentic source before the Board release.
- **Source hierarchy:** [1x04 T0](../1x04_crypto_foundation/0-crypto_inventory.md) = historical baseline; [T15](../1x04_crypto_foundation/15-crypto_posture_audit.md) = assessed findings; [T13](../1x04_crypto_foundation/13-encryption_levels.md) = encryption-level design; [T14](../1x04_crypto_foundation/14-key_management.md) = custody; [T20 playbook](../1x04_crypto_foundation/22-implementation_playbook.md) = proposed change procedures, not deployed controls.

## Part 1 — Crypto Attack Surface Mapping

**Coverage rule:** Map only a phase with an evidenced or plausible cryptographic weakness; explicitly distinguish a *confirmed weak setting* from proof that the actor used it. A phase labelled **not directly cryptographic** is not recast as an encryption failure.

### Phase 3 — Internal reconnaissance and lateral movement (conditional transport opportunity)

```yaml
Phase: "3 — Reconnaissance and lateral movement (Task 0 working phase)"
Crypto Weakness: "CRYPTO-002: PostgreSQL ssl=on but hostnossl paths allowed; F003 broad EHR reachability"
What Crimson Tide Exploits: "If an attacker reaches an unencrypted DB client path, traffic/credentials or PHI may be observable; use of this technique is NOT evidenced in the scenario"
Recommended Crypto Fix: "1x04 T20 Action #5: require hostssl and client sslmode=verify-full, trusted server identity and strong TLS; remove hostnossl after inventory"
Emergency Timeline: "0–12h inventory/monitor; 12–36h stage/test; 36–72h conditional canary cutover, if clinical owners approve and all clients pass"
```

- **Target / cross-reference:** `ehr-db-01`, `ehr-srv-01`; GAP-016/GAP-006; C1 segmentation **$30,000/year proposed**, plus T20 Action #5 (no separately costed crypto implementation). TLS can prevent opportunistic plaintext interception, **not** valid authenticated SQL queries, domain admin abuse or lateral reachability itself.
- **Go/no-go:** Confirm client certificates and server SAN, every EHR/replication/backup client, app transactions and negative plaintext-client refusal before closing CRYPTO-002. A broad immediate HBA rewrite could disrupt clinical logins.

### Phase 4 — Kerberoasting and AD privilege escalation

```yaml
Phase: "4 — Kerberoasting and domain privilege (Task 0 working phase)"
Crypto Weakness: "CRYPTO-011: Kerberos RC4/DES allowed; CRYPTO-010: legacy NT hash exposure context"
What Crimson Tide Exploits: "If an eligible service ticket uses weak encryption and a service password is guessable, offline ticket cracking may disclose a usable service credential"
Recommended Crypto Fix: "Additional 1x04 T15 Phase 1 remediation OUTSIDE the five T20 actions: inventory tickets/accounts, prefer Kerberos AES, strengthen service identities and move to gMSA"
Emergency Timeline: "0–12h log/audit and protect privileged identities; 12–36h scope and test; 36–72h selective vendor/clinical-approved change; no blanket RC4/DES disable tonight"
```

- **Target / cross-reference:** `ad-dc-01`/`ad-dc-02`; 1x02 **F018** legacy Kerberos and **F007** unsigned LDAP; 1x00 **GAP-011/GAP-016**; 1x03 **C2 MFA $11,000/year** and **C3 Wazuh $22,000/year**, both proposed. **LDAP signing is an integrity measure, not encryption**; modernizing LDAP authentication and TLS is a separate related remediation.
- **Boundary:** Kerberoasting is not a generic “RC4 cipher break” and does not prove any ticket has been cracked. Domain administrator access, service-ticket access, ticket encryption type, crackable service secrets and real post-exploitation privilege must be demonstrated, not assumed. gMSA migration requires service compatibility tests and appropriate AD policy.

### Phase 5 — EHR patient-record exfiltration (called Phase 4 in this task's What If)

```yaml
Phase: "5 — Patient-data exfiltration (Task 0; assignment's What If calls it Phase 4)"
Crypto Weakness: "CRYPTO-001: EHR PostgreSQL 14 data/WAL stored on unencrypted ext4; CRYPTO-002: optional link TLS"
What Crimson Tide Exploits: "Plaintext offline DB/data dumps are directly readable if attacker obtains files; privileged SQL/application access can also export plaintext regardless of disk encryption"
Recommended Crypto Fix: "1x04 T20 Action #1: LUKS2 AES-256-XTS encrypted volume and external key escrow; T13 adds selective application-side AES-256-GCM records with separately authorized KMS keys"
Emergency Timeline: "0–12h restrict exports/access and verify independent backups; 12–36h design/stage keys and safe migration; 36–72h test/restoration only; production disk cutover ONLY if all T20 gates are met"
```

- **Target / cross-reference:** `ehr-db-01` (50,000 PHI records), `ehr-srv-01`; 1x02 **F003** is an **adjacent overbroad authenticated-access finding**, not evidence of an encryption flaw; GAP-006 and GAP-017; RISK-001 **$3,025,000/year teaching full-breach ALE**, *not a quantifiable LUKS-only benefit*. C1/C3 are proposed controls, not proof exfiltration is prevented.
- **Closure gate:** The `PGDATA`, WAL, all tablespaces, exports, snapshots, backups, temp and swap paths must be examined; test an isolated full restore and key escrow. Avoid destructive changes to the original ext4 device. **Do not count encrypted disk as protection against a mounted database controlled by an attacker.**

### Phase 6 — Backup destruction and recovery denial

```yaml
Phase: "6 — Backup deletion/recovery denial (Task 0 working phase)"
Crypto Weakness: "CRYPTO-013: NAS-01 backup files and SQL dumps plaintext; CRYPTO-014 backup-link encryption UNVERIFIED, not proved absent"
What Crimson Tide Exploits: "Reachable copies can be stolen in clear; an attacker with delete/admin rights can destroy online copies, whether plaintext OR encrypted"
Recommended Crypto Fix: "1x04 T20 Action #2: encrypted independent backup objects (authenticated AEAD), NAS platform encryption, off-NAS key custody, immutable/offline copies and verified recovery"
Emergency Timeline: "0–12h preserve verified isolated copy if clinically safe; 12–36h independent recovery test; 36–72h start approved immutable/offsite encrypted replica if entitlement, capacity and privacy authorization permit"
```

- **Target / cross-reference:** `NAS-01`, `backup-srv-01`; F015 DSM management exposure is an **access path, not proof of deletion**; **GAP-007/GAP-003/GAP-016**; C4 immutable offsite backup **$21,000/year proposed** and C1 **$30,000/year proposed**. Native RAID-5 and encrypted NAS folders alone **do not** stop deletion or make a backup immutable.
- **Emergency rule:** **Physical NAS disconnection is conditional**: first determine jobs, recovery requirements and a second verified copy; coordinate with clinical and backup owners. If no other viable current backup exists, indiscriminate disconnection risks making the hospital unable to recover newly written records. Use write-protected/offline copy, isolated backup VLAN and separate credentials as appropriate; keep evidence and test restorability.

### Phases without a direct demonstrated crypto exploit

| Task 0 phase | Crypto interpretation | Required intervention outside the T20 five |
|---|---|---|
| **1 — FortiGate SSL-VPN exploit** | **CVE-2023-27997 is a pre-auth memory-corruption flaw, NOT a break of TLS/AES.** Changing ciphers or enabling MFA cannot fix the vulnerable code. | Immediately verify exposed SSL-VPN; safely isolate it and obtain an approved current vendor-patched release. FortiOS **7.0.14 is not a blanket safe 2026 target** because of other vulnerabilities (e.g. CVE-2024-55591). |
| **2 — Foothold / persistence** | Credential weakness may assist access, but no particular cryptographic failure is proved for this phase. | Restrict privileged/session paths, examine endpoints, identify unmanaged identities, preserve audit evidence. |
| **7 — Ransomware / clinical disruption** | Ransomware uses encryption maliciously; **disk encryption does not prevent a privileged process encrypting accessible files**. | Segmentation, response/EDR, approved continuity plans and independent immutable recovery. |

## Part 2 — Updated Crypto Priority List

**Original 1x04 T20 ranking:** **#1 EHR at-rest (CRYPTO-001) → #2 NAS at-rest/backups (CRYPTO-013) → #3 portal TLS/cert (CRYPTO-019) → #4 DICOM TLS (CRYPTO-008) → #5 EHR DB TLS (CRYPTO-002)**; all five are **T15 Immediate**, not Phase 1/2. The original order reflects long-run exposure and criticality, while the revised order reflects **this specific active double-extortion and recovery-denial scenario**.

| New rank | Old rank | T20 action / finding | Reason for change | What is genuinely feasible in 72h? |
|---:|---:|---|---|---|
| **1** | 2 | **Action #2 — NAS-01 backup encryption + independent recoverability (CRYPTO-013)** | Attacker explicitly destroys backups; protect the *last viable recovery source first*. Immutability/independence, rather than encryption alone, is the decisive disruption. | Preserve copy now; test isolated restore next; **start** separately encrypted immutable replica if available/authorized. Full replacement of existing NAS encryption is not guaranteed. |
| **2** | 1 | **Action #1 — EHR volume encryption with separate keys (CRYPTO-001)** | 50,000 PHI records are an explicit theft target. Retain high rank but **do not rush a live PGDATA migration**; volume encryption mainly blocks offline theft, not privileged SQL export. | Inventory, application-consistent backup, off-host keys, stage/test migration; production cutover conditional and unlikely within 72h with current staffing. |
| **3** | 5 | **Action #5 — EHR DB verified TLS (CRYPTO-002)** | Lower than theft/recovery risk, but a comparatively practical way to remove an optional plaintext path during containment. Does **not** stop credentialed database export. | Enumerate `hostnossl` clients and test; staged canary in 36–72h only if all EHR/replication integrations pass. |
| **4** | 3 | **Action #3 — Portal TLS/certificate (CRYPTO-019)** | Significant Internet-facing exposure, but **not** the Crimson Tide FortiGate exploit; do not mistake HTTPS hardening for VPN patching. | Check actual `notAfter`/TLS now; renew or remove TLS 1.0 if verified urgent and tested; otherwise maintain separate imminent-expiry SLA. |
| **5** | 4 | **Action #4 — PACS DICOM TLS (CRYPTO-008)** | Cleartext medical imaging remains serious but not the documented Crimson Tide path; legacy XP MRI/vendor safety makes a rushed change dangerous. | Vendor/biomedical discovery and gateway staging; no forced live modality switch without approved tests. |

**New attack-specific urgent item, outside these five:** **CRYPTO-011** (Kerberos RC4/DES migration, service-account hardening and LDAP protection) is elevated to an **immediate investigation/containment workstream** because it directly aligns with phase 4. It is **not falsely described as a sixth action in T20**: use T15's Phase 1 plan and test before changing authentication in production. **Another essential item, outside encryption altogether:** FortiGate CVE-2023-27997 exposure and its $2,400/year support renewal remain the highest-priority **overall** cyber response, even though they are not members of a crypto-action ranking.

### Operational schedule, dependencies, and ownership

| Window | Sarah Park + two IT staff (do not double-book a production cutover) | James Chen / Security Analyst / owners | Evidence or stop condition |
|---|---|---|---|
| **Tier 1, 0–12h** | IT-A verifies FortiGate/SSL-VPN and safe containment; IT-B catalogs NAS jobs, preserves one viable independent backup, captures EHR TLS configuration **read-only**; Sarah directs safe changes | James reviews threat evidence; EHR/DPO and clinical owners approve downtime rules; Security checks AD Kerberos event evidence | Tested safe remote/intersite access; backup recovery not lost; no newly broken clinical login |
| **Tier 2, 12–36h** | IT-A/vendor prepare FortiGate approved firmware path; IT-B tests isolated restore and backup-key custody; Sarah/DBA stage EHR TLS/migration plan | CFO/CEO decide $2,400 renewal and any C4/provider procurement; AD owner audits weak-enctype accounts; clinical owners review | Proven backup recoverability, reconciled clinical dependencies and approved change windows |
| **Tier 3, 36–72h** | Approved firewall patch and narrow segmentation first; conditional DB TLS canary, offsite encrypted immutable job, test-only EHR storage migration; avoid overlapping production cutovers | James validates denied insecure paths and alarm coverage; DPO validates PHI handling; vendor approves DICOM testing and AD legacy exceptions | No production EHR volume cutover or blanket Kerberos disable without isolated restore, verified keys and clinical sign-off |

**Financial/authority boundary:** In 1x03 the **C1+C2+C3+C4+C6 portfolio** was **proposed**, not Board-approved, funded or deployed: **$97,000/year annualized**, approximately **$115,000 illustrative first-year cash** against the **$120,000 six-month program ceiling** (only $5,000 apparent headroom before unpriced work). The **$2,400/year Fortinet support** and additional EHR crypto/KMS, NAS object storage, vendor work and key escrow are **not automatically included** in these estimates. Sarah runs changes; James leads incident risk; CFO validates cost; CEO/Board approves extraordinary spend; clinical/Biomedical and DPO sign off on affected workflows/data.

## Part 3 — The “What If” Calculation: encrypted EHR, attacker has domain admin and a same-host key

**Question interpreted literally:** In the assignment's **“Phase 4” patient-database theft hypothetical** (**phase 5 in Task 0's working names**), assume `ehr-db-01` has **T13-recommended LUKS2 AES-256-XTS volume encryption**, but **its reusable disk-unlock key is on the same server**; an attacker has acquired **domain-admin privileges**. Does the encryption prevent the theft of 50,000 records?

| Access condition | Can readable patient data be exfiltrated? | Reason |
|---|---|---|
| **Only an offline disk image or storage snapshot; volume locked and key inaccessible** | **Generally no**, assuming correct encryption and full data/WAL/backup coverage | LUKS/XTS ciphertext protects offline storage. A separate uncompromised unlock secret is essential; plaintext copies remain exceptions. |
| **Offline image + readable same-server keyfile/escrow in copied files** | **Yes, likely** | The attacker can potentially unlock/decrypt the copied volume. Same-host key custody defeats much of the offline-loss protection. |
| **Live server, LUKS volume already unlocked; attacker has effective Linux root or storage access** | **Yes** | The host exposes a mounted plaintext filesystem to authorized privileged processes; an attacker controlling them can read PostgreSQL files or abuse local access. |
| **Live database, attacker holds PostgreSQL superuser or permitted EHR application account** | **Yes, within granted capabilities** | SQL or application exports produce plaintext after storage-level decryption. Disk AES-XTS does not enforce row access or prevent authorized queries. |
| **Attacker has Windows AD domain-admin token ONLY, no trusted path to Linux root, PostgreSQL or app** | **Not automatically** | Domain admin is powerful but **does not inherently equal Linux root or PostgreSQL superuser**. Test actual AD/SSO, domain-joined hosts, shared vaults, backup identities and lateral routes before claiming DB access. |
| **Application-side sensitive fields encrypted with AES-256-GCM, off-host KMS keys and narrowly authorized unwrap rights** | **Potentially blocked for protected fields if attacker cannot obtain the app's unwrap rights or compromise plaintext processing** | Distinct identities, access policy and key custody give extra separation; **not a guarantee** after application-tier compromise, approved decrypt requests, memory access or misuse of an authorized clinician session. |

**Answer and calculation:** In the case specified—**domain administrator plus a usable path to `ehr-db-01` and its same-host key or an already-unlocked PostgreSQL process**—the number of patient records *potentially exfiltrable remains up to 50,000 of 50,000*, subject to actual database permissions and access; **there is no justified percentage reduction** attributable to LUKS alone. If domain-admin authority never yields Linux, SQL, application or key access, the attacker may **not** be able to exfiltrate those records; the scenario does not establish that lateral path. This is a conditional exposure bound, **not a prediction that 50,000 records were stolen**. The RISK-001 **$3,025,000/year ALE** is not a cryptography-attributable saving and must not be reduced to $0 simply because a storage cipher is installed.

**Design correction:** Move LUKS recovery keys and KEKs to a separately administered KMS/HSM-backed vault with two-person offline escrow, avoid static reusable plaintext keys on `ehr-db-01`, separate domain/DB/app/backup credentials, limit and monitor bulk exports, force verified database TLS, segment admin paths and test independent recovery. However, **off-host KMS alone cannot prevent extraction from an already-unlocked volume or from an authorized live SQL query**. For the most sensitive fields, use T13's selective **application-side authenticated record encryption** with independent KMS unwrap controls, explicit user/workload authorization, monitored decrypt/export and clinical-safe performance testing; avoid calling `pgcrypto` on the database server a guarantee against a compromised DB administrator. PostgreSQL 14 explicitly cautions that `pgcrypto` runs on the server and exposes data/keys to the trusted server/DB administrator.

**Final Board sentence:** *“Encrypting the EHR disk reduces offline disclosure, but with a stolen privileged identity and locally accessible keys it does not stop live data theft; our decisive near-term defenses are containment, restricted identities, separated keys and independently recoverable backups.”*

## Acceptance tests and unresolved evidence

1. **NAS:** Last-known-good immutable/offline copy demonstrably survives revoked NAS admin/delete rights; encryption key recoverable off-NAS; isolated EHR/billing/PACS restore successful; backup RPO still met.
2. **EHR:** Full data/WAL/tablespace coverage and safe rollback demonstrated; privileged SQL export risk assessed separately; no same-host reusable KEK; unapproved bulk exports alerted or blocked.
3. **Transport:** `pg_stat_ssl` indicates TLS for approved clients; no `hostnossl` bypass; `sslmode=verify-full` and clinical functions succeed; no patient-record or secrets captured in test artifacts.
4. **AD:** Inventory actual RC4/DES service tickets, legacy devices and service accounts; gMSA/AES pilot validates logons before restrictions; compare F018/F007 with logs; no user-care authentication outage.
5. **Scenario truth:** Retrieve authentic advisory and reconcile its original Phase 4/5 numbering, IOCs and claims; check FortiGate SSL-VPN exposure and whether any incident/PHI exfiltration actually occurred. **Do not certify deployed protection without timestamped production evidence.**

## References

### MedDefense internal evidence

- [1x05 Task 0 — Advisory Analysis](0-advisory_analysis.md); [Task 1 — CVE Deep Dive](1-cve_deep_dive.md); [Task 2 — Kill Chain Overlay](2-kill_chain_overlay.md); [Task 3 — 72-Hour Plan](3-emergency_plan.md).
- [1x04 T0 — Crypto Inventory](../1x04_crypto_foundation/0-crypto_inventory.md), [T13 — Encryption Levels](../1x04_crypto_foundation/13-encryption_levels.md), [T14 — Key Management](../1x04_crypto_foundation/14-key_management.md), [T15 — Posture Audit](../1x04_crypto_foundation/15-crypto_posture_audit.md), [T20 — Implementation Playbook](../1x04_crypto_foundation/22-implementation_playbook.md).
- [1x02 Vulnerability Triage](../1x02_the_weak_links/16-triage.md): F003 EHR, F007 LDAP signing, F015 NAS access, F018 Kerberos; [1x00 Gap Analysis](../1x00_first_watch/12-gap_analysis.md): GAP-006/007/011/015/016/017; [1x03 Budget](../1x03_defense_blueprint/8-budget_allocation.md): C1/C2/C3/C4/C6 proposed, not deployed.

### Public technical guidance (mechanics, NOT confirmation of Crimson Tide campaign)

- [NIST SP 800-111 — Guide to Storage Encryption Technologies](https://csrc.nist.gov/pubs/sp/800/111/final): full-disk/volume encryption protects unbooted/locked storage, not the plaintext processed by a running system.
- [PostgreSQL 14 — pgcrypto security limitations](https://www.postgresql.org/docs/14/pgcrypto.html): DB-server-resident cryptography requires trusting the database host and administrator.
- [CISA / MS-ISAC Ransomware Guide](https://www.cisa.gov/sites/default/files/publications/CISA_MS-ISAC_Ransomware%20Guide_S508C.pdf): separate offline encrypted backups, test recovery and protect against deletion.
