# MedDefense Health Systems — Security Strategy Document

**Board decision paper | Project 1x03 — Defense Blueprint | Task 17 (Capstone)**  
**Assessment baseline:** 29 October 2026 | **Planning horizon:** Six months from authorized kickoff  
**Prepared for:** MedDefense Board, CEO, Robert Kim (CFO), James Chen (Deputy CISO), Sarah Park (IT Director), Clinical Leadership and Data Protection Officer  
**Status:** **PROPOSED FOR REVIEW — NOT APPROVED, FUNDED OR IMPLEMENTED**  
**Related intelligence package:** [1x00 Security Posture](../1x00_first_watch/), [1x01 Threat Landscape](../1x01_know_your_enemy/), [1x02 Vulnerability Assessment](../1x02_the_weak_links/) and this 1x03 strategy

> **Interpretive rule:** This document synthesizes already assessed evidence and proposed decisions. *Current* means evidenced at the assessment baseline; *target* means contingent on purchasing, configuration, clinical safety review, testing and explicit authorization. T15's hypothetical assumption that five controls were already deployed applies only to that red-team exercise. No proposed risk acceptance, cost saving, maturity improvement or mitigation is presented as achieved.

---

## 1. Executive Summary

**Current risk posture.** MedDefense has a **Critical overall risk posture for Board attention**: the flat/trust-permissive network and broad VPN-to-server access enable ransomware movement, while uneven endpoint protection, fragile clinical workflows and incomplete independent recovery threaten patient care. The Risk Register includes **RISK-007 at 20/25 (Critical)** and numerous High risks; existing safeguards are fragmented, particularly across EHR access, AD, PACS/MRI, infusion devices and patient-data handling. A numeric score does not supersede the duty to prevent foreseeable medication and device harm.

**Strategic response.** Adopt **NIST CSF 2.0** as the leadership and Current-to-Target Profile, **CIS Controls v8** as the practical safeguard baseline (IG1 first, targeted IG2), and **ISO/IEC 27001-aligned** governance records, without claiming certification. Deliver a staged, risk-led program governed by signed risk ownership, least-privilege access, clinically tested segmentation, actionable monitoring and recoverable data; retain time-bounded exceptions only when authorized and safe.

**Investment requested for conditional approval:** **C2 MFA $11,000 + C1 segmentation $30,000 + C3 Wazuh $22,000 + C4 immutable offsite backup $21,000 + C6 Westside firewall $13,000 = $97,000 annualized.** Upfront treatment of C1/C6 hardware increases the illustrative **year-one cash requirement to $115,000**, leaving **only $5,000** against the separate **$120,000 total six-month program cash ceiling**, *before* unpriced governance, licensing, vCISO, DPO, clinical/vendor and other obligations. **Do not authorize all purchases on this estimate alone:** require a consolidated six-month cash-flow and vendor-quote gate. The portfolio's **$785,000/year sum of conditional marginal ALE-reduction selection scores** is for Task 7/8 comparison; correlated events, modeled probabilities and unvalidated controls mean it is **not guaranteed annual savings or additive enterprise risk reduction**.

**Top three executive actions:**

1. **Protect identity and stop avoidable lateral movement:** assign owners; rapidly close stale VPN/privileged access; verify licensing and phase in **C2 MFA**, **C1 zone enforcement** and **C6 Westside firewall**, including authorized EHR/AD/clinical traffic.
2. **Preserve patient-care availability:** require two-person pharmacy dose-change approval immediately; implement vendor-approved MRI/pump safeguards; verify **C4 protected PACS/EHR/AD/billing backups and full clinical recovery**, without interrupting live medical devices.
3. **Close visibility and privacy blind spots:** restore 15 silent Sophos agents, start controlled EHR export review, test USB restrictions, deploy **C3 Wazuh** with named alert owners; commission a separate DPO-approved export/role-access and clinical-training workstream.

**Board decision requested:** endorse the strategic direction and risk appetite *in principle*; authorize discovery/quotes and controlled quick wins; require a signed six-month cash plan, clinical and privacy safety gates, and milestone-based releases before procurement. Keep the residual **Critical** exposure visible until verified controls and separate patient-data/insider measures justify a new rating.

---

## 2. Governance Framework

### 2.1 Framework selection and method — T0

| Layer | Selection and reason | How success will be proved |
|---|---|---|
| **Strategic outcomes: NIST CSF 2.0** | Six functions (Govern, Identify, Protect, Detect, Respond, Recover) create a common Board risk language and evidence-based Current/Target Profiles appropriate to a regional healthcare organization. | Approved profiles; accountable function owners; category-level closure evidence and Board reviews. |
| **Implementation: CIS Controls v8** | 18 prioritized control families translate gaps into actionable identity, configuration, backup, monitoring and testing safeguards. Start with IG1; apply selected higher-impact safeguards based on clinical risk. | Applicable safeguard list, owners, approved changes and repeatable positive/negative verification; no certification claim. |
| **Assurance: ISO/IEC 27001-aligned management** | Risk assessment, policies, supplier oversight, management reviews, exception expiry and evidence retention build disciplined governance without buying an ISO certification project under this budget. | Signed RACI, versioned policies, review minutes, treatment/acceptance register, corrective-action records and supplier approvals. |

The strategy follows **asset and data criticality (1x00) → threat actors and five kill chains (1x01) → observed findings/exploitability context (1x02) → gap-to-framework mapping, quantitative modeling, prioritized treatments, safe validation and monitoring (1x03)**. NIST profile ratings are *DLH assessment labels*, not official CSF Implementation Tiers; CIS ratings are at **whole-Control level**, not a 153-safeguard audit.

### 2.2 NIST CSF Current vs. Target Profile — T1

| CSF 2.0 function | Current baseline | Six-month target | Priority delivery / required proof |
|---|---|---|---|
| **GOVERN (GV)** | **Partial** | **Managed** | CEO-approved accountability, risk appetite, AUP and risk-review cadence; signed exceptions. |
| **IDENTIFY (ID)** | **Partial** | **Managed** | Reconciled EHR, medical-device, intersite, vendor and shadow-IT asset/owner inventory; repeatable risk updates. |
| **PROTECT (PR)** | **Partial** | **Managed** | Tested MFA, restricted interzone/DB access, controlled privileged paths and minimum vendor-safe medical protections. |
| **DETECT (DE)** | **Partial** | **Managed** | Wazuh log-source coverage, EHR export oversight, defined detection rules and measured human response. |
| **RESPOND (RS)** | **Partial** | **Managed** | Named incident commander, clinical/IT runbooks, tabletop, after-hours escalation and evidence preservation. |
| **RECOVER (RC)** | **Partial** | **Managed** | Independent protected backups, app-consistent PACS/EHR/AD/billing restores, approved clinical RTO/RPO and exercises. |

**Target is ambitious and conditional.** A function may remain Partial at Month 6 if scope, staff capacity, testing, vendor permission or funding is insufficient; no blanket assertion that six Managed levels have been reached. Patient-safe exceptions must be documented rather than concealed.

### 2.3 CIS Controls v8 maturity scorecard — T2

**Baseline:** **0 Implemented (0.0%), 15 Partial (83.3%), 3 Not Implemented (16.7%)** across 18 whole Controls. The three un-evidenced controls are **9 Email/Web Browser Protections, 16 Application Software Security and 18 Penetration Testing**. This is not a compliance percentage and does not mean all safeguards inside a Partial control are working.

