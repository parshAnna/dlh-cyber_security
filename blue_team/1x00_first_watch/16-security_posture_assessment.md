# MedDefense Health Systems — Security Posture Assessment

Prepared for: Board of Directors and James Chen, Deputy CISO  
Prepared by: Junior Security Analyst  
Assessment basis: Supplied project evidence; proposed actions have not been implemented.

## 1. Executive Summary

MedDefense has basic security protections, but they do not provide dependable protection or recovery for several services essential to patient care. Past events have exposed patients’ laboratory results, displayed incorrect medication doses across three sites, interrupted electronic records for nine hours and stopped insurance claims for four days. Current billing diagnostics also show a program configured to mine cryptocurrency consuming substantial processing capacity; repeated restarts have not demonstrated removal of the cause.

**The single most critical finding is the absence of evidenced device-specific detection and recovery for the network-connected infusion-pump fleet.** These devices deliver treatment, yet their configuration backups are explicitly excluded and their network access is not adequately separated from general computing. This creates a potential patient-safety exposure; the assessment does not claim that any pump has been attacked or that a network outage necessarily stops infusion.

**Three recommended actions:**

1. Protect treatment and diagnostic workflows: validate pump and MRI network boundaries, establish pharmacy change/rollback checks, and make imaging records recoverable (GAP-001/002/003/005).
2. Protect shared clinical access: narrow access to the patient-record database and verify recovery of the central network configuration (GAP-004/006).
3. Establish independently protected recovery copies and prove that priority services can be restored after loss of the main server room or a destructive attack (GAP-007).

**Budget:** Allocate $110,000 to these seven work packages and retain $10,000 contingency within the $120,000 annual ceiling, subject to supplier pricing and availability of approximately 62 internal staff-days.

The Board should authorize this staged plan, assign clinical and IT owners, and require evidence of successful access and recovery tests before risks are marked reduced. Billing incident triage must begin promptly alongside the program; its full remediation cost is not silently included. The inventory and several controls remain incompletely validated, so the findings support prioritized action rather than a certification of compliance or a guarantee of safety.

## 2. Scope and Methodology

### Scope and sources

The review covers MedDefense Central (350-bed acute care hospital), Westside Clinic (outpatient services) and Corporate HQ (administration/IT), together with documented cloud services. It includes clinical applications and data, endpoints, medical devices, networking, identity, recovery infrastructure and physical security. It evaluates organizational consequences, existing control coverage and feasible treatment; no new scanning, exploitation or live configuration changes were performed by the author.

| Evidence reference | Source and use |
|---|---|
| [Task 0](0-environment_summary.md), O | Onboarding documents: organization, partial inventory, draft topology, Marcus’s notes and contracts. |
| [Task 1](1-incident_classification.md), I | Six incidents: ransomware, portal disclosure, dosage corruption, defacement, EHR outage and personal-laptop exposure. |
| D, linked in [Task 7](7-asset_registry.md) | Supplied billing diagnostics, ticket #4471; host/process/network details, with initial access unproven. |
| [Task 3](3-physical_assessment.md), W | Supplied physical observations; access weaknesses and monitor details. |
| [Task 4](4-control_inventory.md), C | Eight source artifacts: firewall, SSH, password policy, antivirus, backup, physical contracts, training and logging. |
| M, cited in [Task 7](7-asset_registry.md) | Supplied advanced MRI scenario: operating constraints, approximately 45 studies/day and mandatory PACS connectivity. |
| S, linked in [Task 7](7-asset_registry.md) | Sarah’s existing network scan summary; explicit host responses and undocumented devices. |
| [Tasks 7](7-asset_registry.md), [8](8-criticality_assessment.md), [10](10-complete_control_matrix.md), [12](12-gap_analysis.md), [14](14-risk_decisions.md) | Consolidated inventory, CIA criticality, control effectiveness, prioritized gaps and proposed budget. |

