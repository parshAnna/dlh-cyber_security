# MedDefense Health Systems — Technical Vector Assessment

Prepared for: James Chen, Deputy CISO

Prepared by: Junior Security Analyst

Scope: Technical, non-human attack vectors identified from supplied artifacts; no live testing, credential use or exploitation performed.

## Evidence Basis and Assessment Rules

This assessment uses the First Watch [Asset Registry](../1x00_first_watch/7-asset_registry.md), [Criticality Assessment](../1x00_first_watch/8-criticality_assessment.md), [Data Map](../1x00_first_watch/9-data_map.md), [Complete Control Matrix](../1x00_first_watch/10-complete_control_matrix.md), [Gap Analysis](../1x00_first_watch/12-gap_analysis.md) and [Predecessor Review](../1x00_first_watch/15-predecessor_review.md). Network observations are source **S** in the Asset Registry. Actor selections come from the [T6 Threat Actor Matrix](6-threat_actor_matrix.md).

An open port establishes a reachable listener from the scan position, not successful access. A reported version establishes a validation lead, not automatic exploitability. Shared credentials are confirmed where stated; factory-default credentials on MedDefense medical devices remain unverified and are not presented as a proven condition.

## 1. Vulnerable Software

```text
Vector Category: Vulnerable Software
MedDefense Evidence: billing-srv-01 A-039/A-123 runs Ubuntu 18.04.6 LTS and exposes Apache/MySQL on ports 80/3306. Apache 2.4.29 is reported in Marcus's billing diagnostics, and source S reports inactive Ubuntu ESM; this task identifies Ubuntu 18.04 LTS as EOL, but installed package support and exploitability still require validation. MON-VITALS-3F-01 A-068 has firmware v2.1.3 last updated in 2019, while BD Alaris A-061–A-067 reports firmware 12.1.2 and an unidentified vendor bulletin/CVE claim.
Affected Asset(s): billing-srv-01 A-039, billing application A-123, MySQL data store A-113, MON-VITALS-3F-01 A-068 and the BD Alaris pump fleet A-061–A-067. Flat connectivity also places adjacent AD, EHR, PACS and backup services within post-compromise discovery range.
Actor Most Likely to Exploit: Unskilled/Opportunistic Attacker. T6 rates opportunistic exposure High and links automated known-flaw exploitation to the miner already observed on billing-srv-01, without claiming the original entry vector is known.
Exploitation Scenario: An opportunistic attacker scans a reachable web service and tests a public exploit matching an installed software build. If code execution succeeds on billing-srv-01, the attacker can deploy a miner or resell the foothold and then enumerate the flat network; available evidence does not prove Apache was the existing miner's entry path.
Current Protection: C-003 supplies perimeter denial where traffic crosses the FortiGate; C-035/C-036 retain local Linux and Apache logs; C-022 backs up billing-srv-01. C-047/C-048 provide only weak restart and ad-hoc response, and Sophos C-017–C-021 does not cover Linux servers or medical devices.
Gap Reference: GAP-008 — billing mining activity is treated as a capacity problem; GAP-015 — public-facing vulnerability remediation lacks verified ownership and closure. GAP-001/GAP-018 separately capture missing pump-specific protection and unverified device credentials.
```

## 2. Unsupported Systems

```text
Vector Category: Unsupported Systems
MedDefense Evidence: MRI controller WS-RAD-01 A-016 runs Windows XP Embedded according to the MRI scenario and fingerprints as XP SP3 in source S; it exposes ports 135/139/445 at 10.10.1.70 on the general workstation network. print-srv-01 A-043 is reported as Windows Server 2012 or 2012 R2 and exposes 135/139/445/9100 at 10.10.2.31; the exact edition discrepancy does not change that it is an active legacy system requiring support-state validation.
Affected Asset(s): WS-RAD-01 A-016, Siemens MAGNETOM MRI A-091 and its PACS dependency A-038; print-srv-01 A-043 and any sensitive print jobs or clients using it. The shared network increases exposure for neighboring clinical and administrative systems after either host is compromised.
Actor Most Likely to Exploit: Ransomware Groups (Organized Crime). T6 ranks ransomware first because affiliates combine purchased access or exposed-service exploitation with lateral movement toward clinical systems and recovery infrastructure.
Exploitation Scenario: A ransomware affiliate with an existing VPN, web or workstation foothold discovers the legacy SMB/RPC listeners and tests techniques that remain effective against unsupported operating systems. Compromise of the MRI controller could interrupt approximately 45 studies per day, while compromise of the print server could expose spool content or provide another lateral-movement position.
Current Protection: C-003 is indirect perimeter protection; C-013–C-015 provide general Windows account policy and C-034 provides weak local event logging. Sophos excludes Windows servers, print-srv-01 is outside C-022 backup scope, and no deployed MRI-specific isolation, monitoring or recovery control is evidenced.
Gap Reference: GAP-005 — legacy MRI controller remains on the general workstation network; GAP-023 — legacy print server lacks verified supported maintenance and containment.
```