| CIS Control | Baseline | CIS Control | Baseline |
|---|---|---|---|
| 1 Enterprise Asset Inventory | Partial | 10 Malware Defenses | Partial |
| 2 Software Asset Inventory | Partial | 11 Data Recovery | Partial |
| 3 Data Protection | Partial | 12 Network Infrastructure Management | Partial |
| 4 Secure Configuration | Partial | 13 Network Monitoring and Defense | Partial |
| 5 Account Management | Partial | 14 Security Awareness/Skills | Partial |
| 6 Access Control Management | Partial | 15 Service Provider Management | Partial |
| 7 Continuous Vulnerability Management | Partial | 16 Application Software Security | **Not Implemented** |
| 8 Audit Log Management | Partial | 17 Incident Response Management | Partial |
| 9 Email and Web Browser Protections | **Not Implemented** | 18 Penetration Testing | **Not Implemented** |

**Priority order established in T2:** **CIS 6 → 12 → 11 → 7 → 13**, with dependencies on asset inventory (1), accounts (5), logs (8), malware defenses (10) and response (17). Reassess all 18 controls after six months; do not silently change baseline ratings because a plan exists.

### 2.4 Governance and decision rights — T4

| Role | Board-ready accountability | Decision/evidence gate |
|---|---|---|
| **Board / CEO** | Set appetite; approve policy and security expenditure; **CEO accountable for high/critical risk acceptance** in the proposed RACI; Board oversight or reserved approval for material exposure. | Signed charter, spending/exception decisions and meeting minutes; no implicit acceptance by silence. |
| **James Chen, Deputy CISO** | Own security strategy, priorities, risk recommendations, incident response oversight and monthly reporting. | Risk-register approvals, remediation priorities, detection SLAs, independent evidence review. |
| **Sarah Park, IT Director** | Own technical change delivery: MFA, firewall/segmentation, Wazuh integration, backup execution, vulnerability remediation. | Change tickets, inventory, clinical rollback plans and positive/negative tests. |
| **Robert Kim, CFO** | Challenge estimates, control budgets, cash scheduling and revenue-continuity exposure (RISK-008). | Consolidated cash authorization; no duplicate spend or unpriced commitment. |
| **Clinical, Radiology, Chief Pharmacist and Biomedical leadership** | Own patient-safety and workflow impacts of MRI, PACS, pump and dosage changes. | Clinical/vendor safe-change approval, supervised testing, downtime readiness, escalation. |
| **DPO / Legal / HR / Procurement / vendors** | Privacy obligations, patient-record authorization, lawful monitoring, staff training, supplier contract assurance. | DPO sign-off, retention rules, controlled exceptions, vendor evidence and contract review. |

The vacant CISO role and available analyst time require explicit scope and contingency plans; a vCISO or extra staff is **not assumed paid** inside the $97,000 controls portfolio. Maintain monthly risk dashboards, quarterly Board review and urgent out-of-cycle clinical/privacy escalation. Only the CEO can approve the proposed high residual-risk exceptions after evidence, with the Board engaged as required.

---

## 3. Quantitative Risk Analysis

### 3.1 Top five modeled annualized loss exposures — T5/T6

The five **Task 6 quantitative scenarios** are listed in descending **baseline Annualized Loss Expectancy (ALE)**. They are *not five independent MedDefense losses*: R2 VPN-to-domain ransomware already includes downstream EHR/billing impacts; the scenario probabilities, severities and assumptions are illustrative. This is a comparative teaching model, not an actuarially validated forecast.

**Calculation ledger (T5/T6, illustrative and not independently additive):** `SLE = Asset Value (AV) × Exposure Factor (EF)`; `ALE = SLE × Annualized Rate of Occurrence (ARO)`. Task 6 uses modeled event-specific loss pools rather than market valuations of the entire hospital. The exact EF ratios below avoid rounding error.

| Event | AV and EF assumption → SLE per event | ARO/year | Baseline ALE calculation |
|---|---|---:|---|
| **R1 EHR breach** | $9,075,000 × 1.00 = **$9,075,000** | 1/3 | $9,075,000 × (1/3) = **$3,025,000/y** |
| **R2 VPN/AD ransomware** | $13,460,000 × ($9,548,000/$13,460,000) = **$9,548,000** | 0.30 | $9,548,000 × 0.30 = **$2,864,400/y**; full-campaign assumption `q=1` |
| **R3 negligent disclosure** | $120,000 × 1.00 = **$120,000** | 2.5 | $120,000 × 2.5 = **$300,000/y** |
| **R4 billing outage** | $4,385,000 × ($473,000/$4,385,000) = **$473,000** | 1/3.5 | $473,000 ÷ 3.5 = **$135,142.86/y** |
| **R5 Alaris pumps** | DoS: $205,000 × ($100,000/$205,000) = **$100,000**; clinical harm: $5,250,000 × ($3,000,000/$5,250,000) = **$3,000,000** | 0.10; 0.02 | ($100,000 × 0.10) + ($3,000,000 × 0.02) = **$70,000/y**, on the T6 nonoverlapping-event assumption |

**Portfolio scenario arithmetic (T7/T8, not the bundled T6 residual scenarios):** R1 $3,025,000 − $90,000 = **$2,935,000**; R2 $2,864,400 − ($310,000 + $240,000 + $35,000 + $65,000) = **$2,214,400**; R3 **$300,000** unchanged; R4 $135,142.86 − $45,000 = **$90,142.86**; R5 **$70,000** unchanged. These T7 marginal reductions are selections used for comparing controls, **not observed changes in ARO/EF**.

| Rank | Task 6 event / relevant Task 10 register | Baseline ALE/year | Modeled post-**T8 selected controls** ALE/year | Interpretation |
|---|---|---:|---:|---|
| **1** | R1 EHR breach / **RISK-001** | **$3,025,000** | **$2,935,000** | C3's allocated R1 marginal score of $90,000; not a complete fix of export authorization. |
| **2** | R2 VPN → AD ransomware / **RISK-002** | **$2,864,400** | **$2,214,400** | Sequential C2/C1/C6/C3 allocated marginal score of $650,000; original full-campaign probability assumes `q=1`. |
| **3** | R3 negligent insider disclosure / **RISK-007** | **$300,000** | **$300,000** | No independently credited T8 DLP/export/training treatment; T13 pilot does not establish reduction. |
| **4** | R4 billing ransomware / **RISK-008** | **$135,143** | **$90,143** | Conditional C4 $45,000 improvement if backup and full restore are proven. |
| **5** | R5 BD Alaris pump event / **RISK-004** | **$70,000** | **$70,000** | C8 full package deferred; minimum clinical safeguards are mandatory but unquantified. |

**Do not add columns to state one enterprise ALE.** T6 also explored *different bundled-control scenarios* with other after-control values; the table above uses **only T7/8 marginal allocations** for consistency. **NQ = not quantified, not zero** for pharmacy, PACS, MRI, Westside and the print server. Patient injury and clinical downtime must not be prioritized solely by the five dollar figures.

### 3.2 Risk Register — T10 (all ten open at baseline)

