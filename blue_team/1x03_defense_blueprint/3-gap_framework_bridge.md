# Task 3 — The Gap-to-Framework Bridge

- **Organization:** MedDefense Health Systems
- **Project:** 1x03 — Defense Blueprint
- **Deliverable:** `3-gap_framework_bridge.md`
- **Assessment date:** 29 October 2026
- **Prepared for:** James Chen, Deputy CISO, and Sarah Park, IT Director
- **Planning boundary:** Six-month program; shared funding ceiling of $120,000 (not a per-control allocation)

## Purpose, Selection Method, and Evidence Rules

This document establishes eight traceable **Gap → Vulnerability Evidence → Threat → NIST CSF Function → CIS Control → Recommended Action** chains. The selection follows **the exact first eight entries in 1x01 Task 15's threat-reprioritized list**: **GAP-016, GAP-011, GAP-017, GAP-006, GAP-007, GAP-001, GAP-002 and GAP-003**, in that order. All eight are rated **Critical** in the updated 1x01 analysis; the first five were raised from High, while the final three remained Critical. 1x02 Task 16 triage and Task 17 contextualization are used to connect actual technical findings where one exists. This is a **gap-priority ordering**, not a claim that these are the eight highest-CVSS vulnerabilities.

**Evidence classification:** A finding is **direct** when it measures the stated gap's relevant exposure; **supporting/adjacent** when it increases the plausibility of the threat path but does not prove the gap itself. A scenario is a modeled attack path, **not an observed incident or proof of exploitation**. A missing 1x02 finding is reported as missing rather than invented. CIS Control names and current whole-control scores come from [Task 2](2-cis_controls_audit.md); a whole-control score is not evidence of satisfying each IG1/IG2 Safeguard. The primary NIST function and primary CIS Control identify the most useful framework entry point; supporting controls may be listed to avoid treating a multidisciplinary gap as solvable by a single product.

**Critical source corrections:** In the assignment's *illustrative* sentence, `GAP-003` is called a flat-network gap, but the actual [1x00 gap register](../1x00_first_watch/12-gap_analysis.md) identifies **GAP-003 as missing PACS recovery**; broad network trust boundaries are **GAP-016**. The quoted **$180,000/year ALE reduction is an example, not a verified MedDefense estimate**. No dollar risk reduction, prevented attack or finished remediation is claimed here. The 1x02 version-based allegations for **Finding 031 (Tomcat/Ghostcat)** and **Finding 010 (Alaris firmware)** require build/vendor confirmation; exposed AJP or device-management controls may still warrant remediation independently.

## Part 1 — Eight High-Priority Traceability Chains

### 1. GAP-016 — Broad Trust Boundaries (T15 Rank 1)

- **Gap Reference:** **GAP-016** — updated **Critical** (from High), **6** T10/T14 paths; [1x00 gap register](../1x00_first_watch/12-gap_analysis.md), [1x01 T15](../1x01_know_your_enemy/15-gap_threat_correlation.md).
- **Description:** VPN, intersite, internal and third-party network paths are broader than validated service needs and lack verified least-privilege enforcement.
- **Vulnerability Evidence:** **Finding 003 (direct)** — PostgreSQL on `ehr-db-01` accepts connection attempts from `10.10.0.0/16`, though authentication still applies; **Finding 004 (supporting)** — legacy MRI SMB/RDP reachability without confirmed isolation; **Finding 010 (supporting)** — broadly reachable pump-management interfaces, with vendor/CVE applicability pending verification. [1x02 T16](../1x02_the_weak_links/16-triage.md).
- **Threat Context:** **Ransomware affiliates — KC1** (VPN to AD) and **KC3** (Radiology to PACS); **malicious insider — KC4** (pump management); **compromised MedTech channel / nation-state APT — KC5** (EHR). These are modeled paths, not confirmed breaches.
- **NIST CSF Function:** **PROTECT (PR)** — enforce appropriate access and platform/infrastructure protection.
- **CIS Control:** **12 — Network Infrastructure Management** (**Partial** in T2); supporting **6 — Access Control Management**.
- **Recommended Action:** Define approved source/destination/port matrices and phase in least-privilege VPN, AD, EHR, PACS/MRI and pump network rules with Biomedical/vendor approval and preserved clinical traffic.
- **Closure Evidence:** Approved firewall/ACL changes, denied unauthorized connections **and** successful application, DICOM and medical-device workflow tests; named rule owners and exception expiry dates.

### 2. GAP-011 — Shared Identity and Weak MFA (T15 Rank 2)

