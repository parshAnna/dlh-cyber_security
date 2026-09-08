# MedDefense Health Systems — Prioritized Gap Analysis

Prepared for: James Chen, Deputy CISO  
Prepared by: Junior Security Analyst  
Scope: Task 12 — available-source assessment with provisional data classifications and explicit evidence limits.

## Executive assessment

The highest-priority gaps are missing clinical recovery, unprotected bedside-device functions, legacy MRI safeguards and unverified core-network resilience. Other major gaps concern EHR/portal access, local-only recovery copies, billing compromise, physical access and unmanaged devices. Existing controls are recognized even where Weak; a low-quality log or backup is not silently relabeled as absent to inflate priority.

## Sources, classifications and prioritization

The analysis cross-references the [Asset Registry](7-asset_registry.md), [Criticality Assessment](8-criticality_assessment.md) and [Complete Control Matrix](10-complete_control_matrix.md). Source keys O/I/D/W/C/M/S retain their Task 7 meanings. **Task 9 Data Map and Task 11's separate findings have not been supplied.** The data crosswalk below is an analyst proposal based on existing artifacts, not a claimed extract from Task 9. Shadow IT findings come from S and Incident F, already reconciled in Task 7. Any new Task 9/11 evidence must be reconciled before final organizational sign-off; their absence does not justify inventing facts or ignoring known gaps.

| Provisional data key | Data and classification | Evidence / classification reason |
|---|---|---|
| P1 | EHR records and patient lab results — Restricted | EHR functions, portal disclosure Incident B and visible record W3; identifiable clinical content warrants the most protective level. |
| P2 | Diagnostic images and patient identifiers — Restricted | PACS/MRI clinical use and required study transfer in M; sensitive diagnostic information and patient association. |
| P3 | Dosage values, device settings and patient-linked readings — Restricted | Incident C and connected treatment/monitoring functions; proposed highest protection due to safety-critical integrity even where a reference value alone is not personally confidential. |
| P4 | Privileged credentials, rights and critical network configuration — Restricted | W2 credential exposure and O authentication notes; misuse can alter trusted clinical infrastructure. |
| P5 | HR, claims, scheduling and departmental records — Confidential minimum | Business functions documented but exact fields unknown; any patient-linked health fields require Restricted handling. |
| P6 | Recovery copies — inherit highest source class, Restricted for mixed clinical backups | C A5 includes EHR and identity data; copied data does not lose sensitivity because it is a backup. |

Unknown data, keys, fields, encryption and flows remain unknown. At-rest/in-transit/in-use descriptions identify exposure contexts, not verified encryption status. No patient count, financial loss amount or legal penalty is invented.

**Rule interpretation:** Apply Critical first when a Critical asset or Restricted data has at least one relevant function entirely absent from the evidence: Detective **or** Corrective. The assignment's “or” is interpreted inclusively; a missing corrective capability may therefore qualify even when detection exists. Count Weak relevant controls as present; distinguish direct coverage from unrelated perimeter records. Where the absent function is only undocumented, flag the Critical rating as provisional. High applies to significant High-or-higher asset/sensitivity exposure with inadequate coverage; Restricted is treated as at least Confidential, so stronger sensitivity never lowers priority. Medium applies where a specific gap has meaningful partial safeguards reducing its exposure; Low requires low-impact assets and partial compensating measures. These assumptions make the ambiguous/overlapping rules explicit rather than silently changing ratings.

Within tiers, order reflects clinical immediacy and dependency scope; it is not a fixed response runbook. Billing's evidenced mining activity still requires prompt incident handling even while some structural gaps are rated Critical. Category/function tags support the distribution counts: one primary T8 group per gap, but all missing categories/functions are counted once per gap. Groups can span multiple assets and shared controls.

## Prioritized gap records

### GAP-001 — Infusion pumps lack device-specific detection and recovery