| Risk | Event / consequence | Inherent L×I | Target after validation | Baseline ALE | Treatment recorded in T10 |
|---|---|---:|---:|---:|---|
| **RISK-001** | EHR exfiltration, privacy harm | **15 High** | **15 High** | $3,025,000/y | **Mitigate** |
| **RISK-002** | VPN/AD domain-wide ransomware | **15 High** | **15 High** | $2,864,400/y | **Mitigate** |
| **RISK-003** | PACS outage; unproven independent recovery | **15 High** | **12 High** | **NQ** | **Mitigate** |
| **RISK-004** | Alaris pump unauthorized management / care interruption | **15 High** | **15 High** | $70,000/y | **Mitigate** |
| **RISK-005** | Incorrect pharmacy dosage data | **15 High** | **10 High** | **NQ** | **Mitigate** |
| **RISK-006** | Unsupported XP MRI controller / PACS pivot | **15 High** | **10 High** | **NQ** | **Mitigate** |
| **RISK-007** | Negligent insider patient-information disclosure | **20 Critical** | **20 Critical** pending new work | $300,000/y | **Mitigate** |
| **RISK-008** | Billing ransomware / revenue outage | **12 High** | **9 Moderate** | $135,143/y | **Mitigate** |
| **RISK-009** | Westside weak perimeter and shadow IT | **12 High** | **8 Moderate** | **NQ** | **Mitigate** |
| **RISK-010** | Unsupported print server / privileged pivot | **12 High** | **8 Moderate** | **NQ** | **Mitigate** |

**Cross-project evidence chain (T10):** A numbered scan finding is cited only where it actually supports the risk; *adjacent* means relevant context rather than direct proof. Gaps come from 1x00, threat pathways from 1x01, and findings from 1x02.

| Risk | 1x00 gap(s) | 1x02 finding(s) / evidence limitation | 1x01 threat link |
|---|---|---|---|
| RISK-001 | GAP-006, GAP-017 | 003 direct; 031 applicability disputed | KC5 vendor → EHR |
| RISK-002 | GAP-011, GAP-016 | 007/018 supporting; 003 downstream; no proven VPN CVE | KC1 VPN → AD ransomware |
| RISK-003 | GAP-003, GAP-007 | 004/024 adjacent; missing PACS backup evidenced in 1x00 | KC3 Radiology → PACS |
| RISK-004 | GAP-001, GAP-016 | 010 management exposure; firmware CVE disputed | KC4 insider → Alaris |
| RISK-005 | GAP-002, GAP-022 | **No direct numbered finding**; 1x00 pharmacy incident/control C-044 | KC2 unsafe authorized dosage change |
| RISK-006 | GAP-016 | 004 legacy Windows XP MRI | KC3 adjacent clinical pivot |
| RISK-007 | GAP-017, GAP-011 | 023 USB exposure supporting; no demonstrated negligent event | 1x01 insider scenario S2 *adjacent, intentional rather than negligent* |
| RISK-008 | GAP-007, GAP-016 | 001/002 Apache chain; 015 backup exposure supporting | KC1-compatible parallel foothold, not named KC1 step |
| RISK-009 | GAP-016 and undocumented-asset ownership | 014 router; 029 Grafana host | KC1-compatible site-to-domain pivot |
| RISK-010 | GAP-016 and legacy lifecycle | 008 print-service exposure | KC1-compatible lateral pivot |

**Scales:** Likelihood 1–5 × Impact 1–5; **Low 1–4**, **Moderate 5–9**, **High 10–15**, **Critical 16–25**. The targets are *not observed current residual scores*. Critical patient-safety vulnerabilities remain escalation priorities even where the numerical score is 10–15. Validate Finding 031's reported Tomcat/Ghostcat version applicability and Finding 010's device-firmware/CVE linkage before describing those disputed CVEs as verified; the underlying access restrictions and legacy support problems do not depend on those attributions.

### 3.3 Board risk appetite — T16

> The MedDefense Board proposes **low overall cyber and clinical risk appetite**, ordinarily allowing acceptance only of **Low or Moderate residual risks** after evidenced controls and review. **Foreseeable uncontrolled patient injury, unsafe medication dosing, interruption of critical care, unlawful patient-data disclosure and mandatory-duty breaches cannot be accepted merely to save money.** High residual exposure requires a **specific time-limited CEO-signed exception** with James Chen's recommendation, accountable owner, compensating controls and Board/Clinical/DPO oversight as applicable. Critical residual risk is **outside normal appetite**, requiring urgent CEO/Board escalation and treatment rather than routine acceptance. Every exception has a measurable KRI, expiry, monthly review and immediate reopening trigger.

**Decision status:** This wording is **proposed**, not yet adopted by the Board; no risk is automatically accepted. The operational register remains *Mitigate* until the requisite signed exception is filed.

---

## 4. Control Strategy

### 4.1 Cost-benefit comparison — T7

| Control | Annualized cost | Modeled marginal ALE reduction/year | Modeled net/year | T8 decision |
|---|---:|---:|---:|---|
| **C1 — Network segmentation** | $30,000 | $240,000 | +$210,000 | **Select, conditional** |
| **C2 — VPN/admin MFA** | $11,000 | $310,000 | +$299,000 | **Select, conditional** |
| **C3 — Wazuh SIEM** | $22,000 | $155,000 | +$133,000 | **Select, conditional** |
| **C4 — Immutable offsite backup** | $21,000 | $45,000 | +$24,000 | **Select, conditional** |
| **C5 — Full Sophos EDR estate upgrade** | $41,000 | $43,000 | +$2,000 | **Defer full rollout** |
| **C6 — Westside managed firewall** | $13,000 | $35,000 | +$22,000 | **Select, conditional** |
| **C7 — Outsourced staffed 24/7 SOC** | $185,000 | $80,000 | −$105,000 | **Reject this scope** |
| **C8 — Full medical-device isolation/monitoring** | $44,000 | $35,000 | −$9,000 | **Defer full package; safety minimum now** |

The costs are **annualized assumptions** and benefits are **conditional marginal selections**, not independently measured ROI. Deferring C5 forgoes a *modeled potential* $43,000/year marginal improvement, C8 a $35,000/year marginal improvement, and rejecting C7 a modeled $80,000/year improvement at a much higher cost; none is an acceptable reason to neglect immediate medically necessary safeguards or replace tested controls with untreated exposure.

### 4.2 Recommended allocation, affordability and release decision — T8

| Selected control | Role in the risk strategy | Annualized |
|---|---|---:|
| **C2 MFA** | Restrict VPN and privileged-identity abuse (KC1). | **$11,000** |
| **C1 segmentation** | Enforce least-privilege clinical/AD/database/medical zones (KC1/3/4/5). | **$30,000** |
| **C3 Wazuh** | Correlate AD, VPN, EHR, PACS and network alerts with a named analyst. | **$22,000** |
| **C4 protected backup** | Independent, tested recovery for billing, AD, EHR and scoped PACS. | **$21,000** |
| **C6 Westside firewall** | Remove weak branch perimeter and validate intersite flows. | **$13,000** |
| **Five-control model** | **$785,000/y sum of marginal selection scores, not enterprise savings.** | **$97,000/y** |