Assets were reconciled by names, addresses and functions. Each category's overall criticality is the highest CIA rating, not an average. Controls retain stable C-identifiers; gaps retain GAP-identifiers. Gap prioritization follows Task 12's explicit interpretation: Critical where a Critical asset/Restricted data has at least one relevant Detective or Corrective function absent from the evidence; Weak controls remain present rather than being relabeled absent. Evidence-only absence produces provisional judgments. High and Medium judgments account for sensitivity, coverage and meaningful partial protection.

### Limitations and assumptions

- Source dates are relative, inventory exports incomplete and OS fingerprints not authoritative installed-version checks. Formal owners, data volumes, exact permissions and recovery objectives are often unknown.
- Separate Task 9 Data Map, Task 11 investigation and Task 13 threat-validation updates were not supplied. Data classifications are provisional; unknown-device findings derive from S/Incident F; priorities use Task 12 without invented Task 13 changes.
- Site staffing sums to approximately 1,800 versus the stated organization-wide approximately 2,000. The Central /24 scan grouping reports more devices than a literal /24 can accommodate. Room location, DMZ separation, MRI vendor/OS details and Sophos counts conflict across sources. These are explicitly reconciled in Task 7, not silently resolved.
- A scan response proves reported activity, not health or authorization; no response proves neither retirement nor absence. Documented recovery and contracts do not establish tested full-service restoration. Proposed controls are not counted as deployed.
- No actual patient injury, record-count total, penalty amount or successful exfiltration beyond documented disclosure is invented. This is a security assessment, not a formal legal compliance determination.

## 3. Asset Landscape

### Inventory totals by type and site

The registry contains **123 records**, including **85 explicitly identified scan responses**. The following counts cover registry records, not unique physical machines: applications and data stores can share a server, and some rows represent platforms. Approximately described fleets are recorded separately in Task 7 and excluded from these totals to prevent fabricated per-device counts.

| Asset type | Central | Westside | HQ | Cloud/external | Unresolved/shared | Total |
|---|---:|---:|---:|---:|---:|---:|
| Server | 10 | 1 | 0 | 0 | 0 | 11 |
| Endpoint | 24 | 5 | 5 | 0 | 3 | 37 |
| Network Device | 14 | 2 | 1 | 0 | 0 | 17 |
| IoT Medical | 25 | 0 | 0 | 0 | 0 | 25 |
| Data Store | 4 | 0 | 0 | 0 | 3 | 7 |
| Application | 4 | 0 | 0 | 3 | 4 | 11 |
| Physical Infrastructure | 12 | 2 | 1 | 0 | 0 | 15 |
| **Total registry records** | 93 | 10 | 7 | 3 | 10 | 123 |

Site grouping follows recorded location: clearly Central/Westside/HQ entries go to that site; identified cloud/third-party hosting goes to Cloud/external; mixed, unspecified or unmapped hosting goes to Unresolved/shared. For example, a service used at all three sites is not counted three times. Remaining named-but-location-uncertain endpoints stay unresolved. Physical infrastructure includes non-IP rooms, doors and analog cameras that are not expected to respond to a network scan.

### Five highest-ranked clinical dependencies

| Rank | Asset / registry reference | Business justification |
|---|---|---|
| 1 | ehr-db-01 — A-037/A-112 | Provides the EHR's clinical record store; record loss or corruption affects decisions and access. The nine-hour EHR outage demonstrates reliance on the service. |
| 2 | Pharmacy management — A-093 | Dosage information serves all three sites; a six-hour data error was detected by a pharmacist using a printed reference. Incorrect information can be dangerous even when the application stays online. |
| 3 | Central Cisco core switch — A-087 | Shared connectivity supports several clinical systems and access to Central resources. Exact redundancy and recovery arrangements remain unverified. |
| 4 | BD Alaris pump fleet — A-061–A-067 plus aggregate entries | Treatment-delivery integrity and continuity directly affect bedside safety. This is an operational fleet, not a claim that one pump is always more important than another. |
| 5 | pacs-srv-01 — A-038 | Supports imaging access and required MRI study transfer; MRI handles approximately 45 studies/day, and PACS is explicitly not backed up. |

This ordering reproduces Task 8 and reflects dependency breadth as well as patient safety. GAP-001 is the single most critical finding because it combines the pump fleet's clinical importance with missing device-specific detection/recovery; an asset rank and a gap priority need not be identical. NAS-01 remains a Critical recovery dependency and may become the first operational priority during recovery. Billing's active concern demands triage despite its lower intrinsic High criticality.

