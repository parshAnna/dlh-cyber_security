# MedDefense Health Systems — Task 13: The Encryption Levels

**Project:** 1x04 — Cryptographic Foundation  
**Deliverable:** `13-encryption_levels.md`  
**Assessment date:** 5 November 2026  
**Audience:** James Chen (Deputy CISO), Sarah Park (IT Director), clinical engineering, database and backup owners  
**Status:** Design recommendations derived from the MedDefense scenario and published product documentation; **not** an implemented or tested production deployment.

## 1. Executive decision

Encryption should follow the **threat model and data boundary**, not a uniform “encrypt the database” instruction. MedDefense needs transparent protection against offline disk theft **and**, for particularly sensitive information, controls against excessive access to live applications and database queries. **No at-rest encryption layer by itself protects plaintext after an authorized application, administrator, or attacker with sufficient privileges decrypts it.** Key custody, access controls, audit logs, segmentation, and tested restore procedures remain mandatory.

**Recommended primary levels:** EHR = **Volume** (plus selective Record); NAS backups = **Volume** (plus separately encrypted offsite backup objects); billing MySQL = **Database** (InnoDB tablespace); PACS = **Volume** (plus File for exports); Microsoft 365 email = **service/mailbox-level encryption** (closest *Database*-level analogy, plus message/file controls for sensitive content); employee laptops = **Full-disk**; BD Alaris firmware/configuration artifacts = **File** in the managed distribution and backup repository, **only with vendor-approved on-device controls**. A primary level is not the only necessary layer.

## 2. Part 1 — Six encryption levels (Security+ 1.4 taxonomy)

Performance ratings are **qualitative estimates**, not measured MedDefense storage benchmarks. Hardware acceleration, I/O patterns, concurrent users, backup windows, and data indexing determine actual overhead. Partition and volume controls can use the same block-encryption mechanism; they differ chiefly in the storage boundary and administration model.

| Level | Scope | Performance Impact | Key Management | Use Case |
|---|---|---|---|---|
| **Full-disk** | Entire selected physical/virtual disk, including OS and user data where supported; boot partitions/metadata may remain outside encryption. | Usually **low** with modern hardware acceleration; boot unlock, recovery and heavy I/O can add delay. | One or more disk/host keys, TPM/PIN or passphrase unlock, centrally escrowed recovery, device lifecycle/rotation. | Lost or stolen **employee laptops** and removable endpoints. |
| **Partition** | One defined partition, leaving other partitions independently managed. | **Low**, broadly similar to disk-level block encryption; additional unlock/mount operations. | Per-partition keys, independent unlock policy and protected backup of recovery material. | Isolate a specific sensitive partition on a device that also hosts unprotected partitions. |
| **Volume** | A logical volume/container or encrypted storage pool; it may span drives, RAID or snapshots. | Usually **low to moderate**, workload-dependent; backup and mount/unlock orchestration matter. | Per-volume keys, managed KMS/HSM or offline recovery escrow; controlled startup and restore. | **NAS-01**, EHR/PACS storage and other shared server data volumes. |
| **File** | Selected files or folders, sometimes portable outside the host. | **Low for selective files; potentially higher** for large-file handling, metadata and application integration. | File/folder keys, recipient or service authorization, sharing, versioning and revocation complexity. | Encrypted **PACS exports**, firmware/configuration archives, and protected attachments. |
| **Database** | Database pages, tablespaces, or database-managed data files, normally through TDE or engine-specific at-rest encryption. | Often **low to moderate** with an engine-supported implementation, but verify query and backup I/O. | Database master/key-encryption key via keyring/KMS; rotation, recovery and log/backup coverage. | **MySQL billing** with compatible InnoDB tablespace encryption. |
| **Record** | Selected rows, individual fields/columns, or application-managed data objects. | **Moderate to high engineering impact**: encryption per field, search/index limitations, extra KMS calls and application changes. | Fine-grained data-encryption keys, role/tenant separation, envelope encryption, rotation and decryption authorization. | Particularly sensitive **EHR fields** that must remain unreadable to users lacking application-level entitlement. |

**When each is best:**

