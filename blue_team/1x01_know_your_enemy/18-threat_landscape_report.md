# MedDefense Health Systems — Threat Landscape Report

Prepared for: Board of Directors and James Chen, Deputy CISO

Prepared by: Junior Security Analyst

Assessment date: 22 September 2026

Report status: Final analytical report based on supplied exercise evidence; no live exploitation performed

## 1. Executive Summary

MedDefense faces a high-consequence healthcare threat environment in which ordinary entry routes—remote access, email, valid workforce accounts and trusted vendors—can lead toward systems used for patient records, medication decisions, imaging and recovery. Its greatest exposure is not one isolated flaw: broad internal connectivity, weak identity assurance, delayed monitoring and locally exposed recovery allow a single foothold to affect several clinical services. Existing firewalls, workstation protection, logs and backups reduce risk, but their documented scope does not reliably stop or contain the modeled attack paths.

The **single most dangerous threat is an organized ransomware campaign using double extortion**. The supplied sector evidence identifies regional hospitals of MedDefense Central's size as attractive targets, MedDefense has prior ransomware history, and the completed kill chains show a credible route from VPN or phishing access through identity services to EHR data and reachable backups. Such an event could combine clinical downtime, patient-data disclosure, recovery destruction and financial pressure; restoring systems would not undo stolen-data exposure.

The Board should prioritize three actions:

1. **Contain access and movement.** Replace broad VPN and internal access with approved-flow allowlists, and require named, phishing-resistant-MFA, time-limited sessions for administrators and vendors. This addresses GAP-016 and GAP-011, the two gaps appearing in six of eight modeled paths.
2. **Protect clinical data and recovery.** Add timely EHR export/behavior detection and an access-isolated immutable recovery copy with a full EHR restoration exercise. This reduces ransomware leverage and the insider/vendor theft paths under GAP-017 and GAP-007.
3. **Correct demonstrated operational hazards now.** Treat the billing miner as an incident, introduce a tested pharmacy change-and-rollback gate, and deliver role-specific phishing preparation to IT, Radiology and clinical teams. These actions address GAP-008, GAP-002 and GAP-014: a current compromise indicator, a previously realized medication-integrity failure and the human entry point used in two severe paths.

The overall verdict is actionable rather than fatalistic: MedDefense is attractive to financially motivated and opportunistic actors, but the same identity, boundary, data-monitoring and recovery improvements disrupt several threats at once. Funding should therefore favor controls with cross-path leverage rather than isolated tools that do not change access, visibility or recoverability.

## 2. Scope and Methodology

### 2.1 Scope

This report evaluates threats to MedDefense Health Systems across Central Hospital, Westside Clinic, HQ, cloud services and documented supplier pathways. The principal environment includes a 350-bed hospital, approximately 2,000 staff, clinical information for more than 50,000 patients, three connected sites, cloud collaboration and vendor-maintained clinical systems. The assessment covers external, internal, human and third-party paths; it does not claim that every scanned internal service is Internet-accessible or that any scenario is currently in progress.

This report is the external-threat companion to the First Watch [Security Posture Assessment](../1x00_first_watch/16-security_posture_assessment.md). First Watch answers what MedDefense owns, depends on and fails to control; this report adds who can exploit those conditions, how an attack could progress and which safeguards interrupt the most paths.

### 2.2 Intelligence and Internal Sources

| Source group | Material used | Role in this report |
|---|---|---|
| Supplied threat intelligence | Six-file dossier summarized in [T0](0-threat_landscape_summary.md), actor cases classified in [T1](1-threat_actor_taxonomy.md) and the fictional BlackReef profile analyzed in [T2](2-ransomware_assessment.md) | Sector mechanisms, actor motivation/capability, historical statistics and ransomware operating model |
| First Watch / 1x00 | [Environment Summary](../1x00_first_watch/0-environment_summary.md), [Asset Registry](../1x00_first_watch/7-asset_registry.md), [Criticality Assessment](../1x00_first_watch/8-criticality_assessment.md), [Data Map](../1x00_first_watch/9-data_map.md), [Control Matrix](../1x00_first_watch/10-complete_control_matrix.md), [Gap Analysis](../1x00_first_watch/12-gap_analysis.md) and posture report | Verified or explicitly qualified MedDefense assets, network-scan evidence, controls, data sensitivity, operational incidents and gap IDs |
| Actor and pathway analysis | [Insider Assessment](3-insider_assessment.md), [Social Engineering](4-social_engineering_analysis.md), [Supply Chain](5-supply_chain_assessment.md), [Actor Matrix](6-threat_actor_matrix.md), [Attack Surface](7-attack_surface_map.md) and [Technical Vectors](8-technical_vectors.md) | MedDefense-specific likelihood, human/technical entry routes and trusted dependencies |
| Structured threat modeling | [Vector-to-Asset Matrix](9-vector_asset_matrix.md), [Kill Chains](10-kill_chains.md), [EHR STRIDE](11-stride_ehr.md), [ATT&CK Mapping](13-attck_mapping.md) and [Threat Scenarios](14-threat_scenarios.md) | Reachability, attack progression, threat completeness, shared terminology and defensive break points |
| Decision analysis | [Gap–Threat Correlation](15-gap_threat_correlation.md) and [Threat Priority Assessment](16-threat_priority_assessment.md) | Threat-informed gap movement, cross-path frequency, final Top 5 and recommended effort |

The supplied intelligence statistics are attributed exercise evidence with incomplete dates or denominators; they contextualize MedDefense but are not presented as independently verified live 2026 intelligence. Internal findings distinguish confirmed conditions from validation requirements—for example, mining activity is confirmed, but its entry route is not; pump default credentials and a vulnerable FortiGate version are not confirmed.

### 2.3 Analytical Frameworks

