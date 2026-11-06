# MedDefense Health Systems — Task 18: The Data Classification Matrix

**Project:** 1x04 — Cryptographic Foundation
**Deliverable:** `18-data_classification.md`
**Assessment date:** 6 November 2026
**Audience:** James Chen (Deputy CISO), Sarah Park (IT Director), EHR/PACS clinical data owners, Robert Kim (CFO), DPO/Legal, Biomedical Engineering and all staff
**Status:** **Proposed classification and handling policy, not evidence that controls are implemented or approved.**
**Basis:** 1x04 T0/T6/T13/T14/T15; 1x03 T4 governance, T10 Risk Register and T18 roadmap; 1x00 asset/data inventories. Some categories below are **policy coverage examples** pending inventory confirmation, not claims that MedDefense currently stores those specific files.

## Executive policy decision

Assign **one highest-applicable handling label** to every MedDefense dataset, document, email, data export, database table, backup, log and derived copy: **Public < Internal < Confidential < Restricted**. Separately record **all applicable data types**—Regulated (PHI/health), PII, Financial, Intellectual Property (IP), Legal and Operational—because a dataset can be both Financial and PII or both health information and Legal. Classification determines authorized purpose, encryption boundary, access, key custody, sharing, retention, restoration and incident response; **an encrypted file is not automatically safe to share with an unauthorized person**.

**Jurisdiction guardrail:** Identifiable medical information is **special-category health data under GDPR Article 9** when the GDPR applies; **PHI/ePHI and HIPAA** are relevant when a US covered entity/business associate or other applicable HIPAA relationship is established. The fictional MedDefense scenario does **not** establish US HIPAA-regulated status; the column title “Regulated (HIPAA/PHI)” follows the assignment vocabulary, **not** a legal finding that HIPAA automatically governs this hospital. The DPO/Legal team must confirm jurisdiction, lawful basis, contractual terms and retention requirements.

## Part 1 — Data type inventory and classification map

**Type definitions:** **Regulated (PHI/health)** = identifiable clinical/care data requiring special protection; **PII** = information identifying or making a natural person identifiable; **Financial** = revenue, billing, tax, account, payment and budgets; **IP** = proprietary code, designs, models and research; **Legal** = privileged advice, contracts, claims, regulatory records and disputes; **Operational** = processes, system configurations, logs, schedules, safety and recovery procedures. The last four can be combined with PII/regulated data; a type is **not** a security level by itself.

