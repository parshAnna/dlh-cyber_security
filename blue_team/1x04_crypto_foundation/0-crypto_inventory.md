# MedDefense Health Systems — Data Protection Map

**Project:** 1x04 — Cryptographic Foundation | **Task:** 0 — The Crypto Inventory  
**Document status:** Baseline inventory for review; not evidence of remediation  
**Assessment basis:** Sarah Park, *MedDefense Cryptographic Audit Notes* (Week 5, Day 1), cross-checked against Projects 1x00–1x03  
**Prepared for:** James Chen, Deputy CISO; Sarah Park, IT Director; Data Protection Officer; Clinical and Biomedical stakeholders  
**Scope:** Exactly seven specified data categories × three data states = **21 cells**. The patient portal is assessed separately so the requested denominator remains 21.

## 1. Scope, Definitions and Evidence Rules

- **At Rest:** Data stored in database files, mailboxes, images, drives or backup copies.
- **In Transit:** Data carried between applications, workstations, servers, mail systems or sites.
- **In Use:** Data decrypted and handled by a running process or shown to an authorized user. Ordinary memory and display processing generally requires plaintext; this column inventories *additional controls evidenced*, not a promise of perpetual encryption.
- **Adequate:** Documented cryptographic protection meets the stated transport/storage baseline **for that particular cell**; it is not a full regulatory compliance finding.
- **Weak:** Some protection exists but known downgrade, obsolete primitives, or mixed protected/unprotected paths weaken it.
- **Absent:** No relevant cryptographic protection is documented, or the audit explicitly says none. **An absence of documentation is not proof that an undisclosed technical control does not exist.** Flags below distinguish these cases.
- **Evidence flags:** **[CONFIRMED]** explicitly stated in the audit; **[UNVERIFIED]** no relevant configuration or test data supplied; **[N/A]** state not meaningfully applicable to the stated data object, included only to honor the 21-cell assignment matrix.
- **Source names:** `Audit` = Sarah Park's supplied `meddefense-crypto-audit-notes.txt`, with its section title. `F###` = Project 1x02 numbered finding. References are analytical inputs, **not new live OpenSSL, packet-capture or configuration verification**.

## 2. Data Protection Matrix — 7 × 3

Every cell states **Protection**, **Evidence**, and **Status**. Where the audit does not specify an algorithm or a control, `None documented` deliberately avoids inventing one.