- **Actor analysis (Sec+ 2.1):** assesses motivation, capability, target selection and likelihood for six actor types.
- **Vector analysis (Sec+ 2.2):** maps human and technical vectors to systems, services, ports, credentials and network conditions.
- **Kill chain analysis:** follows initial access, foothold, movement/escalation, objective and business impact, then identifies multiple break points.
- **STRIDE:** tests the EHR architecture for Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service and Elevation of Privilege.
- **MITRE ATT&CK:** maps realistic activity to tactics and techniques so prevention and detection requirements use operationally recognizable behavior.
- **Threat-informed gap correlation:** counts explicit gap dependencies across five kill chains and three scenarios, then combines frequency with actor likelihood, asset impact, evidence quality and existing controls.

Ratings are qualitative. Likelihood estimates selection or occurrence within the next 12 months; impact derives from First Watch asset criticality; priority combines both with path reuse and local evidence. An open port shows reachability, not authorization; missing evidence is not silently converted into a confirmed weakness.

## 3. Healthcare Sector Threat Overview

### 3.1 Why Healthcare Is Targeted

1. **Clinical urgency increases extortion pressure.** Loss of EHR, imaging, pharmacy or connected-device workflows can delay care, making prolonged downtime unusually costly and creating pressure for rapid restoration.
2. **Patient information retains value after recovery.** Clinical, identity, insurance and billing data can support fraud, coercion or resale. Double extortion therefore preserves leverage even when backups work.
3. **Legacy and specialized technology constrains remediation.** Compatibility, certification and continuity requirements can prevent rapid patching or replacement; MedDefense's Windows XP MRI controller must retain PACS connectivity and cannot simply be upgraded or disconnected.
4. **Regional hospitals combine valuable operations with limited security capacity.** The supplied dossier identifies 100–500-bed hospitals as attractive; Central has 350 beds, a small security function and several local/reactive controls.

### 3.2 Trends and Emerging Threats

| Trend | Sector evidence | MedDefense relevance |
|---|---|---|
| Double extortion | The dossier reports exfiltration before encryption in 73% of its healthcare ransomware incidents. | EHR bulk-export controls are weak, and production/recovery share exposure; restoration cannot reverse disclosure. |
| Ransomware-as-a-Service and access brokers | Specialized developers, affiliates and brokers lower the skill and time required to attack a hospital. | An affiliate can buy VPN access or reuse another actor's foothold rather than discover the initial weakness itself. |
| Public-service and identity abuse | The supplied initial-access distribution is 38% public-facing exploitation, 31% phishing, 22% valid credentials and 9% external remote services. | MedDefense has public web/VPN surfaces, incomplete MFA, a credible vendor-patch phish and broad post-entry paths. |
| Automated opportunistic exploitation | Bulk scanning, credential stuffing and packaged exploits let attackers find exposed systems without choosing a hospital personally. | A mining-configured process already runs on billing-srv-01; the entry method remains unknown, but the compromise pattern is locally relevant. |
| Trusted supplier compromise | Attackers increasingly use maintenance identities, software delivery or service systems to appear authorized. | MedTech has documented EHR server/application maintenance access, while transport, approval, privilege and vendor MFA are unresolved. |
| Low-and-slow valid-account misuse | Authorized access can support quiet record collection without malware or obvious exploitation. | EHR audit export is delayed, bulk-export thresholds are not evidenced and removable-media controls remain unverified. |

### 3.3 Sector Context for MedDefense

The supplied dossier reports healthcare as 25% of reported ransomware incidents across its critical-infrastructure population and roughly 35% of healthcare breaches involving insiders, with an approximate 60/40 negligent-to-malicious split. Those figures do not calculate MedDefense's probability, but they align with local evidence: January ransomware stopped claims processing for four days, the exercise reports three nearby hospital attacks in eight months, deliberate EHR snooping is documented, and several convenience-driven unsafe practices exist. The strongest conclusion is therefore comparative: ransomware, negligence and opportunistic compromise deserve more immediate attention than targeted state espionage or hacktivism under current conditions.

## 4. MedDefense Threat Actor Profiles

### 4.1 Six-Actor Ranking

| Rank | Actor type | Likelihood | Capability | Primary motivation | MedDefense priority and principal target |
|---:|---|---|---|---|---|
| 1 | **Ransomware Groups (Organized Crime)** | High | Medium–High | Financial gain through double extortion | **Critical priority:** EHR A-037/A-112, PACS A-038 and recovery A-045/A-118; strongest sector and local-history fit |
| 2 | **Insider (Negligent)** | High | Low–Medium; amplified by legitimate privilege | Convenience and workload reduction | **Critical priority:** pharmacy A-093, EHR/PACS data and administrative changes; unsafe practices are directly documented |
| 3 | **Unskilled/Opportunistic Attacker** | High exposure likelihood | Low, amplified by automation and public tools | Mining, credential theft or access resale | **High priority:** billing A-039/A-113/A-123; confirmed miner creates a possible pivot/resale foothold |
| 4 | **Insider (Malicious)** | Medium | Low–Medium; higher when privileged | Theft, fraud, curiosity, revenge or sabotage | **High priority:** EHR A-037/A-112 and PACS; valid access can bypass the perimeter |
| 5 | **Nation-State APT** | Low targeted likelihood | High | Espionage and strategic access | **High impact-driven priority:** EHR through phishing or MedTech; no institutional research target is established |
| 6 | **Hacktivist** | Low | Low–Medium | Publicity, political pressure or disruption | **Medium priority:** public website/portal A-046/A-114; prior political defacement is relevant but unattributed |

Actor categories can overlap: an opportunistic operator may sell access to ransomware, an insider may enable organized crime, and a supply-chain pathway describes how an external actor enters rather than a separate motive.

### 4.2 Detailed Profile — Ransomware Groups

