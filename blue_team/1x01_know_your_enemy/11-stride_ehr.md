# MedDefense Health Systems — STRIDE Threat Model for the EHR

Prepared for: James Chen, Deputy CISO

Prepared by: Junior Security Analyst

Scope: `ehr-srv-01`, `ehr-db-01`, the logical EHR application and data store, clinical access endpoints, and the network and maintenance paths connecting them; no live testing performed.

## Architecture and Evidence Basis

This model uses the First Watch [Asset Registry](../1x00_first_watch/7-asset_registry.md), [Data Map](../1x00_first_watch/9-data_map.md), [Complete Control Matrix](../1x00_first_watch/10-complete_control_matrix.md) and [Gap Analysis](../1x00_first_watch/12-gap_analysis.md), together with the [T5 Supply Chain Assessment](5-supply_chain_assessment.md), [T8 Technical Vector Assessment](8-technical_vectors.md) and [T10 Kill Chains](10-kill_chains.md).

| EHR Element | MedDefense Evidence Relevant to STRIDE |
|---|---|
| Application tier | `ehr-srv-01` A-036/A-111, Ubuntu 20.04, exposes SSH 22, HTTPS 443 and application port 8080; C-005–C-011 harden only this host's SSH path. |
| Data tier | `ehr-db-01` A-037/A-112, Ubuntu 20.04 and PostgreSQL 5432; 5432 is broadly reachable and SSH 22 retains password authentication under C-051. |
| User tier | Clinical workstations and thin clients access the EHR; W3 observed a patient record in an unattended active session, while managed-workstation protection does not cover every mobile or unmanaged device. |
| Trust paths | The Central `10.10.0.0/16` environment is flat, MedTech maintains the application, application-to-database TLS and service-account scope are unverified, and C-037 audit exports can take 48 hours. |
| Recovery | C-022 backs up both EHR servers to local infrastructure, but the copies share network and physical exposure with production; C-043 is a weak paper fallback rather than system recovery. |

T8 vector names are used where supported. Unsupported EHR operating systems and EHR default credentials are **not** asserted because the artifacts do not establish either condition; conditional software, transport and privilege threats are labeled accordingly.

## Spoofing (S)

### EHR-S1 — Stolen Clinical Session Impersonates a Clinician

```text
Category: S
Threat ID: EHR-S1
Description: Malware or a person using a captured active session on a clinical workstation could submit EHR requests as the logged-in physician or nurse, making the application treat the intruder as authorized; the captured role determines the reachable records and functions.
Attack Vector: Removable Devices / Unmanaged Endpoints (T8) — a malicious removable device or unmanaged endpoint could compromise a clinical workstation and steal credentials or a session token; organization-wide USB enforcement remains unverified.
Impact: The intruder could view or change patient information under a trusted clinical identity, causing privacy loss, unsafe decisions and misleading audit attribution.
Existing Control: C-013–C-015 provide Windows password and lockout rules, C-017–C-021 protect reported managed Windows workstations, and C-037 records EHR application activity; C-041 MFA applies only to James's unspecified personal account.
Gap: GAP-011 — individual identity and MFA coverage are incomplete; GAP-020 — removable-media and outbound-sharing controls are unverified.
```

### EHR-S2 — A False Database Endpoint Impersonates `ehr-db-01`

```text
Category: S
Threat ID: EHR-S2
Description: An attacker already on the flat network could attempt to redirect the application toward a system impersonating ehr-db-01, capturing connection material or returning false responses if database endpoint authentication and encrypted transport are not enforced.
Attack Vector: Unsecure Networks (T8) — the flat Central network and unverified application-to-database TLS create a conditional path for name-resolution, routing or local network redirection; successful spoofing is not established.
Impact: Captured database credentials could enable later record access, while false database responses could present incomplete or incorrect clinical information.
Existing Control: C-003 blocks unmatched traffic crossing the FortiGate and C-004 records limited boundary traffic, but neither establishes east-west service identity; C-035 retains local Linux logs.
Gap: GAP-016 — internal trust boundaries lack verified least-privilege enforcement; GAP-006 — the approved EHR database source and connection baseline are not narrowly enforced.
```

## Tampering (T)

### EHR-T1 — Compromised Update Alters EHR Application Logic

```text
Category: T
Threat ID: EHR-T1
Description: A compromised MedTech maintenance identity or accepted software package could change validation, display or record-processing logic on ehr-srv-01 so altered clinical information appears legitimate to users.
Attack Vector: Vulnerable Software (T8) combined with the trusted maintenance path — malicious update content or a usable application flaw could modify EHR code; no current EHR product vulnerability is claimed because its version is unknown.
Impact: Subtle changes to allergies, medication information, results or clinical presentation could influence treatment while the application remains available and apparently normal.
Existing Control: C-055 provides contracted EHR software updates, C-005–C-011 harden SSH if that is the maintenance route, C-037 records application activity and C-022 supplies local recovery points; none proves independent update-integrity approval.
Gap: GAP-016 — vendor and internal trust boundaries are unverified; GAP-022 — organization-wide change approval and rollback evidence is incomplete.
```