**Critical two-basis finance check:** Annualized selection **$97,000** vs Task 7 comparison ceiling **$120,000** leaves **$23,000 annualized arithmetic headroom**. C1's $18,000 infrastructure and C6's $9,000 appliance, instead of their combined $9,000 annualized depreciation charges, make **$97,000 − $9,000 + $27,000 = $115,000 illustrative first-year cash**; **$5,000** remains under the **total $120,000 six-month program cash ceiling** *only if those cash estimates and timing apply*. Unknown MFA entitlements, licensing, six-month staffing, privacy/legal, vCISO, clinical vendor charges, incident readiness and any other controls can consume or exceed that balance. No Board authorization for an unaffordable or duplicated program is implied.

**Release gates:** (1) Robert Kim and Procurement reconcile real six-month expenditure, payment dates, funding source and quotes; (2) James and Sarah validate identity entitlements, network hardware, Wazuh compute/storage/analyst capacity and S3 immutability/retrieval; (3) Medical/Radiology/Pharmacy leaders approve all patient-impacting workflows; (4) CEO/Board approve the complete staged financial and risk plan. If full-program cash exceeds the cap, **re-scope/reprice before contracting**. The T8 lower-cost alternative C2+C1+C3+C6 ($76,000 annualized; $94,000 illustrative cash) *defers C4 and sacrifices $45,000 modeled benefit*, but is **not clinically acceptable unless protected PACS and other critical restoration can be independently proved or separately funded**.

### 4.3 Risk-to-control selection and framework mapping — T11

Task 11 specifies **19 control selections across all 10 risks**, including controls shared among risks. The table shows the **principal, not exhaustive, implementation map**; refer to T11 for the full safeguard-level selection/dependency ledger. Never multiply a shared control's cost or marginal benefit by the number of risks it supports.

| Risk/workstream | Primary control and verification | CIS Controls v8 mapping | NIST CSF 2.0 outcomes |
|---|---|---|---|
| **RISK-002 VPN/AD** | **C2** named admin/VPN MFA and break-glass drill | **6** Access Control (6.4, 6.5); **5** Accounts | **PR.AA**, GV.RM |
| **RISK-001 EHR records** | **C1** EHR/DB split, PostgreSQL `pg_hba.conf` and test | **12** Infrastructure (12.2); **3** Data Protection (3.12) | **PR.IR, PR.AA** |
| **RISK-002/009 Westside** | **C1+C6** tested site/VPN traffic rules | **12** Infrastructure (12.2, 12.3) | **PR.IR, PR.AA** |
| **RISK-001/002 detection** | **C3** EHR/AD/VPN alert coverage and named human escalation | **8** Audit Logs (8.9); **13** Network Defense (13.1) | **DE.CM, DE.AE** |
| **RISK-003/008 recoverability** | **C4** independent immutable copies and successful PACS/billing restores | **11** Data Recovery; **3** Data Protection | **PR.DS, RC.RP** |
| **RISK-004/006 medical safety** | **C1** vendor-validated pump/MRI source controls; safe passive monitoring | **12** Network Infrastructure; **13** Network Defense | **PR.IR, DE.CM** |
| **RISK-005 medication integrity** | Clinical two-person review, change staging, fallback; **not separately priced** in T7 | **4** Secure Configuration; **16** Application Security (program gap) | **PR.PS, GV.RR** |
| **RISK-007 insider disclosures** | DPO export approvals, controlled USB pilot, role-specific training; **additional work beyond funded five** | **3** Data Protection; **6** Access; **14** Training | **PR.AA, PR.DS, DE.CM** |
| **RISK-010 print pivot** | Restrict spooler and admin ports; EOL replacement plan (separate quote) | **7** Vulnerability Management; **12** Infrastructure | **ID.RA, PR.IR** |

**Cross-cutting safeguards:** owner-based vulnerability closure; secure privileged accounts; application-layer authorization; vendor access reviews; clinical-safe changes; human-alert escalation. The table's non-T7 policy/clinical actions are not assumed free merely because equipment was not bought.

### 4.4 Five immediate quick wins — T13

**Day 1–14 after authorized start**, using existing tools/licenses and ordinary staff time (**$0 assumed *incremental procurement* per win, not zero labor**):

| Action (owner) | Due in first two weeks | Acceptance evidence | Principal risks |
|---|---|---|---|
| **1. Revoke stale VPN/vendor/privileged accounts** — Sarah Park | **Day 3** | Signed joiner/leaver exception list; disabled identity denied VPN access. | RISK-002, KC1 |
| **2. Repair/exception all 15 silent Sophos sensors** — Sarah Park | **Day 8** | 15/15 healthy or individually owned and dated unsupported exceptions; alert check. | RISK-002/008; Finding 027 |
| **3. Reversible unauthorized-USB GPO pilot** — Sarah/DPO/Clinical | **Day 10** | Approved 10-host nonclinical pilot; bad USB denied; essential peripherals function. | RISK-007; Finding 023 |
| **4. Independent pharmacist dose-table approval** — Chief Pharmacist | **Day 5** | Two named approvals and synthetic incorrect-dose rejection; safe 3-site validation. | RISK-005, KC2 |
| **5. Retrospective EHR bulk-export log review** — EHR owner/DPO | **Day 7** | Five dated reviews, reviewer backup, exception drill; explicitly retain ~48-hour audit-lag KRI. | RISK-001/007, KC5 |

**Urgent exceptions to the quick-win budget:** Unsafe Apache exposures, MRI uncontrolled SMB/RDP, pump default/unknown management credentials and missing PACS recovery must have owner-assigned actions even when an immediate zero-cash solution is unavailable. No quick win is treated as closing a Risk Register item without objective tests; no new license or clinical interruption is silently assumed.

---

## 5. Architecture Recommendations

### 5.1 Proposed zone architecture — T14

The current 10.10.x.x flat/trust-permissive environment and FortiGate C-002 `ALL` VPN-to-server policy are **baseline evidence**; the following 10.20.x.x ranges are **proposed**, not existing addresses. Inter-VLAN boundaries must be enforced by a stateful firewall or L3 ACL, with **default deny and documented, narrowly scoped exceptions**. Same-VLAN MRI/PACS traffic may need host/switch isolation because a VLAN by itself cannot filter traffic between its own hosts.

| Proposed VLAN | Zone / CIDR | Critical scope and main permitted flow |
|---|---|---|
| **110** | Z-SRV `10.20.10.0/24` | EHR application, billing, file services; clinical HTTPS; named DB service. |
| **111** | Z-ID `10.20.11.0/24` | AD/DNS; validated domain-member Kerberos/LDAP/DNS/SYSVOL; privileged jump-host admin only. |
| **112** | Z-DATA `10.20.12.0/24` | `ehr-db-01`; **named EHR app → TCP/5432 only** and authorized DBA paths. |
| **120** | Z-CLIN `10.20.20.0/23` | Clinical workstations; EHR HTTPS and authorized PACS viewing, not general server admin. |
| **130** | Z-MED `10.20.30.0/24` | Alaris/Philips; only approved biomedical/clinical device management and telemetry. |
| **131** | Z-IMG `10.20.31.0/24` | MRI/XP controller and PACS; only validated DICOM/viewing, no unrelated SMB/RDP. |
| **140** | Z-MGMT `10.20.40.0/24` | Hardened admin, biomedical jump hosts, Wazuh; named privileged access. |
| **150/151** | Z-GUEST `10.20.50.0/24` / Z-IOT `10.20.51.0/24` | Guest Internet-only, nonclinical IoT explicitly scoped; **deny protected clinical/AD/data networks**. |
| **160** | Z-DMZ `10.20.60.0/24` | Public portal/reverse proxy; minimal authorized app-backend calls. |
| **170** | Z-BACKUP `10.20.70.0/24` | Recovery; enrolled backup agents and named restore/admin operators only. |
| **Logical** | Z-VPN `10.20.61.0/24` | MFA-controlled remote entry **to management jump gateway only**, not an internal free pass. |