```text
Gap ID: GAP-001
Title: Infusion pumps lack device-specific detection and recovery
Affected Asset(s): BD Alaris fleet A-061–A-067 and aggregate entries — Critical (T8 G5)
Data at Risk: P3: dosage settings/updates and patient-linked treatment information — Restricted (provisional); in use and in transit
Current Control Status: C-003 perimeter denial and C-025 entrance checks are indirect only. T10 documents no pump-specific detection; medical-device configuration backups are explicitly excluded from C-022.
What is Missing: Technical Preventive/Compensating network restrictions; Technical Detective device/network monitoring; Technical and Administrative Corrective configuration recovery and clinically validated fallback.
Risk Level: Critical
Risk Justification: Critical bedside treatment assets have no evidenced relevant detective or corrective capability; general firewall logs do not demonstrate visibility into pump traffic. The Critical threshold is met even without proving a particular firmware exploit.
Potential Impact: Unauthorized changes could undermine infusion safety or interrupt treatment. Network reachability alone does not prove remote dose modification or that disconnection stops local pumping; validate device behavior with biomedical staff.
```

Distribution tags: G5; categories: Technical, Administrative; functions: Preventive, Detective, Corrective, Compensating.

### GAP-002 — Pharmacy dosage changes lack validated recovery and systematic checking

```text
Gap ID: GAP-002
Title: Pharmacy dosage changes lack validated recovery and systematic checking
Affected Asset(s): Pharmacy management system A-093 — Critical (T8 G1)
Data at Risk: P3: medication reference/dosage values — Restricted for patient-safety integrity (provisional); at rest and in use
Current Control Status: C-044 pharmacist/printed-reference comparison detected the six-hour error but is Weak. No application-specific recovery control is mapped; host identity and backup scope remain unknown.
What is Missing: Administrative Preventive change approval and validation; Technical Detective dosage sanity checks/auditing; Technical and Administrative Corrective tested rollback and restoration.
Risk Level: Critical
Risk Justification: The Critical-rated system affects all three sites and has no evidenced corrective control. C-044 is recognized as existing detection rather than incorrectly called absent; missing recovery independently meets the stated OR interpretation of the Critical rule.
Potential Impact: Another faulty update could present incorrect doses across three sites until a pharmacist notices, potentially influencing unsafe medication decisions. No actual patient injury is established by Incident C.
```

Distribution tags: G1; categories: Technical, Administrative; functions: Preventive, Detective, Corrective.

### GAP-003 — PACS imaging has no documented recovery copy

```text
Gap ID: GAP-003
Title: PACS imaging has no documented recovery copy
Affected Asset(s): pacs-srv-01 A-038 — Critical (T8 G2)
Data at Risk: P2: diagnostic studies and patient identifiers — Restricted (provisional); at rest and in transit
Current Control Status: C-034/C-038 provide Weak local Windows logging and reactive review; C-039 server-room badge access is Weak. PACS is explicitly excluded from C-022; no alternate recovery mechanism evidenced.
What is Missing: Technical Corrective PACS-capable backups and restoration; Administrative Corrective recovery procedures and capacity planning; Administrative Detective restoration tests.
Risk Level: Critical
Risk Justification: Critical diagnostic imaging and Restricted studies have an explicit backup exclusion with no evidenced corrective alternative. Existing local logs do not restore lost imaging and do not prevent the Critical threshold based on absent correction.
Potential Impact: Storage loss or ransomware could remove access to imaging used in diagnosis. MRI must transmit studies to PACS and processes approximately 45 studies/day; recovery delays could postpone care or require alternative imaging arrangements that are not documented.
```

Distribution tags: G2; categories: Technical, Administrative; functions: Corrective, Detective.

### GAP-004 — Central core-switch configuration and failover protection are unverified

```text
Gap ID: GAP-004
Title: Central core-switch configuration and failover protection are unverified
Affected Asset(s): Cisco core switch A-087 — Critical (T8 G4)
Data at Risk: P4: network configuration and privileged management credentials — Restricted (provisional); stored and used in administration
Current Control Status: C-003/C-004 are indirect perimeter controls. T10 cannot map C-053 exposed switch-stack credentials to the core; no core-specific audit, configuration backup or failover evidence exists.
What is Missing: Technical Detective management/configuration monitoring; Technical and Administrative Corrective configuration backup, recovery and failover verification; Administrative Preventive ownership/change records.
Risk Level: Critical
Risk Justification: The Critical shared network dependency has neither core-specific detective nor corrective coverage evidenced. This is a provisional evidence-gap rating pending configuration and topology validation, not proof that the core is unprotected in reality.
Potential Impact: Destructive switch configuration or hardware failure could interrupt access to multiple clinical services at Central and the Central resources used by remote sites. The presence or absence of a redundant core must be verified.
```