- **Gap Reference:** **GAP-011** — updated **Critical** (from High), **6** T10/T14 paths; [1x00](../1x00_first_watch/12-gap_analysis.md), [1x01 T15](../1x01_know_your_enemy/15-gap_threat_correlation.md).
- **Description:** Shared clinical identities, limited MFA and incomplete account-lifecycle assurance undermine individual accountability and access revocation.
- **Vulnerability Evidence:** **Findings 007 and 018 (supporting, not a direct MFA test)** — LDAP signing is not required and legacy Kerberos DES/RC4 remain enabled on AD, compounding identity-system risk; **C-052** shared PACS login and **C-041** limited MFA are directly documented in 1x00 controls. [1x02 T16](../1x02_the_weak_links/16-triage.md), [1x00 control matrix](../1x00_first_watch/10-complete_control_matrix.md).
- **Threat Context:** **Ransomware affiliates — KC1/KC3** reuse stolen or shared credentials; **malicious insider — KC4** may misuse pump access; **compromised vendor identity / APT — KC5** may reach EHR records.
- **NIST CSF Function:** **PROTECT (PR)** — identity, authentication and access control.
- **CIS Control:** **6 — Access Control Management** (**Partial** in T2); supporting **5 — Account Management**.
- **Recommended Action:** Replace shared privileged/clinical accounts with attributable identities, establish prompt joiner/mover/leaver review and require vendor-supported MFA for VPN, administrator, supplier and relevant clinical access paths.
- **Closure Evidence:** Account ownership inventory, MFA enrollment and bypass review, terminated-user revocation tests, and Biomedical/vendor-approved clinical compatibility validation.

### 3. GAP-017 — Patient-Record Bulk Export Controls (T15 Rank 3)

- **Gap Reference:** **GAP-017** — updated **Critical** (from High), **4** T10/T14 paths; [1x00](../1x00_first_watch/12-gap_analysis.md), [1x01 T15](../1x01_know_your_enemy/15-gap_threat_correlation.md).
- **Description:** EHR bulk export permissions, approvals, volume restrictions and timely anomaly detection are not documented as operating safeguards.
- **Vulnerability Evidence:** **Finding 003 (supporting)** exposes a wide potential access path to the EHR database, and **Finding 023 (supporting)** documents unrestricted USB mass storage on clinical workstations; **neither finding directly tests EHR bulk-export authorization or proves exfiltration**. Existing **C-037** EHR audit exports have a reported **48-hour delay**. [1x02 T16](../1x02_the_weak_links/16-triage.md), [1x00 control matrix](../1x00_first_watch/10-complete_control_matrix.md).
- **Threat Context:** **Nation-state APT via compromised MedTech channel — KC5** (covert patient-record collection); **malicious insider — S2** (quiet export); **ransomware/extortion actor — S1**. S1/S2 are 1x01 T14 scenarios, not additional kill-chain IDs.
- **NIST CSF Function:** **PROTECT (PR)** — patient-data access and controlled handling (with a DETECT dependency).
- **CIS Control:** **3 — Data Protection** (**Partial** in T2); supporting **8 — Audit Log Management** and **6 — Access Control Management**.
- **Recommended Action:** Limit bulk patient-record exports to approved job roles and explicitly authorized requests, apply suitable volume/destination controls and generate timely, centrally reviewed alerts for exceptional queries or downloads.
- **Closure Evidence:** Approved export-rights matrix, rejected unauthorized export test, sampled logged approvals, and tested high-volume EHR alert escalation significantly faster than the current delayed review.

### 4. GAP-006 — Excessive EHR Database Reachability (T15 Rank 4)

- **Gap Reference:** **GAP-006** — updated **Critical** (from High), **3** T10/T14 paths; [1x00](../1x00_first_watch/12-gap_analysis.md), [1x01 T15](../1x01_know_your_enemy/15-gap_threat_correlation.md).
- **Description:** PostgreSQL connectivity and account/source allowances exceed the documented EHR application dependency.
- **Vulnerability Evidence:** **Finding 003 (direct)** — `listen_addresses='*'` and `pg_hba.conf` permits the `10.10.0.0/16` network with **MD5 authentication still required**; **Finding 031 (supporting/conditional)** — a reachable AJP connector could expose credentials, but the reported Tomcat 9.0.31 build is listed as fixed for Ghostcat and CVE applicability must be confirmed. [1x02 T16](../1x02_the_weak_links/16-triage.md), [1x02 T17](../1x02_the_weak_links/17-cvss_contextualizer.md).
- **Threat Context:** **Compromised maintenance identity / nation-state APT — KC5**, progressing from the EHR application toward patient records; **ransomware affiliate — S1** and **vendor-update compromise — S3** are additional modeled paths.
- **NIST CSF Function:** **PROTECT (PR)** — enforce least-privilege access to sensitive application and database infrastructure.
- **CIS Control:** **12 — Network Infrastructure Management** (**Partial** in T2); supporting **3 — Data Protection** and **6 — Access Control Management**.
- **Recommended Action:** Restrict TCP/5432 and PostgreSQL `pg_hba.conf` to verified application sources, review database roles and safely disable or allowlist unnecessary AJP exposure after confirming the actual Tomcat build.
- **Closure Evidence:** Unauthorized source denied; validated EHR application succeeds; database authorization and AJP configuration reviewed, approved and monitored with tested rollback.