| Data / actual or anticipated MedDefense store | Data type(s) — non-exclusive | Default classification | Owner / rationale / evidence status |
|---|---|---|---|
| **Identifiable patient EHR records**, diagnoses, prescriptions, HIV status, lab results (`ehr-db-01`, EHR apps; ~50,000 patient records in T5 scenario) | **Regulated (PHI/health) + PII**; sometimes Legal | **Restricted** | Designated EHR clinical data owner; T0 confirmed plaintext PostgreSQL storage and optional client TLS; RISK-001. HIV status is *not* a lesser category than other identifiable health data. |
| **PACS/DICOM image pixels, patient name, identifiers and study metadata** (`pacs-srv-01`; radiology/MRI) | Regulated (PHI/health) + PII + Operational | **Restricted** | Radiology clinical owner; T0 confirms unencrypted images and DICOM transport; RISK-003. “Image only” is not anonymous by default. |
| **Pharmacy medication lists, doses and clinical update records** | Regulated (PHI/health) + PII + Operational | **Restricted** | Pharmacy Department Head; 1x03 RISK-005, patient-safety integrity; change audit and dual approval mandatory. |
| **BD Alaris patient-linked pump configurations, drug library and treatment parameters** | Operational + Regulated/PII **if patient-linked** + IP where proprietary | **Restricted** for active safety-critical settings or patient linkage | Biomedical/clinical owner; RISK-004. Non-patient vendor firmware binaries are at least **Confidential** unless publicly released; signed-update integrity remains mandatory regardless of label. |
| **Billing transaction details and invoices with patient identifiers** (`billing-srv-01` MySQL) | Financial + PII; **Regulated** when visit/diagnosis/treatment is disclosed | **Restricted** when health-linked; otherwise **Confidential** | Robert Kim / Billing owner; T0 plaintext database and app-to-MySQL traffic; RISK-008. Payment card data, if discovered, require separate PCI scope assessment. |
| **Aggregate financial statements, business plans, budgets and forecasts** | Financial + Operational | **Confidential** until approved publication | CFO; published annual financial summary can become **Public** after documented authorization. |
| **Employee HR files, payroll, identity/contact and personal bank details** (including an HR share if confirmed) | PII + Financial + Legal | **Confidential**; **Restricted** for medical/disciplinary or highly sensitive employee contents | HR owner with DPO; some assets in prior inventory; distinguish general staff directory (Internal) from personnel files. |
| **Ordinary staff directory, internal meeting schedule and non-sensitive shift logistics** | Operational; potentially limited PII | **Internal** | HR / department head; do not put private home addresses, patient appointments or health absences in this tier. |
| **Patient appointment lists or internal clinic schedules with patient identities** | Regulated + PII + Operational | **Restricted** | Clinical reception/data owner; although named “schedule,” it reveals healthcare relationships and must not be treated as a generic staff calendar. |
| **Employee and clinical emails in O365 / Exchange Online** | Content-dependent: Operational, PII, Financial, Legal, Regulated | **Content-sensitive; Restricted if PHI/secrets, otherwise Internal/Confidential** | Sender plus business data owner; T0 reports service encryption and TLS 1.2 but no configured S/MIME/OME for sensitive patient messages. Labels apply to body, attachments and exports. |
| **Patient portal submissions, session tokens and uploaded documents** (`web-srv-01`) | Regulated + PII; authentication secrets | **Restricted** | Portal/EHR data owner; T0/F005/F013 show TLS/certificate risks; tokens and reset links are treated as secrets. |
| **AD service-account credentials, passwords, password hashes, API tokens, MFA recovery codes** (`ad-dc-01`, `ad-dc-02`) | Operational + security secret + possibly PII | **Restricted** | Sarah's identity custodians; T0 legacy NT hashes, DES/RC4 accepted; RISK-002. A password hash is not safe to publish because it is not plaintext. |
| **KMS/HSM keys, LUKS recovery material, TLS/VPN private keys, backup KEKs and escrow manifests** | Operational + security secret | **Restricted** | James (policy) / Sarah (custodian); T14 mandates independent key custody and dual-control recovery, **NOT on NAS-01** in plaintext. Public certificates without private keys are not themselves Restricted. |
| **NAS-01 database dumps, PACS snapshots and any encrypted AWS offsite replicas** | **Inherit every source data type**, commonly Regulated + PII + Financial + Operational | **Restricted** (highest class in backup set) | Backup owner under Sarah; T0/T12/T13/T14. Encryption/immutability do **not** downgrade the classification. |
| **Security logs, incident evidence, network diagrams and vulnerability reports** | Operational + PII where user/IP details exist + Legal when litigation-related | **Confidential**, rising to **Restricted** for secrets/PHI or privileged exploit details | James / Security Analyst; logging data may carry tokens and patient identifiers and must be sanitized before sharing. |
| **Vendor contracts, procurement negotiations, support agreements** | Legal + Financial + Operational; possible IP | **Confidential** | Procurement/Legal; raise to Restricted if contract bundle contains PHI, secrets or protected litigation material. |
| **Legal advice, dispute records, privileged incident response correspondence** | Legal; possible PII/Regulated | **Confidential** or **Restricted** when identifiable health data / high-impact material appears | Legal/DPO; preserve privilege and discovery hold; classification is not a substitute for legal privilege controls. |
| **Proprietary clinical algorithms, unpublished research and internal software/source** *(if present)* | IP + Operational; Regulated/PII **if linked** | **Confidential**; **Restricted** if patient-linked or containing secrets | Research/software owner to be verified; T0 did **not** independently inventory a research repository. Pseudonymization is not automatically anonymization. |
| **Public website pages: hospital address, visiting hours, published cafeteria menu** | Operational / public communication | **Public** after approval | Communications/Facilities; protect published page integrity and delivery with HTTPS even though the information is not secret. |

**Classification inheritance and edge cases:** A joined table, screenshot, spreadsheet, analytics export, email forward, database replica and backup inherit the **highest** class of any included source. Remove **all** direct/indirect identifiers and assess re-identification risk with the DPO before declaring a derivative genuinely anonymous; pseudonymized health data remain personal data. Pure clinical device integrity can warrant **Restricted** even where no PII exists, because unauthorized modification may harm patients.

## Part 2 — Four classification levels and required protection

The algorithm and key settings are **target-state policy baselines, not a claim that every application supports the same implementation**; T13 specifies Full-disk/Volume/File/Database/Record according to storage boundary and T14 governs KEK/DEK lifecycle. **TLS 1.2 with approved AEAD or TLS 1.3** is the normal minimum for protected network flows; avoid legacy TLS 1.0, RC4, DES and unauthenticated plaintext channels. Use **AES-XTS for disk/volume confidentiality** and **AES-GCM for authenticated records/files/backup objects** where supported—do not substitute unauthenticated AES-CBC for an AEAD requirement.