### EHR-T2 — Direct PostgreSQL Modification Bypasses Application Checks

```text
Category: T
Threat ID: EHR-T2
Description: An attacker with a usable database credential could connect directly to PostgreSQL 5432 and alter patient rows, audit-relevant fields or application data without using the normal EHR validation workflow.
Attack Vector: Open Service Ports and Unsecure Networks (T8) — PostgreSQL 5432 is broadly reachable across the flat environment, so a compromised internal host can attempt database authentication directly.
Impact: Incorrect histories, allergies, results or treatment information could remain trusted by clinicians and cause unsafe care; bulk corruption could also make the EHR unusable.
Existing Control: C-035 retains local Linux logs, C-022 backs up ehr-db-01 and C-051 provides only weak password-based SSH protection on the database host; C-005–C-011 do not apply to ehr-db-01.
Gap: GAP-006 — database reachability is broader than the documented application need; GAP-016 — weak internal boundaries permit unnecessary approach paths.
```

## Repudiation (R)

### EHR-R1 — Actions Are Denied After an Unattended Session Is Reused

```text
Category: R
Threat ID: EHR-R1
Description: A second person could use the active EHR session observed on an unattended nurse-station workstation and later deny the lookup or change because the audit trail identifies the logged-in account rather than the person at the keyboard.
Attack Vector: Unsecure endpoint use combined with Unsecure Networks (T8) — physical reuse of an authenticated clinical session reaches the EHR through the normal trusted network path without a new login.
Impact: MedDefense may be unable to determine who accessed or changed a patient record, delaying containment, patient notification, workforce action and reliable clinical reconstruction.
Existing Control: C-013–C-015 govern Windows authentication, C-032 supplies incomplete awareness training and C-037 records vendor-managed EHR activity, but none establishes automatic clinical-session locking or person-level reauthentication.
Gap: GAP-011 — weak individual accountability and limited MFA allow valid accounts or sessions to conceal the responsible person; GAP-014 — training is incomplete and not sufficiently role-specific.
```

### EHR-R2 — Privileged Intruder Alters Local Evidence

```text
Category: R
Threat ID: EHR-R2
Description: An attacker who obtains privileged access on ehr-srv-01 or ehr-db-01 could delete or modify local Linux and authentication records, then dispute the origin, timing or scope of EHR access before the delayed application audit is obtained.
Attack Vector: Vulnerable Software or Open Service Ports (T8) — conditional host compromise through a usable service flaw or privileged remote credential could provide access to locally stored logs; no such EHR exploit is confirmed.
Impact: Investigators could lose evidence needed to distinguish legitimate maintenance from record theft or alteration, extending attacker dwell time and weakening incident, regulatory and legal conclusions.
Existing Control: C-011 records verbose SSH events on ehr-srv-01, C-035 stores Linux logs locally, C-037 provides EHR audit exports after up to 48 hours and C-038 relies on reactive review; none is evidenced as centralized or write-once.
Gap: GAP-017 — timely detection of patient-record export activity is incomplete; GAP-016 — privileged and third-party paths lack verified session restriction and independent monitoring.
```

## Information Disclosure (I)

### EHR-I1 — Restricted Records Are Extracted Directly from PostgreSQL

```text
Category: I
Threat ID: EHR-I1
Description: A compromised internal host with a valid or stolen PostgreSQL credential could query ehr-db-01 directly and collect Restricted medical records outside the normal EHR user interface.
Attack Vector: Open Service Ports and Unsecure Networks (T8) — network-wide reachability to 5432 gives internal footholds a direct opportunity to test database authentication and extraction paths.
Impact: Patient histories, results and other clinical information could be exposed at scale, producing privacy harm, notification and investigation costs, extortion leverage and loss of trust.
Existing Control: C-003 supplies perimeter denial, C-035 records local database-host events and C-037 supplies delayed application audits, but boundary filtering does not restrict internal PostgreSQL sources and application auditing may not cover direct queries.
Gap: GAP-006 — PostgreSQL access is broader than documented need; GAP-016 — internal paths are insufficiently restricted.
```

### EHR-I2 — A Valid User Exports Records to Unmanaged Storage

```text
Category: I
Threat ID: EHR-I2
Description: A clinician or administrator could use legitimate EHR access to export or copy patient records to a personal NAS, USB device, unmanaged tablet or personal cloud location without timely review.
Attack Vector: Removable Devices / Unmanaged Endpoints (T8) — unverified USB controls, unmanaged physician devices and documented shadow storage provide destinations outside approved EHR protection.
Impact: Restricted information could persist without verified encryption, access review, retention or recovery controls and later be lost, shared or compromised without MedDefense visibility.
Existing Control: C-037 records EHR activity but exports can take 48 hours, C-032 provides weak general awareness and C-017–C-021 protect only covered Windows endpoints; C-022 cannot reverse disclosure.
Gap: GAP-017 — bulk export lacks documented authorization and detection safeguards; GAP-020 — outbound sharing and removable-media controls are unverified.
```