Distribution tags: G4; categories: Technical, Administrative; functions: Detective, Corrective, Preventive.

### GAP-005 — Legacy MRI controller remains on the general workstation network

```text
Gap ID: GAP-005
Title: Legacy MRI controller remains on the general workstation network
Affected Asset(s): WS-RAD-01 A-016 and MRI scanner A-091 — Critical (T8 G2)
Data at Risk: P2: MRI studies and patient identifiers — Restricted; P3: clinical device settings — Restricted (both provisional); in use/in transit
Current Control Status: M reports required PACS connectivity and shared workstation VLAN; S shows XP fingerprint. No deployed compensating barrier, controller-specific detection or device recovery is evidenced. C-022 excludes medical-device configurations; C-034 Windows-server logs do not establish controller logging.
What is Missing: Technical Compensating isolation allowing validated clinical flows; Technical Detective monitoring; Administrative and Technical Corrective vendor-compatible recovery, respecting scenario constraints.
Risk Level: Critical
Risk Justification: The Critical MRI service has no evidenced controller-specific detection or correction, while patching, OS upgrade, replacement and full disconnection are ruled out by M. Missing compensating protection exposes a clinically necessary legacy system.
Potential Impact: Compromise could interrupt approximately 45 MRI studies per day or undermine study/control integrity, with potential delay to diagnosis. XP Embedded versus XP SP3 and vendor identity remain unresolved; no specific CVE is assumed.
```

Distribution tags: G2; categories: Technical, Administrative; functions: Compensating, Detective, Corrective.

### GAP-006 — EHR database access is broader than the documented application need

```text
Gap ID: GAP-006
Title: EHR database access is broader than the documented application need
Affected Asset(s): ehr-db-01 A-037/A-112 and EHR application A-036/A-111 — Critical (T8 G1)
Data at Risk: P1: EHR patient records — Restricted (provisional); at rest, in transit and in use
Current Control Status: C-051 password SSH is Weak on the database; C-035 local logs, C-037 delayed EHR audit exports and C-022 local backups exist but are Weak. C-005–C-011 harden only ehr-srv-01. O/S report broad PostgreSQL reachability.
What is Missing: Technical Preventive approved-source database rules and access restrictions; Administrative Preventive permission review; Technical Detective timely database audit review.
Risk Level: High
Risk Justification: Critical/Restricted scope has incomplete protection, but relevant detective and corrective controls exist, so it does not meet the missing-function Critical test. Restricted is treated as exceeding Confidential for the High threshold; exposure does not itself prove successful unauthorized queries.
Potential Impact: An attacker who also defeats database authentication could access or alter clinical records; database interruption could again force paper workflows, as during the documented nine-hour EHR outage.
```

Distribution tags: G1; categories: Technical, Administrative; functions: Preventive, Detective.

### GAP-007 — Production and recovery copies share a failure domain

```text
Gap ID: GAP-007
Title: Production and recovery copies share a failure domain
Affected Asset(s): NAS-01 A-045, backup-srv-01 A-044 and Veeam A-118 — Critical at recovery-service level (T8 G8); backed-up EHR Critical
Data at Risk: P6: backup copies of EHR, billing, AD and departmental data — Restricted, inheriting highest source class (provisional); at rest and backup transit
Current Control Status: C-022 local 14-day backups exist; C-023 RAID5 addresses limited disk failure only. C-024 is a Weak file-server-only partial test. C-039 physical access is Weak; no offsite copy exists. Logging on Linux backup-srv-01 does not prove NAS audit coverage.
What is Missing: Technical Corrective isolated/offsite recoverable copies; Administrative Detective full-service restore testing; Technical Preventive repository access separation.
Risk Level: High
Risk Justification: At the backed-up clinical-service level, detection and local correction exist but are materially incomplete; classify High rather than relabel existing backups as absent. Restricted copies and Critical recovery dependencies face a documented common-location/network exposure.
Potential Impact: A room disaster or compromise reaching both production and repository could leave EHR and billing without usable recovery copies. The six-hour partial file-server restore is not a demonstrated EHR recovery time.
```

Distribution tags: G8; categories: Technical, Administrative; functions: Corrective, Detective, Preventive.

### GAP-008 — Billing mining activity is treated as a capacity problem