| Data category / system | **At Rest** | **In Transit** | **In Use** |
|---|---|---|---|
| **1. Patient medical records** — PostgreSQL 14 (`ehr-db-01`), EHR (`ehr-srv-01`) | **Protection:** None; ext4 data directory without an encryption layer.<br>**Evidence:** Audit §Patient Data: explicitly unencrypted PostgreSQL files; 1x03 RISK-001.<br>**Status: Absent** **[CONFIRMED]** | **Protection:** PostgreSQL SSL enabled but **not enforced**: both `hostssl` and `hostnossl` in `pg_hba.conf`; actual session encryption unknown.<br>**Evidence:** Audit §Patient Data; 1x02 F003 (broad `10.10.0.0/16` database reachability).<br>**Status: Weak** **[CONFIRMED configuration; sessions UNVERIFIED]** | **Protection:** None documented for decrypted application memory/display; workstation automatic screen locking disabled (`Never`).<br>**Evidence:** Audit §Patient Data; 1x00 identity/workstation-accountability context.<br>**Status: Absent** **[CONFIRMED lack of listed additional controls]** |
| **2. Financial/billing data** — MySQL (`billing-srv-01`) | **Protection:** None; unencrypted ext4 MySQL files.<br>**Evidence:** Audit §Financial Data and 1x00 crypto-miner forensic observation (database files accessible without MySQL credentials).<br>**Status: Absent** **[CONFIRMED]** | **Protection:** None for documented billing application ↔ MySQL path; MySQL does not require SSL and the application uses plaintext protocol.<br>**Evidence:** Audit §Financial Data; 1x02 F006 (MySQL bound to `0.0.0.0`).<br>**Status: Absent** **[CONFIRMED for documented path]** | **Protection:** None documented for active MySQL/application processing or exposed sessions.<br>**Evidence:** Audit §Financial Data covers stored and transmitted data only; no in-use mechanism supplied.<br>**Status: Absent** **[UNVERIFIED; evidence gap]** |
| **3. Medical images** — DICOM (`pacs-srv-01`, radiology/MRI) | **Protection:** None; PACS image files on local unencrypted disk.<br>**Evidence:** Audit §Medical Images; 1x03 RISK-003; 1x00 GAP-003 (unproven independent PACS recovery).<br>**Status: Absent** **[CONFIRMED]** | **Protection:** None; DICOM images and identifying headers sent in cleartext on TCP 4242/11112.<br>**Evidence:** Audit §Medical Images; 1x02 F024; 1x01 KC3.<br>**Status: Absent** **[CONFIRMED]** | **Protection:** None documented for decrypted image viewing, process memory or clinical display sessions.<br>**Evidence:** Audit §Medical Images contains no in-use controls; 1x03 RISK-003.<br>**Status: Absent** **[UNVERIFIED; evidence gap]** |
| **4. Credentials** — Active Directory (`ad-dc-01`, `ad-dc-02`) and application passwords | **Protection:** NT hashes based on **MD4** for NTLM compatibility; this is password hashing, **not reversible data encryption**. Application password-storage mechanisms are undocumented.<br>**Evidence:** Audit §Credentials: NTHash/MD4; 1x00 GAP-011.<br>**Status: Weak** **[CONFIRMED for AD; other apps UNVERIFIED]** | **Protection:** Kerberos supports **AES-256/AES-128**, but **RC4 and DES remain enabled**; LDAP encryption is not required by the documented setup.<br>**Evidence:** Audit §Credentials; 1x02 F018 (legacy Kerberos types), F007 (LDAP signing not required).<br>**Status: Weak** **[CONFIRMED]** | **Protection:** None documented for secrets after authentication (process memory, cached tickets/keys, session handling).<br>**Evidence:** Audit §Credentials covers hash storage and authentication protocols, not runtime secret protection.<br>**Status: Absent** **[UNVERIFIED; evidence gap]** |
| **5. Backup data** — Synology `NAS-01` | **Protection:** None; RAID-5 backup volumes and database dumps stored in plaintext. Optional AES-256-CBC shared-folder encryption is supported **but disabled**.<br>**Evidence:** Audit §Backup Data; 1x02 F015; 1x00 GAP-007/backup control C-022.<br>**Status: Absent** **[CONFIRMED]** | **Protection:** None documented; the audit does **not** specify backup transport or replication encryption, so plaintext transmission must **not** be asserted.<br>**Evidence:** Audit §Backup Data describes NAS storage and key management, but no backup wire protocol.<br>**Status: Absent** **[UNVERIFIED; evidence gap]** | **Protection:** None documented for plaintext restores, backup processing, mounted images or runtime key isolation.<br>**Evidence:** Audit §Backup Data provides no in-use controls; 1x03 C4 recovery proposal is not proof of deployment.<br>**Status: Absent** **[UNVERIFIED; evidence gap]** |
| **6. Email** — Microsoft 365 / Exchange Online (O365) | **Protection:** Microsoft-managed **BitLocker** on datacenter disks and per-mailbox encryption; key custody is with Microsoft.<br>**Evidence:** Audit §Email (O365).<br>**Status: Adequate** **[AUDIT-REPORTED; tenant settings not independently tested]** | **Protection:** **TLS 1.2** for Exchange Online connections per audit; protects documented transport hops, **not end-to-end message confidentiality**. Neither S/MIME nor OME is configured, and sensitive patient information is sometimes emailed in plaintext.<br>**Evidence:** Audit §Email (O365).<br>**Status: Adequate** **[TRANSPORT ONLY; PHI message-level gap OPEN]** | **Protection:** None documented for decrypted mailbox content on users' screens/endpoints, or end-to-end protected handling of PHI.<br>**Evidence:** Audit §Email (O365): no S/MIME/OME; PHI sometimes shared as unprotected message content.<br>**Status: Absent** **[UNVERIFIED runtime protections; confirmed content-policy gap]** |
| **7. VPN traffic** — Central↔Westside and Central↔HQ | **Protection:** None documented for stored *VPN payload*; live tunnel traffic is not a stored dataset. VPN configuration, logs and key backups are **different assets** and are not assessed here.<br>**Evidence:** Audit §VPN Traffic describes tunnels only.<br>**Status: Absent** **[N/A placeholder; NOT an identified at-rest encryption defect]** | **Protection:** **IPsec AES-256 + SHA-256**, **IKEv2**, **DH Group 14** on both site-to-site tunnels.<br>**Evidence:** Audit §VPN Traffic: FortiGate configurations appear adequate; Westside Netgear firmware/security unknown.<br>**Status: Adequate** **[CONFIGURATION REPORTED; endpoint assurance UNVERIFIED]** | **Protection:** None documented for payload after tunnel-endpoint decryption; traffic must normally be processed in plaintext at its destination.<br>**Evidence:** Audit §VPN Traffic contains no host/memory protection information.<br>**Status: Absent** **[N/A/evidence placeholder; NOT proof of a VPN cryptographic defect]** |