1. **Full-disk:** Choose it when every locally stored file on a portable device needs broad protection against offline theft with minimal application changes.
2. **Partition:** Choose it when only one fixed partition requires separate encryption and unlock policy while other partitions remain independently managed.
3. **Volume:** Choose it when an entire server/NAS storage pool needs transparent protection across many files or databases without rewriting every application.
4. **File:** Choose it when individual files must stay protected when copied, exported, shared or stored separately from their original encrypted volume.
5. **Database:** Choose it when the specific database engine supports integrated at-rest encryption and transparent SQL behavior is essential.
6. **Record:** Choose it when access to a live database must not automatically reveal selected sensitive fields to every database administrator or application function.

### 2.1 Limits common to all six levels

- **Offline versus online:** Full-disk, partition, volume and database TDE mainly address offline/media theft; an unlocked filesystem or authenticated SQL session can still expose plaintext.
- **Record-level nuance:** For protection from database administrators, encrypt **inside the authorized application before storing data**, with keys inaccessible to the database service; PostgreSQL `pgcrypto` decrypts on the database server and cannot provide that exact isolation by itself.
- **Coverage:** Logs, temporary files, indexes, WAL/redo/undo, snapshots, exported CSVs, copied images, crash dumps and backups must be explicitly mapped or they may remain plaintext.
- **Integrity:** Encryption is not the same as authenticated integrity. Use authenticated encryption where supported for data objects and **digital signatures** for software/firmware provenance.
- **Availability:** No recovery key means encrypted data may be irretrievable; test escrow, restore and emergency access without exposing keys on the protected storage.

## 3. Part 2 — MedDefense Encryption Level Map

The baseline statements below come from the supplied **MedDefense exercise** (prior 1x00–1x03 work), not a fresh inventory scan. All new controls are **proposed**, not claimed to be deployed.

| # | Data store / baseline | Primary recommended level | Complementary controls | Why this fit and what remains exposed |
|---|---|---|---|---|
| **1** | **PostgreSQL patient records — `ehr-db-01`**; case-study ext4 storage unencrypted; SSL available but not universally enforced. | **Volume** using LUKS2/dm-crypt for the EHR data volume, WAL and database snapshots. | **Record** encryption for particularly sensitive PHI in the application with keys outside PostgreSQL; force PostgreSQL TLS, least-privilege roles, audit, secure exports and encrypted backups. | Volume encryption covers the entire live database without assuming native PostgreSQL TDE; targeted record encryption reduces disclosure through excess SQL access, but introduces controlled search/index and clinical-workflow changes. |
| **2** | **Backup repository — `NAS-01`**; backups currently plaintext; reachable attack paths in the scenario. | **Volume** encryption for dedicated backup storage/pool with independently managed LUKS2-equivalent keys (implementation depends on NAS platform). | Backup-object/file encryption **before offsite replication**, immutable/offline copies, segmentation, dedicated backup identities, restore testing and remote key custody. | Transparent encryption protects powered-off or stolen disks, **not** backups exposed by an unlocked, network-accessible NAS; separately encrypted objects protect cloud replicas independently of NAS state. |
| **3** | **MySQL financial records — `billing-srv-01`**; at-rest and transport exposures described. | **Database**: InnoDB tablespace/file-per-table encryption (TDE), **after version/engine and keyring compatibility checks**. | Encrypted OS volume, encrypt redo/undo/binlogs and logical backups, require TLS to MySQL, tokenize or selectively encrypt sensitive payment identifiers, KMS key escrow. | Engine-managed encryption minimizes SQL application changes and protects stolen tablespace files, but authorized SQL access yields plaintext and **logical dumps are not automatically protected**. |
| **4** | **Medical imaging — `pacs-srv-01`**; PACS files and DICOM traffic described as unencrypted. | **Volume** encryption for the primary image store and metadata/indices. | **File** encryption for DICOM exports, research extracts and removable transfers; DICOM TLS for supported links, identity control and integrity/clinical compatibility testing. | Transparent volume encryption preserves high-throughput reads and the PACS file format; modifying every DICOM object directly may disrupt interoperability, so file-level protection is reserved for workflows that support it. |
| **5** | **Email — Office 365 / Exchange Online (O365)**; externally hosted service. | **Database/service level (closest taxonomy analogue)**: retain Microsoft's built-in encrypted mailbox/service data at rest. | Review eligibility for Microsoft **Customer Key** for tenant-controlled root keys; apply **message-level** Purview encryption/sensitivity labels for sensitive emails and **File** protection for attachments/exports; conditional access and DLP. | MedDefense does **not** run Exchange Online disks or independently toggle native database TDE: provider-managed BitLocker and service encryption already protect stored mail; customer controls focus on classified content, sharing and key governance. |
| **6** | **Employee laptops**; portable endpoints, encryption status not verified in the case study. | **Full-disk** (BitLocker on managed Windows; LUKS2 on managed Linux). | TPM-backed unlock with suitable PIN policy, centrally escrowed recovery keys, MDM compliance, screen lock, patching, remote revoke and encrypted removable media. | Theft/loss can expose cached patient or employee data; disk encryption is transparent to ordinary use but does not protect a logged-in stolen device or files already copied elsewhere. |
| **7** | **BD Alaris pump firmware/configuration**; exact model, firmware features and on-device storage capability **not verified**. | **File** encryption for hospital-held configuration exports, firmware packages and vendor-approved backups **outside the pump**. | **Digitally signed/verified vendor firmware**, authenticated update channels, configuration integrity and change control; assess hardware-supported encryption and secure boot **only with BD/clinical engineering approval**. | Unauthorized firmware/config modification can affect infusion safety; encryption alone does **not** authenticate code, and deploying unvalidated LUKS/full-disk changes on a medical device could break operation or certification. |