```text
Gap ID: GAP-008
Title: Billing mining activity is treated as a capacity problem
Affected Asset(s): billing-srv-01 A-039; billing application/data A-123/A-113 — High (T8 G3)
Data at Risk: P5: billing/claim records — Confidential minimum; patient-linked health fields would be Restricted (provisional); at rest/in use/in transit
Current Control Status: D documents mining-configured executable, CPU saturation and outbound connections. C-047 restarts and C-048 ad-hoc response are Weak; C-035/C-036 local logs and C-022 backups exist. C-017–C-019 do not cover Linux servers.
What is Missing: Technical Preventive server protection and appropriate egress restrictions; Technical Detective process/network monitoring; Administrative and Technical Corrective investigation, eradication and validated recovery.
Risk Level: High
Risk Justification: High-criticality billing already exhibits mining activity and Finance-reported slowdown while existing detection/recovery is incomplete. Repeated restarts are not proof of eradication, but are not described as nonexistent controls.
Potential Impact: Persistent resource consumption could delay claims and revenue processing, as the prior ransomware incident stopped claims for four days. Initial access and data theft remain unproven; preserve those distinctions during response.
```

Distribution tags: G3; categories: Technical, Administrative; functions: Preventive, Detective, Corrective.

### GAP-009 — Patient portal object-level authorization lacks closure evidence

```text
Gap ID: GAP-009
Title: Patient portal object-level authorization lacks closure evidence
Affected Asset(s): web-srv-01 A-046 and patient portal A-114 — Critical overall (T8 G10, driven by confidentiality)
Data at Risk: P1: patient lab results exposed through portal — Restricted (provisional); in use and in transit
Current Control Status: I B confirms cross-patient access by URL modification; remediation status unknown. C-001 perimeter filtering exists; C-036 Apache logs and C-022 backups are Weak. C-042 demonstrates homepage restoration only, not authorization repair.
What is Missing: Technical Preventive patient-specific object authorization; Administrative/Technical Detective regression testing and access review; Administrative Corrective documented incident closure.
Risk Level: High
Risk Justification: Restricted clinical results and confirmed historical authorization failure have incomplete coverage. Logs and backups exist, so Critical is not assigned merely because those controls cannot prevent every disclosure; backups are not claimed to undo a confidentiality loss.
Potential Impact: Authenticated patients could again view other patients’ lab results if the defect persists, exposing sensitive information and damaging confidence in the portal. Current persistence requires validation.
```

Distribution tags: G10; categories: Technical, Administrative; functions: Preventive, Detective, Corrective.

### GAP-010 — Generic server-room access exposes critical hosted systems

```text
Gap ID: GAP-010
Title: Generic server-room access exposes critical hosted systems
Affected Asset(s): Central server room A-098 — Critical (T8 G9); hosted EHR A-036/A-037 and PACS A-038 — Critical
Data at Risk: P1/P2: clinical records and imaging — Restricted; P6: backup copies — Restricted (provisional); storage media at rest
Current Control Status: C-039 grants every employee access. C-025–C-029 cover entrances rather than the server-room door; no room camera or visitor log. EHR local logs/backups exist, while PACS recovery exclusion is separately GAP-003. Electronic badge-log existence is unknown.
What is Missing: Physical Preventive role-restricted entry; Physical Detective room-area monitoring; Administrative Preventive/Detective visitor authorization and access review.
Risk Level: High
Risk Justification: Hosted Critical systems and Restricted media face inadequate access controls, but applicable host detection and EHR recovery exist. This physical-access gap is High; PACS’s independent lack of correction is already Critical in GAP-003 and is not double-counted here.
Potential Impact: A badge holder could remove media or interfere with hosted servers, exposing records or interrupting care systems. Encryption status, precise room location and the range of accessible equipment require confirmation.
```

Distribution tags: G9; categories: Physical, Administrative; functions: Preventive, Detective.

### GAP-011 — Shared identities and limited MFA weaken clinical accountability