## Denial of Service (D)

### EHR-D1 — Ransomware Disables Production and Reachable Recovery Copies

```text
Category: D
Threat ID: EHR-D1
Description: Ransomware entering through a workstation, VPN or other internal foothold could encrypt or disable ehr-srv-01 and ehr-db-01, then attack reachable local backup infrastructure before MedDefense restores service.
Attack Vector: Unsecure Networks (T8) — flat connectivity and broad VPN/server-subnet permissions can let a successful foothold discover EHR and recovery systems; connectivity alone does not grant administrative rights.
Impact: Clinicians could lose timely record access and revert to a weak paper workflow, repeating or exceeding the documented nine-hour outage while reconciliation and recovery delay care.
Existing Control: C-017–C-021 protect covered workstations, C-022/C-023 provide local backups and RAID, and C-043 supplies a paper fallback; no full EHR recovery exercise or independent recovery copy is evidenced.
Gap: GAP-007 — production and recovery share a failure domain; GAP-016 — weak segmentation increases the potential ransomware blast radius.
```

### EHR-D2 — Internal Requests Exhaust the Application or Database

```text
Category: D
Threat ID: EHR-D2
Description: A compromised internal system could create excessive sessions, expensive database queries or repeated requests against ports 443, 8080 or 5432 until legitimate clinical users experience severe delay or service failure.
Attack Vector: Open Service Ports and Unsecure Networks (T8) — EHR services are broadly discoverable from internal scan positions and PostgreSQL is not limited to validated application sources.
Impact: Slow or unavailable EHR access can delay medication review, results retrieval and documentation, forcing manual work and increasing the risk of incomplete or inconsistent clinical information.
Existing Control: C-003 denies unmatched perimeter traffic, C-004 keeps limited firewall logs and C-035 retains local Linux logs; no internal rate limit, database connection control or automated availability alert is evidenced.
Gap: GAP-006 — unnecessary database reachability remains; GAP-016 — internal least-privilege boundaries are unverified.
```

## Elevation of Privilege (E)

### EHR-E1 — Application-Server Compromise Gains Database Capability

```text
Category: E
Threat ID: EHR-E1
Description: An attacker who gains code execution under the EHR application context on ehr-srv-01 could obtain an application-held connection secret or service identity and convert limited host access into read or write capability on ehr-db-01.
Attack Vector: Vulnerable Software and Open Service Ports (T8) — a usable flaw on application ports 443/8080 could create the initial application context, followed by the documented database dependency; exploitability is not confirmed.
Impact: The attacker could move from one application process to Restricted patient data, enabling record theft, tampering or database disruption beyond the initial server foothold.
Existing Control: C-005–C-010 harden the SSH route to ehr-srv-01, C-011/C-035 retain local host evidence and C-022 backs up both servers; those controls do not establish least-privilege database service credentials.
Gap: GAP-006 — approved database clients and accounts are not narrowly enforced; GAP-016 — the application-to-database trust boundary lacks verified least privilege.
```

### EHR-E2 — Vendor Maintenance Access Exceeds Its Intended Scope

```text
Category: E
Threat ID: EHR-E2
Description: A compromised or malicious MedTech operator could use legitimate maintenance access to obtain application secrets, privileged commands or database functions beyond the minimum tasks authorized by the support relationship.
Attack Vector: Open Service Ports and Unsecure Networks (T8) combined with supply-chain access — the vendor's exact transport, account privileges, approval process and reachable destinations are not documented.
Impact: A trusted maintenance identity could become an application administrator or database-capable actor, enabling stealthy record collection, code changes or EHR disruption with activity resembling normal support.
Existing Control: C-005–C-011 restrict and log ehr-srv-01 SSH if that is the route, while C-054/C-055 establish maintenance and update obligations; none proves vendor MFA, time-limited approval, session recording or database privilege restriction.
Gap: GAP-011 — strong individual identity and MFA are not organization-wide; GAP-016 — third-party and internal privilege boundaries remain unverified.
```

## STRIDE Summary for EHR

**Tampering represents the greatest EHR risk** because an integrity failure can remain less visible than an outage while directly changing the information clinicians trust for diagnosis, medication and treatment. MedDefense's broadly reachable PostgreSQL service, unverified application-to-database trust, conditional vendor update path, delayed EHR audit access and local-only recovery evidence create multiple opportunities for altered data or code to look legitimate long enough to influence care. Information disclosure and denial of service are also Critical, but staff can recognize many outages and invoke limited paper procedures, whereas a functioning EHR that silently presents false allergies, results or treatment information can propagate unsafe decisions across users and into backups before anyone knows recovery is necessary. In healthcare, that combination of apparent availability and corrupted clinical truth makes Tampering particularly dangerous.