### Data classification summary

| Classification | MedDefense context | Protection implications / evidence limit |
|---|---|---|
| Public | Intentionally published homepage content; Incident D says the website contains no patient data | Confidentiality of published text is Low, but integrity and service trust still matter. Do not extend this classification to the patient portal. |
| Internal | Routine non-sensitive internal guidance, where its contents justify this level | Proposed classification requiring document review; security notes containing credentials or sensitive architecture require higher handling. |
| Confidential | HR, departmental, scheduling and claims records at minimum | Actual fields and hosting are incomplete; patient-specific health information requires Restricted treatment. |
| Restricted | EHR/lab results, patient-linked imaging, privileged credentials and mixed clinical backups; safety-critical dosage/configuration data provisionally included | Protect all three data states. Backups inherit source sensitivity; unsupported encryption claims and exact field counts are not assumed. |

Task 12's provisional P1–P6 crosswalk supplies the detailed data-to-gap connection. At-rest, in-transit and in-use exposure is considered, but encryption, cloud retention and complete flow maps remain unverified.

## 4. Current Security Controls

### Control counts

| Control category | Preventive | Detective | Corrective | Compensating | Deterrent | Total |
|---|---:|---:|---:|---:|---:|---:|
| Technical | 22 | 9 | 4 | 0 | 0 | 35 |
| Administrative | 4 | 6 | 3 | 0 | 0 | 13 |
| Physical | 4 | 3 | 0 | 0 | 1 | 8 |
| **Total** | 30 | 18 | 7 | 0 | 1 | 56 |

The **56 control records** comprise **31 Adequate and 25 Weak**, with none evidenced to meet the full Strong definition of correct configuration, appropriate scope and active maintenance. Related mechanisms of the same product are counted separately by function, not as independent products. No deployed compensating program is demonstrated by the MRI assignment's request to design one. [Task 10]

### Maturity and effectiveness

MedDefense's posture is **reactive and uneven**, an evidence-based description rather than a scored maturity certification. Relative strengths are scoped inbound filtering, host-specific SSH restrictions, actual workstation blocking/quarantine, documented entrance recording and training-completion tracking. These provide a foundation but do not establish comprehensive protection.

- **Narrow hardening:** C-005–C-011 apply to ehr-srv-01; they must not be credited to ehr-db-01 or all Linux servers. Other Linux SSH password access remains (C-051). Organizational MFA is not established by James's personal-account setup (C-041).
- **Protection gaps:** Sophos demonstrates workstation actions, but Windows servers, Linux servers and mobile devices are outside the stated protection scope. The 387/372/15 reporting inconsistency must be reconciled before using coverage percentages for management targets. [C A4; C-017–C-021]
- **Weak detection:** Local logs exist, but collection is not centralized, security alerts are not automated, and EHR exports take 48 hours. No log-integrity protection is documented. [C A8; C-004/C-034–C-038]
- **Unproven recovery:** Local backups exclude PACS and medical configurations; a partial file-server restore took six hours eight months earlier. RAID and the secondary domain controller provide limited resilience, not recoverable offsite copies. [C A5; C-022–C-024/C-050]
- **Physical and human weaknesses:** Generic server-room badges, uncovered IT areas, an open restricted-area door and Westside's 58% training completion limit otherwise existing controls. [W; C A6/A7; C-025–C-033/C-039/C-046]

All five highest-ranked assets are Under-Protected in Task 10: each has material gaps, though their individual weaknesses differ. A higher count of general perimeter or training controls does not compensate for absent clinical recovery.

## 5. Gap Analysis

Each row retains the detailed evidence and assumptions in [Task 12](12-gap_analysis.md); current control IDs below make the assessment traceable. Treatments for GAP-001–007 are funded planning packages in Task 14. GAP-008–014 actions are additional scoped recommendations, not silently included as fully funded programs.

### Critical findings