| Level | Who may access | Encryption **at rest** | Encryption **in transit** | What happens if exposed / required response |
|---|---|---|---|---|
| **Public** | Anyone **after owner-approved release**; only delegated publishers can modify | No confidentiality encryption required for intentionally public content; maintain integrity and secure publishing/storage administration | **HTTPS/TLS 1.2+** for websites and publishing interfaces to authenticate origin and prevent tampering | Public read itself is not a secrecy breach; **unauthorized changes**, spoofing or premature release trigger correction, audit and communications review. |
| **Internal** | Authenticated MedDefense staff/contractors with a work purpose; no anonymous/public shares | Managed encrypted endpoint disks/volumes (e.g., BitLocker/LUKS2 AES-XTS or approved platform equivalent); approved internal service storage | TLS 1.2+/1.3, verified peer; approved IPsec for sites; no unauthenticated plaintext internal services | Report accidental external disclosure to IT Security/data owner; contain sharing, determine whether any PII or higher class was included and reclassify if needed. |
| **Confidential** | Named, least-privilege job roles and approved counterparties; MFA for privileged/remote access | AES-256-XTS volume/full-disk or engine-supported TDE; AES-256-GCM for exported files/objects; separate authorized KMS/vault, encrypted backups | Authenticated TLS 1.2+ with approved AEAD, preferably TLS 1.3; approved encrypted attachments/portals for external transfer | **Immediate internal incident report** to Security/owner; revoke links/tokens, preserve evidence, evaluate financial, contractual, privacy or IP loss with CFO/Legal/DPO as relevant. |
| **Restricted** | Individually authorized clinical/identity/key-custodian roles on a **need-to-know** basis; emergency *break-glass* access must be time-limited, attributable and audited | AES-256-XTS volume protection **plus** selective application/record AES-256-GCM or equivalent AEAD where SQL/admin access is a threat; KMS/HSM-protected KEK, separated recovery escrow, encrypted immutable offsite backups, audited access and restore tests | Strong mutually authenticated TLS 1.2/1.3 where supported (mTLS for service-to-service), DICOM TLS after vendor approval, encrypted patient messaging, IPsec where applicable; no ordinary plaintext email of PHI/keys | **Urgent security/clinical escalation**, isolate exposure without disrupting care, preserve evidence; DPO/Legal assesses GDPR/HIPAA duties and required notifications, clinical owner manages patient-safety risk, James directs response and Sarah restores secure service. |

**Exposure workflow applies at every tier:** stop further disclosure; **do not delete logs or conceal an incident**; report through approved IT Security/clinical channels; identify class, affected people/records and recipients; the Security Analyst collects evidence, James coordinates security response, Sarah contains/recovers, and the data owner/DPO/Legal assess severity and reporting. **GDPR supervisory-authority reporting (commonly 72 hours after awareness where the risk threshold is met) and any HIPAA deadlines are legal determinations, not blanket automatic notifications for every internal incident**. Staff must report promptly so those decisions can be made on time.

### 2.1 MedDefense implementation controls linked to earlier tasks

| System / tier | Primary encryption level (T13) | Key and operational rule (T14) | Known T0/T15 issue and priority |
|---|---|---|---|
| **EHR Restricted** | **Volume**, selective **Record** | EHR KMS/HSM-backed KEK and app-scoped wrapped DEKs; separate LUKS recovery escrow; clinical approval for all changes | Unencrypted ext4 and optional PostgreSQL TLS; remediate urgently with controlled migration and restore test. |
| **PACS Restricted** | **Volume**, **File** for patient-linked exports | Separate export keys and protected image storage; DICOM TLS **only after vendor/MRI compatibility sign-off** | Plaintext PACS media and DICOM transfer; RISK-003. |
| **NAS-01 / AWS copies Restricted** | **Volume** plus **File/object** encryption **before** cloud replication | MedDefense-controlled off-NAS KEK/DEKs, separate backup/restore identities, immutable offsite store and dual-control recovery | Plaintext NAS backup, unverified backup transport, 1x03 C4 only **proposed**. |
| **Billing Confidential or Restricted by content** | **Database** encryption (MySQL InnoDB tablespaces if supported) + secure volume | KMS/keyring external to database config; encrypt dumps, redo/undo, binlogs and backups; enforce authenticated DB TLS | T0 plaintext ext4 and billing app→MySQL link; RISK-008. |
| **O365 content-sensitive** | Provider service/mailbox encryption plus **message/File** protection | Approved sensitivity labels, encrypted message/attachment flows; verify tenant controls with DPO | TLS/storage are reported, but message-level PHI confidentiality is an open gap. |
| **Employee laptops Internal → Restricted by contents** | **Full-disk** | TPM-backed BitLocker/LUKS, central recovery escrow and remote wipe/lock process | Endpoint enforcement not verified; lost-device disclosure risk requires inventory and testing. |
| **Alaris operational Restricted for safety-critical settings** | **File** on managed distribution/backup repository; vendor-approved on-device controls | Signed firmware provenance, change approval, Biomedical/vendor supervision, tested rollback; do not encrypt live device firmware ad hoc | RISK-004 clinical safety; encryption alone does not ensure firmware integrity. |