### 5. GAP-007 — Shared Backup Failure Domain (T15 Rank 5)

- **Gap Reference:** **GAP-007** — updated **Critical** (from High), **2** T10/T14 paths; [1x00](../1x00_first_watch/12-gap_analysis.md), [1x01 T15](../1x01_know_your_enemy/15-gap_threat_correlation.md).
- **Description:** Production and recovery systems share exposure; demonstrated copies are local, have limited separation and lack complete clinical restoration tests.
- **Vulnerability Evidence:** **Finding 015 (direct supporting infrastructure exposure)** — Synology NAS management ports 5000/5001 are reachable network-wide and the NAS holds unencrypted backups; this demonstrates an attack path, **not actual backup destruction**. Independently, controls **C-022–C-024** document local 14-day backups, RAID5 and a limited file-server restore test. [1x02 T16](../1x02_the_weak_links/16-triage.md), [1x00 control matrix](../1x00_first_watch/10-complete_control_matrix.md).
- **Threat Context:** **Ransomware affiliates — KC1** (domain takeover and possible backup interference); **S1** (hospital-wide extortion) also depends on reachable recovery infrastructure.
- **NIST CSF Function:** **RECOVER (RC)** — ensure protected, usable clinical and identity-service restoration.
- **CIS Control:** **11 — Data Recovery** (**Partial** in T2); supporting **12 — Network Infrastructure Management**.
- **Recommended Action:** Create segregated immutable or offline/offsite recovery copies for approved critical EHR, AD and business workloads, restrict backup administrator/management paths and rehearse full-service restores to clinical RTO/RPO objectives.
- **Closure Evidence:** Documented copy location and immutability/access checks; successfully restored service **and data**, recorded recovery times, and a separate backup-admin access review.

### 6. GAP-001 — Infusion-Pump Detection and Recovery (T15 Rank 6)

- **Gap Reference:** **GAP-001** — maintained **Critical**, **1** T10/T14 path; [1x00](../1x00_first_watch/12-gap_analysis.md), [1x01 T15](../1x01_know_your_enemy/15-gap_threat_correlation.md).
- **Description:** Alaris pumps lack verified device-specific change monitoring, safe isolation and tested device-configuration recovery.
- **Vulnerability Evidence:** **Finding 010 (related device exposure)** — the scan reports accessible Alaris management and default `admin/admin` credentials, but the firmware-specific **CVE-2020-25165 applicability is disputed for version 12.1.2** and requires BD validation; do not infer that active infusion settings are remotely modifiable. [1x02 T16](../1x02_the_weak_links/16-triage.md), [1x02 T17](../1x02_the_weak_links/17-cvss_contextualizer.md).
- **Threat Context:** **Malicious biomedical/clinical/IT insider — KC4**, potentially abusing privileged pump-management access to alter configuration or interrupt treatment operations.
- **NIST CSF Function:** **DETECT (DE)** — recognize and analyze unauthorized changes to safety-critical devices (with recovery as a necessary secondary function).
- **CIS Control:** **13 — Network Monitoring and Defense** (**Partial** in T2); supporting **11 — Data Recovery** and **6 — Access Control Management**.
- **Recommended Action:** With Biomedical and BD approval, restrict pump-management origins, monitor approved passive/configuration-change signals, alert accountable staff and preserve a tested device-safe configuration recovery procedure.
- **Closure Evidence:** Vendor-approved version/credential review, successful benign change-alert test, documented escalation and clinically supervised configuration restore or fallback validation; no uncontrolled live-device exploitation.

### 7. GAP-002 — Unsafe Pharmacy Changes (T15 Rank 7)