Ransomware is MedDefense's highest-priority threat because target fit, demonstrated local disruption and cross-system impact coincide. A BlackReef-style affiliate can buy access, exploit a usable VPN/web weakness or send a credible support lure; after entry, broad internal paths support discovery of AD, EHR, PACS and backup services. The objective is not only encryption: patient-data theft creates a second source of pressure, and recovery destruction increases the value of the demand.

The most important enabling conditions are GAP-016 (broad trust boundaries), GAP-011 (weak identity assurance), GAP-017 (weak export detection) and GAP-007 (shared production/recovery exposure). The decisive break points are restricted remote/internal flows, protected privileged identities, timely data-access monitoring and immutable tested recovery. The rating is **High likelihood / Critical impact / Critical priority**; it is not an attribution of prior incidents to BlackReef.

### 4.3 Detailed Profile — Insider (Negligent)

Negligent insiders begin with access that is legitimate, so no exploit is necessary. MedDefense already documents shared PACS sessions, a personal NAS with patient copies, plaintext administrative credentials, incomplete training and a pharmacy change that presented incorrect dosage values for six hours. High workload and clinical urgency make shortcuts plausible even when intent is helpful.

The most consequential path is an inadequately reviewed privileged change affecting pharmacy integrity, but negligence also exposes records through unmanaged storage and weakens accountability through shared sessions. GAP-002, GAP-011, GAP-014, GAP-020 and GAP-022 define the main safeguards. The rating is **High likelihood / potentially Critical impact / Critical priority**; intent is benign, but the clinical effect may not be.

### 4.4 Detailed Profile — Unskilled/Opportunistic Attacker

Opportunistic attackers use scanning, credential stuffing and commodity exploits at scale, so MedDefense need not be individually selected. The mining-configured process on billing-srv-01 is direct evidence of compromise behavior consistent with this model, although it does not identify the attacker or entry method. Ubuntu 18.04, reported Apache 2.4.29, legacy Windows systems and unmanaged devices provide validation targets rather than automatically proven exploits.

GAP-008 is the immediate concern because restarts treated mining as performance trouble instead of an incident; GAP-015, GAP-012 and GAP-016 determine whether another automated foothold can persist or expand. The rating is **High exposure likelihood / High observed impact with Critical escalation potential / High priority**.

## 5. Attack Surface Analysis

MedDefense's attack surface has three linked layers. External services and people provide entry; the internal surface determines blast radius; human and supplier trust can bypass assumptions made about the perimeter. First Watch's scan came from an HQ workstation across connected networks, so internal listeners below are not relabeled as publicly exposed.

### 5.1 External Surface

| Exposure point | Evidence | Existing protection | Principal gaps and consequence |
|---|---|---|---|
| Patient portal/public web — A-046/A-114 | WAN HTTP/HTTPS; prior cross-patient authorization failure and political defacement | C-001/C-003 firewall rules, C-036 local logs, C-022 host backup | GAP-009, GAP-015, GAP-016 and GAP-019; disclosure, defacement or conditional internal foothold |
| Central VPN/FortiGate — A-086 | Terminates Central Internet and site VPNs; firmware/public listeners unknown | C-002 object scoping, C-003 deny, C-004 local logs | GAP-015/GAP-016; a usable exploit or valid session could receive broader internal access than required |
| O365 — A-115 | Organization-wide email, SharePoint and OneDrive; configuration and identity integration unresolved | General account policy, workstation protection and awareness program | GAP-011/GAP-013/GAP-014/GAP-020; phishing, BEC, cloud disclosure and recovery uncertainty |
| Authorized vendor maintenance | MedTech reaches ehr-srv-01; Siemens supports MRI; exact paths/privileges unknown | EHR SSH hardening if applicable; support/update contract | GAP-011/GAP-016/GAP-022; compromised valid access or update can appear legitimate |
| Westside edge — A-074 | Consumer Netgear router and IPSec path; internal scan saw 22/80/443 but not WAN exposure | IPSec tunnel and Central boundary rules | GAP-015/GAP-016; conditional router/tunnel compromise and broad intersite reach |

### 5.2 Internal Surface

| Exposure point | Concrete evidence | Threat significance |
|---|---|---|
| Flat Central network and broad VPN rules | Central `10.10.0.0/16` groups lack verified firewall separation; C-002 permits `ALL` services toward the server subnet | GAP-016 lets one endpoint, VPN or vendor foothold enumerate several critical zones. |
| EHR database | ehr-db-01 A-037/A-112 exposes PostgreSQL 5432 more broadly than the documented application need | GAP-006/GAP-017 create a route toward Restricted records if authentication or an application identity is defeated. |
| Billing | A-039/A-113/A-123 exposes 22/80/3306 internally; miner is confirmed under `www-data` | GAP-008 plus flat reachability makes a currently suspicious host a potential discovery or resale foothold. |
| Recovery infrastructure | A-044/A-045/A-118 shares network and physical exposure with production; NAS management is reachable | GAP-007 lets privileged ransomware attack restoration before encryption. |
| PACS and legacy imaging | PACS A-038 exposes SMB/DICOM services; shared session; no documented backup; XP MRI controller A-016 on general network | GAP-003/GAP-005/GAP-011/GAP-016 support theft, disruption and difficult attribution/recovery. |
| Medical IoT | Pump, monitor, nurse-call and badge interfaces respond on web/service ports within the broad network | GAP-001/GAP-018/GAP-016 expose patient-safety functions after an internal foothold; default credentials are unverified. |
| Active Directory and Windows services | AD A-040/A-041 exposes expected identity ports; endpoints expose SMB and selected RDP | Stolen credentials and pass-the-hash can convert one host into domain-level movement under GAP-011/GAP-016. |
| Unmanaged/legacy assets | Unknown systems, personal laptop/NAS, Raspberry Pi, iPads and legacy print server lack full control coverage | GAP-012/GAP-020/GAP-023 create unmonitored entry, storage and pivot opportunities. |