**Ten critical policy requirements in T14:** R01 allow VPN→approved management gateway TCP/443; R02 allow clinical→EHR HTTPS; R03 allow EHR app→DB TCP/5432; R04 allow scoped AD protocols; R05 allow modality→PACS DICOM TCP/4242,11112 with same-VLAN enforcement; R06 allow Radiology viewer→PACS HTTPS; R07 allow biomedical jump→approved device management; R08 allow enrolled agents→protected backup; **R09 deny guest/IoT→all internal protected zones**; **R10 deny unauthorized direct management/database/SMB/AJP paths**; default-deny all other interzone traffic. Real AD RPC, DICOM, HL7 and vendor dependencies must be enumerated before cutover. A financial VLAN plan does not authorize changes on active pumps or imaging devices.

### 5.2 Disruption of five existing kill chains

| 1x01 chain | Where new architecture helps | Remaining bypass requiring non-network safeguards |
|---|---|---|
| **KC1 VPN → AD ransomware** | Restricts post-VPN foothold (Step 2), AD lateral movement (Step 3) and GPO propagation blast radius (Step 4). | A legitimate stolen privileged identity can use approved channels; C2, admin tiering and C3 are required. |
| **KC2 negligent pharmacy change** | Network segmentation does **not** validate an authorized dose value. | Two-person approval, clinical reference checks, change staging and rollback. |
| **KC3 Radiology phishing → PACS** | Restricts unnecessary workstation↔PACS SMB/RDP and recovery-system access. | Authorized PACS sessions, shared login, endpoint visibility and patient-safe recovery remain risks. |
| **KC4 malicious insider → Alaris** | Narrows pump-management origins and helps audit biomedical change paths. | An insider already authorized at the biomedical jump host still needs dual approval and device-level safety controls. |
| **KC5 vendor → EHR records** | Blocks unapproved direct vendor/database access, isolates protected EHR database. | Compromised authorized EHR app or trusted update can use its legitimate DB path; monitor role/exports and supplier access. |

**T14 estimate:** **4/5 = 80%** of the selected chains have *at least one materially constrained network-stage step* (KC1, KC3, and partial KC4/KC5). **Only 2/5 (40%)** have a comparatively strong network-stage break; **KC2 is not materially prevented**. Neither percentage is a measured reduction in breach frequency, probability, patients harmed or ALE. Validate with allowed-and-denied test evidence, threat-informed tabletop scenarios and medical/vendor sign-off.

---

## 6. Policy Foundation

### 6.1 Acceptable Use Policy (AUP) — T12

Task 12's **eight-section draft AUP** governs acceptable use of MedDefense information systems; prohibited behavior (unauthorized access/shadow IT, credential sharing, unsafe software or exports); BYOD/removable-media restrictions; individual passwords and MFA where available; Restricted patient-record handling; proportional/logged monitoring, exceptions and consequences; and a signed employee acknowledgment. Personal USB storage is disallowed except for approved, necessary and authorized encrypted workflows, with documented clinical exceptions; emergency access must remain medically safe and auditable. **The draft is not enforceable merely because it has been written:** obtain CEO approval, DPO/legal review, HR communication, training, version control and acknowledgments. Treat technical enforcement (GPO, MFA, audit logs) as separate demonstrable steps, with accessible exception and incident-reporting paths.

### 6.2 Policy and procedure roadmap

| Policy / operating procedure | Priority and owner | Target approval or evidence | Why it is required |
|---|---|---|---|
| **AUP and patient-data/USB handling** | **Months 1–2**, CEO policy approval; James/HR/DPO prepare | Signed policy, acknowledgments, safe clinical-media exception process, pilot proof | RISK-007, GAP-017/020, Finding 023 |
| **Identity, privileged and vendor access** | **Month 1** charter; **Months 2–3** C2 rollout; Sarah/James | Named accounts, MFA coverage, emergency break-glass, joiner/mover/leaver review | KC1/KC5, GAP-011 |
| **Vulnerability and legacy-system exceptions** | **Month 1**, Sarah/James + Biomedical | Patching SLAs, MRI/print lifecycle register, vendor approvals and closure/rescan tickets | Findings 001/002/004/008/031; GAP-015 |
| **Pharmacy/medical-device safe change control** | **Immediate**, Chief Pharmacist/Biomedical/Clinical | Independent dosage approval, staged tests, rollback, vendor-certified changes | RISK-004/005/006, patient safety |
| **Logging, privacy monitoring and incident response** | **Months 1–3**, James/DPO/IT | Log inventory, retention/privacy review, alert runbooks, clinical response tabletop | GAP-001/017; 24/7 SOC not assumed |
| **Backup, clinical business continuity and disaster recovery** | **Months 1–4**, Sarah/Radiology/Clinical | PACS/EHR/AD/billing scopes, immutable copies, approved RTO/RPO and full restore evidence | RISK-003/008; GAP-003/007 |
| **Supplier and cryptographic baseline** | **Months 3–6**, Procurement/James/vendors | Vendor session controls, DICOM/TLS, SSH/certificate inventory and plan for 1x04 | KC5, DICOM Finding 024, EHR certificate Finding 030 |

Policy issuance without a demonstrable technical or clinical process is not equivalent to compliance. DPO/legal must determine actual jurisdiction-specific patient/privacy obligations and lawful retention rather than assuming alignment is certification.

---

## 7. Residual Risk Assessment

### 7.1 Independent red-team challenge — T15

**Hypothesis:** For the T15 tabletop *only*, all five selected T8 controls operate as specified; full **C5 estate-wide Sophos EDR** and **C8 full medical-device isolation/monitoring** remain deferred and the **C7 24/7 SOC** is not purchased. **Finding:** **KC3 Radiology phishing → PACS abuse/extortion remains conditionally viable**, because a compromised legitimate radiology session may exercise approved PACS workflows even across well-configured VLANs. The five-stage hypothetical path is (1) social engineering of an authorized Radiology worker; (2) reuse/misuse of approved PACS session/identity; (3) attempted harmful application-level PACS action if excessive rights or a separate flaw exists; (4) delayed containment opportunity when Wazuh is not staffed continuously; (5) possible temporary imaging outage or patient-data exposure even with immutable recoverable backups. This is **not proof of a PACS exploit**: endpoint protection, application authorization, timely alerts and tested restores could stop the path at multiple stages.

**Insider finding:** KC2 pharmacy administration remains viable as an *authorized but unsafe clinical change*, unless dual pharmacist approval and dose validation close GAP-002/GAP-022. A separate malicious/curious patient-record access case remains under RISK-007: segmentation cannot tell legitimate chart access from snooping, and bulk-export monitoring may lag. Device administration by an approved biomedical insider likewise warrants high-risk dual authorization despite C1.

