# MedDefense Health Systems — Task 20: The Implementation Playbook

**Project:** 1x04 — Cryptographic Foundation
**Required repository deliverable:** `blue_team/1x04_crypto_foundation/22-implementation_playbook.md` (the assignment calls this **Task 20** but explicitly requests filename **22**, which is preserved).
**Prepared:** 6 November 2026
**Operational owner:** Sarah Park, IT Director; security approval/incident lead: James Chen, Deputy CISO
**Document type:** Production **change runbook / implementation playbook**, **not** a report of changes already made.
**Scope:** The five `Immediate` findings in Task 15: **CRYPTO-001, CRYPTO-013, CRYPTO-019, CRYPTO-008, CRYPTO-002**.
**Safety:** No real production configurations, device models, host certificates, approved IP allowlists or key-vault credentials were supplied. Replace marked site-specific values **only after discovery and a signed change ticket**. Commands are examples for the stated platform and must be rehearsed in staging. Do **not** execute this document verbatim on a live clinical system.

## 0. Monday-morning release control: mandatory for *all* five actions

**No-Go until Sarah has:** (1) identified the actual host, software release, service manager, storage device and traffic path; (2) written a change ID and captured sanitized before-state evidence; (3) named a technical operator, independent verifier, clinical contact and on-call rollback decision-maker; (4) proved a current, **independently accessible and decryptable** backup; (5) obtained a signed clinical workflow and DPO/Legal review for PHI changes; (6) staged the exact configuration/rollback on a representative non-production environment; (7) checked available capacity, maintenance window, monitoring, failover and out-of-band access; (8) obtained financial approval within the **single $120,000 six-month cap** (1x03 proposed portfolio already consumes an estimated $115,000 first-year cash, subject to reconciliation).

**Hard stop:** Any unexpected patient-safety signal, corrupted EHR/PACS study, denied legitimate clinical access, lost backup recovery key, unapproved plaintext exposure, or failed integrity check triggers **STOP / incident triage immediately**, even before a timer expires. The maximum downtimes below are **proposed conservative change-stop limits**, **not** documented MedDefense RTOs; a stricter owner-approved clinical RTO supersedes them. If a task cannot meet the approved RTO, arrange a tested HA/parallel-cutover approach or defer.

**Deployment order:** Follow the numerical ranking of the T15 top three (EHR, NAS, Portal), then the two other Immediate findings (DICOM and PostgreSQL TLS). This is **risk order**, not a demand to migrate storage before prerequisites: Portal renewal, PostgreSQL TLS preparation and vendor DICOM tests may run as independent parallel work. **One production cutover at a time**, with review and approval before the next. No destructive storage operation, unsupervised automatic key rotation, unapproved firewall lockout, or test using real PHI.

| Action | T15 priority / trace | Production target | Target control | Proposed unplanned-impact stop limit |
|---|---|---|---|---|
| **#1** EHR storage | **Immediate**; CRYPTO-001, 1x03 **RISK-001**; F003 **adjacent**, not evidence of disk encryption | `ehr-db-01` PostgreSQL 14; dependent `ehr-srv-01` | New LUKS2/dm-crypt AES-256-XTS **volume**; controlled migration, independent key escrow | **0 minutes** of unscheduled clinical outage; **10 minutes** for approved write-frozen cutover, if clinical RTO allows |
| **#2** NAS backups | **Immediate**; CRYPTO-013, F015 **adjacent**, RISK-003/RISK-008 | Synology `NAS-01` and offsite recovery store | Supported volume/folder encryption + **independently encrypted** backup objects, off-NAS KMS, immutable copy | **0 minutes** unplanned loss of restore capability; halt migration after **10 minutes** of interrupted backup ingestion |
| **#3** Portal TLS/cert | **Immediate**; CRYPTO-019, F005/F013; portal-specific Risk Register entry **not yet assigned** | `web-srv-01` / actual public TLS termination node | Trusted renewed certificate, ACME, TLS 1.3/strong 1.2; no TLS 1.0 | **5 minutes** continuous verified patient-portal failure, or immediately if safety impact reported |
| **#4** DICOM transit | **Immediate**; CRYPTO-008, F024; RISK-003/RISK-006 | `pacs-srv-01`, MRI/radiology modalities and approved gateways | Vendor-supported **DICOM TLS** or protected gateway + isolated legacy segment | **0 minutes** unplanned diagnostic workflow outage; **5 minutes** approved test interruption, if Radiology allows |
| **#5** EHR DB TLS | **Immediate**; CRYPTO-002, F003 **adjacent**; RISK-001 | `ehr-db-01` and each approved EHR DB client | Verified `hostssl`, `scram-sha-256`, validated client CA/SAN, no plaintext TCP | **5 minutes** of EHR app-to-DB error at agreed cutover; lower clinical threshold wins |