### 5.3 Human Surface

| Human target | Why targeted | Evidence and primary gap |
|---|---|---|
| Clinical and Radiology staff | Urgency, patient-care workflow and shared sessions make support or credential pretexts credible. | Training completion is 71% at Central and 58% at Westside; shared PACS access and unattended EHR use support GAP-011/GAP-014. |
| IT and security staff | Elevated access makes one trusted maintenance decision or captured credential highly valuable. | Small team, local/reactive logs, urgent vendor-patch pretext and exposed switch credentials support GAP-011/GAP-015/GAP-022. |
| Executives and Finance | Authority and payment access support spearphishing/BEC, while cloud work contains sensitive business information. | HQ training completion is 94%, but role-specific BEC controls and tenant-wide MFA are not evidenced. |
| Contractors and vendors | Legitimate accounts, service laptops and updates can bypass ordinary suspicion. | Effective MedTech/Siemens/Greenfield permissions, approval windows, MFA and revocation remain unresolved under GAP-011/GAP-016/GAP-021. |

The **internal surface is the greatest multiplier**: the external or human event may affect one account or endpoint, but broad reachability turns it into a possible EHR, identity, medical-device and recovery event.

## 6. Critical Attack Paths

### 6.1 Five Kill Chains and Defensive Break Points

| Chain | Actor, vector and sequence | Target and business consequence | Gaps | Highest-value break points |
|---|---|---|---|---|
| **KC1 — VPN to domain-wide ransomware** | Ransomware affiliate → usable VPN exploit → Windows foothold → credential theft → AD privilege → GPO deployment/recovery attack | AD A-040/A-041 and dependent services; authentication failure, clinical downtime, disclosure and extortion | GAP-015, GAP-011, GAP-016, GAP-007 | Verify edge remediation and require MFA at entry; replace `ALL` VPN services with allowlists; tier privileged administration and alert on credential/GPO changes; isolate and test AD/recovery copies. |
| **KC2 — unsafe pharmacy change** | Negligent administrator → legitimate maintenance → unreviewed script → shared pharmacy dataset → incorrect values | Pharmacy A-093; multi-site medication-integrity failure and loss of trusted service | GAP-002, GAP-022 | Individual least privilege; peer-reviewed ticket and representative testing; database constraints/canary deployment; known-good rollback and rapid independent dosage validation. |
| **KC3 — Radiology phish to PACS extortion** | Ransomware affiliate → vendor-themed phish → workstation foothold/shared session → PACS discovery → theft/encryption | PACS A-038; image disclosure and delayed diagnosis, including approximately 45 MRI studies/day | GAP-014, GAP-011, GAP-016, GAP-003 | Radiology-specific phishing controls; individual MFA-backed PACS sessions; permit only validated modality/management flows; isolated tested PACS recovery. |
| **KC4 — malicious insider to infusion pumps** | Privileged insider → legitimate or retained access → reusable device credential → flat-network enumeration → unauthorized fleet action | BD Alaris A-061–A-067 and fleet; configuration distrust, device isolation and potential treatment delay | GAP-018, GAP-011, GAP-016, GAP-001 | Named biomedical accounts and strong authentication; safely validate/rotate device credentials; allowlist management origins; alert and dual-authorize high-risk changes; test device-safe recovery. |
| **KC5 — compromised MedTech channel to EHR** | Nation-State APT → compromised vendor identity/update → ehr-srv-01 persistence → application-held DB identity → record collection/change | EHR A-036/A-111 and DB A-037/A-112; stealthy disclosure, false clinical information or containment outage | GAP-011, GAP-016, GAP-006, GAP-017 | Time-bound vendor PAM and signed updates; file-integrity/session review; restrict 5432 to the validated service identity/path; timely bulk-query and modification alerts. |

These chains show that the most reusable intervention points occur before the final objective: identity assurance, approved-flow enforcement, reviewed privileged changes and timely behavior monitoring. Recovery remains essential because prevention will not stop every path.

### 6.2 Most Connected Assets

T9 contains 39 evidence-supported vector-to-asset intersections. The three most connected assets each have seven viable vectors:

1. **EHR database A-037/A-112 — 7 vectors:** the #1 Critical asset combines Restricted information, treatment dependency and broad database/app trust.
2. **BD Alaris infusion-pump fleet — 7 vectors:** network, supplier, credential, insider and physical paths converge on a patient-safety function.
3. **Active Directory A-040/A-041 — 7 vectors:** compromise amplifies one account or endpoint into wider authentication, privilege and policy control.

PACS and other Medical IoT each follow at six vectors. Connectivity is not proof of successful exploitation; every path still requires usable authorization, a credential, a vulnerability or physical access.

### 6.3 Most Versatile Vectors

| Vector | Assets reached | Why it matters |
|---|---:|---|
| **Insider — Malicious** | 7 of 7 | Legitimate privilege and workflow knowledge bypass perimeter assumptions and can reach every assessed asset class. |
| **Insider — Negligent** | 7 of 7 | Routine access, unsafe changes, credential handling and unmanaged storage can expose every class without attacker-level tooling. |
| **VPN Exploit** | 6 of 7 | C-002's broad server-subnet permission and flat internal paths turn one remote-access failure into discovery of identity, clinical and device services. |

## 7. STRIDE Analysis Summary

### 7.1 EHR Deep Analysis

The EHR model covers ehr-srv-01 A-036/A-111, ehr-db-01 A-037/A-112, clinical workstations and their network connections. Twelve concrete threats—two in every STRIDE category—were identified:

| STRIDE category | Key MedDefense threats | Principal consequence | Relevant gaps |
|---|---|---|---|
| **Spoofing** | EHR-S1: stolen/unattended clinical session impersonates a clinician; EHR-S2: a false database endpoint impersonates ehr-db-01 | Unauthorized activity appears to come from a trusted person or system | GAP-011, GAP-006, GAP-016 |
| **Tampering** | EHR-T1: compromised update alters application logic; EHR-T2: direct PostgreSQL change bypasses application checks | False medication, history or result information can remain available and look trustworthy | GAP-022, GAP-006, GAP-016 |
| **Repudiation** | EHR-R1: action is denied after a shared/unattended session; EHR-R2: privileged intruder alters local evidence | Investigation cannot reliably establish who acted or what changed | GAP-011/GAP-014 for session accountability; GAP-017/GAP-016 for delayed or locally alterable evidence |
| **Information Disclosure** | EHR-I1: records extracted directly from PostgreSQL; EHR-I2: valid user exports data to unmanaged storage | Patient confidentiality loss that recovery cannot reverse | GAP-006, GAP-017, GAP-020 |
| **Denial of Service** | EHR-D1: ransomware disables production and reachable recovery; EHR-D2: internal requests exhaust application/database capacity | Clinicians lose timely records and fall back to weak paper workflows | GAP-007, GAP-006, GAP-016 |
| **Elevation of Privilege** | EHR-E1: application compromise obtains DB capability; EHR-E2: vendor maintenance exceeds intended scope | A limited foothold becomes database-level collection, alteration or disruption | GAP-006, GAP-011, GAP-016 |

**Tampering is the greatest EHR STRIDE risk.** An obvious outage can trigger downtime procedures, but a functioning EHR that silently presents false clinical information can influence care before staff recognize that the system is untrustworthy. Broad database reachability, conditional vendor update access, delayed audit review and incomplete change assurance make integrity validation as important as confidentiality and availability.

### 7.2 PACS, Active Directory and Network Surfaces

The repository contains a formal twelve-threat STRIDE inventory for EHR. The following are **STRIDE-informed system summaries** derived from First Watch, T7–T10 and the modeled paths; they are not represented as a missing separate STRIDE artifact.

| System | Top STRIDE threats | Evidence and gaps | Highest consequence |
|---|---|---|---|
| **PACS A-038** | Spoofing/Repudiation through a shared Radiology identity; Information Disclosure through image access/copying; Tampering/DoS through reachable SMB/DICOM services and ransomware | C-052 shared account, ports 445/4242/11112, flat network, no C-022 backup; GAP-011, GAP-016, GAP-003 | Stolen or altered images and unrecoverable imaging outage can delay diagnosis; MRI alone processes approximately 45 studies/day. |
| **Active Directory A-040/A-041** | Spoofing through stolen hashes; Elevation/Lateral Movement through pass-the-hash; Tampering through account/group/GPO changes; DoS through domain-wide ransomware | Expected AD ports broadly reachable, privileged credential residue modeled, local/reactive C-034 review; GAP-011/GAP-016/GAP-007 | Domain control can distribute impact across Windows services, identities and recovery access rather than one host. |
| **Network/core A-086/A-087/A-110** | Spoofing through stolen VPN/management identities; Tampering with routing/firewall/switch configuration; Information Disclosure through overbroad flows; DoS from destructive configuration or missing failover | C-002 permits `ALL` services, core management/redundancy unknown, exposed switch-stack credentials cannot be mapped to the core; GAP-004/GAP-015/GAP-016/GAP-021 | Loss or manipulation of shared connectivity can affect several clinical services and all intersite access simultaneously. |

## 8. Threat Scenarios

### 8.1 Board-Level Scenario Summary

| Scenario | Actor and initial vector | Attack summary | Assets affected | Business impact | Principal gaps |
|---|---|---|---|---|---|
| **S1 — Vendor Patch Lure to Hospital-Wide Extortion** | BlackReef-style RaaS affiliate; Fortinet-themed spearphishing | IT workstation compromise → persistence/discovery → privileged hash theft → AD movement → EHR/file theft → backup destruction → encryption | A-081, A-040/A-041, A-036/A-111, A-037/A-112, A-042, A-044/A-045/A-118 | **Clinical:** paper workflows and reconciliation risk. **Financial:** response, restoration and claims disruption. **Regulatory/reputational:** patient-data disclosure and loss of trust. | GAP-014, GAP-011, GAP-016, GAP-006, GAP-017, GAP-007 |
| **S2 — The Quiet Export Before Departure** | Malicious insider; legitimate access abused | Authorized EHR/billing login → record discovery → paced built-in exports → personal USB → local file deletion | A-036/A-111, A-037/A-112 and conditional billing A-113/A-123 | **Clinical/patient:** private histories can support coercion or fraud. **Financial/regulatory:** investigation, notification and claims. **Reputational:** loss of confidence in workforce access. No outage or record alteration is assumed. | GAP-017, GAP-020 |
| **S3 — Trusted MedTech Update, Hidden EHR Collection** | Nation-State APT; compromised vendor maintenance/update path | Supplier compromise → vendor token/key theft → trusted login → covert application component → DB identity discovery → low-volume collection/exfiltration | A-036/A-111, A-037/A-112, A-119 | **Clinical:** false/incomplete information or isolation downtime. **Financial:** forensic validation and vendor response. **Regulatory/reputational:** supplier-path patient-data compromise and trust failure. | GAP-011, GAP-016, GAP-022, GAP-006, GAP-017 |

The scenarios deliberately use different actors and primary vectors. S1 is the most likely and broadly disruptive; S2 requires the least technical capability; S3 is less likely but hardest to distinguish from legitimate maintenance and can undermine clinical integrity silently. Detailed sequences and detection opportunities appear in Appendix A.

## 9. Gap–Threat Correlation

### 9.1 Recalibration of First Watch Priorities