- **Gap Reference:** **GAP-002** — maintained **Critical**, **1** T10/T14 path; [1x00](../1x00_first_watch/12-gap_analysis.md), [1x01 T15](../1x01_know_your_enemy/15-gap_threat_correlation.md).
- **Description:** Production dosage updates have inadequate peer review, automated data-integrity validation and proven restoration/rollback.
- **Vulnerability Evidence:** **No matching numbered Finding in 1x02 T16** tests the pharmacy application, its change pipeline or dose-validation rules; the direct evidence is the **1x00 Incident C** (a faulty change undetected for approximately six hours), the weak **C-044** pharmacist comparison and **GAP-002/GAP-022**. Absence of a scanner finding **does not** make this patient-safety gap low risk. [1x00](../1x00_first_watch/12-gap_analysis.md), [1x01 KC2](../1x01_know_your_enemy/10-kill_chains.md).
- **Threat Context:** **Negligent authorized insider — KC2**, applying an unreviewed pharmacy change that corrupts dosage values across all three sites; this is an integrity/control-failure sequence, not necessarily a malicious intrusion.
- **NIST CSF Function:** **PROTECT (PR)** — secure production changes and protect clinical information integrity (with RECOVER as a dependency).
- **CIS Control:** **16 — Application Software Security** (**Not Implemented**, provisionally, in T2); supporting **11 — Data Recovery** for validated rollback.
- **Recommended Action:** Require named change approvers, peer-reviewed and staged pharmacy scripts, dosage-range/reference checks, pre-change recovery points and a clinically approved tested rollback before production release.
- **Closure Evidence:** Representative invalid-dose test fails safely; signed pharmacy change tickets; successful rollback and reconciliation exercise, including verification across all three sites.

### 8. GAP-003 — PACS Has No Documented Recovery Copy (T15 Rank 8)

- **Gap Reference:** **GAP-003** — maintained **Critical**, **1** T10/T14 path; [1x00](../1x00_first_watch/12-gap_analysis.md), [1x01 T15](../1x01_know_your_enemy/15-gap_threat_correlation.md).
- **Description:** PACS imaging studies are excluded from the documented backup set and no alternate recoverable, tested imaging-service copy is evidenced.
- **Vulnerability Evidence:** **Finding 024 (supporting, not a backup finding)** — patient-linked DICOM traffic lacks TLS; **Finding 004 (adjacent radiology foothold)** — legacy MRI controller exposes SMB/RDP risk; **neither proves the lack of PACS backups**, which is directly evidenced by the explicit **C-022** exclusion. [1x02 T16](../1x02_the_weak_links/16-triage.md), [1x00](../1x00_first_watch/12-gap_analysis.md).
- **Threat Context:** **Ransomware affiliate — KC3**, moving from Radiology phishing toward PACS image theft/encryption; missing recovery worsens clinical outage and extortion consequences.
- **NIST CSF Function:** **RECOVER (RC)** — restore critical diagnostic imaging services and validate clinical continuity.
- **CIS Control:** **11 — Data Recovery** (**Partial** in T2); supporting **12 — Network Infrastructure Management** for Radiology isolation.
- **Recommended Action:** Include PACS images, metadata and configuration in a protected backup/replication design, agree RTO/RPO with Radiology and perform a supervised full PACS restore plus MRI-to-PACS DICOM workflow validation.
- **Closure Evidence:** Dated PACS backup coverage, independently readable protected copy, successful restoration of representative studies/metadata and clinical sign-off on viewing, transfer and reconciliation.

## Part 2 — Traceability Summary Table

| T15 rank / gap | Vulnerability evidence from 1x02 | Threat actor → chain / scenario (1x01) | NIST CSF function | Primary CIS Control / T2 score | Framework-aligned action |
|---|---|---|---|---|---|
| **1 · GAP-016** | **003** direct; **004, 010** supporting | Ransomware → **KC1/KC3**; malicious insider → **KC4**; vendor/APT → **KC5** | **PR** | **12 — Network Infrastructure Management (Partial)** | Enforce validated least-privilege zone and VPN flows, with clinical positive/negative testing. |
| **2 · GAP-011** | **007, 018** identity-hardening support; shared account **C-052** is 1x00 | Ransomware → **KC1/KC3**; insider → **KC4**; vendor/APT → **KC5** | **PR** | **6 — Access Control Management (Partial)** | Named accounts, MFA, lifecycle review and privileged/vendor access restrictions. |
| **3 · GAP-017** | **003, 023** supporting; **no direct bulk-export scan test** | APT/vendor → **KC5**; insider → **S2**; ransomware → **S1** | **PR** | **3 — Data Protection (Partial)** | Require export approval, least privilege, volume rules and near-real-time alerting. |
| **4 · GAP-006** | **003** direct; **031** conditional/adjacent | APT/vendor → **KC5/S3**; ransomware → **S1** | **PR** | **12 — Network Infrastructure Management (Partial)** | Narrow `5432` and `pg_hba.conf` to approved EHR sources; review roles and AJP. |
| **5 · GAP-007** | **015** backup-management exposure; local copies **C-022–024** | Ransomware → **KC1/S1** | **RC** | **11 — Data Recovery (Partial)** | Segregate protected backups and verify full-service restores. |
| **6 · GAP-001** | **010** device-management exposure; firmware CVE disputed | Malicious insider → **KC4** | **DE** | **13 — Network Monitoring and Defense (Partial)** | Vendor-approved passive detection, alerts and device-safe recovery tests. |
| **7 · GAP-002** | **None in 1x02**; Incident C / **C-044** in 1x00 | Negligent insider → **KC2** | **PR** | **16 — Application Software Security (Not Implemented, provisional)** | Peer-review/stage dosage changes, validate integrity and test rollback. |
| **8 · GAP-003** | **024, 004** adjacent; PACS exclusion **C-022** in 1x00 | Ransomware → **KC3** | **RC** | **11 — Data Recovery (Partial)** | Protected PACS copy and witnessed imaging-service recovery. |