**Roles/authority (from 1x03 T4):** Sarah **owns the implementation/change/rollback**; James approves risk handling and directs a security incident; Security Analyst collects independent validation; EHR Clinical Data Owner and Radiology/Clinical leadership approve workflow changes; Biomedical Engineering + manufacturer approve medical-device changes; DPO/Legal review PHI; Robert Kim/CFO validates cost; CEO approves budget/risk exceptions. No operator gains unrestricted access to plaintext master keys merely by being an administrator.

---

## Action #1: Encrypt the EHR PostgreSQL data volume without losing patient records

**Priority:** **Immediate** (T15 **CRYPTO-001**).
**System Affected:** `ehr-db-01` (PostgreSQL 14 database host), `ehr-srv-01` (application dependency); actual service unit, filesystem layout and replication configuration must be discovered.
**Prerequisites:** Approved encrypted-storage architecture and empty **new** storage target; current full plus WAL-consistent EHR backup; tested **isolated** PostgreSQL restore and point-in-time recovery; known table spaces, WAL, logs, temp, swap and snapshot coverage; measured copy/cutover duration and available rollback host; tested application transaction and clinical read/write test plan; separate LUKS recovery secret and two-person escrow; encrypted backup destination and signed DPO/EHR-owner authorization. **Never overwrite the currently populated data device.**

**Steps:**

1. **Record the live baseline (read-only):** use an approved privileged session to discover PostgreSQL's actual config/data paths, active tablespaces, mounts, replication and disk IDs. Preserve sanitized evidence in the change ticket, **not** secrets in Git:

   ```bash
   sudo -u postgres psql -Atc 'SHOW data_directory;'
   sudo -u postgres psql -Atc 'SHOW config_file;'
   sudo -u postgres psql -Atc 'SHOW hba_file;'
   sudo -u postgres psql -Atc 'SHOW ssl;'
   sudo -u postgres psql -Atc 'SELECT spcname, pg_tablespace_location(oid) FROM pg_tablespace;'
   findmnt -T /ACTUAL_PGDATA_PATH
   lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINTS
   ```

2. **Create an isolated encrypted destination** in staging first, then in production only after the storage operator has verified the **by-id identity is a new, unused device**, received a two-person authorization and proven recovery. The approved provisioning plan specifies **LUKS2, `aes-xts-plain64`, key size 512 bits (two 256-bit AES keys)**, filesystem consistent with PostgreSQL deployment, mount ownership, secure bootstrap and SELinux labeling. This is a **destructive provisioning step**: do **not** run `dd`, `cryptsetup luksFormat`, `mkfs` or partition commands against the original PGDATA device. The storage team performs the signed new-device procedure (not an inline one-size-fits-all command).
3. **Inspect the newly provisioned volume** and validate keys/recovery before admitting data:

   ```bash
   sudo cryptsetup luksDump /dev/disk/by-id/APPROVED_NEW_LUKS_DEVICE
   sudo cryptsetup status APPROVED_EHR_MAPPER
   findmnt -T /APPROVED_ENCRYPTED_PGDATA
   sudo ls -ld /APPROVED_ENCRYPTED_PGDATA
   ```

   `luksDump` reports metadata, not secrets, but restrict ticket visibility; the mapper name/device/path are **placeholders**, not factual MedDefense values. **Do not commit keyfiles or LUKS headers to Git.** Maintain tested **separate encrypted header/recovery backups** where applicable.
4. **Pre-seed using a PostgreSQL-consistent approved method** (tested physical backup/streaming standby or verified logical migration). A raw `rsync` while the primary database is writing is **not** a safe consistent copy. Stage a follower or conduct a **write-frozen, PostgreSQL-stopped** final copy with verified WAL/data consistency; include auxiliary tablespaces and archive destinations. Validate file owner, permissions, service unit paths and SELinux contexts on the new mount.
5. During the clinical-approved window, **fence new writes**, take a final consistent backup/checkpoint, record the exact last committed transaction/LSN, activate the encrypted mount and switch the *tested* PostgreSQL unit/config to the new data path. **Keep the original immutable as rollback evidence**; do not wipe or reformat it. An encrypted target mounted before PG start is essential; fail closed if unlock/KMS is unavailable.
6. Start the new DB service through its **actual discovered service unit**, test PostgreSQL startup/logs, perform synthetic clinical transactions and establish backup+WAL archiving. Release the write fence **only after** data consistency, EHR application paths, clinical read/write and restore/key-escrow checks succeed and the clinical lead signs off. Keep plaintext old storage access-restricted until a formally approved secure-retirement window.