| Gap / description | Affected assets | Existing coverage and potential impact | Recommended treatment |
|---|---|---|---|
| GAP-001 — Infusion pumps lack device-specific detection and recovery | BD Alaris fleet A-061–A-067 and aggregate entries — Critical (T8 G5) | C-003 perimeter denial and C-025 entrance checks are indirect only. T10 documents no pump-specific detection; medical-device configuration backups are explicitly excluded from C-022. Unauthorized changes could undermine infusion safety or interrupt treatment. Network reachability alone does not prove remote dose modification or that disconnection stops local pumping; validate device behavior with biomedical staff. | GAP-001: Mitigate with clinically validated pump zoning, passive/device monitoring and vendor-supported configuration recovery; $22,000, 6–10 weeks. |
| GAP-002 — Pharmacy dosage changes lack validated recovery and systematic checking | Pharmacy management system A-093 — Critical (T8 G1) | C-044 pharmacist/printed-reference comparison detected the six-hour error but is Weak. No application-specific recovery control is mapped; host identity and backup scope remain unknown. Another faulty update could present incorrect doses across three sites until a pharmacist notices, potentially influencing unsafe medication decisions. No actual patient injury is established by Incident C. | GAP-002: Mitigate through pharmacy-approved change validation, comparison checks and tested rollback after host identification; $8,000, 3–4 weeks. |
| GAP-003 — PACS imaging has no documented recovery copy | pacs-srv-01 A-038 — Critical (T8 G2) | C-034/C-038 provide Weak local Windows logging and reactive review; C-039 server-room badge access is Weak. PACS is explicitly excluded from C-022; no alternate recovery mechanism evidenced. Storage loss or ransomware could remove access to imaging used in diagnosis. MRI must transmit studies to PACS and processes approximately 45 studies/day; recovery delays could postpone care or require alternative imaging arrangements that are not documented. | GAP-003: Mitigate through PACS-aware backup/capture, protected copies and representative restore testing; $24,000, 6–8 weeks, dependent on GAP-007. |
| GAP-004 — Central core-switch configuration and failover protection are unverified | Cisco core switch A-087 — Critical (T8 G4) | C-003/C-004 are indirect perimeter controls. T10 cannot map C-053 exposed switch-stack credentials to the core; no core-specific audit, configuration backup or failover evidence exists. Destructive switch configuration or hardware failure could interrupt access to multiple clinical services at Central and the Central resources used by remote sites. The presence or absence of a redundant core must be verified. | GAP-004: Mitigate by validating topology, protecting configurations, reviewing management events and verifying spare/recovery arrangements; $15,000, 3–4 weeks subject to delivery. |
| GAP-005 — Legacy MRI controller remains on the general workstation network | WS-RAD-01 A-016 and MRI scanner A-091 — Critical (T8 G2) | M reports required PACS connectivity and shared workstation VLAN; S shows XP fingerprint. No deployed compensating barrier, controller-specific detection or device recovery is evidenced. C-022 excludes medical-device configurations; C-034 Windows-server logs do not establish controller logging. Compromise could interrupt approximately 45 MRI studies per day or undermine study/control integrity, with potential delay to diagnosis. XP Embedded versus XP SP3 and vendor identity remain unresolved; no specific CVE is assumed. | GAP-005: Mitigate using external MRI isolation allowing validated PACS flows, passive monitoring and vendor-approved recovery/access procedures; $12,000, 3–4 weeks subject to clinical approval. |
### High findings