First Watch originally rated five gaps Critical, sixteen High and two Medium using asset impact, missing controls and exposure. Threat analysis added 31 explicit path-to-gap connections across five kill chains and three scenarios. The updated distribution is:

| Risk level | Original 1x00 | Threat-informed | Net movement |
|---|---:|---:|---:|
| Critical | 5 | 10 | +5 |
| High | 16 | 11 | −5 |
| Medium | 2 | 2 | 0 |
| Low | 0 | 0 | 0 |
| **Total** | **23** | **23** | — |

GAP-006, GAP-007, GAP-011, GAP-016 and GAP-017 moved from High to Critical because repeated paths connect them to the #1 asset, the highest-likelihood actor or several entry types. GAP-014 moved from Medium to High. GAP-019 moved from High to Medium because no selected path uses transport downgrade, the reported legacy TLS configuration is unverified and exploitation requires additional positioning; validation is still required. Sixteen gaps stayed at their original level.

### 9.2 The Critical Three

1. **GAP-016 — least-privilege boundaries: 6 paths.** KC1, KC3, KC4, KC5, S1 and S3 depend on broad or unverified VPN, intersite, internal or supplier reach. Closing it reduces blast radius regardless of entry vector.
2. **GAP-011 — identity and accountability: 6 paths.** The same six paths use stolen, shared, retained or vendor identities. Named access, lifecycle enforcement and strong MFA interrupt attacks early.
3. **GAP-017 — patient-record export controls: 4 paths.** KC5 and all three T14 scenarios depend on weak authorization or delayed detection of record collection. Closing it reduces ransomware, insider and espionage disclosure.

GAP-016 and GAP-011 tie for frequency; their ordering reflects T7's finding that the internal surface multiplies every foothold, not a material numerical difference. GAP-006 is the nearest runner-up with three paths.

### 9.3 The Surprise

**GAP-014 moved from Medium to High.** First Watch credited the existing training program, completion tracking and endpoint protection. Kill-chain analysis then showed the remaining weakness at the first step of two severe paths: a Radiology phish leading to unrecoverable PACS and an IT-targeted vendor-patch lure leading to hospital-wide ransomware. The new concern is not training completion alone; it is the absence of role-specific resistance for people whose ordinary work makes the pretext credible.

## 10. Prioritized Recommendations

### 10.1 Top Five Threats and Actions

| Rank | Threat and actor | Likelihood / impact / priority | Single key gap | Recommended action and effort |
|---:|---|---|---|---|
| 1 | Enterprise ransomware and double extortion — Ransomware Groups | High / Critical / **Critical** | **GAP-016** | **Short-term (6–12 weeks):** replace C-002's `ALL` VPN/server access with tested source/destination/protocol allowlists, separating AD, EHR and backup management paths. |
| 2 | Unsafe privileged change corrupts medication information — Insider (Negligent) | High / Critical / **Critical** | **GAP-002** | **Short-term (4–8 weeks):** require one pharmacy production gate with peer approval, representative testing, approved-dose comparison and demonstrated rollback. |
| 3 | Automated billing compromise becomes a foothold — Unskilled/Opportunistic Attacker | High / High / **High** | **GAP-008** | **Quick Win (up to 2 weeks):** formally contain billing-srv-01, preserve evidence, rebuild from known-good media, rotate service credentials and restore only documented flows. |
| 4 | Malicious insider exports EHR records — Insider (Malicious) | Medium / Critical / **High** | **GAP-017** | **Short-term (4–8 weeks):** require secondary approval above an agreed EHR export threshold and alert on cumulative per-user volume using timely A-119 events. |
| 5 | Compromised vendor access alters the EHR — Nation-State APT through MedTech | Low / Critical / **High, impact-driven** | **GAP-011** | **Short-term (6–12 weeks):** place MedTech maintenance behind ticket-linked PAM with named accounts, phishing-resistant MFA, time limits, recording and automatic closure. |

These actions connect one threat to one primary gap for accountability. They do not imply that adjacent gaps are irrelevant: ransomware also depends on identity, export and recovery; vendor compromise also depends on boundary, database and change controls.

### 10.2 Two-Initiative Strategic Recommendation

If MedDefense can fund only two initiatives next quarter, fund **(1) Least-Privilege Access Containment** to close GAP-016 and GAP-011 through approved-flow VPN/internal rules plus named, phishing-resistant-MFA, time-limited administrator and vendor sessions; those two gaps each appear in six of eight modeled paths and interrupt ransomware, insider and supplier movement near the beginning. Fund **(2) Clinical Data-Loss and Recovery Resilience** to close GAP-017 and reduce GAP-007 through timely EHR export/behavior alerts, an access-isolated immutable recovery copy and a full EHR restoration test; this limits all three data-theft scenarios and removes ransomware's strongest leverage after prevention fails. Pharmacy change control and billing containment should start under existing operational authority rather than wait for a larger platform purchase.

### 10.3 Connection to 1x02 Vulnerability Assessment

The next phase should convert conditional threat paths into verified technical findings without disrupting care. Prioritize these evidence questions:

1. **External exposure and version validation:** identify FortiGate firmware/listeners, portal/web builds, billing package support and the true Internet-facing surface before assigning CVEs or exploitability.
2. **Network-path validation:** confirm C-002 behavior, DMZ egress, guest isolation, approved EHR/PACS/medical-device flows and whether 5432/3306 are reachable from unnecessary sources.
3. **Identity and supplier review:** enumerate named/shared/stale accounts, MFA coverage, privileged-use locations, MedTech/Siemens transports and effective permissions; do not test live treatment-device credentials without biomedical/vendor approval.
4. **Host and application verification:** investigate billing persistence/root cause; confirm supported state for Ubuntu, Apache, print server and constrained MRI; validate portal authorization closure and EHR export functions.
5. **Recovery and detection testing:** verify immutable/offsite copies, perform full EHR/PACS/AD restoration exercises, measure audit delay and test alerts for privileged changes, bulk reads and backup deletion.