### 3.1 EHR (`ehr-db-01`) — safe implementation boundary

- Establish all actual PostgreSQL tablespaces, WAL, archives, backups, logs and exported data; map files outside the encrypted data volume.
- Plan maintenance, snapshot/restore and key unlock with a separate recovery path; never reformat an existing ext4 partition as a shortcut.
- For the most sensitive diagnosis/identity fields, pilot **application-side field/record encryption** using envelope encryption and AEAD with dedicated KMS authorization; do not store the decryption key in SQL or a database configuration file.
- Do not treat PostgreSQL `pgcrypto` column encryption as secrecy from the server administrator: its functions execute within the server and can handle plaintext and keys there.
- Enforce database TLS for all authorized client connections; this is **transport security**, not an extra at-rest level.

### 3.2 NAS-01 — key separation, loss and offsite replication

**Encryption level:** Prefer **Volume**, rather than re-encrypting each file individually, for a large heterogeneous backup pool and predictable restore operations; retain per-object encrypted copies for replication.

**Key location:** The master/unlock key must be **NOT on the NAS** itself in reusable plaintext form. Keep recovery material in a separately administered KMS/HSM or offline sealed escrow with access logging, dual control and documented break-glass procedures. A trusted backup service may receive short-lived unlocking authority; do not keep permanent secrets beside the ciphertext.

**Lost-key impact:** If all valid unlock keys and recovery copies are lost, both the encrypted volume and its backups may become **unrecoverable**. Escrow multiple protected recovery paths, separate duties, rotate/revoke on compromise and periodically conduct a documented restore drill; retention without successful decryption is not a usable backup.

**Cloud replica:** Replicate only **encrypted backup objects over TLS**, preserving end-to-end encryption at rest in the cloud as well; do not assume that the NAS's *unlocked* filesystem produces an encrypted cloud copy. MedDefense must retain control of the **client-side backup encryption key** (KMS/HSM outside both NAS and cloud backup access roles), distinct from or properly wrapped separately from the volume unlock key. Cloud-provider server-side encryption is a supplemental layer, not a substitute for MedDefense-controlled client-side encryption. Coordinate this with 1x03's **proposed** immutable/offsite backup control C4.

### 3.3 Billing MySQL — database encryption does not encrypt exported SQL

