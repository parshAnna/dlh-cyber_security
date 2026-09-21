# MedDefense Health Systems — Integrated Threat Scenarios

Prepared for: James Chen, Deputy CISO

Prepared by: Junior Security Analyst

Scope: Three plausible planning scenarios that integrate the completed actor, vector, surface, kill-chain, STRIDE and ATT&CK analyses. They are not claims that these attacks have occurred or that a named vendor or person is compromised.

## Evidence Basis and Scenario Boundaries

Actor judgments come from the [Threat Actor Matrix](6-threat_actor_matrix.md), with the fictional BlackReef model from the [Ransomware Assessment](2-ransomware_assessment.md) and the malicious-insider pattern from the [Insider Assessment](3-insider_assessment.md). Entry paths are grounded in the [Social Engineering Analysis](4-social_engineering_analysis.md), [Supply Chain Assessment](5-supply_chain_assessment.md), [Attack Surface Map](7-attack_surface_map.md), [Technical Vector Assessment](8-technical_vectors.md) and [Vector-to-Asset Matrix](9-vector_asset_matrix.md). Sequence and detection logic reuse the [Kill Chains](10-kill_chains.md) and [ATT&CK Mapping](13-attck_mapping.md); asset, control and gap IDs come from First Watch.

The supplied repository contains Task 11's EHR STRIDE model but no Task 12 artifact. Consequently, the STRIDE references below use only documented [Task 11 EHR threat IDs](11-stride_ehr.md); no Task 12 findings are invented. Scenario 3 is conditional: Task 5 establishes MedTech maintenance access to `ehr-srv-01`, but not vendor database, root or organization-wide privileges. The sequence therefore requires the attacker to obtain an application-held database identity rather than assuming direct vendor database access.

| Scenario | Distinct actor | Distinct primary vector | Principal T7 surface |
|---|---|---|---|
| 1 — External ransomware | Organized crime / BlackReef-style RaaS affiliate | Spearphishing link and malicious file | Human, then internal |
| 2 — Internal exfiltration | Malicious insider | Legitimate EHR access abused | Human and internal |
| 3 — Third-party compromise | Nation-State APT through MedTech | Compromised vendor maintenance/update path | External third-party trust path |

## Scenario 1 — Vendor Patch Lure to Hospital-Wide Extortion

**Title:** Vendor Patch Lure to Hospital-Wide Extortion

**Threat Actor:** Ransomware Groups (Organized Crime), specifically a BlackReef-style Ransomware-as-a-Service affiliate from T2; T6 rates this actor **High likelihood** with **Medium–High capability** and ranks it MedDefense's first priority.

**Motivation:** **Financial gain** through double extortion: payment pressure from service disruption plus threatened disclosure of stolen patient data.

**Initial Vector:** **Phishing / Spear Phishing** from T4/T9. An attacker sends Sarah Park a Fortinet-themed support message containing a link to a malicious document, matching the credible IT-role pretext mapped in T13 Scenario Alpha.

**Attack Surface Exploited:** T7 **Human surface** (IT staff and urgent vendor-patch trust) provides entry through WS-HQ-01; the T7 **internal surface** then exposes broad intersite and flat-network paths to AD, EHR, file and recovery systems. The email is Internet-delivered, but the primary vector is human deception rather than a presumed FortiGate exploit.

### Attack Sequence