Testing must be authorized, evidence-preserving and clinically coordinated. Open ports, product labels or scanner signatures should generate validation work—not automatic exploitation—especially for pumps, MRI, pharmacy and other safety-relevant systems.

## Appendix A — Detailed Threat Scenarios

### A.1 External Ransomware — Vendor Patch Lure to Hospital-Wide Extortion

**Actor:** Ransomware Groups (Organized Crime), BlackReef-style RaaS affiliate. **Motivation:** financial gain through double extortion. **Primary vector:** Fortinet-themed spearphishing. **Surface:** human/IT, then internal. **Primary STRIDE effects:** Information Disclosure (EHR-I1) and Denial of Service (EHR-D1).

| Step | ATT&CK tactic/technique | Action and MedDefense dependency | Detection or prevention opportunity |
|---:|---|---|---|
| 1 | Reconnaissance — T1590.006 | Actor identifies the Fortinet dependency and Sarah Park's IT role. | Monitor brand/domain impersonation intelligence; require independent support-channel verification. |
| 2 | Initial Access — T1566.002 | Fraudulent support link and document reach WS-HQ-01 A-081. | Email URL/file detonation, domain-age checks and role-specific phishing practice. |
| 3 | Execution — T1059.001 | PowerShell stager creates a remote shell. | EDR process-chain and script-block alerts; automatic host isolation. |
| 4 | Persistence — T1053.005 | Windows Update-themed scheduled task restarts the foothold. | Central scheduled-task analytics and reviewed persistence alerts. |
| 5 | Discovery — T1018 | HQ path and flat Central network expose AD, EHR, files and backups to enumeration. | Internal network detection and deny-by-default intersite/server rules. |
| 6 | Credential Access — T1003.001 | A memory-resident `svc_backup` hash is extracted from the ordinary workstation. | LSASS protection, privileged-access workstations and administrative tiering. |
| 7 | Lateral Movement — T1550.002 | Pass-the-hash reaches ad-dc-01 A-040 and domain functions. | Real-time privileged authentication analytics and unusual-source blocking. |
| 8 | Collection — T1213.006 | EHR and file data are staged through privileged/reachable services. | Timely DB/EHR audit review, export approval and cumulative-volume thresholds. |
| 9 | Exfiltration — T1567.002 | Archived data leave over HTTPS to cloud storage. | Proxy/egress analytics, archive/tool detection and content-aware DLP. |
| 10 | Impact — T1490 | Reachable NAS recovery points and shadow copies are deleted. | Immutable/offline copies, separate backup identity and deletion alerts. |
| 11 | Impact — T1486 | Group Policy and separately obtained remote access distribute encryption. | High-risk GPO approval, mass-encryption detection and tested isolation/recovery. |

**Assets:** A-081, A-040/A-041, A-036/A-111, A-037/A-112, A-042 and A-044/A-045/A-118. **Gaps:** GAP-014, GAP-011, GAP-016, GAP-006, GAP-017 and GAP-007. **Business impact:** clinical record and shared-service outage; response/restoration and billing cost; patient-data breach assessment; reputational loss. The FortiGate is a trusted path/theme in this scenario and is not assumed compromised.

### A.2 Internal Exfiltration — The Quiet Export Before Departure

**Actor:** Insider (Malicious), extending T3's deliberate valid-account misuse pattern. **Motivation:** modeled financial gain. **Primary vector:** legitimate EHR access abused. **Surface:** human/internal. **Primary STRIDE effect:** Information Disclosure (EHR-I2).

| Step | ATT&CK tactic/technique | Action and MedDefense dependency | Detection or prevention opportunity |
|---:|---|---|---|
| 1 | Initial Access — T1078.002 | Specialist signs in with her authorized billing/EHR identity. | Purpose-of-use monitoring and manager-reviewed access recertification. |
| 2 | Discovery — T1083, closest fit | Accessible patient, insurance, diagnosis and prescription fields are surveyed. | Patient/task relationship analytics and unusual search-breadth alerts. |
| 3 | Collection — T1213.006 | Built-in export is used in repeated batches, avoiding one large event. | Near-real-time A-119 ingestion, cumulative per-user thresholds and secondary approval. |
| 4 | Exfiltration — T1052.001 | CSV files are copied to a personal USB device. | Endpoint device control and DLP with clinically governed exceptions. |
| 5 | Defense Evasion — T1070.004 | Local CSV files are deleted; the independent EHR audit trail should remain. | Central file/EDR telemetry correlated with immutable application audit events. |

**Assets:** A-036/A-111, A-037/A-112 and, if billing fields are combined, A-113/A-123. A-119 is a detection source, not assumed altered. **Gaps:** GAP-017 and GAP-020. **Business impact:** privacy harm, fraud/coercion risk, investigation/notification cost and loss of patient confidence; no clinical outage or record change is assumed.

### A.3 Third Party — Trusted MedTech Update, Hidden EHR Collection

**Actor:** Nation-State APT using MedTech as a stepping stone. **Motivation:** espionage. **Primary vector:** compromised vendor maintenance identity or update pathway. **Surface:** external third-party trust, then application-to-database. **Primary STRIDE effects:** EHR-T1, EHR-R2, EHR-I1 and EHR-E1/E2.