| Gap / description | Affected assets | Existing coverage and potential impact | Recommended treatment |
|---|---|---|---|
| GAP-006 — EHR database access is broader than the documented application need | ehr-db-01 A-037/A-112 and EHR application A-036/A-111 — Critical (T8 G1) | C-051 password SSH is Weak on the database; C-035 local logs, C-037 delayed EHR audit exports and C-022 local backups exist but are Weak. C-005–C-011 harden only ehr-srv-01. O/S report broad PostgreSQL reachability. An attacker who also defeats database authentication could access or alter clinical records; database interruption could again force paper workflows, as during the documented nine-hour EHR outage. | GAP-006: Mitigate using approved-source PostgreSQL access, account review and timely audit handling; $6,000, conditional initial restriction within one week. |
| GAP-007 — Production and recovery copies share a failure domain | NAS-01 A-045, backup-srv-01 A-044 and Veeam A-118 — Critical at recovery-service level (T8 G8); backed-up EHR Critical | C-022 local 14-day backups exist; C-023 RAID5 addresses limited disk failure only. C-024 is a Weak file-server-only partial test. C-039 physical access is Weak; no offsite copy exists. Logging on Linux backup-srv-01 does not prove NAS audit coverage. A room disaster or compromise reaching both production and repository could leave EHR and billing without usable recovery copies. The six-hour partial file-server restore is not a demonstrated EHR recovery time. | GAP-007: Mitigate with one shared isolated/offsite recovery service, separate credentials and workload restore exercises; $23,000, 6–8 weeks. |
| GAP-008 — Billing mining activity is treated as a capacity problem | billing-srv-01 A-039; billing application/data A-123/A-113 — High (T8 G3) | D documents mining-configured executable, CPU saturation and outbound connections. C-047 restarts and C-048 ad-hoc response are Weak; C-035/C-036 local logs and C-022 backups exist. C-017–C-019 do not cover Linux servers. Persistent resource consumption could delay claims and revenue processing, as the prior ransomware incident stopped claims for four days. Initial access and data theft remain unproven; preserve those distinctions during response. | GAP-008: Mitigate through immediate evidence-preserving incident triage, clinically coordinated containment and validated eradication/rebuild; price external response separately before commitment. |
| GAP-009 — Patient portal object-level authorization lacks closure evidence | web-srv-01 A-046 and patient portal A-114 — Critical overall (T8 G10, driven by confidentiality) | I B confirms cross-patient access by URL modification; remediation status unknown. C-001 perimeter filtering exists; C-036 Apache logs and C-022 backups are Weak. C-042 demonstrates homepage restoration only, not authorization repair. Authenticated patients could again view other patients’ lab results if the defect persists, exposing sensitive information and damaging confidence in the portal. Current persistence requires validation. | GAP-009: Mitigate by confirming closure of the portal defect, enforcing patient-specific object authorization and testing cross-patient access denial; scope vendor work before funding. |
| GAP-010 — Generic server-room access exposes critical hosted systems | Central server room A-098 — Critical (T8 G9); hosted EHR A-036/A-037 and PACS A-038 — Critical | C-039 grants every employee access. C-025–C-029 cover entrances rather than the server-room door; no room camera or visitor log. EHR local logs/backups exist, while PACS recovery exclusion is separately GAP-003. Electronic badge-log existence is unknown. A badge holder could remove media or interfere with hosted servers, exposing records or interrupting care systems. Encryption status, precise room location and the range of accessible equipment require confirmation. | GAP-010: Mitigate by restricting room entry by role and establishing visitor/access review and suitable door-area monitoring; validate room location and price facilities work separately. |
| GAP-011 — Shared identities and limited MFA weaken clinical accountability | PACS workstation identity unresolved (G2 scope Critical); ehr-db-01 A-037 Critical; other clinical endpoints G6 Critical for integrity | C-012/C-016 policy is Weak; C-052 shared PACS account and C-051 password SSH remain. C-013–C-015 Windows rules and C-034/C-035 logs exist; C-041 MFA applies only to James’s unspecified personal account. No organization-wide MFA mandate. Stolen or shared accounts could enable unauthorized record access or changes and prevent identification of the responsible user. Exact workstation-to-server privileges remain unverified; do not assume all users can edit clinical data. | GAP-011: Mitigate using individual accounts, supported MFA/access paths and departure/privilege review; validate legacy constraints before replacing shared access. |
| GAP-012 — Undocumented internal devices lack ownership and access review | UNKNOWN-01 A-047, Westside device A-080, personal laptop A-095 — individual criticality unresolved within T8 G7 High group; exposed HR share A-094 High and reachable server zone containing Critical assets | C-056 discovery is Weak but found both unknown IPs; C-040 guest isolation is unverified. C-002 allows broad VPN services; C-004 logs are local. I F places the personal laptop in the HR-share segment, but no unauthorized file access is proven. An unmanaged host could provide an unmonitored access path to internal systems if additional access controls fail. Port 3000 does not identify a particular product; A-080 is not confirmed as the rumored second Westside server. Validate before operational changes. | GAP-012: Mitigate by identifying owners and purpose of both unknown hosts, validating network permissions and introducing managed-device admission; do not disconnect unknown clinical dependencies blindly. |
| GAP-013 — Departmental cloud and file data lack validated recovery scope | O365 A-115, HR share A-094, ws-srv-01 A-075 and file-srv-01 A-042 — High (T8 G7) | C-022 covers file-srv-01 but explicitly excludes O365 and ws-srv-01. C-024 tested only part of file-srv-01 eight months ago. HR-share host mapping is unresolved; C-034 local Windows logs and GPO policy exist, without proof of cloud settings. Deletion or ransomware could disrupt Westside scheduling or destroy departmental/HR records with no demonstrated recovery route for those locations; payroll and legal impacts depend on actual stored datasets, which remain unverified. | GAP-013: Mitigate by mapping HR/cloud/Westside datasets and adding appropriate recovery scope with restore validation; additional capacity is not assumed included in the seven-package budget. |