## Traceability and Delivery Guardrails

1. **Do not confuse the chain with causation:** Findings 007/018 do not prove MFA is missing; Finding 024 does not prove PACS has no backup; Finding 015 does not prove ransomware destroyed a backup; and no scanner result substitutes for an audited pharmacy deployment workflow.
2. **Keep separate, urgent 1x02 tickets:** The T15 top-eight *gap* selection does not deprioritize the separately actionable billing/print Findings **001, 002, 008**, or urgent verification of **031, 003, 004, 010**. Their actual owners, fixes and closeout evidence remain governed by 1x02 triage and validation procedures.
3. **Protect patient care:** Network rules, identity changes, patching and recovery exercises that touch MRI, PACS, pumps or pharmacy require Biomedical/vendor and clinical sign-off, maintenance windows, positive workflow tests and an approved rollback path.
4. **Do not double-count controls or benefits:** One CIS Control may resolve multiple gaps (e.g., 12 for network boundaries and EHR database reachability; 11 for backup separation and missing PACS copies). Report separate gap-closure evidence without inventing separate risk savings.
5. **Measure closure, not documentation alone:** A recommendation or planned safeguard is not an operating control. Reassess T1 NIST maturity and T2 CIS Safeguard coverage only after deployment evidence, testing, ownership and exception review.
6. **Funding:** These actions are candidates for the **single $120,000 six-month Defense Blueprint ceiling**. No implementation price, ALE, annual savings or claimed risk-reduction percentage is assigned without a supported quantitative business case.

## Source Index (Repository-Relative)

- [1x00 Task 12 — Prioritized Gap Analysis](../1x00_first_watch/12-gap_analysis.md): source GAP IDs, descriptions, existing controls and affected services.
- [1x00 Task 10 — Complete Control Matrix](../1x00_first_watch/10-complete_control_matrix.md): controls C-022–C-024, C-037, C-041, C-044, C-052 and documented limitations.
- [1x01 Task 15 — Gap–Threat Correlation](../1x01_know_your_enemy/15-gap_threat_correlation.md): authoritative first-eight re-prioritization and path frequencies.
- [1x01 Task 10 — Critical Kill Chains](../1x01_know_your_enemy/10-kill_chains.md): KC1–KC5, actors, attack steps and defensive break points.
- [1x01 Task 14 — Integrated Threat Scenarios](../1x01_know_your_enemy/14-threat_scenarios.md): S1, S2 and S3 referenced by Task 15.
- [1x02 Task 16 — Vulnerability Triage](../1x02_the_weak_links/16-triage.md): finding numbers, operational findings and correction priorities.
- [1x02 Task 17 — CVSS Contextualizer](../1x02_the_weak_links/17-cvss_contextualizer.md): version/CVE caveats and separated business priorities.
- [1x03 Task 1 — NIST CSF Mapping](1-nist_csf_mapping.md): six-function Current Profile and conditional targets.
- [1x03 Task 2 — CIS Controls Audit](2-cis_controls_audit.md): complete Control names, evidence-based 18-Control baseline and priorities.
- [NIST CSF 2.0 (CSWP 29)](https://doi.org/10.6028/NIST.CSWP.29) and [CIS Controls v8](https://www.cisecurity.org/controls/v8): framework definitions; the repository sources above establish MedDefense-specific evidence.

**Conclusion:** These eight records connect prior prioritized risks to implementable framework controls without converting hypothetical attacks into incidents or assigning unsupported risk savings. Closure requires measured, clinically safe operating evidence.