**Access + retention rules:** Each dataset must have a named data owner, a technical custodian, documented purpose and approved recipients, a record of processing where applicable, retention/deletion rules, a tested restore target and a label that travels with exports. Labels do not override legal secrecy rules, emergency care requirements or litigation holds; classification can be raised immediately by the owner but lowered only after documented DPO/owner review. Human access and cryptographic key administration are segregated: the ability to manage a server must **not** imply permission to decrypt all records or backups.

## Part 3 — Staff-facing classification decision tree

```text
START: What will this document, message, file or dataset contain?
 |
 +-- Patient health, diagnosis, prescriptions, imaging, patient appointment,
 |   identifying clinical detail, or safety-critical treatment settings?
 |      YES --> RESTRICTED [Regulated/PHI + PII where identifiable;
 |                         Operational when device safety is involved]
 |      NO  --> Continue
 |
 +-- Passwords, MFA recovery codes, tokens, private certificates,
 |   encryption keys, key escrow or privileged secrets?
 |      YES --> RESTRICTED [Operational / credential secrets]
 |      NO  --> Continue
 |
 +-- Contains other highly sensitive personal information or a legal hold
 |   requiring the highest controls, or combined data enabling PHI inference?
 |      YES --> RESTRICTED [PII / Legal / possibly Regulated]
 |      NO  --> Continue
 |
 +-- Non-public financial reports, invoices, payroll, vendor contracts,
 |   personnel files, intellectual property or protected legal advice?
 |      YES --> CONFIDENTIAL [Financial / PII / IP / Legal as applicable]
 |      NO  --> Continue
 |
 +-- Intended only for staff: internal operating instructions, non-sensitive
 |   staff directory, team meeting schedule, routine system information?
 |      YES --> INTERNAL [Operational; possibly limited PII]
 |      NO  --> Continue
 |
 +-- Explicitly approved by the responsible publisher for public release,
 |   e.g., hospital address, visiting hours, cafeteria menu?
 |      YES --> PUBLIC [Operational / approved communications]
 |      NO  --> INTERNAL temporarily; ask the data owner / DPO.
 |
 FINAL: Apply the HIGHEST classification of any component; record ALL data
 types; label copies and attachments; confirm recipients, encryption and
 retention. When unsure, DO NOT publish or externally transmit the data.
```

**Three examples:** (1) A billing spreadsheet listing patient names and procedures is **Restricted**, not merely Confidential financial data; (2) a generic shift meeting without patient identifiers is **Internal**, while an appointment list naming patients is **Restricted**; (3) an approved cafeteria menu is **Public**, but an unpublished vendor pricing contract is **Confidential**.

## Part 4 — Data sovereignty and geolocation (3-sentence decision)

**Data sovereignty matters in healthcare because patient records and backup copies may be subject to GDPR special-category safeguards, national healthcare secrecy rules, contractual residency restrictions and legal-access regimes that differ by country, so MedDefense must approve the AWS Region, subprocessors, administrative access locations and replication destinations before any migration.** **A move to another US state is not inherently a HIPAA violation, nor does HIPAA categorically forbid another country: where HIPAA applies, MedDefense must execute the appropriate AWS Business Associate Agreement (BAA), use HIPAA-eligible services and meet the Security Rule; for EU/EEA patient data moved outside the EEA, GDPR Chapter V requires an applicable transfer mechanism and potentially a transfer-impact assessment and supplementary safeguards.** **MedDefense-controlled client-side AES-256-GCM encryption, keys outside AWS backup access roles and TLS mitigate disclosure risk, but encryption does not by itself change data location or eliminate jurisdiction, vendor-contract, lawful-access, transfer, restoration or clinical-availability obligations.**