**Validation:**

- **Cryptographic:** `cryptsetup status` reports the approved LUKS mapper; data and WAL actual filesystem paths resolve to the encrypted mount; offline access to the raw **new** device does not reveal synthetic test markers; the separate unlock escrow can restore in isolation. AES-XTS protects confidentiality of a **locked** volume, not integrity or an already authenticated SQL query.
- **Service:** PostgreSQL starts with expected system identifier/LSN, application test can retrieve/update a synthetic EHR entry, clinical users verify authorized workflows, logs and replication show no abnormal errors, backups continue, an isolated full restore reaches the approved recovery point.
- **Go/No-Go:** For any checksum mismatch, missing tablespace/WAL, mount/key failure, unapproved RTO overrun or broken clinical workflow, do not release writes.

**Rollback:** Before any writes are accepted on the new primary, fence connections, stop the new instance, restore the exact previous service configuration and reattach **original untouched** PGDATA, verify its consistency and resume service; keep incident notes and encrypted copy for investigation. **After new writes are accepted, switching back to the old data volume risks lost patient updates**: stop and escalate to DBA+EHR owner for WAL replay/safe failover and reconciliation; never perform a blind old-volume rollback. **Maximum acceptable downtime:** zero unscheduled; stop at **10 minutes of scheduled write-frozen cutover**, subject to stricter signed RTO.

**Maintenance Window:** Overnight, low-load, **only** with on-site clinical coverage and tested emergency downtime workflow; pre-seeding can occur beforehand without disruption.
**Communication:** **Before:** Sarah/DBA, EHR clinical owner/department heads, James, DPO, service desk/on-call, backup team, CFO for funded change. **During:** 5-minute bridge updates, clinical safety contact available. **After:** notify users and incident owners with timestamp, evidence, recovery status and remaining risks; obtain clinical sign-off.

---

## Action #2: Encrypt NAS-01 backups and create independently recoverable offsite ciphertext

**Priority:** **Immediate** (T15 **CRYPTO-013**).
**System Affected:** Synology `NAS-01` and the **proposed** 1x03 C4 offsite/immutable backup repository (provider/region/bucket not yet confirmed).
**Prerequisites:** Confirm Synology model, DSM version, licensing, filesystem/RAID, free capacity and volume-encryption support; inventory all backup jobs, snapshots, service accounts, retention/restore dependencies (EHR, PACS, MySQL); have independently verified **existing** backup and offline recovery before changing anything. DPO must approve geographic region, legal/processor terms and clinical recovery targets. Choose KMS/HSM **outside NAS** plus protected offline escrow and separate backup/restore identities; check storage cost/immutability support.

**Steps:**

1. In the Synology DSM administrative console, record **Control Panel / Storage Manager** versions, folder/volume names and backup application/job configuration (export **redacted** screenshots/change manifest). Confirm **DSM 7.2+ and the exact model's support** before choosing encrypted volume; otherwise use a **supported encrypted shared folder** and/or **client-side backup-object encryption**. **Do not install Linux LUKS on an unknown Synology storage pool.**
2. On an **additional unused volume/folder**, use the vendor-supported **Storage Manager → encrypted volume** provisioning or **Control Panel → Shared Folder → encryption** workflow (UI paths can vary with DSM version). Select an **off-box KMIP/key vault** where supported or supported independent vault workflow; **do not enable auto-unlock using the sole reusable plaintext key on the same NAS**. Preserve separate two-person escrow and the recovery instructions.
3. From a backup client with dedicated service identity, configure **AES-256-GCM authenticated per-backup object encryption before upload**, with unique nonces/DEKs wrapped by a **MedDefense-controlled KEK** stored separately from NAS and the cloud-replica administrator. If the product cannot document its algorithm, validate its supported authenticated encryption rather than assuming it is GCM. TLS 1.2/1.3 transport and cloud SSE are **additional** layers, not substitutes for client-side encryption.
4. Replicate to an approved **separate failure domain** with immutability/object lock (or equivalent immutable offsite control), versioning, retention and non-deletable audit trail; **not** the same NAS-admin account. Do not claim the AWS roadmap is already deployed or authorized. Test inability of a compromised NAS credential to remove offsite protected copies.
5. Run a **synthetic and then application-consistent approved dataset** through a new encrypted job; confirm the repository stores ciphertext, retention policy, encryption headers/manifests, access-denied behavior and checksum. Restore a selected EHR/PACS/billing dataset in an **isolated** environment using two-person escrow and verify data and metadata.
6. Only after two independent successful backup cycles and a restore, switch scheduled production jobs to the new destination, observe successful run+alerting and retain the previous NAS backup copy in a **restricted/isolated transition state** until its lawful retirement date. Never erase source backups to make room before verification.