### Medium findings and distribution

**GAP-014 — incomplete security training:** Central completion is 71% and Westside 58%, versus HQ 94%; role-specific and digital patient-information content is absent. The existing program, tracking and covered-workstation controls reduce some exposure, supporting Medium for this specific training gap rather than lowering the sensitivity of clinical data. Enforce completion, assign departmental follow-up and introduce targeted content. [C-032/C-033; C A7]

| Priority | Count |
|---|---:|
| Critical | 5 |
| High | 8 |
| Medium | 1 |
| Low | 0 |
| Total | 14 |

Imaging has three primary gaps; EHR/medication and administrative/business services have two each; the other seven Task 8 groups each have one. All 14 gaps include an Administrative improvement, 12 include Technical improvements and one directly identifies Physical improvements. Detective needs appear in 14, Preventive in 12, Corrective in nine and Compensating in two. These overlapping counts reflect cross-cutting needs, not separate incidents or additive loss amounts. Limited physical-gap count does not minimize the consequences of broad server-room access. [Task 12 distribution tags]

Critical ratings for undocumented core/pharmacy recovery remain provisional pending evidence. Existing Weak logging or backup is acknowledged; it is not treated as nonexistent merely to increase severity. Restricted classification assumptions and the inclusive “missing Detective or Corrective” rule are stated in Task 12 for review.

## 6. Risk Treatment Recommendations

### Seven priority packages

All seven primary decisions are **Mitigate**: eliminating these clinical services is not feasible, insurance does not prevent unsafe treatment or restore services, and unbounded acceptance lacks a defensible loss/cost basis. No financial transfer or management risk acceptance is claimed to have occurred. [Task 14]

| Gap | Strategy and funded scope | First-year estimate | Timeline | Delivery/acceptance responsibility proposed |
|---|---|---:|---|---|
| GAP-001 | Mitigate: pump zoning, monitoring integration and supported recovery validation | $22,000 | 6–10 weeks | IT + biomedical + nursing; validate required flows and device-safe recovery |
| GAP-002 | Mitigate: pharmacy validation, change approval and rollback | $8,000 | 3–4 weeks after host/vendor identification | Pharmacy + application owner; approve dosage checks and rollback test |
| GAP-003 | Mitigate: PACS-specific capture/restore capacity and vendor integration | $24,000 | 6–8 weeks; depends on shared recovery service | Radiology + IT/vendor; restore studies and index consistently |
| GAP-004 | Mitigate: core management/logging, configuration backups and spare/recovery path | $15,000 | 3–4 weeks, delivery-dependent | IT network team; verify topology and configuration recovery |
| GAP-005 | Mitigate: external MRI boundary, passive detection and approved recovery/access process | $12,000 | 3–4 weeks, vendor-dependent | Radiology + biomedical + IT; preserve PACS transfer and certified OS |
| GAP-006 | Mitigate: approved EHR database sources, account review and audit handling | $6,000 | Conditional Quick Win within one week; broader review within month | DBA + clinical application owner; test allowed/denied access and rollback |
| GAP-007 | Mitigate: shared isolated/offsite copies, independent access and restore exercises | $23,000 | 6–8 weeks | IT + clinical owners; recover priority workloads using independent copies |
| **Subtotal** | | **$110,000** | | |
| **Contingency** | Pricing, compatibility and essential variance | **$10,000** | | Finance/James review |
| **Annual allocation** | | **$120,000** | | Within stated ceiling |