**Overall residual rating after hypothetical T8 deployment: CRITICAL.** Use the highest material untreated risk, **RISK-007 L5×I4 = 20**, plus unquantified patient-safety risk; do not average ratings or sum overlapping ALEs. T15 identifies **incomplete clinically compatible endpoint/server detection and rapid response** as the largest technical gap, while distinguishing the nondeferrable privacy and pharmacy safety improvements. Verify current production coverage rather than assuming 15 agents remain broken after T13.

### 7.2 Proposed risk acceptance and conditions — T16

**All ten T10 decisions remain `Mitigate` in the source register.** T16 proposes only **time-limited, explicitly signed acceptance of the *residual condition after mitigation*** in three cases—not accepting an open, exploitable or unsafe baseline.

| Case | Bounded proposed exception | Authority and compensating evidence | Reopen / expiry |
|---|---|---|---|
| **RISK-006 MRI XP** | Temporarily retain unsupported OS while a **$2.1m scanner lease has 18 months remaining**; the lease figure is **not** replacement or breakage cost. | **CEO not yet approved**; James recommends; Sarah verifies C1 isolation; Siemens/Radiology/Biomedical authorize DICOM, vendor support and patient safety; C3 passive monitoring and downtime plan. | Any unapproved SMB/RDP, vendor advisory, clinical failure, exploitable path or affordable upgrade triggers review; initial exception no later than **31 Jan 2027** if authorized. |
| **RISK-008 billing outage** | Accept only **limited recoverable** business interruption after Apache remediation and C4 full restore; not open RCE/LPE or unprotected copies. | CEO signature pending; Robert Kim owns financial risk; James/Sarah verify security and CFO-approved RTO/RPO, C3 alerts, C4 restore. | Critical patch >7 days overdue, restore/immutability failure, RTO breach or incident; initial exception expires **31 Jan 2027** if authorized. |
| **RISK-010 legacy print** | Short transition to supported host after approved isolation and spooler restriction; not accepting known uncontained pivot. | CEO signature pending; Sarah/James deliver least-privilege printer clients, disabled unnecessary services, log monitoring, replacement milestone and clinical printing tests. | Unapproved RPC/SMB route, active exploited flaw, missed retirement date or domain-pivot indicator; initial exception expires **31 Jan 2027** if authorized. |

**MRI Board debate:** James Chen correctly insists that unsupported Windows XP and unnecessary SMB/RDP represent an avoidable patient-service and ransomware pivot. Robert Kim correctly notes that immediate replacement cannot be assumed financially rational simply from an **$2.1m lease**, without a replacement price, termination exposure, approved clinical alternative or budget; already funded C1 may offer material interim containment. **Verdict:** support **James's non-negotiable safe isolation and monitoring now**, with **Robert's evidence-based, temporary deferral of replacement** only after vendor/Radiology tests and CEO sign-off; do not defer any urgent mandatory control until the lease ends. Renewal is never automatic, including if the 18-month lease still runs.

**Risk-acceptance ledger minimum:** risk ID; risk owner; inherent and validated residual scores; treatment/compensating measure; clinical and privacy impact; financial alternative; independent test evidence; CEO/Board decision; KRI; review date; expiry; automatic revocation conditions. If any condition fails, revert to **Mitigate / Escalate** and obtain immediate clinical/security direction.

### 7.3 Year 2 priorities, without precommitting new money

1. **Scoped C5 critical-host EDR + rapid response:** pilot on **supported PACS/application/admin hosts**, improve health reporting for original 15 Sophos gaps, integrate with C3 and measure after-hours alert-to-person time. The full C5 model **$41,000 cost/$43,000 potential marginal benefit** has a narrow $2,000 modeled net; obtain a *new targeted quote*, do not claim identical value for the pilot or install uncertified agents on MRI/Alaris.
2. **C8 medical/legacy lifecycle and minimum-safety maturity:** independently assess vendor-approved pump isolation/monitoring, medically necessary protections, MRI/XP upgrade/retirement and unsupported print server; no patient-safety duty waits for positive financial ROI. The full C8 $44,000/$35,000 model is a pump/device planning package, **not an MRI replacement quote**.
3. **Insider/privacy and application integrity:** fund approved data-export authorization and prevention, role-based clinical training, named PACS sessions, pharmacy dose validation, supplier access assurance and fast audited EHR log delivery to reduce RISK-007 and KC2/KC5 exposure.
4. **Proportionate after-hours monitoring:** test Wazuh-to-human coverage and price a smaller on-call/targeted MDR service if needed; **do not reinstate full C7 $185,000 contract automatically**.
5. **Cryptographic upgrades (1x04):** vendor-compatible DICOM TLS, secure LDAP/AD authentication, certificate lifecycle, approved backup encryption and key custody; confirm protocols/clinical compatibility first.

---

## 8. Six-Month Implementation Roadmap

**Scheduling assumption:** Six months begin on **formal CEO/Board-authorized kickoff**, not on the assessment date. T13's dated **30 October–12 November 2026** two-week window is a *proposal*, not proof of work already done. A 30 October 2026 kickoff would put Months 1–2 approximately **November–December 2026**, Months 3–4 **January–February 2027**, and Months 5–6 **March–April 2027**; shift dates if authority/funding arrives later. Work remains gated by **the real $120,000 total-program cash ceiling**, vendor availability, privacy review and clinical safety.

### 8.1 Phase 1 — Months 1–2: quick wins, discovery, governance and procurement

| Deliverable/milestone | Accountable and dependency | Phase exit evidence / metric |
|---|---|---|
| **Day 1–14 quick wins**: identity cleanup, 15 Sophos agents, USB pilot, pharmacy dual approval, EHR export review | Sarah; Chief Pharmacist; EHR owner/DPO; HR/Clinical permission | **5** outcomes marked Completed/Partial/Blocked with tickets; **100% confirmed stale identities disabled**; 15 sensors accounted for; pilot USB allow/deny; sample wrong dose rejected; **five EHR review records** and lag exception. |
| Board/CEO governance, proposed appetite and AUP review | CEO/Board with James, DPO, HR | Signed RACI/policy or tracked approval blockers; critical exceptions escalated; register updated *without* pretending acceptances were granted. |
| Discover zone flows and recovery scope | Sarah, Biomedical, Radiology, EHR/vendor owners | **100% named owners** for in-scope critical assets; approved AD/EHR/MRI/PACS/pump/backup traffic matrix; current backups and RTO/RPO inventoried. |
| Cash/quote gate and phased procurement | Robert Kim, Procurement, CEO/Board | Signed **complete six-month cash-flow ≤ $120,000**, not just $97k annualized; MFA entitlement and support checks; C1/C4/C6 quotations; defined C3 staff/storage cost. |
| Pilot incident-response and vendor-safe medical exceptions | James + Clinical + IT | After-hours escalation contact tree and one tabletop scenario; approved clinical rollback/stop conditions for subsequent changes. |

**Phase 1 go/no-go:** No high-impact network cutover, MFA denial of clinical emergency access or unquoted purchasing before approved clinical services and finance gates. Urgent clinical/pharmacy remediation can occur earlier with appropriate safe authority; it must not wait for the procurement phase.

### 8.2 Phase 2 — Months 3–4: core control deployment