```text
Gap ID: GAP-011
Title: Shared identities and limited MFA weaken clinical accountability
Affected Asset(s): PACS workstation identity unresolved (G2 scope Critical); ehr-db-01 A-037 Critical; other clinical endpoints G6 Critical for integrity
Data at Risk: P4: credentials/access rights — Restricted; P1/P2: accessible clinical records — Restricted (provisional); in use and authentication transit
Current Control Status: C-012/C-016 policy is Weak; C-052 shared PACS account and C-051 password SSH remain. C-013–C-015 Windows rules and C-034/C-035 logs exist; C-041 MFA applies only to James’s unspecified personal account. No organization-wide MFA mandate.
What is Missing: Technical Preventive individual access and suitable MFA on supported access paths; Administrative Preventive account ownership/departure enforcement; Technical/Administrative Detective privileged-access review.
Risk Level: High
Risk Justification: Clinical/Restricted access has incomplete controls, not universal absence. This gap addresses identity/accountability; it does not duplicate the separately ranked PACS recovery gap. Shared credentials make recorded actions unreliable for attribution.
Potential Impact: Stolen or shared accounts could enable unauthorized record access or changes and prevent identification of the responsible user. Exact workstation-to-server privileges remain unverified; do not assume all users can edit clinical data.
```

Distribution tags: G2; categories: Technical, Administrative; functions: Preventive, Detective.

### GAP-012 — Undocumented internal devices lack ownership and access review

```text
Gap ID: GAP-012
Title: Undocumented internal devices lack ownership and access review
Affected Asset(s): UNKNOWN-01 A-047, Westside device A-080, personal laptop A-095 — individual criticality unresolved within T8 G7 High group; exposed HR share A-094 High and reachable server zone containing Critical assets
Data at Risk: P5: HR/business records — Confidential (provisional); data on the unknown devices is Unknown, not assumed to be patient data
Current Control Status: C-056 discovery is Weak but found both unknown IPs; C-040 guest isolation is unverified. C-002 allows broad VPN services; C-004 logs are local. I F places the personal laptop in the HR-share segment, but no unauthorized file access is proven.
What is Missing: Administrative Preventive approved ownership/inventory and service validation; Technical Preventive managed-device admission/restricted access; Technical Detective continuous inventory reconciliation.
Risk Level: High
Risk Justification: High business-data exposure and incomplete network admission justify a provisional High rating based on adjacent assets, not an invented critical workload on the unknown devices. Discovery already exists, and exposure does not establish compromise or exfiltration.
Potential Impact: An unmanaged host could provide an unmonitored access path to internal systems if additional access controls fail. Port 3000 does not identify a particular product; A-080 is not confirmed as the rumored second Westside server. Validate before operational changes.
```

Distribution tags: G7; categories: Technical, Administrative; functions: Preventive, Detective.

### GAP-013 — Departmental cloud and file data lack validated recovery scope

```text
Gap ID: GAP-013
Title: Departmental cloud and file data lack validated recovery scope
Affected Asset(s): O365 A-115, HR share A-094, ws-srv-01 A-075 and file-srv-01 A-042 — High (T8 G7)
Data at Risk: P5: personnel, scheduling and departmental business records — Confidential minimum (provisional); any patient-specific health content requires Restricted classification; at rest/in use/in transit
Current Control Status: C-022 covers file-srv-01 but explicitly excludes O365 and ws-srv-01. C-024 tested only part of file-srv-01 eight months ago. HR-share host mapping is unresolved; C-034 local Windows logs and GPO policy exist, without proof of cloud settings.
What is Missing: Administrative Preventive data/owner mapping and backup responsibility; Technical Corrective explicitly scoped recovery for cloud and Westside data; Administrative Detective restore validation.
Risk Level: High
Risk Justification: High business services and Confidential data have uneven recovery coverage. Cloud backup exclusion and unknown HR location must not be disguised by the existence of a backup for one other file server. No data-specific cloud encryption failure is asserted.
Potential Impact: Deletion or ransomware could disrupt Westside scheduling or destroy departmental/HR records with no demonstrated recovery route for those locations; payroll and legal impacts depend on actual stored datasets, which remain unverified.
```

Distribution tags: G7; categories: Technical, Administrative; functions: Preventive, Corrective, Detective.

### GAP-014 — Security training does not reach clinical staff consistently