**Validation:**

- NAS storage encryption is visible in the supported DSM status; **client-side** offsite objects are not plaintext after retrieval **without** the MedDefense key; wrong-role decrypt and wrong-key authentication checks fail.
- Backup jobs meet approved RPO; full isolated restore (including PACS study metadata/EHR WAL or billing consistency as applicable) meets clinical RTO; immutability and independent deletion-denial are evidenced, all key versions remain recoverable and documented.
- A RAID level or storage encryption **alone** does not prove backup immutability, safe key escrow or online ransomware resistance.

**Rollback:** If new encryption, uploads or recoveries fail, **stop new-job cutover**, resume the last **validated existing** backup jobs from the preserved source and retain old copies read-only/isolated; revoke new KMS permissions only after confirming no production data depends exclusively on the new key. Do not remove the new vault or encrypted copies during investigation. **Maximum acceptable downtime:** **0 minutes** without a recoverable last-known-good copy; stop/revert the new backup-ingestion change after **10 minutes** of unexpected interruption and escalate if any RPO is threatened.

**Maintenance Window:** Prepare/configure in ordinary business hours using a **separate** destination; schedule bulk seed and final backup-job cutover **overnight/off-peak**, with no clinical interruption acceptable.
**Communication:** **Before:** Sarah, backup/recovery operator, James, EHR/PACS/billing data owners, Radiology, DPO/Legal, Finance. **After:** provide restore evidence, KMS ownership, offsite region, retained legacy-copy plan and next quarterly recovery drill.

---

## Action #3: Renew the patient-portal certificate and disable legacy TLS safely

**Priority:** **Immediate** (T15 **CRYPTO-019**, 1x02 **F005/F013**).
**System Affected:** `web-srv-01` **and/or actual TLS terminator** (reverse proxy/load balancer not established). Patient portal handles an estimated **800 patient connections/day**, not proven simultaneous users.
**Prerequisites:** Discover **actual public hostname** (`PORTAL_FQDN`), authoritative DNS, edge reverse proxy/web-server type and current cert/key chain/expiry; test an ACME staging/renewal route and firewall; approved CA account, SANs, DNS/HTTP-01 challenge method and rollback certificate; sample patient browsers/clinical integrations, synthetic login flow, uptime monitor and emergency contact. **Task 10 `.local` test CSR/private key is NOT a production/public certificate.** The report's historical “expires in 18 days” is not a validated live `notAfter`.

**Steps:**

1. From an approved monitor outside the patient network, inspect the **real** discovered DNS name; configure it through a nonsecret environment variable (do **not** insert literal `.local` in a public ACME request):

   ```bash
   PORTAL_FQDN='REPLACE_WITH_VERIFIED_PUBLIC_FQDN'
   openssl s_client -connect "$PORTAL_FQDN:443" -servername "$PORTAL_FQDN" \
     -verify_hostname "$PORTAL_FQDN" -verify_return_error </dev/null
   echo | openssl s_client -connect "$PORTAL_FQDN:443" \
     -servername "$PORTAL_FQDN" 2>/dev/null | openssl x509 -noout -issuer -subject -dates -ext subjectAltName
   ```