## 3. Open Service Ports

```text
Vector Category: Open Service Ports
MedDefense Evidence: ehr-db-01 A-037/A-112 exposes PostgreSQL 5432 and SSH 22; billing-srv-01 A-039/A-113 exposes MySQL 3306, HTTP 80 and SSH 22. RDP 3389 appears on reception workstations A-001/A-002, administrative workstations A-011–A-013 and ws-srv-01 A-075. Medical interfaces include monitors on 80/443/2575, pumps on 80/443, nurse-call systems on 80/5060, badge readers on 80/443 and PACS on 4242/11112; source S reports broad reachability from the HQ scan position.
Affected Asset(s): EHR database A-037/A-112, billing server/data A-039/A-113, selected workstations and ws-srv-01, PACS A-038, monitors A-048–A-060, pumps A-061–A-067, nurse-call A-069/A-070 and badge readers A-071–A-073.
Actor Most Likely to Exploit: Ransomware Groups (Organized Crime). T6 identifies weak boundaries and reachable clinical services as the most consequential follow-on path after an affiliate gains initial access.
Exploitation Scenario: After compromising a VPN account, portal or workstation, an affiliate enumerates 5432, 3306, 3389 and device web interfaces to identify reachable services and authentication targets. A successful login or service exploit could expose Restricted records, support lateral movement or disrupt medical and physical-access functions, although an open port alone does not establish permission or compromise.
Current Protection: C-002 scopes VPN objects but permits ALL services to the server subnet; C-003 denies unmatched boundary traffic; C-004 supplies limited firewall logs. C-013–C-021 protect covered Windows identities/endpoints, while C-035–C-037 provide weak local or delayed server/application logging.
Gap Reference: GAP-006 — EHR database reachability is broader than documented need; GAP-016 — public-service and intersite boundaries lack verified least privilege. GAP-001 and GAP-018 address the distinct medical-device detection/recovery and credential exposures.
```

## 4. Default Credentials

```text
Vector Category: Default Credentials
MedDefense Evidence: C-052 confirms a shared PACS workstation account, but does not establish that the password is a vendor default. BD Alaris pump interfaces A-061–A-067 are reachable on 80/443, while GAP-018 explicitly records their management credential baseline as unverified rather than confirmed default. C-053 also records a username/password sheet beside an unlocked switch stack, creating exposed shared administrative material even though validity and mapping to the core switch are unverified.
Affected Asset(s): Radiology PACS sessions and pacs-srv-01 A-038, BD Alaris pumps A-061–A-067, the observed switch stack and systems reachable through any resulting network-management access.
Actor Most Likely to Exploit: Insider (Malicious). T6 identifies valid-account and privilege abuse as this actor's preferred vector, and shared credentials reduce both the effort required and reliable attribution; an external ransomware operator becomes a secondary risk after obtaining internal access.
Exploitation Scenario: A malicious insider uses the shared PACS identity to view or copy imaging information while actions remain difficult to attribute to one person. An attacker already inside the network could also test documented vendor defaults against pump web interfaces or use exposed switch credentials, but success must remain conditional until MedDefense validates those credentials safely.
Current Protection: C-016 requires shared-password changes after departures but has no compliance evidence; C-013–C-015 cover Windows password policy generally; C-041 provides MFA only for James's unspecified personal account. C-052/C-053 are weak credential gates, not effective individual accountability controls.
Gap Reference: GAP-011 — shared identities and limited MFA weaken clinical accountability; GAP-018 — medical-device management credential baseline is unverified. GAP-004 also covers missing core-switch management and recovery evidence.
```