| Deliverable/milestone | Accountable and dependency | Phase exit evidence / metric |
|---|---|---|
| **C2** remote/admin MFA and named accounts | Sarah/Identity; after entitlement and emergency-access review | **100% of in-scope VPN and privileged human accounts** MFA-protected or exception signed and dated; successful break-glass drill. |
| **C1** production segmentation and **C6** Westside firewall | Sarah/Network; after approved flow mapping and clinical vendor sign-off | **100% pilot test cases pass**: unauthorized guest→clinical and VPN→AD management fail; approved EHR HTTPS/PostgreSQL, AD logons, DICOM and pump workflows still work; rollback evidenced. |
| **C4** protected, independent offsite backups | Sarah/Recovery + Radiology/Clinical; after retention, immutability and retrieval quote | **100% specified critical backup sets present** (including PACS images *and metadata* where included), independence proven, one supervised end-to-end recovery per key service with RTO/RPO recorded. |
| **C3** Wazuh high-value log and alert onboarding | James/Sarah; after confirmed platform and analyst capacity | **100% designated priority sources reporting or individually excepted** (VPN, AD, firewall, EHR, PACS where export feasible); test alert-to-human acknowledgment, including outside hours. |
| Critical remediation and clinical integrity controls | IT, DPO, Chief Pharmacist, Biomedical | Closed/owner-excepted Apache/AD/XP/print/device findings with tests; pharmacy two-person check on all sampled in-scope changes; EHR export approvals established. |

**Phase 2 go/no-go:** Deploy in pilot waves, with approved rollback and vendor presence where needed. If clinical flow validation or backup restoration fails, stop expansion, retain prior safe configuration and escalate. Wazuh is **not** asserted to provide a staffed 24/7 SOC.

### 8.3 Phase 3 — Months 5–6: verification, exercises and optimization

| Deliverable/milestone | Accountable and dependency | Phase exit evidence / metric |
|---|---|---|
| Segmentation and remote access validation | Sarah + Security + Clinical owners | Positive and negative reachability matrix, **0 unexplained forbidden routes**, no failed essential care flows, controlled rescan and source-limited exception record. |
| Ransomware/PACS/AD and pharmacy tabletop + restoration drill | James incident lead; Radiology, Pharmacy, DPO, IT | **At least one documented multidisciplinary tabletop** and representative PACS/EHR/AD/billing restoration proof; clinical RTO/RPO met or escalated. |
| Detection and privacy governance | James + DPO/EHR owner | Reviewed log timeliness, high-risk event detection, **alert-to-human time measured**, no unowned critical alerts or untracked bulk-export exception; privacy-respecting retention audit. |
| CIS/CSF and Risk Register reassessment | James + Sarah + DPO/Clinical | Evidence-based Current/Target status for 6 CSF functions, re-scored 18 CIS controls, all 10 risks reviewed, risk acceptance signatures/expiry verified. |
| Board value/Year 2 decision | CEO/Board and Robert Kim | Actual spend-vs-approved cash; supplier costs; unreconciled ALE assumptions highlighted; C5/clinical/privacy business cases priced and prioritized; roadmap revised. |

**Phase 3 success is proof, not paper:** Signed purchases, scanned ports, Wazuh installation or a written policy alone are insufficient. For each outcome retain `asset scope → control/configuration → positive test → negative test → clinical/privacy sign-off → dated evidence → risk-register decision`.

### 8.4 Management KPI/KRI dashboard

| Metric | Baseline at assessment | Month 6 success threshold / escalation |
|---|---|---|
| In-scope VPN and privileged-human MFA enforcement | Organization-wide coverage not evidenced | **100%** enforced or named time-bounded approved exception; any unexplained bypass escalates. |
| Confirmed stale VPN/privileged accounts | Unknown count; inventory needed | **0 confirmed stale active accounts**; any confirmed stale credential reopens ticket. |
| Sophos silent workstations | **15** reported in Finding 027 | **0 unexplained silent agents** among baseline 15; supported hosts healthy, unsupported counted as explicit exceptions. |
| Critical interzone unauthorized reachability | Flat/permissive internal paths evidenced | **0 unexplained forbidden paths** in approved negative tests, with positive clinical tests passing. |
| PACS/AD/EHR/billing protected restoration | PACS absent from evidenced local backup scope; limited restore testing | Approved full restore scope and recovery objectives **met or owner-escalated**, with representative evidence. |
| Pharmacy production dose changes | Prior incorrect-dose incident; no routine independent gate | **100% sampled production dose changes** have distinct pharmacy approval and reference check; any unapproved change urgently escalated. |
| EHR high-risk export monitoring | ~**48-hour** vendor audit-export latency | Daily review of available logs with named owner; latency **≤24 hours target** or formal exception/mitigation; do not claim real-time without proof. |
| Wazuh high-priority telemetry and escalation | No enterprise integrated SIEM evidenced | **100% approved priority feeds** active or excepted; measured daytime and after-hours acknowledgment versus signed SLA. |
| Risk acceptance and governance | 10/10 Mitigate; no signed T16 acceptance | **0 unapproved high/critical acceptances**; every signed exception has owner, KRI, monthly review and expiry. |
| Cash and approvals | Budget unapproved; $115k illustrative cash | **Actual authorized six-month spend ≤ $120,000**, plus separately documented all scope changes and unpriced obligations; never spend by assumed headroom. |

**Dependencies to report to the Board:** MFA licensing may require more than Office 365 E3; PACS restore may require faster storage than archival Glacier; biomedical devices and Windows XP may reject ordinary endpoint agents; clinical services can use undocumented ports; legacy EHR audit reports may not offer timely exports; an unstaffed SIEM can miss after-hours containment. Each is a possible gating failure, not a reason to claim an unrealistically completed target.

---

## 9. Next Steps — From Strategy to Delivery and Project 1x04

### 9.1 Executive decisions within the next Board cycle

1. **Approve the strategic direction and proposed appetite for review**, not unsigned blanket acceptance; confirm whether the five-control selection fits the *whole* six-month financial envelope.
2. **Commission a two-basis spending ledger**: annualized control costs, upfront hardware cash, six-month payment calendar and all extra legal, staffing, licensing, clinical and vendor costs; release purchase orders only within the explicitly signed cash ceiling.
3. **Appoint a single delivery owner for each of the five selected controls and each critical Risk Register item**, alongside named clinical, DPO and Finance signatories; prioritize the five safe quick wins.
4. **Request technical acceptance evidence**, not reassurance: reversible VPN/admin tests, approved interzone service matrix, medically supervised PACS/Alaris/MRI test plan, application-consistent backup restoration, Wazuh alerts with an on-call human.
5. **Open unfunded workstreams and decision gates** for the Critical insider/privacy exposure RISK-007, pharmacy integrity KC2, legacy MRI/print retirement, compatible EDR coverage and clinically safe device management. Do not silently transfer these to the funded control ledger.

### 9.2 Project 1x04 — Cryptographic Foundation

The planned next project should operationalize the **cryptographic dependencies discovered here**, while separating them from this six-month portfolio unless separately priced and approved:

| Carry-forward issue | Proposed 1x04 cryptographic work | Security/clinical validation |
|---|---|---|
| **PACS DICOM without TLS** (Finding 024) | Inventory DICOM endpoints, vendor-supported **DICOM TLS** and certificate trust/rotation. | MRI→PACS modality and image-viewer compatibility, patient identifiers confidentiality; clinical sign-off. |
| **AD and authentication** (Findings 007/018) | Verify LDAP signing/channel-binding requirements, Kerberos security, encrypted privileged-management channels and credential/key handling. | Domain joins, sign-ins, intersite connectivity and supported legacy device dependencies; no untested hard cutoff. |
| **EHR TLS certificate mismatch** (Finding 030) | Approved PKI certificate names, server identity, TLS configuration, renewal inventory and revocation handling. | EHR clinical URL/hostname consistency, no bypassing certificate warnings. |
| **Backup and medical/vendor trust** | Encryption in transit/at rest, S3 immutability permissions, key custody/recovery and vendor-managed device certificate plans where supported. | Independent recovery of encryption keys, audited access, PACS restore, approved medical-device support. |
| **Remote admin and suppliers** | Secure SSH/TLS baselines, VPN cipher/protocol review, named vendor certificates or other approved authentication. | Support continuity and privileged-session evidence; no unverified cipher/version claim. |

**Handoff output:** a cryptographic asset and trust-boundary inventory, risk-ranked crypto gap backlog, owners, exact vendor compatibility requirements, a certificate/key lifecycle plan, test cases and a separately approved cost/schedule. Cryptography complements—not replaces—application authorization, segmentation and patient-safety controls.

### 9.3 Evidence pack and accountable implementation

The Board should receive a single controlled package: (a) signed governance and risk-appetite decisions; (b) versioned Risk Register and time-bounded exception ledger; (c) approved investment/cash ledger; (d) firewall service matrix and positive/negative test records; (e) MFA and Wazuh coverage exports with measured human escalation; (f) backup/PACS/AD/billing restoration proof; (g) AUP acknowledgments and clinical-change approvals; and (h) the next-iteration CSF/CIS profile. **Recalculate residual scores and ALE only when evidence supports changed frequencies or impacts.** If the six-month cash plan or patient-safety gates fail, re-scope, defer noncritical purchases and return a decision to the CEO/Board; do not declare risk treated by drafting the strategy.

---

## Appendix A — Traceability to the Defense Blueprint and Earlier Assessments

| Source file | Contribution to this strategy |
|---|---|
| [T0 — Framework Landscape](0-framework_landscape.md) | NIST/CIS/ISO selection, scope and financial discipline. |
| [T1 — NIST CSF Mapping](1-nist_csf_mapping.md) | Six-function Partial baseline and proposed Managed targets. |
| [T2 — CIS Controls Audit](2-cis_controls_audit.md) | Whole-Control scorecard, 15 Partial/3 Not Implemented and priority order. |
| [T3 — Gap-to-Framework Bridge](3-gap_framework_bridge.md) | Evidence trace across technical, clinical, privacy and governance gaps. |
| [T4 — Governance Architecture](4-governance_architecture.md) | Accountable CEO, James, Sarah, Finance, Clinical and DPO roles. |
| [T5 — Risk Equation](5-risk_equation.md) / [T6 — ALE Workshop](6-ale_workshop.md) | Baseline five scenarios, assumptions and correlated-loss warning. |
| [T7 — Cost-Benefit Analysis](7-cost_benefit_analysis.md) | Eight control envelopes, marginal modeled ARR and validation constraints. |
| [T8 — Budget Allocation](8-budget_allocation.md) | Selected five, $97k annualized/$115k first-year cash, deferred C5/C8 and rejected C7. |
| [T9 — CFO Challenge](9-cfo_challenge.md) | Financial objections, spending discipline, insurance and alternative allocations. |
| [T10 — Risk Register](10-risk_register.md) | Ten risks, event owners, inherent/target scores, open treatments and KRIs. |
| [T11 — Control Selection](11-control_selection.md) | Nineteen decisions, risk-to-CIS/CSF mapping and dependencies. |
| [T12 — Acceptable Use Policy](12-acceptable_use_policy.md) | Eight-section hospital AUP draft and enforcement boundaries. |
| [T13 — Quick Wins](13-quick_wins.md) | Five actions, Days 1–14, $0 incremental cash assumption and verification. |
| [T14 — Segmentation Architecture](14-segmentation_architecture.md) | VLAN and flow design, ten firewall rules, KC1 stage breaks and 4/5 constrained paths. |
| [T15 — Red Team Blueprint](15-red_team_blueprint.md) | Conditional KC3 ransomware path, Critical residual, Year 2 scoped EDR priority. |
| [T16 — Risk Appetite Debate](16-risk_appetite.md) | Board appetite, three proposed exceptions, MRI lease debate and decision authority. |
| [1x00 — First Watch](../1x00_first_watch/README.md) | Current environment, assets, data classes, documented controls and gaps. |
| [1x01 — Know Your Enemy](../1x01_know_your_enemy/10-kill_chains.md) | Five attack/control-failure chains; insider, vendor and ransomware scenarios. |
| [1x02 — The Weak Links](../1x02_the_weak_links/16-triage.md) | Findings, confidence, remediation priority and clinical-safe verification context. |

## Appendix B — Limitations, confidence and approval record

1. **Evidence and scope:** No authorized production penetration test, full application traffic capture, medical-device change, Board decision, vendor quotation or complete six-month cost actuals were performed to create this strategy. Source inventories have unknowns; missing evidence is not automatically proof that a safeguard is absent.
2. **Financial estimates:** Costs are Task 7 assumptions, annualized vs actual cash requires reconciliation, and the modeled $785,000/year is a *selection score*, not validated ROI or additive enterprise ALE. The five baseline ALE scenarios overlap. Unquantified clinical risks are not zero.
3. **Control deployment:** T8/T14/T16 are plans, not evidence that MFA, VLANs, Wazuh, backup immutability or exceptions were activated. T15 deliberately assumes the five funded controls exist only to stress-test their theoretical residuals.
4. **Clinical safety:** Clinical, Biomedical and vendor approvals govern any change to MRI, PACS, pumps, pharmacy and urgent-care access. Favor passive observations and reversible pilots; no invasive live-device tests or unsupported endpoint installs.
5. **Regulatory and exploit uncertainty:** DPO/Legal confirm actual duties and retention. For Finding 031 Ghostcat and Finding 010 pump-firmware CVE applicability, obtain vendor/version verification; treat confirmed broad exposure separately from a disputed CVE label.

**Decision register (for completion by authorized MedDefense leadership; no approval implied):**

| Approval/decision | Named role | Signature or minutes | Date | Status |
|---|---|---|---|---|
| Strategic direction, risk appetite and high-risk exception criteria | CEO / Board | **Pending** | **Pending** | **Not approved** |
| Consolidated six-month cash and purchase releases | Robert Kim / CEO / Board | **Pending** | **Pending** | **Not funded** |
| Clinical safety and vendor compatibility gates | Radiology / Biomedical / Chief Pharmacist / relevant vendors | **Pending** | **Pending** | **Not approved** |
| Privacy monitoring, EHR exports and AUP | DPO / Legal / CEO | **Pending** | **Pending** | **Not approved** |
| Deployment validation and Risk Register re-rating | James Chen / Sarah Park / affected risk owners | **Pending** | **Pending** | **Not implemented** |

**Board recommendation:** Approve a staged, evidence-gated clinical security transformation; safeguard patients and patient records immediately, validate the complete financial envelope before contracting, and retain explicit accountability for high/critical risks that the five-control package cannot fully treat.