| Step | ATT&CK tactic/technique | Action and MedDefense dependency | Detection or prevention opportunity |
|---:|---|---|---|
| 1 | Initial Access — T1566.001/T1566.002 | A MedTech engineer or support environment is compromised outside MedDefense. | Contractual vendor MFA and incident-notification obligations; supplier-side response evidence. |
| 2 | Credential Access — T1552/T1539, conditional | Maintenance key, token or session is obtained; exact technique depends on the undocumented route. | Managed vendor identity, token revocation and phishing-resistant MFA. |
| 3 | Initial Access — T1133 | The valid vendor pathway reaches ehr-srv-01 during a plausible maintenance window. | Ticket-linked PAM, source allowlist, named account and recorded session. |
| 4 | Persistence — T1505 | A modified update or maintenance action installs a covert application component. | Signature verification, two-person approval, staging and file-integrity monitoring. |
| 5 | Defense Evasion — T1562.001 | Selected local events are suppressed or delayed while normal service continues. | Independent append-only logs and missing-event/heartbeat alerts. |
| 6 | Discovery — T1083 | Configuration and dependencies are inspected for a database service identity. | Secret vaulting and alerting on sensitive configuration access. |
| 7 | Lateral Movement — T1021 | A recovered application identity follows the approved dependency to PostgreSQL. | Restrict 5432 to the validated source/account and alert on deviations. |
| 8 | Collection — T1213.006 | Patient records are queried and staged in small batches. | Database activity monitoring and cumulative purpose/volume analytics. |
| 9 | Exfiltration — T1567 | Low-volume HTTPS or vendor-channel transfers remove staged records. | Egress allowlists, proxy analytics, DLP and post-maintenance transfer review. |

**Assets:** A-036/A-111, A-037/A-112 and A-119. **Gaps:** GAP-011, GAP-016, GAP-022, GAP-006 and GAP-017. **Business impact:** possible false clinical information, EHR isolation/downtime, patient-data disclosure, vendor/forensic cost and trust damage. This conditional chain requires usable application credentials; Task 5 does not establish vendor database or root privilege.

## Appendix B — Finding-to-Evidence Traceability

| Finding | Primary evidence | Framework confirmation | Gap/action linkage |
|---|---|---|---|
| Ransomware is the top threat | T0/T2 sector mechanisms; prior four-day claims outage; regional-hospital profile | T6 Rank 1, KC1/KC3, T14 S1, T16 Rank 1 | GAP-016; approved-flow segmentation and remote-access containment |
| Negligence can create Critical clinical harm | Incident C, shared sessions, personal NAS and unsafe credential handling | T3, T6 Rank 2, KC2, T16 Rank 2 | GAP-002/GAP-022; pharmacy change gate and rollback |
| Opportunistic compromise is already relevant | billing-srv-01 mining-configured process and performance symptoms | T1 pattern, T6 Rank 3, T8 vulnerable software, T16 Rank 3 | GAP-008; formal incident containment and rebuild |
| Internal reach is the main blast-radius multiplier | Flat Central network, C-002 `ALL` services, broad scan reachability | T7 internal-surface conclusion, T8 unsecure networks, four T10 chains | GAP-016; enforce approved internal/intersite flows |
| Identity failure is cross-cutting | Shared PACS login, limited MFA, retained/privileged/vendor account uncertainties | T6, KC1/KC3/KC4/KC5, T14 S1/S3, T15 six-path count | GAP-011; named MFA/PAM and lifecycle enforcement |
| Patient-data export is a common objective | Delayed EHR audit export and no evidenced bulk limits | EHR-I1/I2, KC5 and all T14 scenarios | GAP-017; timely cumulative export/query controls |
| EHR tampering is the greatest system-specific risk | Critical clinical use; DB reachability; vendor update and local logging conditions | EHR-T1/T2 and STRIDE summary; T14 S3 | GAP-006/GAP-022; DB allowlist, signed/reviewed changes and integrity monitoring |
| Recovery can be attacked with production | Local NAS, shared room/network, 14-day retention and partial restore test | KC1, T14 S1, T15 upgrade, T16 strategic initiative | GAP-007; immutable isolated copy and full restore exercise |
| PACS has high extortion impact | Shared account, reachable PACS services, explicit backup exclusion | T9 six vectors, KC3, STRIDE-informed PACS summary | GAP-003/GAP-011/GAP-016; individual access, isolation and recovery |
| Medical-device risk combines access and patient safety | Reachable pump interfaces, flat network, no device-specific monitoring/recovery | T9 seven pump vectors, KC4 | GAP-001/GAP-018; safe identity validation, allowlists, alerts and recovery |
| Training priority increased | 71% Central/58% Westside completion and no role-specific content | KC3 and T14 S1; T15 Medium→High surprise | GAP-014; role-specific phishing/support verification |
| Two initiatives offer greatest shared reduction | GAP-016/GAP-011 each in six paths; GAP-017 in four; ransomware targets recovery | T15 Critical Three and T16 strategic recommendation | Access containment; data-loss and recovery resilience |

## Appendix C — Assumptions, Qualifications and Rating Boundaries

- Network-scan results reflect internal reachability from the HQ scan position; they do not prove Internet exposure.
- A listening port, flat route or valid session does not by itself grant application or administrative authorization.
- No evidence confirms a vulnerable FortiGate build, an Apache entry into billing, unchanged pump defaults or a fleet-wide remote dose-change capability.
- MedTech maintenance access to ehr-srv-01 is documented, but its transport, database/root privilege, approval window and organization-wide reach are not.
- C-022 backups, C-017–C-021 workstation protection, local logs and manual checks are recognized as partial controls; the report does not relabel them absent.
- The supplied sector statistics have source/date/denominator limitations and support comparative prioritization, not numerical prediction.
- The repository contains a formal EHR STRIDE artifact but no separate supplied formal STRIDE artifact for PACS, AD or network; Section 7.2 is explicitly derived from documented surfaces and kill chains.
- Criticality describes credible business consequence; likelihood describes threat relevance; neither is a declaration of breach, actor attribution, legal noncompliance or guaranteed patient harm.
- Any live validation involving pharmacy, MRI, infusion pumps, PACS, EHR or core networking requires approved scope, clinical/biomedical ownership, a safe rollback plan and evidence preservation.
