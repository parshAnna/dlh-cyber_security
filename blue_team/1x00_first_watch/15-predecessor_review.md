# MedDefense Health Systems — Predecessor Review

Prepared for: James Chen, Deputy CISO  
Prepared by: Junior Security Analyst  
Scope: Evaluation of Marcus Webb's DRAFT v0.3 against the supplied internal evidence; no live validation performed.

Source: [Marcus's draft assessment](https://s3.eu-west-3.amazonaws.com/hbtn.intranet/uploads/text/2026/3/d277b540e8352f75b2508b29a48aabbbdcf1c629.txt), dated relatively three months ago. M-01–M-08 below are its finding labels, distinct from the MRI scenario's M source key. References use the [Asset Registry](7-asset_registry.md), [Data Map](9-data_map.md), [Control Matrix](10-complete_control_matrix.md), [updated Gap Analysis](12-gap_analysis.md) and [Reality Check](13-reality_check.md). O/C/I/S refer to the source artifacts indexed in those documents. Retrospective comparisons distinguish new evidence from mistakes; unsupported detail is not accepted simply because an experienced predecessor wrote it.

## Part 1 — Comparative Analysis

### Documented findings

| Finding | Marcus's Assessment | Your Assessment | Agree/Disagree | Resolution |
|---|---|---|---|---|
| M-01 — Network segmentation | Critical; entirely flat, every host can reach every other; January spread was avoided only because the variant was non-propagating; $25–40K/3–6 months proposed. | GAP-016 confirms broad or unverified boundaries; GAP-001/005 identify Critical clinical isolation gaps. S supports broad reachability from the scan host and explicit Central non-separation, but not every authorized application path. | Agree on priority; qualify universality, cause and estimate. | C-002 allows ALL VPN services; C-003 does not establish internal separation. No January malware analysis proves its propagation behavior or that luck alone limited impact. Verify topology and switch capability; claimed VLAN support and license/labor pricing are not established quotes. A single highest-ranked finding depends on the stated risk method, not rhetoric. |
| M-02 — Backup isolation | Critical; colocated NAS; both copies would be encrypted; recovery relies on monthly offsite tapes despite saying no offsite replication. | GAP-007 is High under our explicit coverage rubric because weak local detection/correction exists; common-failure exposure is serious. A-045 and C-022/C-023 do not prove tape recovery or inevitable NAS encryption. | Agree on exposure; disagree with guaranteed outcome and reliance on tapes. | C A5 explicitly says no offsite/cloud backup and provides no tape job, inventory or restore evidence. Keep monthly tape as an unresolved source conflict; request media custody, rotation and test records before crediting it. Alpha's tapes in Task 13 belong to another hospital. $14,400/year is a historical quote requiring new scope validation. |
| M-03 — Medical IoT | High, potentially Critical; approximately 200 devices, many defaults and a BD bulletin; restrict to clinical workstations/PACS. | GAP-001 is Critical for missing device-specific detection/recovery; GAP-018 tracks credentials as unverified. O estimates about 80 monitors plus 120 pumps before additional device categories; S counts differ. | Agree on clinical importance; strengthen priority and qualify detail. | Do not treat 200 as a reconciled all-device count or assume all devices use default credentials. Marcus supplies no device-specific credential evidence or bulletin ID. Validate each vendor flow: PACS permission suits imaging, not automatically every pump; deny-by-default rules must preserve approved clinical/update paths. |
| M-04 — Monitoring | High; “zero detective capability,” no retention policy or review; deploy Wazuh in 2–4 weeks. | Centralized/active detection is inadequate, but C-004/C-011/C-018/C-021/C-029/C-034–C-038 demonstrate real logging, malware detection, surveillance and limited review. | Disagree with zero capability; agree on the monitoring gap. | C A8 records firewall retention 30 days, Apache four weeks, reactive review and a 48-hour EHR export delay; these are not a comprehensive retention program, but contradict no retention/review whatsoever. Wazuh is not installed; software availability does not supply onboarding, tuning, responders or validated coverage automatically. |
| M-05 — MFA | None anywhere, every system password-only; inevitable compromise; existing O365 E3 gives $0 VPN/admin rollout. | GAP-011 remains High; C-041 records MFA on James's personal account and C-005 confirms key-only SSH on ehr-srv-01. Organization-wide suitable MFA is not demonstrated. | Agree on broad need; disagree with absolutes and unsupported zero cost. | Key-only SSH is not automatically MFA, but is not password-only. Verify tenant entitlements, authentication method, VPN integration, hardware/support and staff effort before a cost claim; O365 E3 alone proves none of those details. Credential compromise is plausible, not inevitable. |
| M-06 — Westside | High; consumer router, no managed switching/firewall, no physical IT security; replace router and lock closet. | A-074/A-088 and O support weak router/switch governance; O reports unlocked closet. C-030 shows an entrance camera, which does not protect the closet. | Agree on specific weaknesses; qualify “no security” and hardware-only treatment. | GAP-012/013/016 address unmanaged access, local recovery and broad VPN reach. Confirm consumer-router capabilities/rules rather than imply no filtering whatsoever. A managed appliance needs support, configuration and validation; ~$1,500 is Marcus's unverified hardware estimate, not total protection cost. |
| M-07 — Shared PACS login | Medium because access is on-site; proximity/smart-card authentication suggested. | GAP-011 is High: shared access to Restricted imaging undermines confidentiality/accountability regardless of being on-site; C-052 is Weak. | Disagree with location-based downgrade. | Internal attackers, compromised workstations and staff misuse remain credible. Individual fast authentication is appropriate to evaluate with Radiology/vendor, but badge capability, integration cost and session attribution must be validated. Credentials are not reproduced in this report. |
| M-08 — Print server | Low; little target value and internal access make it mainly a compliance issue. | A-043 responds in S; supported maintenance, privileges and spooled data remain unverified. Task 8 treats standalone printing as potentially Medium rather than automatically Critical. | Disagree with internal-network reassurance; do not inflate unproven exploitability. | Add GAP-023, provisionally Medium: verify exact OS/build/support and required connectivity, then plan supported migration or retirement. The S table says Server 2012 while O/S notes say 2012 R2. Internal exposure can matter, but no specific installed flaw or sensitive print dataset is established. |

### Unfinished findings: validate, extend or reject unsupported conclusions

| Finding | Marcus's Assessment | Your Assessment | Agree/Disagree | Resolution |
|---|---|---|---|---|
| Portal TLS | “SSL certificate” uses TLS 1.0 alongside 1.2; disable 1.0. | A protocol setting is not itself a certificate property; no server/proxy handshake configuration is supplied. | Valid concern, unverified current configuration. | Add GAP-019 to validate the transport baseline and supported clients; do not claim interception or that all sessions use the older protocol. |
| No DLP | Patient/financial data can leave by any route without prevention/detection. | GAP-017 covers EHR bulk export; Task 9 and Task 11 identify broader data flows, but absent DLP tooling does not prove every user can read/export all files. | Agree on missing assurance; reject universal unrestricted-exfiltration conclusion. | Add GAP-020 for downstream endpoint/email/cloud controls with field-level rights validation; keep existing authentication and antivirus acknowledged. |
| Unrestricted USB | No USB-storage GPO anywhere. | No policy export or device sample supports universal absence; removable-media governance was not explicit in the earlier enterprise gaps. | Valid validation lead, not confirmed fleet-wide state. | Include in GAP-020; require clinical exceptions and approved alternatives before blanket blocking. Combine overlapping USB/DLP channels instead of duplicate gap counts. |
| HQ landlord dependency | No visibility into shared infrastructure; unclear VPN termination. | A-110 and O corroborate third-party network management; C-002/C-004 show only some perimeter visibility. “Building management system” is ambiguous and does not establish an additional HVAC/BMS asset. | Agree on assurance gap; qualify actual security state. | Add GAP-021 for provider responsibilities, incident notification and tenant/VPN assurance; do not invent landlord compromise or an extra building-control host. |
| No change management | All changes ad hoc; backup cron fault caused by an untested change. | I A/C/E independently demonstrate backup misconfiguration, dosage-script error and untested rollback. Existing GAP-002/004 cover specific workloads, not an organization-wide process. | Agree on systemic concern; qualify universal absence and cron causation. | Add GAP-022; verify approval/test/rollback evidence across representative changes. The exact change that broke cron remains Marcus's claim, not a proven forensic sequence. |

### Valid findings added to the Gap Analysis

These five full records also appear in Task 12. “Valid” means a justified exposure or assurance gap to investigate, not independent confirmation of every statement in Marcus's notes. They use Task 9 classifications and preserve prior IDs; the updated distribution is **23 gaps: 5 Critical, 16 High, 2 Medium**.

### GAP-019 — Patient-portal transport baseline permits legacy TLS according to unverified draft

```text
Gap ID: GAP-019
Title: Patient-portal transport baseline permits legacy TLS according to unverified draft
Affected Asset(s): web-srv-01 A-046 / portal A-114 — Critical G10
Data at Risk: Task 9: lab results and authenticated patient information Restricted in transit; published website text Public
Current Control Status: C-001 offers HTTP/HTTPS; C-036 logs and C-022 backups exist; no effective TLS/cipher or redirect configuration supplied
What is Missing: Technical Preventive validated supported TLS configuration and secure client paths; Administrative Preventive configuration ownership and compatibility review
Risk Level: High
Risk Justification: Provisional High: Marcus section 2 reports TLS 1.0 alongside 1.2 without a configuration extract. Restricted data and incomplete transport assurance warrant validation, not a claim that traffic was intercepted or every session uses TLS 1.0.
Potential Impact: If weak protocol negotiation or unprotected routes are usable, an appropriately positioned attacker could threaten session confidentiality/integrity; actual settings, clients and attack prerequisites remain unknown.
```

Distribution tags: G10; categories: Technical, Administrative; functions: Preventive.

### GAP-020 — Removable-media and outbound sharing restrictions lack verified data controls

```text
Gap ID: GAP-020
Title: Removable-media and outbound sharing restrictions lack verified data controls
Affected Asset(s): Clinical/administrative endpoints G6 Critical integrity / G7 High; EHR and patient-linked files Restricted
Data at Risk: Task 9: patient information Restricted; HR/business documents Confidential; exports at rest, in use and in transit
Current Control Status: C-017–C-021 protect covered endpoints from some malware; C-032 training and C-033 tracking exist; GAP-017 covers bulk EHR export but not all downstream USB/email/cloud channels
What is Missing: Technical Preventive approved removable-media and sensitive-sharing restrictions; Technical Detective endpoint/export monitoring; Administrative Preventive documented clinical exceptions and data handling
Risk Level: High
Risk Justification: Marcus section 2 alleges unrestricted USB and no DLP, consistent with incomplete controls but not independently verified for every endpoint. High-sensitive-data exposure and partial protection justify High; lack of a DLP product alone does not prove no access control.
Potential Impact: An authorized user or compromised session could copy readable patient or business files to removable media or personal cloud/email channels if permitted; actual file access, transfer and theft are not demonstrated.
```

Distribution tags: G6; categories: Technical, Administrative; functions: Preventive, Detective.

### GAP-021 — HQ landlord-managed network lacks documented security responsibility and assurance

```text
Gap ID: GAP-021
Title: HQ landlord-managed network lacks documented security responsibility and assurance
Affected Asset(s): HQ network A-110 and VPN dependency — Critical group G4; HQ endpoints A-081–A-085 — High G7
Data at Risk: Task 9: corporate/HR data Confidential; credentials Restricted; intersite data may include Restricted content depending on workflows
Current Control Status: O describes landlord-managed network and MedDefense VLAN; C-002/C-004 VPN perimeter rules/logs exist; C-031 cameras are outside MedDefense access; exact HQ termination/security configuration unknown
What is Missing: Administrative Preventive provider responsibility, access/patch/incident obligations and assurance review; Technical Detective supported visibility into relevant tenant/VPN events
Risk Level: High
Risk Justification: Shared network dependency and sensitive traffic have incomplete documented oversight. Marcus section 2 reinforces O but does not prove malicious landlord activity, insecure cryptography or compromise; existing perimeter controls remain present.
Potential Impact: Provider changes, unauthorized management access or an unreported shared-infrastructure incident could interrupt HQ access or expose reachable services; tenant isolation and VPN termination require verification.
```

Distribution tags: G4; categories: Administrative, Technical; functions: Preventive, Detective.

### GAP-022 — Organization-wide change approval and rollback evidence is incomplete

```text
Gap ID: GAP-022
Title: Organization-wide change approval and rollback evidence is incomplete
Affected Asset(s): Pharmacy A-093, EHR A-036/A-037 and core A-087 — Critical; backup platform G8 Critical
Data at Risk: Task 9: clinical/dosage information and recovery copies Restricted; configuration integrity across all states
Current Control Status: C-024 partial restore test, C-043 paper fallback and C-047 restarts exist; GAP-002 and GAP-004 cover particular systems, not enterprise change governance
What is Missing: Administrative Preventive documented approval, testing, ownership and maintenance windows; Administrative Detective post-change validation; Administrative Corrective tested rollback and escalation
Risk Level: High
Risk Justification: Marcus alleges universal ad-hoc changes; I C/E/A independently show dosage-script error, untested migration rollback and a misconfigured backup job. These validate a systemic evidence gap, not proof every change lacks authorization; partial detective/corrective capabilities are acknowledged.
Potential Impact: Poorly validated changes could corrupt dosage/reference data, interrupt EHR access or silently stop backups, turning routine maintenance into clinical disruption; causation of the cron fault by an unauthorized change remains Marcus’s claim.
```

Distribution tags: G1; categories: Administrative; functions: Preventive, Detective, Corrective.

### GAP-023 — Legacy print server remains active without verified supported maintenance and containment

```text
Gap ID: GAP-023
Title: Legacy print server remains active without verified supported maintenance and containment
Affected Asset(s): print-srv-01 A-043 — member of High G7; standalone printing availability provisionally Medium per Task 8 component boundary
Data at Risk: Print-job/spool content unknown; routine documents Internal, business records Confidential, patient documents Restricted if present
Current Control Status: C-013–C-015 policy and C-034 Windows logs reported; C-003 perimeter protection exists; C-022 excludes print server; no server antivirus coverage established
What is Missing: Technical Preventive verify support/patch state and restrict required print/management flows; Administrative Preventive approved migration/retirement and dependency mapping
Risk Level: Medium
Risk Justification: Upgrade from Marcus’s Low to provisional Medium for this component: it responds internally and retains a legacy OS with partial controls, but actual sensitive spool contents, privileges and exploitability are unverified. Escalate if Restricted spooling or a usable path to Critical systems is confirmed.
Potential Impact: Compromise could disrupt printing, expose any readable spooled documents or support attempts at lateral movement. Internal placement is not immunity, but no specific installed vulnerability or successful pivot is claimed.
```

Distribution tags: G7; categories: Technical, Administrative; functions: Preventive.

### Findings in our work that Marcus's draft omits or does not resolve

| Our finding | Supporting reference | Why it may be absent from his draft — hypothesis only |
|---|---|---|
| PACS explicitly excluded from backups | C A5/C-022; GAP-003; A-038 | He focused on where backups were stored rather than verifying each workload's inclusion; the partial draft may predate full scope review. |
| Incorrect dosage update and unmapped pharmacy hosting/recovery | I C; A-093; GAP-002 | Application-owner access or time for clinical workflow investigation may have been limited. |
| Unattended EHR session and instruction discouraging logout | W3; Task 9 patient data in use | Our walk-through supplied a concrete observation not recorded in this draft; absence does not show he never noticed it. |
| Patient portal cross-patient object access | I B; GAP-009 | His portal note concerns TLS, a different layer; he may not have reviewed the incident findings before departure. |
| Sophos server/mobile exclusions and inconsistent coverage counts | C A4; C-017–C-021; Task 5 G-005 | Current console export or licensing details may not have been available to him. |
| Exact identity of two scan unknowns remains unresolved | S; A-047/A-080; GAP-012 | The scan was compiled for the replacement analyst, after the draft; it adds observations he could not necessarily access. |
| Personal NAS, personal-account Marketing Drive and abandoned Pi | Task 11; A-124–A-126 | Mike's later account supplies ownership/use details; the draft may lack department interviews. Other Marcus notes mention a NAS, so “missing from this draft” does not mean unknown to him. |
| Room-location, DMZ and inventory-count contradictions | Task 7 reconciliation | Later combined sources expose conflicts that a single partial assessment might not reveal. |

Do not treat our later evidence access as proof of negligence by Marcus. Conversely, his status as the previous analyst does not convert speculation, outdated snapshots or incomplete claims into authoritative current facts. No proposed control is marked implemented, and the original seven-package budget is not expanded automatically by these new findings.

## Part 2 — The Last Page

Our internal assessment identifies the critical clinical services, sensitive data and control gaps that determine how an external intrusion could harm MedDefense, including exposed medical-device paths and recovery copies sharing the production environment. Marcus's unfinished work supplies the next questions: which actors and techniques are relevant, and which of these local weaknesses match observed attack patterns rather than hypothetical possibilities. An external threat landscape assessment should validate current healthcare advisories and applicable versions, use ATT&CK to describe supported behaviors, and apply STRIDE to MedDefense's documented trust boundaries without assuming a named actor or specific exploit. This is the logical next step because threat evidence refines likelihood and action order, while the internal assessment supplies the asset, data and business-impact context needed to make those priorities defensible.