## 5. Unsecure Networks

```text
Vector Category: Unsecure Networks
MedDefense Evidence: First Watch reports a flat 10.10.0.0/16 Central network with no VLANs; source S states the 10.10.1.0/24 workstation, 10.10.2.0/24 server and 10.10.3.0/24 medical-device groups share a physical network without firewall separation. C-002 permits ALL services from Westside/HQ VPN objects to the Central server subnet. Westside uses consumer Netgear router A-074 with no dedicated firewall documented, and Central guest Wi-Fi has a separate SSID but unverified isolation under C-040.
Affected Asset(s): All Central user, server and medical-device groups; Westside systems A-074–A-080; HQ endpoints and VPN dependency A-081–A-085/A-110; Top 5 assets including ehr-db-01, the core switch, pump fleet and PACS.
Actor Most Likely to Exploit: Ransomware Groups (Organized Crime). T6 ranks ransomware first and specifically connects permissive VPN/internal paths to discovery, lateral movement, data theft and attacks on recovery infrastructure.
Exploitation Scenario: An affiliate enters through a stolen VPN identity, public service or infected endpoint and uses broad reachability to enumerate AD, clinical databases, PACS, IoT and NAS management. Because segmentation is absent or unverified, each additional credential or exploit can expand the blast radius from one system to multiple sites and patient-care dependencies.
Current Protection: C-002 provides weak address-level VPN scoping, C-003 supplies catch-all perimeter denial and C-004 keeps limited local firewall logs. C-045 protects Westside tunnel traffic with IPSec, while C-040 documents a guest SSID but not effective isolation; encryption in transit does not enforce least-privilege destinations.
Gap Reference: GAP-016 — public-service and intersite trust boundaries lack verified least-privilege enforcement; GAP-021 — HQ landlord-managed network lacks documented responsibility and assurance. GAP-012 is relevant where unmanaged hosts connect to these broad paths.
```

## 6. Removable Devices / Unmanaged Endpoints

```text
Vector Category: Removable Devices / Unmanaged Endpoints
MedDefense Evidence: The predecessor review records Marcus's allegation of unrestricted USB/no DLP as consistent with incomplete evidence and creates GAP-020 for validation rather than claiming every endpoint is unrestricted. Approximately 25 physician iPads have no evidenced MDM/EMM and are excluded from Sophos. Shadow and unmanaged assets include intern laptop A-095, personal NAS A-124, personal-account Google Drive A-125, Raspberry Pi A-126, UNKNOWN-01 A-047 and Westside device A-080.
Affected Asset(s): Clinical and administrative endpoints, EHR/PACS data accessible during authorized sessions, HR/business repositories, internal network services and any data copied to personal storage or removable media.
Actor Most Likely to Exploit: Insider (Negligent). T6 ranks this actor second and identifies shadow IT, credential/data mishandling and convenience-driven shortcuts as preferred vectors with potentially Critical clinical consequences.
Exploitation Scenario: A well-intentioned employee copies patient or business information to USB, a personal cloud account or an unmanaged device to continue work outside an approved workflow. Malware or weak sharing settings on that endpoint can then expose the data or create an internal foothold, while the flat network increases the systems visible after connection.
Current Protection: C-017–C-021 protect reported managed Windows workstations but exclude mobile devices and do not establish USB/DLP enforcement; C-032/C-033 provide incomplete awareness training and tracking. C-056 detected two unknown systems in a one-time scan, but continuous inventory or managed-device admission is not evidenced.
Gap Reference: GAP-020 — removable-media and outbound-sharing restrictions lack verified data controls; GAP-012 — undocumented internal devices lack ownership and access review. GAP-014 contributes through incomplete role-specific training.
```

## Assessment Conclusion

The six vectors reinforce one another rather than operating independently. Vulnerable or unsupported software and reachable services create footholds; shared credentials and unmanaged devices reduce the effort needed to use them; and the flat network allows a local failure to threaten clinical databases, imaging, medical devices and backups. Across the T6 actor priorities, ransomware groups present the strongest technical exploitation chain, opportunistic attackers are most likely to test exposed known flaws at scale, and negligent insiders are the clearest source of unmanaged-device and removable-media exposure.