These are incremental first-year **planning allowances, not verified quotes**. GAP-007 alone includes the $14,400/year offsite allowance from the historical source quote; PACS-specific capacity/integration is in GAP-003. Device-specific recovery work uses that shared platform instead of purchasing duplicate offsite services. Expanded capacity, licensing, restore charges and future support renewals require confirmation. The $110,000 package additionally needs approximately **62 existing-staff person-days**; payroll/backfill and future recurring funding are not automatically covered by the cash estimate. [Task 14 cost breakdown]

### Delivery sequence and conditions

**Quick wins — within one week:** Validate pharmacy/core ownership and clinical data flows (GAP-002/004), and implement EHR source restrictions only after permitted clients and rollback are established (GAP-006). Open prompt billing incident triage (GAP-008); existing-team triage is not a guarantee that full forensic remediation is cost-free. Record control findings and assign review of new alerts immediately.

**Short term — within one month:** Complete pharmacy checks/rollback, core configuration protection and the approved MRI pilot (GAP-002/004/005). Confirm clinical recovery objectives, supplier compatibility and offsite/PACS sizing (GAP-003/007). Prototype and validate pump flows before rolling out restrictions (GAP-001). Restricting network communication must preserve medically required operation; do not patch or modify the MRI OS contrary to scenario constraints.

**Long term — beyond one month:** Finish staged pump deployment and integrated PACS/offsite recovery exercises over approximately 10–12 weeks where dependencies permit (GAP-001/003/007). Retest and update residual ratings only after successful clinical acceptance. Full redundant-core architecture, broader round-the-clock monitoring and an enterprise SIEM are deferred enhancements, not capabilities bought by this budget; interim named review remains necessary. MRI replacement is not promised as a next-year solution to the current constraint.

Additional GAP-008–014 remediation requires scope, ownership and pricing. Use existing-team actions where practical, but do not imply that all 14 gaps will close for $120,000. If quotes exceed contingency, revalidate reusable infrastructure, prioritize safe clinical recovery and seek explicit funding or a documented time-limited decision; do not silently remove a priority work package. Any deferred risk requires accountable management sign-off and a review trigger. Proposed owners and future controls remain proposals. [Task 14]

## 7. Conclusion and Next Steps

MedDefense has enough basic protection to build on, but cannot yet demonstrate reliable prevention, recognition and recovery for several failures that could disrupt care. Without the recommendations, unsafe dosage information, interrupted clinical records, unavailable imaging and delayed claims remain credible business outcomes; no specific breach or patient injury is presented as inevitable. Continuing to restart an affected server or relying on an untested local backup leaves the underlying exposure unresolved.

The Board should approve the staged allocation, have Sarah confirm staff/vendor capacity, and have James maintain a risk register with clinical owners and acceptance evidence. Progress reporting should show validated restoration, verified access restrictions and closure of specific GAP IDs, rather than product purchases or raw control counts. Unknown device ownership, source discrepancies and provisional data classifications should be resolved in parallel. A supplier support response promise is not a clinical recovery test.

The next phase is the **External Threat Landscape Assessment**, completing Marcus's unfinished work on who targets hospitals and how. Validate healthcare-relevant ransomware, credential abuse, exploitation and medical-device threats against authoritative current sources; verify product versions and applicability before connecting a bulletin to a MedDefense device. Treat the billing mining process and the two undocumented internal devices as investigation leads, not proof of a named actor or campaign. Reconcile any Task 13 findings, revise likelihood and priorities where evidence supports it, and carry the approved dependencies, recovery needs and residual risks into the next assessment. This report provides the internal baseline; it does not claim that external threat research has already been completed.