1. **Step 1 — Reconnaissance, Gather Victim Network Information (T1590.006):** The affiliate or its access broker identifies MedDefense's Fortinet dependency and Sarah's IT role, then prepares a believable security-update lure. Much of this pre-compromise research occurs outside MedDefense's local logging.
2. **Step 2 — Initial Access, Spearphishing Link (T1566.002):** Sarah follows the fraudulent support link and opens the downloaded file on WS-HQ-01 A-081. C-017–C-021 may inspect the endpoint, but this scenario models a payload that executes successfully.
3. **Step 3 — Execution, PowerShell (T1059.001):** The document launches a PowerShell stager and establishes a remote shell under the user's context. This converts the human compromise into an endpoint foothold.
4. **Step 4 — Persistence, Scheduled Task (T1053.005):** The attacker creates a Windows Update-themed scheduled task that restarts the foothold every 30 minutes. C-034/C-038 do not establish centralized, real-time alerting for new scheduled tasks.
5. **Step 5 — Discovery, Remote System Discovery (T1018):** From HQ, the attacker enumerates AD, EHR, file and backup systems through the broad site-to-site path. C-002 permits `ALL` services toward the Central server subnet, while the flat Central environment increases discoverability.
6. **Step 6 — Credential Access, LSASS Memory (T1003.001):** Local administrative access is used to extract a memory-resident `svc_backup` NTLM hash left by prior privileged use. Password policy does not prevent privileged credential residue on an ordinary workstation.
7. **Step 7 — Lateral Movement, Pass the Hash (T1550.002):** The hash is reused to obtain Domain Admin access through ad-dc-01 A-040 and reach domain-joined systems. Connectivity alone would not grant this access; the stolen privileged authentication material is the enabling condition.
8. **Step 8 — Collection, Data from Information Repositories: Databases (T1213.006):** The attacker uses the acquired privileges and reachable PostgreSQL service to stage EHR data from ehr-db-01 A-037/A-112 and selected files from file-srv-01 A-042. GAP-006 and GAP-017 make this path more plausible but do not prove unrestricted database rights.
9. **Step 9 — Exfiltration, Exfiltration to Cloud Storage (T1567.002):** Archived patient and business data are transferred over HTTPS to attacker-controlled cloud storage. The theft supplies disclosure leverage even if systems can later be restored.
10. **Step 10 — Impact, Inhibit System Recovery (T1490):** Using compromised administrative access, the affiliate deletes reachable NAS recovery points and Windows shadow copies. C-022/C-023 provide local backups and RAID, but GAP-007 leaves production and recovery in a common failure domain.
11. **Step 11 — Impact, Data Encrypted for Impact (T1486):** Ransomware is distributed through Group Policy to Windows systems and through separately obtained SSH access where available, disrupting EHR dependencies, shared files and administration. C-005's key-only SSH on `ehr-srv-01` means that host requires a usable key or another access path; a Linux password alone is not assumed.

**STRIDE Categories Triggered:** **Information Disclosure — EHR-I1**, because Restricted records are extracted from PostgreSQL; and **Denial of Service — EHR-D1**, because production services and reachable recovery copies are disabled or encrypted. Credential impersonation occurs elsewhere in the chain, but EHR-S1 is not cited because Task 11 defines that threat specifically as reuse of a clinician session, which this scenario does not establish.

**MedDefense Assets Impacted:** WS-HQ-01 A-081; ad-dc-01 A-040 and ad-dc-02 A-041; EHR application/server A-111/A-036; EHR database A-112/A-037; file-srv-01 A-042; backup-srv-01 A-044, NAS-01 A-045 and Veeam platform A-118. The FortiGate A-086 supplies the trusted HQ-to-Central path but is not assumed compromised.

**Business Impact:**

- **Clinical:** Clinicians could lose timely histories, medication information and results, forcing the weak C-043 paper fallback and creating reconciliation risk when systems return.
- **Financial:** Emergency response, restoration, interruption of billing and extortion handling would generate direct costs; payment and successful decryption are not assumed.
- **Regulatory:** Exfiltration of Restricted patient records could trigger breach assessment, notification and investigation obligations.
- **Reputational:** Simultaneous care disruption and threatened data publication could reduce patient, workforce and partner trust.

**Gaps Exploited:**

- **GAP-014 — incomplete, non-role-specific training:** the Fortinet support lure exploits a believable IT duty and urgent-patch pressure.
- **GAP-011 — weak identity and MFA assurance:** privileged authentication is reusable without demonstrated phishing-resistant MFA or administrative tier separation.
- **GAP-016 — unverified least-privilege boundaries:** broad VPN and flat-network paths support discovery and lateral movement after initial access.
- **GAP-006 — excessive EHR database reachability:** the attacker can attempt PostgreSQL access from more sources than the documented application dependency requires.
- **GAP-017 — inadequate bulk-export safeguards:** abnormal patient-data collection lacks demonstrated timely authorization checks and alerting.
- **GAP-007 — shared production/recovery failure domain:** reachable local recovery infrastructure can be attacked before encryption.

### Detection Opportunities