2. Inventory terminating service and its ACME client/configuration. Prefer **ACME/Let's Encrypt with automated rotation**, not a human-maintained commercial one-year certificate. Arrange new correctly trusted cert/private key, complete chain and exact SANs. For a Certbot-managed installation, test a renewal with **`sudo certbot renew --dry-run`** and confirm its scheduler is active; if managed by another ingress/ACME operator, use **that platform's** equivalent, not an unrelated Certbot command. Add a safe **post-renew deploy hook** for tested reload and external certificate verification.
3. Configure **TLS 1.3 and hardened TLS 1.2 only** at the real terminating layer (after staged compatibility testing); for **Nginx**, a tested site-specific directive is `ssl_protocols TLSv1.2 TLSv1.3;`; for **Apache HTTPD**, `SSLProtocol -all +TLSv1.2 +TLSv1.3` is the equivalent. Use approved TLS 1.3 **AES-GCM** suites and TLS 1.2 **ECDHE + AES-GCM**; enable HSTS only after hostname/subdomain and redirect testing. Never copy both syntax variants into an unknown service.
4. Test the staged config with the **actual server** (`sudo nginx -t` or `sudo apachectl configtest`); take a config snapshot, install new cert/key with correct restrictive permissions and use **graceful reload** through the verified systemd unit. Do not use unconditional restart commands. Keep last-known-good version and rollback cert/config available.
5. Run browser and synthetic patient login/booking tests, validate external chain/SAN/OCSP where applicable, explicit acceptance of TLS 1.2/1.3 and **rejection** of TLS 1.0. Create independent daily certificate/hostname/expiry probes, 90/60/30/7-day escalating alerts from T17 and an ACME failure alert; short-lived CA certificates must be renewed ahead of expiry rather than waiting for 7 days.

**Validation:**

   ```bash
   openssl s_client -connect "$PORTAL_FQDN:443" \
     -servername "$PORTAL_FQDN" -tls1_2 -verify_return_error </dev/null
   openssl s_client -connect "$PORTAL_FQDN:443" \
     -servername "$PORTAL_FQDN" -tls1_3 -verify_return_error </dev/null
   openssl s_client -connect "$PORTAL_FQDN:443" \
     -servername "$PORTAL_FQDN" -tls1 -brief </dev/null
   ```

- Approved TLS 1.2/1.3 connections have valid chain and exact hostname; `-tls1` must **fail**; portal response, clinical workflows, error rates and 800/day access expectation remain within the agreed baseline. Confirm ACME dry-run, scheduler, deploy hook, alert routing and tested incident escalation.
- Old certificate must not be silently reused after replacement. If TLS 1.3 is impossible at a verified proxy, record a time-limited TLS 1.2 AEAD exception; **do not** retain TLS 1.0 just to attain a paper pass.

**Rollback:** Reapply the backed-up edge TLS config and **last still-valid** certificate, test syntax and gracefully reload; do **not** roll back to an **expired, revoked, compromised** certificate or enable TLS 1.0 without explicit incident/clinical risk escalation. Prefer failover to a pretested healthy endpoint with valid modern TLS. **Maximum acceptable downtime:** **5 minutes continuous failed patient-portal checks**, or **immediately** on clinical-impact signals.

**Maintenance Window:** Stage renewals and ACME testing in business hours; **overnight/low traffic** for protocol cutover, with patient access/clinical helpdesk watch.
**Communication:** **Before:** Sarah/web/PKI team, James, DPO, service desk, clinical portal owner and patient support communications desk. **After:** send observed SAN/expiry, renewal automation evidence, protocol tests, synthetic patient journey results and any known browser exceptions.

---

## Action #4: Protect PACS DICOM transport without breaking legacy MRI imaging

**Priority:** **Immediate** (T15 **CRYPTO-008**; 1x02 **F024**, F004 adjacent; **RISK-003/RISK-006**).
**System Affected:** `pacs-srv-01`, actual DICOM sending/receiving modalities and MRI controller **`WS-RAD-01`** (legacy Windows XP); original audit reports plaintext DICOM on TCP **4242/11112**.
**Prerequisites:** Radiology and Biomedical manufacturer-approved compatibility matrix; identify **each** DICOM AE Title, remote host/port, modality version and certificate capability; validated PACS image+metadata restore; synthetic DICOM study and C-ECHO tests; approved trusted internal PKI/cert renewal; segmented network and documented downtime/fallback; change approval by clinical owner and vendor. **Do not modify/patch a certified MRI controller or active clinical device without sign-off.**

**Steps:**

1. **Inventory read-only** listener ports at PACS and document actual peer mappings, including plaintext hops:

   ```bash
   sudo ss -ltnp | grep -E ':(4242|11112)\b'
   ```

   Obtain DICOM AE Title lists through vendor admin tools; never capture/store real DICOM payloads in tickets, terminal logs or Git. For packet/protocol verification use only **synthetic** test images on an approved staging path.