- Confirm MySQL release, the InnoDB engine, storage layout, and a supported production-grade keyring/KMS before enabling tablespace encryption.
- Include relevant redo/undo logs, binary/relay logs, temporary exports and logical backups; a `mysqldump` of encrypted tables is **plaintext unless separately protected**.
- Require TLS for client-to-database and replication transport, protect billing service credentials, and test restore of encrypted snapshots and keyring material.
- If payment account numbers are processed, prefer authorized payment tokenization and avoid storing them unless operationally required; do not invent PCI scope without an inventory.

### 3.4 PACS — avoid changing clinical image encoding blindly

- Select an encrypted volume that presents ordinary DICOM files after controlled unlock; performance-test image retrieval and emergency imaging access before rollout.
- Encrypt portable/exported images separately and verify who can decrypt them after transfer; preserve DICOM metadata integrity and audit every export.
- Treat unencrypted DICOM/TCP as a **separate in-transit risk**; add supported secure transport and device segmentation with vendor and modality compatibility approval.

### 3.5 O365 and laptops — responsibilities differ

- **O365:** Microsoft operates the underlying storage and service encryption. Microsoft-managed keys are a default; **Customer Key** is optional and depends on licensing/technical eligibility. Sensitive email sharing needs Purview message encryption, classification, access controls and audit, **not** a hypothetical customer-side disk formatter.
- **Laptops:** enforce full-disk policy across the whole managed fleet; a BitLocker/LUKS recovery key must be centrally backed up, access-controlled and recoverable during staff absence or device failure. Check suspend/hibernation and pre-boot protection, not only that a drive reports encrypted.

### 3.6 BD Alaris — clinical safety gate

- Protect **file-level copies** of firmware/configuration in the hospital's update repository or approved exports; store encryption keys away from that repository.
- Verify firmware **digital signatures, approved version, secure update provenance and configuration integrity**; encryption is for confidentiality, signatures are for authenticity and tamper detection.
- **Do not** flash firmware, alter secure-boot settings or deploy filesystem encryption on pumps based solely on this lab. Ask BD and biomedical engineering to confirm exact model/version, supported safeguards, regulatory/clinical approval, rollback procedure and supervised change window.
- BD disclosures show that features and risks vary across Alaris models and firmware versions; no assertion is made that the MedDefense unit supports or lacks any particular encryption feature.

## 4. Performance and key-management decision criteria

In Task 1, the Fedora OpenSSL 16 KiB test recorded approximately **774.56 MB/s for AES-256-CBC**, **1,057.36 MB/s for AES-128-CBC**, and **3,284.10 MB/s for AES-256-GCM** in that benchmark. These figures show CPU cryptographic capacity under that test only; **they are not LUKS AES-XTS throughput, database TDE overhead, PACS latency or cloud backup performance**. Task 12 verified LUKS function but did not benchmark encrypted-versus-unencrypted disk I/O. No defensible single percentage overhead can be computed from these tasks.

| Workload | Before/after acceptance evidence | Recovery/key dependency |
|---|---|---|
| EHR PostgreSQL | Clinician-facing p95 query latency, write throughput, maintenance/replication lag and emergency workflow. | App-side record keys plus volume keys, with separated roles and restores. |
| NAS backup and cloud | Sustained backup/restore throughput, backup-window completion, deduplication and recovery-time objectives. | Offsite KMS/escrow, immutable copies and tested cloud restore. |
| Billing MySQL | Payment posting latency, backup duration, DB logs, failover and transaction consistency. | Keyring at startup; escrow + consistent backups. |
| PACS | DICOM image retrieval p95, large-study import, modality compatibility and emergency availability. | Volumes unlock under controlled failover; protected export keys. |
| O365 / endpoints | Message delivery/open and data-sharing experience; laptop cold boot, lock/unlock and recovery. | Provider/customer key governance; MDM/TPM recovery escrow. |
| Alaris | Clinical engineering acceptance, firmware validation, unchanged infusion operations and rollback plan. | Vendor-controlled recovery and signed update workflow. |

**Key policy:** Assign an accountable owner per key; use least-privilege KMS/HSM, strong identity/MFA, separation of duties, immutable audit, documented key versioning and rotation, escrow, revocation and **successful restore tests**. Key loss and accidental key deletion are availability incidents, not merely security-policy exceptions.

## 5. Implementation order and verification