| Step(s) | Observable opportunity | Control that could interrupt or expose the sequence |
|---|---|---|
| 1–2 | Newly registered support domain, Fortinet impersonation, suspicious link/file and unusual sender context | Secure email gateway with URL detonation and domain-age checks; role-specific vendor-verification procedure; phishing-resistant MFA for cloud and administrative identities |
| 3–4 | Office-to-PowerShell process chain, encoded commands, outbound shell and new scheduled task | Centrally managed EDR with PowerShell/script logging, scheduled-task analytics and automatic host isolation; C-017–C-021 are a partial endpoint base, not evidence of these detections |
| 5 | Broad cross-subnet host/port enumeration from WS-HQ-01 | Internal network detection plus least-privilege segmentation and deny-by-default HQ-to-server flows |
| 6–7 | LSASS access, NTLM pass-the-hash and abnormal Domain Admin use from a staff workstation | Credential Guard/LSASS protection, privileged-access workstations, administrative tiering and real-time AD authentication analytics |
| 8–9 | Large database reads, `pg_dump`-like behavior, archive creation and uncommon cloud-transfer volume | Near-real-time EHR/database audit alerts, export approval thresholds, host telemetry and egress DLP/proxy analytics |
| 10–11 | Backup deletion, shadow-copy commands, Group Policy changes and rapid file rewrites | Immutable/offline recovery copies with deletion alerts; privileged change approval; mass-encryption/canary-file detection; tested isolation and recovery playbooks |

## Scenario 2 — The Quiet Export Before Departure

**Title:** The Quiet Export Before Departure

**Threat Actor:** **Insider (Malicious)** from T6, specifically T3 Scenario 4, **“The Curious Employee,”** whose defining behavior is deliberate patient-record access outside a legitimate purpose. This scenario develops that malicious valid-account pattern into the paced exfiltration path documented in T13 Scenario Beta. T6 assesses malicious insiders as **Medium likelihood** with **Low–Medium capability** because valid access can remove the need for an exploit.

**Motivation:** **Financial gain** from selling patient and billing information. This motive is a modeled scenario, not an accusation that T3's clerk or any actual employee sought payment.

**Initial Vector:** **Legitimate access abused** (T3/T9). A departing billing specialist uses her authorized billing account and read-only EHR role; a personal USB device from T8 is the later exfiltration channel, not the initial vector.

**Attack Surface Exploited:** T7 **Human surface** supplies trusted workforce status and knowledge of normal workflows; the **internal surface** supplies authenticated EHR and billing access from the assigned workstation. No external exploit, stolen password or privilege escalation is required for the initial collection.

### Attack Sequence

1. **Step 1 — Initial Access, Valid Accounts (T1078.002):** While still employed, the specialist signs in with her own authorized identity and decides to use it for an unauthorized purpose. The parent T1078 applies if either application identity is not AD-backed.
2. **Step 2 — Discovery, File and Directory Discovery (T1083, closest fit):** She reviews the patient, insurance, diagnosis and prescription fields available through ordinary billing/EHR workflows and selects high-value records. ATT&CK has no exact application-record discovery technique, so T1083 is used only as T13's closest fit.
3. **Step 3 — Collection, Data from Information Repositories: Databases (T1213.006):** She uses the built-in EHR export function in batches of roughly 200 records per day, eventually collecting the 2,800-record set modeled in T13 without a single conspicuous bulk event.
4. **Step 4 — Exfiltration, Exfiltration over USB (T1052.001):** The CSV files are copied to a personal USB drive. Normalized removable-media use and the absence of a verified USB-restriction GPO let the transfer resemble routine work.
5. **Step 5 — Defense Evasion, File Deletion (T1070.004):** She deletes the local CSV files and empties the recycle bin. This removes obvious workstation copies but does not erase the vendor-managed EHR audit trail, so the evasion is incomplete.

**STRIDE Categories Triggered:** **Information Disclosure — EHR-I2**, because a valid EHR user exports records to unmanaged storage. The local deletion is ATT&CK Defense Evasion, but **EHR-R1 is not claimed**: that Task 11 threat requires reuse of an unattended session, whereas this scenario uses the insider's own attributable account.

**MedDefense Assets Impacted:** EHR application A-111 on ehr-srv-01 A-036; EHR data store A-112 on ehr-db-01 A-037; billing web application A-123 and Billing MySQL data store A-113 if the selected export combines billing information. EHR audit log A-119 is a detection source and is not assumed altered. The supplied narrative does not identify the specialist's workstation in the Asset Registry, so no endpoint ID is invented.

**Business Impact:**

- **Clinical:** Confidential histories and prescriptions can be used to target or coerce patients; the modeled attack does not change clinical records or interrupt care.
- **Financial:** Investigation, legal support, notification, identity-protection services and possible claims would impose costs independent of whether the data are sold.
- **Regulatory:** Purpose-of-use violations and removal of Restricted records from controlled systems would require privacy and breach assessment based on the verified scope.
- **Reputational:** Deliberate workforce misuse can undermine patient confidence that even correctly functioning systems protect sensitive care information.