2. Test **DICOM TLS 1.2/1.3 with ECDHE AES-GCM** on a separate supported PACS listener or vendor-approved DICOM TLS gateway. Issue machine certificates with appropriate SANs/trust and peer validation, store private keys in protected PKI secrets, monitor expirations under T17. **Do not assume PACS runs Orthanc**: if and only if its verified software is Orthanc, vendor-documented keys include `DicomTlsEnabled`, `DicomTlsCertificate`, `DicomTlsPrivateKey`, `DicomTlsTrustedCertificates` and peer-specific `UseDicomTls`; otherwise follow **the actual product's supported configuration procedure**.
3. For each TLS-capable modality, point a **test** AE to the new listener using approved destination port and trusted certificate; perform `C-ECHO`, synthetic `C-STORE`, query/retrieve and checksum/patient-metadata checks. Use a compatible DCMTK `echoscu` TLS test with approved certs if available; **never** assume a plaintext C-ECHO proves TLS.
4. If the XP MRI controller lacks TLS, use a **vendor-approved TLS-terminating gateway** and restrict the remaining legacy plaintext segment to a dedicated, tightly ACL-controlled clinical management link. The local legacy hop remains a documented **residual plaintext risk**; do not falsely claim end-to-end TLS or transmit it across the flat network. Avoid certificate settings or cipher changes on the MRI unless manufacturer-approved.
5. In a scheduled radiology window, switch **one modality at a time**, keep old routing definitions backed up, compare received study counts and DICOM identifiers/checksums and observe patient-care queue latency. Block old insecure wide-area paths only when the new permitted path is proven. Record exception owner/expiry for any necessary legacy hop.

**Validation:**

- Authorized TLS-capable modality authenticates the PACS/gateway and transfers synthetic image with verified identity and study metadata; invalid peer or untrusted certificate is refused. Packet metadata in synthetic staging confirms TLS on the switched link; no PHI is disclosed in change evidence.
- Radiologists can search/read images and receive urgent studies; queue depth, study count, retrieval latency and emergency workflow remain acceptable; documented legacy plaintext hop is **isolated**, not misreported as fixed.

**Rollback:** Restore backed-up modality AE routing and PACS/gateway config **only to the previously validated isolated clinical path**, then verify synthetic C-ECHO/C-STORE and urgent radiology imaging. Reopen insecure access across the flat network **only** if a clinical safety incident forces a formally authorized, time-bounded exception and compensating isolation; do not disable certificate checks as a shortcut. **Maximum acceptable downtime:** **0 minutes** unplanned clinical diagnostic disruption; halt the approved per-modality test by **5 minutes** of failed workflow or earlier per Radiology RTO.

**Maintenance Window:** Overnight/low study load **with staffed Radiology, Biomedical and vendor standby**; avoid unstaffed weekends.
**Communication:** **Before:** Radiology department head, MRI/PACS operator, Biomedical, device vendor, Sarah, James, DPO and ED/clinical escalation lead. **After:** report modality-by-modality acceptance, pending legacy exceptions, time of routing switch and sign-off.

---

## Action #5: Require verified TLS for every EHR PostgreSQL client connection

**Priority:** **Immediate** (T15 **CRYPTO-002**, 1x02 F003 adjacent; **RISK-001**, overlapping RISK-002).
**System Affected:** PostgreSQL 14 `ehr-db-01`, EHR app `ehr-srv-01`, **all discovered** reporting/maintenance/replication client identities and approved network sources.
**Prerequisites:** Inventory exact PostgreSQL 14 binary/config/`pg_hba.conf` path and server certificate; all application, backup and replication clients and source IPs; trusted CA, matching server DNS/SAN, tested `sslmode=verify-full` and healthy authentication; SCRAM-compatible credentials; allowed network boundary design; signed EHR owner/DPO change and production rollback copy. **`hostssl` alone is insufficient if another broad `host` or `hostnossl` permits plaintext.**

**Steps:**

1. In an authorized read-only session, verify the effective auth/TLS and client footprint; redact patient/credential information from logs:

   ```sql
   SHOW ssl;
   SHOW hba_file;
   SHOW ssl_cert_file;
   SHOW ssl_key_file;
   SELECT line_number, type, address, auth_method, error
   FROM pg_hba_file_rules ORDER BY line_number;
   SELECT a.application_name, a.client_addr, s.ssl, s.version, s.cipher
   FROM pg_stat_activity a JOIN pg_stat_ssl s ON a.pid = s.pid
   WHERE a.backend_type = 'client backend';
   ```