| Priority | Workstream | Proposed rollout and security verification |
|---|---|---|
| **P0** | NAS-01 and offsite backups | Inventory; select encrypted volume design; separate KMS/escrow; restore in staging; encrypt offsite object before replication; verify cloud ciphertext and key custody; enable immutability; change-control approval. |
| **P0** | EHR and billing | Inventory data paths; pilot EHR LUKS2 volume and selective records; confirm MySQL InnoDB/keyring; force transport TLS; test medical/business workflows, logs, backups, failover and restores. |
| **P1** | PACS and endpoints | Stage encrypted PACS volume and secure exports; benchmark DICOM retrieval; enroll all laptops in full-disk/MDM policy and test recovery. |
| **P1** | O365 | Verify tenant service encryption, eligibility for Customer Key, label policy and encrypted message/attachment flows; measure false positives and external-recipient experience. |
| **Vendor-gated** | BD Alaris | Validate vendor advisories and device inventory; retain signed firmware/config artifacts in controlled encrypted repository; authorize only vendor-supported changes with clinical engineering. |

**Definition of done for each store:** A documented storage boundary and threat model; key owner and recoverable escrow; evidence of encrypted data at rest; negative test of offline plaintext access where applicable; permission/role tests for online access; restore test with the correct key; overhead within clinical/operational acceptance limits; change approval and monitoring. A design recommendation is **not** proof that MedDefense has implemented it.

## 6. Evidence, assumptions and authoritative references

**MedDefense source context:** The exercise's 1x00 asset/criticality and 1x02 vulnerability baseline, 1x01 attack paths and 1x03 proposed C4 offsite backup control. The user-performed Task 1 crypto benchmark and Task 12 LUKS2 500 MiB + 128 MiB lab underpin examples only; they do not establish production capacity or device encryption capabilities.

**Product/version assumptions requiring validation:** PostgreSQL exact release and extensions, MySQL release/engine/keyring, NAS operating system, PACS vendor and DICOM endpoint compatibility, O365 licensing/Customer Key eligibility, laptop OS/MDM enrollment, and BD Alaris exact model/firmware. Where unverified, the report makes a conditional recommendation rather than inventing a deployed configuration.

1. NIST SP 800-111, *Guide to Storage Encryption Technologies for End User Devices* — full-disk, volume/virtual disk, file/folder: https://csrc.nist.gov/pubs/sp/800/111/final
2. PostgreSQL 18, *Encryption Options* — disk and field options, live-server caveats: https://www.postgresql.org/docs/18/encryption-options.html
3. PostgreSQL, *pgcrypto Security Limitations* — server-side processing and keys: https://www.postgresql.org/docs/current/pgcrypto.html
4. MySQL 8.4, *InnoDB Data-at-Rest Encryption FAQ* — transparent tablespace protection, key and backup behavior: https://dev.mysql.com/doc/refman/8.4/en/faqs-tablespace-encryption.html
5. MySQL 8.4, *The MySQL Keyring*: https://dev.mysql.com/doc/refman/8.4/en/keyring.html
6. Microsoft Learn, *What is Microsoft 365 service encryption?*: https://learn.microsoft.com/en-us/purview/microsoft-365-service-encryption
7. Microsoft Learn, *Overview of Customer Key*: https://learn.microsoft.com/en-us/purview/customer-key-overview
8. BD, *Alaris System with Guardrails Suite MX*, security advisory: https://www.bd.com/en-us/about-bd/cybersecurity/bulletin/bd-alaris-system-with-guardrails-suite-mx
9. BD, *Alaris PC Unit PCU physical access to wireless credentials*, model/version-sensitive security example: https://www.bd.com/en-us/about-bd/cybersecurity/bulletin/potential-physical-access-to-wireless-credentials-alaris-pc-unit

**Final recommendation:** Deploy **Volume** encryption for server/NAS storage, **Database** encryption for compatible billing InnoDB, **selective application-side Record** encryption where SQL access itself must not reveal highly sensitive EHR fields, **Full-disk** for laptops, service/message protection for O365, and **File** encryption plus verified vendor signatures for managed Alaris artifacts. All seven decisions require independent key recovery and operational validation before production rollout.