**Gaps Exploited:**

- **GAP-017 — weak bulk-export authorization and detection:** every read-authorized user can perform the modeled export without demonstrated additional approval, volume limits or prompt review.
- **GAP-020 — unverified removable-media and outbound controls:** no evidenced device-control or content-aware DLP control blocks the CSV transfer to personal USB storage.

### Detection Opportunities

| Step(s) | Observable opportunity | Control that could interrupt or expose the sequence |
|---|---|---|
| 1–2 | Record access unrelated to assigned patients/tasks, unusual search breadth or a departure-related change in behavior | Patient-relationship/purpose-of-use analytics, manager-reviewed access recertification and risk-based monitoring coordinated with HR without presuming guilt |
| 3 | Repeated daily exports, cumulative volume across sessions and unusually broad data fields | Near-real-time ingestion of A-119 audit events, per-user export thresholds, secondary approval for large/sensitive exports and cumulative-volume UEBA; C-037's 48-hour export is too slow for prompt interruption |
| 4 | CSV writes to removable storage and a new personal USB device | Endpoint device control and DLP that block or require approval for Restricted-data writes, with an exception path for documented clinical need |
| 5 | Creation followed by rapid deletion of exported CSV files | Central EDR/file telemetry correlated with the immutable EHR audit trail; alerting should preserve evidence rather than treat deletion alone as proof of theft |

## Scenario 3 — Trusted MedTech Update, Hidden EHR Collection

**Title:** Trusted MedTech Update, Hidden EHR Collection

**Threat Actor:** **Nation-State APT** from T6, using a compromised MedTech Solutions operator or software-delivery path as a stepping stone. T6 rates this actor **Low likelihood** for MedDefense specifically but **High capability**; the scenario becomes more relevant if patient intelligence, a strategic individual or a future research partnership becomes a state objective.

**Motivation:** **Espionage**—quiet, sustained collection of patient information or access useful to a strategic intelligence requirement.

**Initial Vector:** **Supply Chain Compromise / vendor access pathway** from T5/T9. The APT first compromises MedTech outside MedDefense's boundary, then enters through the supplier's authorized EHR maintenance or update channel. A vendor spearphish may compromise the supplier, but the primary MedDefense vector is the trusted third-party path.

**Attack Surface Exploited:** T7 **external surface — authorized vendor maintenance** to ehr-srv-01 A-036/A-111. Once code executes in the application context, the attack crosses the T7 **internal application-to-database trust path** toward ehr-db-01 A-037/A-112. The exact transport and privileges remain unknown; this is a conditional path, not a finding that MedTech has direct database or root access.

### Attack Sequence

1. **Step 1 — Initial Access, Spearphishing Attachment/Link (T1566.001/T1566.002):** The APT compromises a MedTech engineer or support environment outside MedDefense. MedDefense may receive no telemetry for this supplier-side event.
2. **Step 2 — Credential Access, Unsecured Credentials or Steal Web Session Cookie (T1552/T1539, conditional):** The attacker obtains the vendor's maintenance key, token or authenticated session. The exact technique cannot be narrowed until MedTech's connection method is documented.
3. **Step 3 — Initial Access, External Remote Services (T1133):** The attacker uses the valid vendor pathway during a plausible maintenance window to reach ehr-srv-01. C-005–C-011 can harden and log SSH if SSH is the route, but a valid compromised key can still appear authorized.
4. **Step 4 — Persistence, Server Software Component (T1505):** A modified EHR update installs a covert component in the application stack so access survives the maintenance session. The scenario requires the update or maintenance identity to possess relevant application-write permission; Task 5 does not prove root access.
5. **Step 5 — Defense Evasion, Impair Defenses (T1562.001):** The component suppresses selected local application events or delays forwarding while preserving enough normal behavior to avoid an obvious outage. A-119 is vendor-managed and already exported with delay, reducing prompt independent visibility.
6. **Step 6 — Discovery, File and Directory Discovery (T1083):** The attacker examines configuration files and application dependencies to locate an EHR database connection identity. Discovery does not itself prove the secret is readable.
7. **Step 7 — Lateral Movement, Remote Services (T1021):** Using a recovered application-held identity, the attacker moves from ehr-srv-01 to the PostgreSQL service on ehr-db-01. This step depends on usable credentials; GAP-006's reachability alone is insufficient.
8. **Step 8 — Collection, Data from Information Repositories: Databases (T1213.006):** Selected patient records are queried and staged in small batches under the compromised application identity, avoiding a single large export.
9. **Step 9 — Exfiltration, Exfiltration Over Web Service (T1567):** The staged records leave over HTTPS or the established vendor channel in low-volume transfers. The exact sub-technique depends on the destination and is not assumed.

