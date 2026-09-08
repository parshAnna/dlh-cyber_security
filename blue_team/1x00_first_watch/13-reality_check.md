# MedDefense Health Systems — Reality Check

Prepared for: James Chen, Deputy CISO  
Prepared by: Junior Security Analyst  
Scope: Comparison of three supplied breach cases with MedDefense's documented gaps; no new live-system testing.

Source: [Healthcare breach summaries](https://s3.eu-west-3.amazonaws.com/hbtn.intranet/uploads/text/2026/3/1e2b24215eff09598f5cd1872c6c7fc52f667fc8.txt), cases **B1 Alpha**, **B2 Beta**, **B3 Gamma**. The packet attributes the anonymized cases to CISA, HHS and public reports but supplies no original case links or specific CVE identifiers. Treat the details as supplied case evidence, not independently authenticated reporting or current statistics. The assignment calls them “past two years,” but its Q3 2023/Q1 2024/Q4 2024 dates are historical relative to this assessment's September 2026 preparation; do not silently describe all three as recent two-year incidents.

Internal references: [Asset Registry](7-asset_registry.md), [Data Map](9-data_map.md), [Control Matrix](10-complete_control_matrix.md), [Shadow Systems](11-shadow_systems.md), and the now-updated [Gap Analysis](12-gap_analysis.md). External similarities support investigation and prioritization, not proof of identical local vulnerabilities, actors or attack paths.

## 1. Regional Hospital Alpha — Ransomware via VPN

**Attack vector and exploited weaknesses:** Initial access was exploitation of an unpatched VPN vulnerability with a four-month-old available patch. The attacker crossed a flat network, reached AD within three hours, and used a compromised domain-administrator account to distribute ransomware through Group Policy. This was not necessarily a Group Policy software vulnerability: legitimate administrative capability was abused after credential compromise. Missing monitoring, production-connected backups and improvised response amplified the attack, resulting in 23 encrypted servers, approximately 400 workstations and 11 days of disruption. Possible exfiltration is not confirmed by this case.

**MedDefense correlation:** GAP-007 matches the shared-network recovery exposure; GAP-011 covers privileged/shared access and account governance; GAP-006 exposes the EHR database to broad internal reachability, while GAP-004 concerns shared network visibility/recovery and GAP-003 imaging recovery exclusion. Those gaps could facilitate propagation or worsen consequences after entry, but none establishes that MedDefense's FortiGate is unpatched or exploitable. C-002's all-service VPN permissions and the reported flat topology make the case relevant; the full perimeter configuration and firmware evidence remain missing. The absence of a formal response plan was identified in Task 5 G-002 and the posture assessment, but should also remain an explicit cross-cutting treatment requirement when handling these gaps.

**Blind spot check:** Add GAP-015 for documented public-facing vulnerability-remediation ownership/closure and GAP-016 for the broader DMZ/VPN/internal trust boundaries. Earlier host-specific access and device isolation findings did not fully articulate these two enterprise mechanisms. Full records appear below and in Task 12; both are provisional High evidence gaps. No new claim of a local CVE or guaranteed ransomware propagation is made.

## 2. Health Network Beta — Insider and Credential Abuse

**Attack vector and exploited weaknesses:** A terminated employee used retained valid VPN/EHR credentials, not a new software exploit. A missed manager ticket left accounts active for 47 days; repeated off-hours access and bulk export went unreviewed despite available EHR logs. Lack of MFA, incomplete offboarding, unreviewed audit events and unrestricted extraction enabled theft of 3,211 patient records, discovered through a patient's fraudulent bill report. MFA alone would not revoke a former employee's authorization if the employee still controlled the enrolled factor.

**MedDefense correlation:** GAP-011 already includes departure enforcement, individual accountability and strong authentication; GAP-006 includes access review and timely EHR auditing. C-016 is only a shared-password departure rule, not proof of an HR-integrated organization-wide deactivation process; C-037's 48-hour export delay and C-038's reactive review demonstrate the detection weakness. GAP-012 and Task 11 also show ownership/retirement problems, including a former intern's unmanaged monitor and a personal cloud account. No evidence establishes a specific MedDefense former employee retaining active VPN/EHR access for 47 days.

**Blind spot check:** Account lifecycle and absent effective review are already covered by GAP-011/GAP-006, so strengthen their validation checklist rather than create duplicate gaps. Require evidence of HR-triggered disabling across VPN, EHR, shared/cloud identities, token/session revocation and completion verification; also consider safe exceptions for service accounts. Add GAP-017 because patient-record export authorization, volume limits and unusual-download alerts were not separately documented. Beta's SSNs and record count are not assigned to MedDefense's datasets without field evidence.

## 3. Community Hospital Gamma — Portal-to-Medical-Device Pivot

**Attack vector and exploited weaknesses:** Initial entry was an unpatched internet-facing portal vulnerability, followed by an overly permissive DMZ-to-internal connection. Mining spread to the portal and three clinical workstations, then exposed pump management interfaces with default credentials gave access to patient names and dosage information. Flat medical-device connectivity, firmware constraints and absent monitoring allowed 23 days before a technician noticed unusual traffic. The case documents exposure and performance degradation, not demonstrated changes to a patient's infusion dose or actual patient injury.

**MedDefense correlation:** GAP-009 identifies a historical portal authorization flaw, which is relevant to application security but is not evidence of Gamma's code-execution path. GAP-008 independently shows mining on MedDefense billing, with its entry vector still unresolved. GAP-001 covers medical-device isolation/detection/recovery; GAP-005 addresses legacy isolation constraints; GAP-006 highlights reachability of clinical systems. The DMZ label conflicts with internal placement in MedDefense's inventory, but the actual Gamma-style outbound firewall rule has not been supplied.

**Blind spot check:** GAP-015 and GAP-016 cover application-patching assurance and explicit DMZ egress review. Add GAP-018 for vendor-supported medical management credential validation: GAP-011 covered human/shared accounts, not factory credentials on pumps. Gamma's default credential is not evidence that MedDefense uses the same password; record a validation gap and do not test changes on live treatment equipment without biomedical coordination. The broader lack of pump detection/recovery remains the existing Critical GAP-001.

## 4. Newly Documented Gaps

The following records are also inserted into Task 12 with stable new IDs. Related scenarios are cross-referenced, not counted as independent losses. Data classes follow Task 9; local controls marked unknown must be validated before treating absence of evidence as confirmed exposure.

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

## 5. Priority Reassessment

**No existing gap changes risk level solely because of these cases.** All five existing Critical gaps remain Critical, the eight original High gaps remain High and the training gap remains Medium; add four provisional High gaps, yielding **18 total: 5 Critical, 12 High, 1 Medium, 0 Low**. Real-world analogues strengthen relevance and urgency but do not erase existing logs/backups or prove an unverified local flaw.

| Gap(s) | Decision and reason |
|---|---|
| GAP-001 / GAP-005 | Maintain Critical and expedite safe medical isolation validation; Gamma shows the plausibility of entry through another server reaching medical devices. |
| GAP-003 / GAP-007 | Maintain Critical / High respectively; Alpha strongly supports independent, tested recovery. Local backups still exist for GAP-007, so do not upgrade it by calling them absent. |
| GAP-004 / GAP-002 | Maintain provisional Critical pending core/pharmacy recovery evidence. Their absence from these three case narratives is not a reason to lower patient-care priorities. |
| GAP-006 / GAP-011 / new GAP-017 | Maintain or assign High but raise operational priority of access review, offboarding verification and export monitoring following Beta; shared infrastructure controls can benefit these together. |
| New GAP-015 / GAP-016 | Place early in the High validation queue because Alpha/Gamma begin at public services and cross internal boundaries; confirm local versions/rules before procurement or a confirmed-vulnerability claim. |
| New GAP-018 | Provisional High credential-baseline validation alongside existing Critical pump protections; if live evidence confirms default credentials with absent device detection/correction, reassess under Task 12's Critical rule and avoid duplicating GAP-001. |
| GAP-008 | Keep High but perform prompt incident triage now: MedDefense mining evidence already exists, independent of another hospital's case. |
| GAP-009/010/012/013/014 | No downgrade: portal authorization, physical access, unmanaged systems, data recovery and training remain locally supported concerns even where external examples emphasize other pathways. |

Task 14's seven-package $110,000 plan plus $10,000 reserve is not automatically rewritten or expanded here. Begin version/boundary verification and lifecycle/export scoping using approved staff capacity; determine whether narrow work fits existing GAP-004/006/007 packages, and explicitly cost any expansion. The cases support funding recovery, practical internal boundaries and assigned detection/response before assuming an expensive monitoring product alone solves the problem. Expanded remediation requires a reviewed budget and clinical change plan, not an unapproved claim that all new gaps fit the reserve.

**Upgrade/downgrade triggers:** Confirmed exploitable exposure plus absent relevant detection/correction may justify an upgrade; demonstrated applicable controls and successful recovery may justify lowering a provisional rating. A vendor version label alone, a single successful scan or purchase of a tool is insufficient. Review current advisories and exact software builds before converting these historical examples into vulnerability findings.

## 6. Pattern Analysis

Across the three supplied breaches, initial entry differs—VPN exploitation, retained valid credentials and a vulnerable portal—but excessive trust, delayed recognition and incomplete lifecycle or recovery controls repeatedly turn access into substantial harm. Alpha and Gamma show why public-service boundaries and internal segmentation matter, while Beta demonstrates that audit records without review and account/export governance leave legitimate-looking access dangerous. MedDefense should focus its limited budget on verified remediation of exposed entry points, clinically safe least-privilege boundaries, timely access/behavior review and tested independent recovery, with clear owners for each action. These measures address mechanisms shared by the cases; sector analogues do not establish identical local vulnerabilities, guarantee same-day detection or justify ignoring documented patient-safety gaps outside this small sample.