**Cloud approval gate (operational evidence, not extra legal conclusions):** Require written DPO/Legal assessment; verify AWS region/bucket and cross-region replication configuration; sign appropriate GDPR processor agreement and HIPAA BAA only if applicable; restrict IAM and egress; confirm object-lock/immutability and deletion schedules; ensure escrowed MedDefense-owned keys can decrypt independently of NAS/AWS administrative compromise; rehearse a full restore; document any transfer or support access from outside the EEA. An EU AWS Region is a **geographic preference**, not automatically proof of compliance across all service, access and transfer arrangements.

## Governance, acceptance and status

| Decision / action | Responsible or approving role | Evidence needed before closure |
|---|---|---|
| Set classification policy, approve exceptions | James Chen proposes; CEO approves; DPO/Legal reviews | Signed policy, version and annual review; risk register with expiring exceptions |
| Classify patient, image, pharmacy and clinical device data | Named clinical department owner; Biomedical for devices | Itemized data inventory; patient-safety and privacy approval; permitted workflow tests |
| Implement access, disk/DB encryption, logging and backups | Sarah Park / designated IT custodians | Positive + denied-access tests, cipher/key metadata, independently recoverable encrypted restore |
| Validate permissions and report incidents | Security Analyst under James; DPO/Legal decide reporting duties | IAM logs, classification audit, ticket and chain of custody; no PHI in test data |
| Authorize AWS third-party processing and budget | CEO/Finance/Procurement + James, DPO/Legal and data owners | Complete supplier/processor and region assessment, contractual terms, all-in cost and restored-data verification |

**Acceptance criteria:** Every in-scope source has a recorded type set, unique handling label and owner; every Restricted dataset has documented approved access, encrypted rest/transit and recoverable independent keys; the DPO signs off cloud transfer decisions; staff can follow the tree without confusing generic financial data with health-linked invoices; audit sampling proves labels survive email/export/backup; and no production remediation is claimed without actual technical evidence.

## Sources and traceability

**MedDefense project evidence:** [T0 — Data Protection Map](0-crypto_inventory.md); [T6 — Algorithm Landscape](6-algorithm_landscape.md); [T13 — Encryption Levels](13-encryption_levels.md); [T14 — Key Management](14-key_management.md); [T15 — Crypto Posture Audit](15-crypto_posture_audit.md); [1x03 T4 — Governance Architecture](../1x03_defense_blueprint/4-governance_architecture.md); [1x03 T10 — Risk Register](../1x03_defense_blueprint/10-risk_register.md); [1x03 T18 — Six-Month Roadmap](../1x03_defense_blueprint/18-roadmap.md). These documents contain baseline observations and **proposals**, not a verified production rollout.

**Authoritative external guidance (accessed 6 November 2026):**

1. [European Commission — Special categories of personal data (GDPR Article 9)](https://commission.europa.eu/law/law-topic/data-protection/information-individuals_en) — identifiable health information needs enhanced protection.
2. [European Data Protection Board — International transfers](https://www.edpb.europa.eu/sme/be-compliant/international-data-transfers_en) and [Luxembourg CNPD — Third-country transfer assessment](https://cnpd.public.lu/en/dossiers-thematiques/transferts-internationaux-donnees-personnelles/transferts-dehors-eee-sans-protection-adequate.html) — Chapter V, SCCs/adequacy, risk assessments and possible supplementary safeguards.
3. [US HHS — HIPAA and cloud computing](https://www.hhs.gov/hipaa/for-professionals/special-topics/health-information-technology/cloud-computing/index.html) and [HHS — Overseas ePHI guidance](https://www.hhs.gov/hipaa/for-professionals/faq/business-associates/index.html) — BAA and security obligations even when provider cannot decrypt; HIPAA does not categorically bar hosting abroad.
4. [AWS — HIPAA compliance and BAA](https://aws.amazon.com/compliance/hipaa-compliance/), [AWS — S3 Region semantics](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html) — available agreements, shared responsibility and region configuration; verify eligibility before use.
5. [HHS — HIPAA Security Rule summary](https://www.hhs.gov/hipaa/for-professionals/security/laws-regulations/index.html) — required vs addressable safeguards; no blanket statement that a specific AES key length is legally mandated for every class.

**Approval status:** Pending James Chen / Sarah Park / business data owners / DPO / CEO as specified; this draft does **not** certify GDPR, HIPAA or AWS compliance.