### Important interpretation boundaries

1. **PostgreSQL `ssl=on` is not equivalent to `SSL required`.** Audit notes explicitly include `hostnossl`. Measure actual client sessions before labeling any given connection protected or unprotected.
2. **LDAP signing and encryption solve different problems.** The audit confirms signing is not mandatory, but signing by itself does not encrypt LDAP contents. Prove StartTLS/LDAPS transport and enforce integrity separately after application compatibility checks.
3. **Email transport vs message confidentiality are different layers.** TLS 1.2 supports an **Adequate transport-only** score, but lack of S/MIME/OME and risky PHI emailing remain an unresolved patient-privacy gap; the table does not certify all email workflows as safe.
4. **VPN crypto vs router security are different layers.** IPsec algorithms appear adequate in configuration, but unsupported firmware, secrets/key lifetime, peer authentication and implementation vulnerabilities remain unverified (1x02 F014).
5. **In-use processing cannot normally stay ciphertext throughout.** An `Absent` entry in the in-use column means *no additional protection evidenced in these notes*, not that normal EHR viewing, image processing or tunnel termination is inherently a cryptographic failure. Runtime controls need a separate assessment.
6. **VPN at rest / in use are bookkeeping cells.** They satisfy the strict **7 × 3** exercise grid but do **not** represent two verified exposures. They should be excluded from an actionable-remediation backlog unless a real stored VPN asset or endpoint-processing weakness is discovered.

## 3. Gap Summary and Coverage Calculation

| Category | Adequate | Weak | Absent | Total |
|---|---:|---:|---:|---:|
| Patient medical records | 0 | 1 | 2 | 3 |
| Financial/billing data | 0 | 0 | 3 | 3 |
| Medical images | 0 | 0 | 3 | 3 |
| Credentials | 0 | 2 | 1 | 3 |
| Backup data | 0 | 0 | 3 | 3 |
| Email (O365) | 2 | 0 | 1 | 3 |
| VPN traffic | 1 | 0 | 2 | 3 |
| **Total** | **3** | **3** | **15** | **21** |

**Arithmetic checks:** `7 categories × 3 states = 21 cells`; `3 Adequate + 3 Weak + 15 Absent = 21`.

- **Adequate:** `3 ÷ 21 × 100 = 14.29%`.
- **Weak:** `3 ÷ 21 × 100 = 14.29%`.
- **Absent:** `15 ÷ 21 × 100 = 71.43%`.
- **Overall cryptographic coverage (strict assignment measure):** **3 / 21 × 100 = 14.29%, approximately 14.3%.** Weak cells do **not** count as adequate. This is a **cell-count indicator**, not a weighted security-maturity, patient-impact or legal-compliance percentage.