**STRIDE Categories Triggered:** **Tampering — EHR-T1**, because a compromised update alters EHR application logic; **Repudiation — EHR-R2**, because a privileged intruder suppresses local evidence; **Information Disclosure — EHR-I1**, because Restricted records are extracted from PostgreSQL; and **Elevation of Privilege — EHR-E1/EHR-E2**, because application or vendor maintenance access is converted into database capability beyond the intended scope.

**MedDefense Assets Impacted:** ehr-srv-01 A-036 and EHR application A-111; ehr-db-01 A-037 and EHR data store A-112; EHR audit log A-119. MedTech's own systems are the stepping stone but are outside MedDefense's Asset Registry.

**Business Impact:**

- **Clinical:** Covert application tampering could present false or incomplete clinical information; even a confidentiality-focused intrusion may require EHR isolation and downtime while code and data integrity are validated.
- **Financial:** Forensic validation of the EHR, vendor coordination, restoration and prolonged clinical downtime can create substantial cost without any ransomware demand.
- **Regulatory:** Unauthorized vendor-path access to Restricted patient data could create reportable privacy and third-party oversight issues, subject to confirmed scope and applicable requirements.
- **Reputational:** A trusted supplier delivering compromised access or code can weaken confidence in both MedDefense's EHR and its vendor-governance program.

**Gaps Exploited:**

- **GAP-011 — weak identity/MFA assurance:** vendor-specific MFA, individual attribution and time-limited approval are not evidenced.
- **GAP-016 — unverified third-party and internal least privilege:** the effective vendor route, maintenance permissions and application-to-database boundary are not documented or demonstrated as minimal.
- **GAP-022 — incomplete change approval and rollback evidence:** a modified update may enter without independently verified signature, two-person approval, baseline comparison or tested rollback.
- **GAP-006 — excessive database reachability and incomplete access review:** the compromised application host can reach PostgreSQL, while service-identity scope is not proven minimal.
- **GAP-017 — weak export detection:** low-and-slow patient-record collection lacks demonstrated timely volume or purpose-of-use alerting.

### Detection Opportunities

| Step(s) | Observable opportunity | Control that could interrupt or expose the sequence |
|---|---|---|
| 1–2 | Supplier account or token compromise | Contractually required vendor MFA, supplier incident notification, managed vendor identities and rapid credential/session revocation; MedDefense cannot rely on local telemetry for the supplier-side event |
| 3 | Vendor login from a new source, outside an approved window or without a linked ticket | Time-bound PAM gateway, source allow-list, phishing-resistant MFA, named accounts, session recording and maintenance-ticket correlation |
| 4 | Update signature mismatch, unexpected application files or unapproved maintenance change | Cryptographic update verification, two-person change approval, isolated pre-production validation, file-integrity monitoring and a tested rollback package |
| 5 | Audit process/configuration change or an unexplained drop in expected events | Independent, append-only central logging with heartbeat/missing-event alerts; vendor-controlled A-119 exports should be reconciled against host and database logs |
| 6–8 | Configuration-secret access, new DB client behavior, abnormal queries or cumulative patient-volume growth | Secret vaulting, least-privilege service identities, PostgreSQL source/account allow-lists, database activity monitoring and cumulative export analytics |
| 9 | Unusual outbound destination, long-lived HTTPS session or vendor-channel transfer inconsistent with the ticket | Egress allow-listing, proxy/network analytics, DLP and post-maintenance session/transfer review |

## Board-Level Comparison

Scenario 1 is the most likely of the three and has the clearest path to simultaneous clinical outage, data theft and recovery destruction. Scenario 2 requires the least technical capability because the insider starts inside the authorization boundary; its key control points are purpose-of-use monitoring and blocking uncontrolled exports. Scenario 3 is less likely under T6's current target assessment, but it is the hardest to distinguish from legitimate support and can silently undermine the integrity of the system clinicians trust. Across all three, the recurring defensive priorities are strong identity, verified least-privilege boundaries, near-real-time EHR/database monitoring, controlled data egress and independently protected recovery.