```text
Gap ID: GAP-014
Title: Security training does not reach clinical staff consistently
Affected Asset(s): Clinical endpoint users (T8 G6 Critical integrity); HQ/Westside business services G7 High; applies to staff behavior rather than every host control
Data at Risk: P1: clinical information — Restricted; P5: personnel/business information — Confidential (provisional); in use during staff handling
Current Control Status: C-032 annual training is Weak: Central 71%, Westside 58%, HQ 94% completion; C-033 tracking is Adequate. Covered workstations also have C-017–C-021 prevention/detection/quarantine; training has no PHI-specific or role-specific modules.
What is Missing: Administrative Preventive completion enforcement and role/PHI-specific content; Administrative Detective follow-up to verify learning and completion.
Risk Level: Medium
Risk Justification: The specific training gap has partial controls that reduce exposure: a delivered program, tracked completion and endpoint protection on covered devices. This explicitly uses the Medium partial-control rule, not a claim that clinical information is Medium sensitivity; direct technical gaps remain separately prioritized.
Potential Impact: Staff may mishandle patient information, miss phishing or permit tailgating. Existing content and endpoint controls provide some protection, so this program-improvement gap ranks below absent clinical recovery and direct exposure pathways.
```

Distribution tags: G6; categories: Administrative; functions: Preventive, Detective.

### GAP-015 — Public-facing vulnerability remediation lacks verified ownership and closure

```text
Gap ID: GAP-015
Title: Public-facing vulnerability remediation lacks verified ownership and closure
Affected Asset(s): FortiGate A-086 — Critical G4; web-srv-01 A-046 — Critical G10; billing-srv-01 A-039 — High G3, external exposure unverified
Data at Risk: Task 9: patient clinical information Restricted; privileged configuration Restricted; public content Public but administrator access sensitive
Current Control Status: C-001/C-003 filter perimeter traffic; C-055 covers EHR application updates only, not demonstrated FortiGate/web patch compliance; C-035/C-036 logs and C-022 server backups exist
What is Missing: Administrative Preventive advisory ownership, risk-based maintenance deadlines and tracked exceptions; Technical Preventive verified version/configuration remediation and closure
Risk Level: High
Risk Justification: High provisional evidence-gap rating: critical public-facing dependencies have incomplete remediation evidence, not a proven exploitable FortiGate flaw. Existing logging/server recovery prevents claiming universally absent detection/correction; verify scope per device.
Potential Impact: If an applicable exposed flaw is left unresolved, unauthorized entry could enable clinical data compromise and lateral disruption resembling Alpha/Gamma; their CVEs and exposure cannot be assigned to MedDefense without validation.
```

Distribution tags: G4; categories: Administrative, Technical; functions: Preventive.

### GAP-016 — Public-service and intersite trust boundaries lack verified least-privilege enforcement

```text
Gap ID: GAP-016
Title: Public-service and intersite trust boundaries lack verified least-privilege enforcement
Affected Asset(s): web-srv-01 A-046, FortiGate A-086, AD A-040/A-041 — Critical; internal EHR/PACS/medical zones Critical
Data at Risk: Task 9: EHR and imaging Restricted; privileged network/identity material Restricted; in transit and in use
Current Control Status: C-001 refers to dmz, C-002 permits ALL VPN services, C-003 denial is preceded by broad allows; C-004 boundary logs and host logs/backups exist; S reports broad internal reachability
What is Missing: Technical Preventive enforced approved flows across DMZ, VPN and internal zones; Administrative Preventive ownership and validation of application exceptions; Technical Detective review of interzone activity
Risk Level: High
Risk Justification: High because Critical/Restricted targets retain some logging/recovery but boundaries are broad or contradictory. Gamma highlights a specific DMZ-to-internal path not proven by the partial MedDefense export; the exact outbound rule remains an evidence gap.
Potential Impact: A compromised portal or VPN session could attempt to reach identity and clinical services outside its business need, increasing the number of affected systems; do not infer universal successful access from scan reachability.
```

Distribution tags: G4; categories: Technical, Administrative; functions: Preventive, Detective.

### GAP-017 — Patient-record bulk export lacks documented authorization and detection safeguards

```text
Gap ID: GAP-017
Title: Patient-record bulk export lacks documented authorization and detection safeguards
Affected Asset(s): EHR A-036/A-037/A-111 and portal A-114 — Critical; HR/business repositories High where applicable
Data at Risk: Task 9: patient records/lab results Restricted; exported files remain Restricted at rest, in transit and in use
Current Control Status: C-037 EHR audit export is delayed; C-035/C-036 and C-038 are local/reactive; backups C-022 exist but cannot undo disclosure; no approved export limits, permissions or alert evidence supplied
What is Missing: Technical Preventive role-appropriate export restrictions; Technical Detective unusual-volume/source/time alerts; Administrative Preventive export approval and review with clinical exceptions
Risk Level: High
Risk Justification: Restricted records and incomplete controls meet High; existing audit capability is weak rather than absent. Beta demonstrates the consequence of uncontrolled extraction but does not prove MedDefense permits the same export volume or fields.
Potential Impact: A valid or stolen account could copy patient records in bulk before discovery if export rights permit it, causing disclosure that recovery copies cannot reverse; MedDefense export capabilities must first be mapped.
```

