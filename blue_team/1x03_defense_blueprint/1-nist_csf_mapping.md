# MedDefense Health Systems — NIST CSF 2.0 Current Profile

**Project:** 1x03 — Defense Blueprint | **Task:** 1 — The NIST CSF Mapping  
**Prepared for:** James Chen, Deputy CISO, and Sarah Park, IT Director  
**Assessment date:** 22 October 2026 | **Planning horizon:** Six months

## Purpose, scope and rating method

This is an **organization-level Current Profile**, informed by the three MedDefense assessments. It is not a certification, a NIST CSF Tier rating, or proof that recommendations have been deployed. The six functions and category IDs follow [NIST CSF 2.0, CSWP 29](https://doi.org/10.6028/NIST.CSWP.29). The four maturity labels below are the **DLH task's assessment scale**, not NIST's four Implementation Tiers.

| Level | Assessment rule |
|---|---|
| **Not Implemented** | No activity evidenced for the function. |
| **Partial** | Some activity exists, but coverage or execution is informal, inconsistent or incomplete. |
| **Managed** | Documented, repeatable activities cover most relevant assets and operations. |
| **Optimized** | Continuous, measured improvement is demonstrably operating. |

**Evidence standard:** The analyst-created asset inventory, threat chains, triage, patch briefing and validation plan are valuable **assessment outputs**, not proof that MedDefense already operates the corresponding controls. Described controls are counted only where current use is evidenced; proposed MRI safeguards CC-01–CC-04 and planned vulnerability rescans do not count as implemented. Absence of documentation is described as *not evidenced*, not automatically as proof of absence. Six-month targets are **proposals contingent on approval, procurement, clinical/vendor safety constraints and verification**, within the fixed **$120,000 program ceiling**; no control cost or risk reduction is asserted without a validated estimate.

## Executive Current-to-Target Profile

| CSF 2.0 Function | Current Level | Six-Month Target | Principal weakness |
|---|---|---|---|
| **GOVERN (GV)** | Partial | Managed | No demonstrated enterprise-wide security policy, risk appetite or accountable risk register |
| **IDENTIFY (ID)** | Partial | Managed | Newly constructed inventory not yet a proven continuous asset/risk process |
| **PROTECT (PR)** | Partial | Managed | Weak segmentation, legacy hosts and inconsistent identity/device protection |
| **DETECT (DE)** | Partial | Managed | Fragmented security telemetry; no evidenced unified 24/7 detection and triage |
| **RESPOND (RS)** | Partial | Managed | Ad-hoc response without demonstrated incident playbooks or rehearsals |
| **RECOVER (RC)** | Partial | Managed | Local-only, incomplete backups and insufficient restoration testing |

*The desired Managed target means repeatable coverage of the organization's prioritized clinical and business-critical services, with explicit exceptions for unsupported medical technology; it does not mean zero outstanding vulnerabilities. All targets require documented evidence and management review before being marked achieved.*

## 1. GOVERN (GV)

**Function:** Govern — organizational context (GV.OC), risk strategy (GV.RM), roles (GV.RR), policy (GV.PO), oversight (GV.OV) and supply-chain risk (GV.SC).  
**Current Level: Partial.**

**Evidence:** MedDefense has named leadership and decision paths: James Chen coordinates cybersecurity, Sarah Park runs IT, and the CEO/Board reviews security reports and has set a **$120,000** planning ceiling. Project 1x00 documented assets and weaknesses; 1x01 documented threat actors and vendor-linked kill chains; 1x02 prioritized exploitable findings for leadership. These indicate governance interest and emerging analysis, **not** a formally operating CSF program. The project context expressly reports no formally adopted framework. The MRI depends on vendor certification and maintenance; the threat landscape's KC5 describes risks arising from a compromised vendor maintenance channel.

**Key Gaps:** No demonstrated Board-approved risk appetite/tolerance, standard risk methodology or owner-maintained risk register; no evidenced security RACI, recurring management performance review, complete policy hierarchy or documented supplier security requirements. Without governance, a decision to defer the MRI/Alaris exposure may lack a named residual-risk owner. **Trace:** 1x00 **GAP-011** (weak individual accountability/MFA) → 1x02 **Findings 007/018** (AD identity exposure) → 1x01 **KC1** (VPN foothold to domain ransomware); **KC5** highlights the vendor-oversight dependency.

**Target Level: Managed (six months).** James Chen should sponsor a formally approved CSF Current/Target Profile, a documented risk-scoring and exception process, Board-defined patient-safety and data-loss tolerance, an owner and expiry for every accepted high risk, and a RACI assigning Sarah Park, Security, Biomedical and clinical/vendor stakeholders. Establish a monthly risk committee, quarterly Board dashboard and vendor-security review for critical service providers. **Acceptance evidence:** signed policies and RACI, dated risk register, meeting minutes, accountable exception approvals and repeatable KPI review. **Justification:** the Board can approve constrained spending against traceable patient-care risk rather than choosing tools without ownership or measurement.

## 2. IDENTIFY (ID)

**Function:** Identify — asset management (ID.AM), risk assessment (ID.RA), improvement (ID.IM).  
**Current Level: Partial.**

**Evidence:** Project 1x00 created an asset registry, dependency/data mapping, CIA criticality groups and a control/gap matrix. Projects 1x01 and 1x02 connected the assets to threats and the SecurePoint 31-finding scan. The asset inventory was a product of the recent assessment, **not evidence of a previously maintained enterprise inventory**. The vulnerability triage identifies an unregistered Linux server (`10.10.2.99`, Finding 028) and an undocumented Grafana device (`10.10.10.200`, Finding 029), proving discovery/authorization is incomplete. Project 1x00 identified **GAP-012**, covering undocumented internal devices and incomplete asset ownership, alongside **GAP-016**, which describes insufficiently verified least-privilege network boundaries.

**Key Gaps:** No verified continuous discovery, software/firmware inventory reconciled with asset owners, system-to-vendor dependency register, routine risk reassessment or closed-loop tracking of previously unknown devices. Multiple medical-device counts and version-to-CVE applicability claims require validation rather than assumption. **Trace:** 1x00 **GAP-012** (undocumented internal assets and missing ownership) → 1x02 **Findings 028/029** (unknown Linux server and undocumented Grafana host) → potential exposure relevant to 1x01 **KC1** (VPN foothold to domain-wide ransomware). **GAP-016** provides the related network trust-boundary weakness described in KC1 Steps 2–3. This is a modeled risk relationship, not evidence that either unknown device was compromised or used in an actual attack.

**Target Level: Managed (six months).** Sarah Park and asset owners should reconcile the registry against authorized discovery, DHCP/DNS, endpoint inventory, procurement and biomedical/vendor records; record location, owner, criticality, application, firmware, dependencies, support status and scan safety classification. Review exceptions and newly found assets monthly and after onboarding/change; tie each verified CVE to an asset owner and re-evaluate exposure when new KEV/vendor evidence arrives. **Acceptance evidence:** owner-signed inventory covering the prioritized estate; documented disposition of Findings 028/029; monthly inventory deltas; tracked vulnerability-to-asset assignments and closed improvement tickets. **Justification:** unowned devices and poorly matched product versions make risk estimates and remediation scheduling unreliable.

## 3. PROTECT (PR)

**Function:** Protect — identity and access control (PR.AA), awareness (PR.AT), data security (PR.DS), platform security (PR.PS), infrastructure resilience (PR.IR).  
**Current Level: Partial.**

**Evidence:** Existing controls include perimeter filtering (**C-002/C-003**), Sophos protection and quarantine on **some workstations** (**C-017–C-021**), restricted physical entry at defined locations, and a secondary AD controller (**C-050**). Coverage is uneven: servers and legacy medical devices are not shown to have equivalent endpoint protection; **15 Sophos endpoints are inactive/not reporting** (Finding 027). PostgreSQL on `ehr-db-01` permits overly broad internal connection attempts (Finding 003); the XP MRI controller is not adequately segmented (Finding 004); LDAP signing is not required (Finding 007); the Alaris pump management exposure remains urgent (Finding 010). The Alaris firmware-specific CVE assertion is contested and must be reconciled with the vendor, while management-credential exposure remains a separate risk. The MRI **CC-01–CC-04 controls are only proposed**.

**Key Gaps:** Internal least-privilege segmentation, legacy-platform containment, privileged access accountability and consistent patch/device-management coverage; training and data-transport safeguards are incomplete. **Trace:** 1x00 **GAP-006** (excessive database access) and **GAP-016** (insufficient network restrictions) → 1x02 **Finding 003** (broad PostgreSQL access) → 1x01 **KC5**, Step 3 (vendor-origin EHR access path). Separately, Finding 004 identifies legacy MRI exposure relevant to radiology security, while KC3 models a phishing-led attack against PACS. KC3 does not demonstrate exploitation of the MRI controller. **GAP-003** concerns PACS recovery and is primarily addressed under RECOVER.

**Target Level: Managed (six months).** Prioritize narrowly scoped database access and EHR AJP controls (Findings 003/031), phased default-deny segmentation around MRI/PACS and medical IoT with vendor-supervised workflow tests, verified identity hardening for AD and privileged administrators, restoration of Sophos reporting, and supported server patches. Keep essential device interfaces available; record time-bounded exceptions and compensating barriers where vendor-approved patches are impossible. **Acceptance evidence:** signed network allowlists and negative/positive access tests, EHR/PACS clinical sign-off, verified patch/build records, device-vendor approvals and sustained coverage reports. **Justification:** these measures break credible movement toward patient records and imaging services while respecting device safety; enterprise-wide Managed status is conditional on funded rollout and exception governance.

## 4. DETECT (DE)

**Function:** Detect — continuous monitoring (DE.CM) and adverse-event analysis (DE.AE).  
**Current Level: Partial.**

**Evidence:** Project 1x00 documents endpoint detections and quarantine by Sophos (**C-018/C-019**), limited network/perimeter logs (**C-004**), and local server/event logs. Therefore *Not Implemented* would incorrectly ignore existing detective activity. Nevertheless, Marcus's notes indicate essentially **no effective centralized security-monitoring capability**, and isolated logs are not evidence of consistent review, 24/7 coverage or actionable correlations. EHR audit exports have a reported **48-hour delay**; server and medical-device observability remains weak, and fifteen Sophos endpoints are not reporting.

**Key Gaps:** No evidenced centralized alert intake, agreed ownership/coverage, monitored medical-device boundaries, normalized timestamps, alert escalation SLA or detection exercises. **Trace:** 1x00 **GAP-001** (infusion pumps lack device-specific detection/recovery) → 1x02 **Finding 010** (medical-device management exposure) → 1x01 **KC4** (privileged misuse threatening infusion integrity and availability).

**Target Level: Managed (six months).** Security should deploy or configure an affordable central alert queue using existing tools where viable, onboard essential AD/VPN, EHR, database, firewall and backup log sources, restore endpoint sensor health and use **passive/vendor-approved** monitoring for MRI and pumps. Specify on-call ownership, detection scenarios matched to KC1/KC3/KC4/KC5, escalation thresholds and a monthly alert rehearsal. **Acceptance evidence:** documented source coverage and freshness, alert test tickets, owner acknowledgement timestamps, a monitoring dashboard and recurring tuning reviews. **Justification:** finding a foothold before it reaches AD or clinical systems is meaningful only when an alert produces timely action; no 24/7 SOC is presumed funded.

## 5. RESPOND (RS)

**Function:** Respond — incident management (RS.MA), analysis (RS.AN), reporting/communication (RS.CO) and mitigation (RS.MI).  
**Current Level: Partial.**

**Evidence:** MedDefense has responded to security events, including website defacement and billing-server trouble; Project 1x00 records **C-048 (ad-hoc billing response)** and service-restart actions **C-047**, but not a fully documented repeatable incident response capability. A previous ransomware incident disrupted insurance claims for four days; the total incident response duration is not established by the available evidence. The new 1x02 triage and Task 23 validation plan **propose** decision and escalation processes; they are not evidence of completed response drills or deployed automation.

**Key Gaps:** No demonstrated cross-site incident severity matrix, approved playbooks, evidence preservation procedures, incident commander roster, clinical safety escalation, vendor isolation authority or reporting/communications exercises. **Trace:** 1x00 **GAP-011** (shared identities and limited MFA) → 1x02 **Findings 007/018** (AD identity weaknesses) → 1x01 **KC1** (domain-wide ransomware). A response must preserve clinical continuity while containing compromised credentials and endpoints.

**Target Level: Managed (six months).** James Chen should approve a severity-driven incident response plan and RACI; Sarah Park, Security, Legal/Privacy, Biomedical and clinical leadership should rehearse coordinated playbooks for **KC1 ransomware, KC3 PACS disruption, KC4 infusion-pump tampering and KC5 EHR exfiltration**. Define evidence-handling, access revocation, network isolation boundaries, incident notification criteria and vendor escalation. **Acceptance evidence:** signed runbooks/contact tree, at least one documented cross-functional tabletop and follow-up actions, test alert-to-ticket escalation, and recorded management approval for clinically sensitive containment. **Justification:** the earlier improvised response demonstrates that reaction alone is not a repeatable capability.

## 6. RECOVER (RC)

**Function:** Recover — incident recovery plan execution (RC.RP) and recovery communication (RC.CO).  
**Current Level: Partial.**

**Evidence:** **C-022** confirms scheduled backups for selected servers, and **C-023** provides RAID5 redundancy at the NAS; neither ensures ransomware-resistant recovery. Current backups are **local-only** and omit at least PACS. **C-024** documents a limited `file-srv-01` restore test approximately eight months earlier; **C-042** records restoration of a defaced website in about two hours. During an EHR interruption, clinicians used a weak paper-based fallback (**C-043**). These establish some restoration activity, not a tested full clinical recovery program.

**Key Gaps:** No documented protected/offsite copy for PACS, unverified EHR/database and AD end-to-end restores, no approved RTO/RPO based on patient-care dependencies, no demonstrated recovery order or tested clinical data reconciliation. **Trace:** 1x00 **GAP-003** (PACS lacks documented recovery copy) → 1x02 **Finding 004** (legacy radiology controller exposure) → 1x01 **KC3** (PACS extortion/encryption). The finding and kill chain affect a shared imaging service dependency, not necessarily the same host.

**Target Level: Managed (six months).** IT Ops and Biomedical should prioritize isolated/immutable or offsite recovery copies for EHR, AD and PACS, define application-specific RTO/RPO with clinical owners, test representative restores of **data plus usable service**, and rehearse an MRI/PACS downtime and image-reconciliation procedure. Assign crisis communications and recovery sign-off to Management and the affected clinical owner. **Acceptance evidence:** dated backup coverage report, protected-copy verification, test restoration results, documented RTO/RPO and exception register, revised runbooks and clinical sign-off. **Justification:** an accessible backup file is not equivalent to timely restoration of patient care, and RAID is not an offsite backup.

## Traceability: why these are MedDefense priorities

| Business exposure | 1x00 gap / existing-control evidence | 1x02 vulnerability or weakness | 1x01 threat scenario | Functions driven |
|---|---|---|---|---|
| Domain-wide ransomware | GAP-011; weak identity governance | Findings 007 and 018, AD authentication configuration | KC1 — VPN foothold → AD → ransomware | GV, PR, DE, RS |
| Patient-record exposure | GAP-016; broad internal trust | Finding 003, EHR database reachable across `/16` | KC5 — compromised maintenance channel → EHR data | ID, PR, DE |
| Imaging disruption/extortion | GAP-003; C-022 excludes PACS | Finding 004, unsegmented legacy MRI controller | KC3 — radiology foothold → PACS extortion | PR, RS, RC |
| Unsafe medical-device management | GAP-001; lack of pump-specific detective/recovery proof | Finding 010, urgent vendor/credential verification | KC4 — insider abuse → Alaris integrity/availability | GV, DE, RS |

The links above are **risk-path relationships**, not claims that the observed findings prove a successful real-world attack. Where a CVE/version association is contested, the vulnerable build must be confirmed before remediation is marked complete.

## Six-month implementation and verification gates

| Period | Proposed governance and technical milestone | Owner / proof of completion |
|---|---|---|
| **Month 1** | Approve CSF profile and risk owners; validate high-priority findings, shadow devices and medical-device firmware; initiate safe MRI/EHR barriers | James Chen, Sarah Park, Biomedical; signed approvals, baseline and clinical validation |
| **Months 2–3** | Launch live asset reconciliation, approved boundary changes, endpoint sensor repair, central critical-event intake and critical-service backup design | IT Ops + Security; reconciled inventory, rules/tests, telemetry samples, purchase estimates |
| **Months 4–5** | Expand prioritized protection and monitoring, complete vendor-led IoT verification, deploy protected backups and rehearse incident/recovery playbooks | Security, IT Ops, Biomedical + vendors; tickets, alert exercises, restore records |
| **Month 6** | Reassess all six functions, review residual risk and approved exceptions, compare objective evidence with Managed criteria and present the next gap-closure plan | James Chen + management; updated Current/Target Profile, metrics, Board record |

**Funding gate:** This initial maturity profile **does not allocate or spend** the approved $120,000. The subsequent blueprint must price every proposed control, show quantitative risk assumptions and control dependencies, and select an affordable portfolio before implementation. Do not claim that all six functions have reached Managed without the above acceptance evidence.

## Evidence and reference index

- **NIST:** [Cybersecurity Framework 2.0 (NIST CSWP 29)](https://doi.org/10.6028/NIST.CSWP.29), Core functions and category identifiers; [NIST CSF resource center](https://www.nist.gov/cyberframework).
- **1x00 — posture assessment:** [Asset Registry](../1x00_first_watch/7-asset_registry.md), [Criticality Assessment](../1x00_first_watch/8-criticality_assessment.md), [Complete Control Matrix](../1x00_first_watch/10-complete_control_matrix.md), [MRI Compensating Controls](../1x00_first_watch/6-compensating_controls.md).
- **1x01 — threat landscape:** [Kill Chains](../1x01_know_your_enemy/10-kill_chains.md) (KC1–KC5, referenced 1x00 gaps).
- **1x02 — vulnerability assessment:** [Triage](../1x02_the_weak_links/16-triage.md) (Findings 001–031), [Environmental Prioritization](../1x02_the_weak_links/17-cvss_contextualizer.md), [Patch Briefing](../1x02_the_weak_links/22-patch_briefing.md), [Validation Plan](../1x02_the_weak_links/23-validation_plan.md).

**Assessment conclusion:** Every CSF function has at least some demonstrated activity, but none has evidenced enterprise-wide documented, repeatable and measured execution. **Partial across six functions** is therefore the defensible starting profile; achieving **Managed** requires tested controls, reliable owners and operational proof—not simply more assessment documents.