**Assurance caveat:** Of the 15 `Absent` cells, **two are VPN [N/A] placeholders**, and several other cells are **[UNVERIFIED] evidence gaps**, not confirmed plaintext exposures. The 14.3% figure deliberately uses all 21 requested cells; an analytically adjusted metric would need agreed applicability and verification rules before comparing systems. It must **not** be described as “85.7% of production data is demonstrably unencrypted.”

### Confirmed weaknesses versus evidence gaps

- **Confirmed missing at-rest protection:** EHR PostgreSQL, billing MySQL, PACS local images, and NAS backups (**4 cells**).
- **Confirmed missing encryption on documented transport paths:** billing application → MySQL and MRI/radiology → PACS DICOM (**2 cells**).
- **Confirmed weak/mixed cryptography:** EHR PostgreSQL optional SSL; AD NTLM MD4 hashes; AD legacy DES/RC4 and insufficiently assured LDAP protection (**3 cells**).
- **Other `Absent` cells:** unverified in-use controls (multiple categories), backup transport protection not recorded, plus two VPN N/A placeholders; **do not infer technical absence without validation**.
- **Cross-cutting gap outside this 21-cell tally:** Email lacks configured S/MIME/OME despite patient information sometimes being emailed as unprotected message content; TLS alone does not solve this.

## 4. Additional Critical System — Patient Portal (Outside the Required 21-Cell Matrix)

**System:** `web-srv-01` patient portal; included as a tracked risk because excluding it from the *seven required rows* must not conceal a known critical finding.

| State | Protection and evidence | Assessment |
|---|---|---|
| At Rest | Audit §Patient Portal does not document portal/database disk encryption; do not infer plaintext storage without inspecting its backing data stores. | **Unverified** (not counted) |
| In Transit | **TLS 1.0 and 1.2 enabled**, TLS 1.3 not enabled, HSTS and OCSP stapling not configured, cipher suite inventory missing. 1x02 **F005** supports obsolete TLS. | **Weak**; urgent hardening after client compatibility checks |
| In Use | Audit supplies no portal session/memory protection evaluation. | **Unverified** (not counted) |

**Certificate:** 1x02 **F013** and Audit §Patient Portal report a Let's Encrypt certificate expiring in **18 days relative to the Week 5 audit**, with **no automatic renewal**. Do **not** invent an absolute expiry date; confirm the certificate's live `notAfter`, names, chain and renewal method before cutover. Test success and failure of approved portal clients to avoid excluding the scenario's 800 patients.

## 5. Prioritized Validation and Remediation Backlog

| Priority | System / gap | Proposed next action (not yet deployed) | Evidence required for closure | Responsible role and safeguards |
|---|---|---|---|---|
| **P0** | Portal legacy TLS and expiring certificate | Inventory actual suites/client support; stage valid replacement certificate and renewal; disable TLS 1.0 and nonapproved suites only after tests. | OpenSSL + SSL Labs evidence; confirmed valid hostname/chain and renewal; legacy client testing, documented rollback. | Sarah Park / web owner; James security review; clinical access checks. |
| **P0** | EHR PostgreSQL plaintext files and optional SSL | Design tested encrypted storage/key recovery; inventory real SQL sessions; require encrypted app→DB connections and remove `hostnossl` safely. | Filesystem/volume config, key escrow and restore drill; observed TLS session enforcement, denied plaintext connection and passed EHR workflow. | Sarah Park + EHR data owner, DPO; change/rollback approval. |
| **P1** | NAS plaintext and shared failure domain | Plan **independently recoverable, encrypted, immutable offsite backups**, with keys kept outside the same NAS failure domain. | Cipher/key custody evidence; successful isolated full restore (including PACS scope); backup transport verified. | Sarah / Recovery + Radiology + James; ties to 1x03 C4. |
| **P1** | Cleartext PACS DICOM and image storage | Obtain vendor support matrix for DICOM TLS/certificates and legacy XP MRI compatibility; assess encrypted PACS volumes. | Approved imaging tests, certificate chain, DICOM success/denial tests, no lost studies, vendor/Radiology sign-off. | Radiology + Biomedical + Sarah; 1x02 F024, 1x03 KC3/RISK-003. |
| **P1** | AD DES/RC4, NTLM dependence and LDAP | Inventory service accounts, event logs, legacy clinical/vendor requirements; plan AES-only Kerberos where feasible, secure LDAP transport and signing/channel binding. | Account/service compatibility list, controlled settings, successful authorized Kerberos/LDAP logons and rejected unsafe connections. | Sarah + James + Biomedical; 1x02 F007/F018; no abrupt production disablement. |
| **P1** | Billing MySQL plaintext at rest/in transit | Scope encrypted disk/volume and MySQL client TLS requirement, validate application compatibility, reduce wide listening access. | Encrypted storage and separate recovery key; packet/session TLS evidence, plaintext rejection and successful billing transactions. | Sarah / Billing owner + Robert Kim; 1x02 F006, RISK-008. |
| **P2** | O365 PHI message-level confidentiality | DPO-approved classification, encrypted-message/approved portal workflow, policy and role-based training; audit mailbox and device protection. | Approved message-protection test with an external recipient, exception log, policy acknowledgment and secure disclosure process. | DPO + HR/Clinical + Microsoft 365 admin. |
| **P2** | In-use protection and unknowns | Check access/session locks, EHR/PACS permissions, credentials in memory, recovery mounts and key custody; capture missing backup transport configs. | Evidence-backed revised status per cell; do not claim an algorithm absent because notes are silent. | Sarah / system owners + DPO + James. |