Distribution tags: G1; categories: Technical, Administrative; functions: Preventive, Detective.

### GAP-018 — Medical-device management credential baseline is unverified

```text
Gap ID: GAP-018
Title: Medical-device management credential baseline is unverified
Affected Asset(s): BD Alaris A-061–A-067 and other managed medical devices — Critical G5
Data at Risk: Task 9: patient-linked device data Restricted; management credentials Restricted; safety-critical settings require strong integrity protection
Current Control Status: C-013–C-015 Windows GPO and C-005 SSH do not establish device account protection; C-003 is indirect perimeter protection; GAP-001 already records missing pump detection and recovery
What is Missing: Technical Preventive vendor-supported non-default unique credentials and restricted management access; Administrative Preventive commissioning/account ownership checks and safe change procedures
Risk Level: High
Risk Justification: High provisional validation priority, not a confirmed default-password finding; there is no local evidence that factory credentials remain. The already Critical missing device detection/recovery stays in GAP-001 and is not counted again as a newly proven exploit.
Potential Impact: If default or shared management credentials are present, a reachable attacker could access patient-linked settings or attempt unauthorized changes; effects and safe credential-change support require biomedical/vendor validation.
```

Distribution tags: G5; categories: Technical, Administrative; functions: Preventive.

## Gap Distribution Summary

Updated by [Task 13 Reality Check](13-reality_check.md). Original gap IDs and levels remain stable; four provisional High evidence gaps are added.

| Risk level | Count |
|---|---:|
| Critical | 5 |
| High | 12 |
| Medium | 1 |
| Low | 0 |
| **Total** | **18** |

| Primary Task 8 asset group | Gap count |
|---|---:|
| G1 | 3 |
| G2 | 3 |
| G3 | 1 |
| G4 | 3 |
| G5 | 2 |
| G6 | 1 |
| G7 | 2 |
| G8 | 1 |
| G9 | 1 |
| G10 | 1 |

| Missing/inadequate dimension | Gaps mentioning it |
|---|---:|
| Technical | 16 |
| Administrative | 18 |
| Physical | 1 |
| Preventive | 16 |
| Detective | 16 |
| Corrective | 9 |
| Compensating | 2 |
| Deterrent | 0 |

EHR/medication (G1), imaging (G2) and shared network/identity (G4) now tie for the largest primary-group count at three each. Technical and Administrative safeguards dominate the missing dimensions. Category/function counts overlap and are not additive incidents or loss estimates. Newly documented evidence gaps do not establish that the same flaws exploited at Alpha, Beta or Gamma are present locally.

## Validation and action dependencies

Reconcile P1–P6 with Task 9 when available and verify whether Task 11 changes either unknown device's identity, purpose or data exposure. Obtain pharmacy host/recovery evidence and core topology before treating missing documentation as proven absence; those may change their provisional Critical ratings. Validate device-safe recovery and permitted MRI/PACS flows before proposing operational restrictions. Test backups against clinical service requirements rather than assuming a successful file-server restore covers EHR or PACS.

Cross-cutting gaps are deliberately separated by treatment: imaging recovery, account access and physical access are different missing safeguards even when they affect PACS together. They must not be summed into a numerical loss estimate. The severity distribution is an evidence-based prioritization under the stated rubric, not a prediction of incident frequency or a declaration of regulatory noncompliance.

## Task 13 Validation Addendum

The three supplied anonymized breach summaries validate relevance, not local exploitation or independently authenticated case attribution. See Task 13 for full source/date limitations and priority ordering. Task 9 and Task 11 are now available: earlier references to their absence describe the original analysis stage; new GAP-015–018 use Task 9 classifications. Update field-level classification and host identity evidence before reissuing a fully reconciled enterprise assessment. No prior gap is automatically closed or downgraded by these external cases.