2. Issue a server-auth certificate from the approved internal PKI with a SAN matching the **real** `ehr-db-01` DNS name, restrict private key permissions and verify CA chain; set approved PostgreSQL `ssl=on` and supported minimum protocol. Update **every** application/replication client to use authenticated server TLS, e.g. libpq parameters **`sslmode=verify-full`**, `sslrootcert=/APPROVED_CA_PATH` and **the SAN-matching hostname**, never `sslmode=require` without identity verification as the end state. Use secret vault for DB credentials rather than command-line password literals.
3. On a **staged and approved** PostgreSQL 14 `pg_hba.conf` copy, allow **only** verified client IPs/users/database names using `hostssl` with `scram-sha-256`; add early `hostnossl ... reject` entries and remove/replace broad `host` allow rules after auditing order and replication/monitoring dependencies. **Illustrative** lines (substitute approved database/user/CIDRs; these are not MedDefense-discovered values):

   ```text
   hostnossl all      all     0.0.0.0/0          reject
   hostnossl all      all     ::/0               reject
   hostssl   EHR_DB   EHR_APP APPROVED_IP/32      scram-sha-256
   ```

   HBA is **first-match**, no fall-through. Do not remove needed local Unix-socket admin access or GSS-encrypted paths without validation; disable old broad network sources as a separately authorized network ACL change.
4. Preflight `pg_hba_file_rules` with **no parser errors**; schedule reload, **not restart**, after the exact staged config is promoted: `SELECT pg_reload_conf();` (a true return means the signal was sent, **not** that every rule/client passed). Check server logs and `pg_stat_ssl` again. Test from an approved **nonproduction identity/network** first, then a synthetic application workflow in the clinical-approved window.
5. With an authorized test identity and vault-provided credentials, confirm secure connection, correct SAN/CA, and explicit plaintext rejection; choose real host/database/user values from the signed asset sheet:

   ```bash
   psql "host=APPROVED_DB_FQDN dbname=APPROVED_DB user=APPROVED_USER sslmode=verify-full sslrootcert=/APPROVED_CA_PATH" \
     -c 'SELECT 1;'
   psql "host=APPROVED_DB_FQDN dbname=APPROVED_DB user=APPROVED_USER sslmode=disable" \
     -c 'SELECT 1;'
   ```

   The **first** command must succeed and the **second must fail** on a TCP network path. Inspect `pg_stat_ssl` and application logs for active sessions and verify old non-TLS backends are **drained/terminated in a clinically coordinated way**; reloading HBA does not retroactively encrypt existing sessions.

**Validation:**

- **Crypto:** All new approved remote connections are `ssl=true` with an accepted TLS 1.2/1.3 cipher; client `verify-full` checks the SAN/CA; plaintext `sslmode=disable` is rejected; unapproved source CIDRs are denied; no overly broad `host` line undoes the restriction.
- **Service:** EHR clinical reads and synthetic writes succeed, report exports, scheduled interfaces, backups and replication operate correctly, PostgreSQL logs show no unexpected authentication failures and no protected-health data has leaked to diagnostics.

**Rollback:** If a legitimate client fails, stop new changes and restore the **saved versioned HBA/TLS client configuration** to the **last validated permitted scope**, reload PostgreSQL and verify business transactions. Avoid restoring a wide-open `10.10.0.0/16` plaintext path without explicit incident/clinical approval; use narrowly scoped emergency TLS exceptions, never `trust` authentication. Investigate stale sessions and cert failures. **Maximum acceptable downtime:** **5 minutes** EHR application/database connection disruption, or less if the signed clinical RTO requires.

**Maintenance Window:** **Overnight** for final required-TLS enforcement; certificate issuance and client preparation can be staged during business hours.
**Communication:** **Before:** Sarah/DBA, EHR application/clinical owner, James, DPO, vendor interface owners, reporting/backup team, service desk; **after:** provide `pg_stat_ssl` acceptance, denied plaintext/source tests, app workflow sign-off, config diff and rollback disposition.

---

## 6. Change sequencing, exit tickets and evidence hand-off

Each action receives its **own approved change ticket** and closes only after independent verification. Do not batch all five into one rollback domain. The following records are **required outputs**, not claims that the work happened:

| Gate | Evidence that must be attached to the change ticket (redacted) | Release authority |
|---|---|---|
| **G0 — Before** | Asset/software versions, signed clinical impact and maximum downtime, backup restore log, signed data map, site-approved CIDRs/FQDNs, exact tested config diff, owner contacts | Sarah + relevant clinical lead + James; DPO/Finance if applicable |
| **G1 — Dry run** | Staging positive/negative tests, KMS/PKI and escrow test, performance/RTO measurements, rollback drill and explicit no-go criteria | Technical operator + independent Security Analyst |
| **G2 — Cutover** | Timestamp, operator/approver, change revision, monitored error/latency, validated TLS/cipher/at-rest status, no PHI leaked into evidence | Sarah, clinical lead during change bridge |
| **G3 — Restore and close** | Independent encrypted-data restore, clinical read/write or DICOM/portal workflow, failure/negative tests, cert/key-owner and next rotation date | Clinical data owner, Sarah, James; DPO for PHI |
| **G4 — Governance** | Update T0 baseline, T15 finding status, 1x03 RISK register/exception, certificate/key inventory (T14/T17), operational runbook and after-action review | James coordinates, CEO only for reserved risk/budget approval |

**Scope discipline:** Task 12's Fedora LUKS file was a synthetic **lab**, not an authorized production volume. T15's **100% remediation-path coverage** is documentation completeness, **not** 100% cryptographic deployment. The five `Immediate` actions are proposals pending implementation evidence. No medical device should be interrupted simply to satisfy a checklist; if a technical control conflicts with certified imaging or urgent care, isolate and time-limit the residual exposure under the clinical risk owner instead.

### Project evidence (traceable internal sources)

- [T0 — Data Protection Map](0-crypto_inventory.md): PostgreSQL optional SSL, unencrypted EHR/PACS/NAS, plaintext DICOM and scope caveats.
- [T6 — Algorithm Landscape](6-algorithm_landscape.md): AES-XTS vs AEAD, TLS protocol selection, legacy cryptography.
- [T12 — Disk Encryption Lab](12-disk_encryption.md): synthetic LUKS2 example only, **not** production cryptographic evidence.
- [T13 — Encryption Levels](13-encryption_levels.md): EHR Volume+Record, NAS Volume+backup-object encryption, PACS Volume+File.
- [T14 — Key Management](14-key_management.md): independent KMS/HSM, restricted identities, offline escrow, restoration and rotation/compromise playbooks.
- [T15 — Crypto Posture Audit](15-crypto_posture_audit.md): authoritative five `Immediate` findings and priorities.
- [T17 — Certificate Lifecycle](17-certificate_lifecycle.md): trusted portal PKI, automated renewal, certificate inventory and 90/60/30/7-day alerts.
- [1x02 — Vulnerability Triage](../1x02_the_weak_links/16-triage.md): F003, F004, F005, F013, F015, F024.
- [1x03 — Risk Register](../1x03_defense_blueprint/10-risk_register.md): RISK-001, RISK-003, RISK-006, RISK-008, and non-additive modeled loss caveats.
- [1x03 — Governance Architecture](../1x03_defense_blueprint/4-governance_architecture.md): delivery, incident, financial, DPO and clinical approval roles.

### Authoritative implementation references (architecture and syntax only)

- [PostgreSQL 14 — `pg_hba.conf` first-match, `hostssl` and `hostnossl`](https://www.postgresql.org/docs/14/auth-pg-hba-conf.html); [PostgreSQL 14 — TLS](https://www.postgresql.org/docs/14/ssl-tcp.html); [PostgreSQL 14 — libpq SSL modes](https://www.postgresql.org/docs/14/libpq-ssl.html).
- [NIST SP 800-38E — AES-XTS](https://csrc.nist.gov/pubs/sp/800/38/e/final); [NIST SP 800-57 — Key Management](https://csrc.nist.gov/pubs/sp/800/57/pt1/r5/final).
- [Synology — encrypted volume model/DSM requirements](https://kb.synology.com/en-global/DSM/tutorial/Which_models_support_encrypted_volumes); [Synology — shared folder encryption](https://kb.synology.com/en-global/DSM/help/DSM/AdminCenter/file_share_create?version=7).
- [Orthanc DICOM TLS configuration](https://orthanc.uclouvain.be/book/faq/dicom-tls.html) — **illustration only if this is the actual verified PACS software**, not evidence that MedDefense runs Orthanc.
- [Certbot documentation: renewal/dry run/hooks](https://certbot.eff.org/docs/using.html); [RFC 8996 TLS 1.0/1.1 deprecation](https://www.rfc-editor.org/rfc/rfc8996.html); [RFC 8446 TLS 1.3](https://www.rfc-editor.org/rfc/rfc8446.html).