**Algorithm selection note:** A disk/volume encryption design (e.g., LUKS2 with an appropriate disk mode such as AES-XTS) is **not the same layer** as authenticated application-message encryption (e.g., AES-GCM). The actual algorithm, operational mode, secret storage, recovery and vendor compatibility must be justified and lab-tested in later 1x04 tasks; no algorithm or disk layout is asserted as deployed here.

## 6. Source Traceability

| Source | Evidence used |
|---|---|
| **Sarah Park — `meddefense-crypto-audit-notes.txt`** (provided with Task 0) | Explicit system-by-system encryption baseline, audit uncertainty, O365 transport/disk encryption, IPsec configuration, portal certificate timeline. |
| [1x02 — Vulnerability Triage](../1x02_the_weak_links/16-triage.md) | F003 database source scope; F005 TLS 1.0; F006 MySQL reachability; F007 LDAP signing; F013 portal certificate; F014 Westside device; F015 NAS management; F018 legacy Kerberos; F024 cleartext DICOM. |
| [1x00 — Control Matrix](../1x00_first_watch/10-complete_control_matrix.md) and [Gap Analysis](../1x00_first_watch/12-gap_analysis.md) | Legacy backup/restore, PACS protection, shared identities, network boundaries, and documented clinical dependencies. |
| [1x01 — Kill Chains](../1x01_know_your_enemy/10-kill_chains.md) | KC1 VPN→AD ransomware, KC3 radiology→PACS, KC5 vendor→EHR exposure. |
| [1x03 — Risk Register](../1x03_defense_blueprint/10-risk_register.md) | RISK-001/002/003/007/008 and control ownership. |
| [1x03 — Security Strategy](../1x03_defense_blueprint/17-security_strategy.md) | Approved planning priority only; proposed C4 protected backups and 1x04 cryptography handoff are not evidence of implementation. |

## 7. Assessment Sign-off (Pending)

| Review | Responsible role | Status |
|---|---|---|
| Technical accuracy, configuration evidence and test plan | Sarah Park, IT Director | Pending |
| Risk traceability and prioritization | James Chen, Deputy CISO | Pending |
| Patient-information protection and lawful processing | Data Protection Officer | Pending |
| DICOM, MRI and clinical continuity dependencies | Radiology / Biomedical Engineering | Pending |

**Next review trigger:** Any new certificate expiry evidence, encryption/key-management configuration, failed backup restore, high-risk patient-data disclosure, authentication downgrade or medical-device workflow change. **Do not mark gaps closed until configuration evidence and safe positive/negative tests exist.**
