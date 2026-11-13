# MedDefense Health Systems — Task 7: The Risk Register Update

- **Project:** 1x05 — Emergency Board Briefing
- **Required deliverable:** `blue_team/1x05_board_briefing/7-risk_register_update.md`
- **Basis:** 1x03 Task 10 Risk Register v1.0 (29 October 2026); 1x05 Task 5 emergency ALE scenario (12 November 2026)
- **Decision context:** Crimson Tide exercise; emergency Board briefing and first 72-hour response window
- **Prepared for:** James Chen (Deputy CISO), Sarah Park (IT Director), Robert Kim (CFO), Dr. Patricia Morales (CEO), Maria Santos (General Counsel), clinical and privacy owners
- **Status:** **EMERGENCY PROPOSED REGISTER AMENDMENT — NOT EVIDENCE OF AN ATTACK, AN APPROVED BUDGET OR A COMPLETED PATCH.**

## Executive decision and scope

**Re-score RISK-002 from High (15/25) to Critical (20/25); retain `Mitigate` and escalate to CEO/Board now.** Original compounded VPN-to-ransomware **SLE = $9,548,000**, original ARO **0.30/year**, original ALE **$2,864,400/year**. Task 5's explicitly hypothetical **12-month high-alert ARO = 0.60/year** yields **$5,728,800/year** (**+$2,864,400; +100%**), holding the event definition and loss severity constant. **Five regional hospital incidents in ten days are a warning signal, not a mathematically valid MedDefense ARO estimate**: the exposed-hospital denominator, campaign duration, service configurations and conditional likelihood of the full chain are unknown.

**Create RISK-NEW-001 for the specifically identified FortiGate 100F / FortiOS 7.0.9 / CVE-2023-27997 exposure.** The new entry is a **cause-level, exploitable-gateway risk nested within the already costed RISK-002 enterprise campaign outcome**. Its standalone incremental SLE/ALE is **not quantified**. The $5,728,800 enterprise ALE may be shown as a **linked, non-additive exposure proxy only**; neither the new entry nor RISK-001/EHR or RISK-008/billing may be summed with RISK-002 as if they were independent events.

**Board decision requested:** authorize **up to $2,400/year** for official Fortinet support entitlement after contract/quote verification, condition its benefit on **safe SSL-VPN containment, a vendor-supported firmware version selected after current PSIRT review, installation/verification and compromise assessment**, and approve a clinically supervised emergency change path. **Do not assume available 7.0.14 is the best final version**: it fixes the subject CVE but remains in the separately affected CVE-2024-55591 7.0.0–7.0.16 range. Fortinet documents 7.0.17 as a fix for that *separate* issue; actual present supported release/upgrade path still needs verification. [E1–E4]

## 0. Scoring method and evidence rules (unchanged from 1x03 T10)

| Register measure | Original method | Application in this update |
|---|---|---|
| Likelihood 1–5 | L3 `Possible` = ARO 0.10 to <0.50; L4 `Likely` = ARO 0.50 to <2.00 | Updated conditional full-campaign ARO 0.60 maps to **L4**; this is an analyst **scenario stress assumption**, not observed event frequency at MedDefense |
| Impact 1–5 | I5 `Severe/Catastrophic` when severe clinical harm, prolonged critical outage, or modeled loss >= $2 million | **I5 unchanged**; $9,548,000 conditional compounded campaign SLE |
| Rating bands | 1–4 Low; 5–9 Moderate; 10–15 High; 16–25 Critical | **L4 × I5 = 20/25, Critical** for both connected risk paths under the emergency stress case |
| ALE | `SLE × ARO` for the **same defined loss event** | Keep loss terms, scope, and q assumptions explicit; do not infer probability directly from incident counts |
| Treatment and residual | Current controls differ from **target** safeguards requiring approval, implementation, evidence and review | Do not credit C1/C2/C3/C4/C6 or emergency firmware as deployed; revised target ratings are **conditional only** |

**Scope caveat:** T5's 0.60/year is an *effective full-event* scenario rate under the original training simplification **q=1**, where `q` is the unknown probability that a VPN compromise reaches the complete EHR/billing/ransomware outcome. An improved model is `ALE = $9,548,000 × (ARO of viable initial access) × q`. An appliance finding on its own neither proves Internet-reachable SSL-VPN nor a present compromise. CISA's public KEV listing corroborates known exploitation of the **real CVE**, not the exercise's unverified Crimson Tide attribution or fictional hospital details. [E1–E3]

### Change-control summary: 1x03 baseline versus emergency register

| Field | Existing RISK-002 (1x03 T10) | Revised RISK-002 | Added RISK-NEW-001 |
|---|---|---|---|
| Event | VPN foothold → AD → ransomware | Crimson Tide-style VPN → AD/RC4 → EHR theft/NAS loss/ransomware | FortiGate SSL-VPN CVE-2023-27997 exploitation as entry event |
| Likelihood | L3/5 (`0.30` ARO/y) | **L4/5** (`0.60` assumed full-event ARO/y) | **L4/5 provisional**; inherits urgent scenario band, not an independent measured CVE rate |
| Impact | I5/5 | **I5/5** | **I5/5** via single-perimeter/three-site downstream exposure, not evidence of actual outage |
| Inherent risk | 15/25 **High** | **20/25 Critical** | **20/25 Critical (conditional exposure)** |
| Annualized ALE | **$2,864,400** | **$5,728,800** modeled stress case | **NQ separately**; linked RISK-002 proxy $5,728,800 **non-additive** |
| Treatment | Mitigate | **Mitigate; accelerate and escalate** | **Mitigate immediately** |
| Protection status | Proposed C1/C2/C3/C6 | Same proposals **not evidenced deployed** | Contract expired; firmware **7.0.9 confirmed**; SSL-VPN listener/reachability **unverified** |
| Review | Old date: 06 Nov 2026 | **Immediate, +12h, +36h, +72h** | **Immediate; 4-hour containment gate; 12/36/72h validation** |

---

## Part 1 — Updated existing register entry

### RISK-002 — Crimson Tide VPN foothold, identity compromise, data theft and multi-site ransomware

- **Risk ID:** **RISK-002** — UPDATED; preserve historical ID and previous version for audit.
- **Risk Description:** In the regional Crimson Tide exercise, attackers exploit or otherwise compromise the FortiGate remote-access perimeter, gain internal reach, perform AD reconnaissance and potentially Kerberoast vulnerable service accounts, steal accessible patient data, impair reachable backups and deploy ransomware, disrupting clinical authentication and care across three sites. **This is a plausible path, not an observed MedDefense intrusion.**
- **Risk Category:** **Operational**, with material patient privacy, financial, regulatory and clinical-safety consequences; do not invent separate additive compliance dollars.
- **Threat Source:** **Crimson Tide (CT)** ransomware campaign **as named in the course exercise**; organized ransomware affiliates are a general alternate source (1x01 KC1). The named campaign and five hospitals/three nearby remain scenario inputs, **not independently authenticated CISA campaign intelligence**.
- **Vulnerability:** **New CVE-2023-27997** on scenario-confirmed FortiOS 7.0.9, provided the vulnerable SSL-VPN attack surface is reachable; 1x02 **F007** LDAP-signing weakness, **F018** Kerberos RC4/DES, **F003** overbroad PostgreSQL access, **F015** NAS management exposure, **F027** incomplete defensive coverage. Additional encryption weaknesses: 1x04 **CRYPTO-001** EHR at rest, **CRYPTO-013** plaintext backups and **CRYPTO-011** legacy Kerberos. **F014 relates to the Westside Netgear/router, not the FortiGate CVE.**
- **Affected Asset(s):** **FortiGate 100F (A-086)**, `ad-dc-01` (A-040), `ad-dc-02` (A-041), `ehr-db-01` (A-037), `ehr-srv-01`, `NAS-01` (A-045), `backup-srv-01` (A-044), `billing-srv-01` (A-039), dependent Westside/HQ clinical workflows and PACS; no claim that all are already compromised.
- **Likelihood:** **4/5 — Likely under the Task 5 emergency stress case**, revised from **3/5** using **ARO=0.60 full-campaign equivalents/year** vs. original 0.30. This maps to T10's 0.50–<2.00 L4 band and must be recalibrated when gateway exposure, logs, attacker activity and event-progression probability `q` are known.
- **Impact:** **5/5 — Severe/Catastrophic**, unchanged: modeled joint SLE **$9,548,000 per complete campaign** with possible EHR loss, domain/clinical downtime and backup impairment.
- **Inherent Risk Score:** **4 × 5 = 20/25 (Critical)**; previous **3 × 5 = 15/25 (High)**. Business and patient-safety escalation overrides any illusion of precision in a five-level scale.
- **ALE:** **Original:** `$9,548,000 × 0.30 = $2,864,400/year`; **Emergency high-alert scenario:** `$9,548,000 × 0.60 = $5,728,800/year`; **difference:** `+$2,864,400/year` (**+100%**). Confidence **Low**; short burst count does not statistically calibrate annual frequency and overlaps RISK-001 and RISK-008.
- **Risk Owner:** **James Chen, Deputy CISO** (accountable), supported by **Sarah Park** (technical change), **Robert Kim** (cash and cost assumptions), DPO/Legal (privacy), clinical/Biomedical leadership (continuity).
- **Treatment Decision:** **Mitigate — unchanged and accelerated; emergency Critical escalation.** Do not accept, transfer, or treat a procurement request as closed risk.
- **Treatment Justification:** A known-exploited critical SSL-VPN CVE is installed on a single perimeter appliance; documented VPN/AD/EHR/NAS dependencies mean rapid propagation and loss of recovery are credible. The near-term priority is to eliminate a preventable remote entry and preserve recoverability, then restrict authorized paths and detect misuse. **MFA cannot stop the pre-auth CVE**, while EHR disk encryption alone cannot stop an authorized live DB read; layered treatment is necessary. The revised ARO stresses the urgency without proving a precise doubled real-world frequency.
- **Planned Control(s):** **Immediate new action:** verify and contain Internet-exposed SSL-VPN; renew supported Fortinet access; obtain/vendor-verify correct firmware and upgrade path, install with approved three-site rollback; preserve forensic evidence. Existing 1x03 portfolio: **C1** segmentation ($30,000/y), **C2** VPN/admin MFA ($11,000/y; not a pre-auth fix), **C3** Wazuh ($22,000/y), **C4** independently recoverable immutable backup ($21,000/y), **C6** Westside firewall ($13,000/y). 1x04: CRYPTO-011 Kerberos transition, CRYPTO-001/013 EHR and backup crypto; independently scoped and **not priced as free**. **Selected/proposed does not equal funded or deployed.**
- **Residual Risk:** **Current after-treatment status: not yet achieved; remain Critical 20/25** until verified containment and restoration controls. **Target (conditional, subject to validation): L3 × I5 = 15/25 High** after gateway remediation, network-reachability tests, monitoring and independent restore; actual residual ARO/ALE **TBD**, do not reuse old T7 `$2,214,400/year` as an achieved updated result. A domain-admin compromise, allowed EHR access or alternate entry could still drive severe consequences.
- **KRI:** **CT-relevant detection KRI:** **count of unexplained FortiGate SSL-VPN session/admin anomalies, configuration changes or IOC matches to the *verified* advisory**, with alert threshold **>=1 corroborated event in any 15-minute review interval**, requiring immediate triage (not automatic actor attribution). **Exposure KRI:** `FortiOS 7.0.9` plus an externally reachable SSL-VPN listener at the **4-hour containment gate** (threshold **one confirmed unmitigated listener**); **control KRI:** any unauthorized VPN→AD/EHR/NAS connection or missed critical backup integrity check. Record evidence source and time; IOCs must be obtained from the original advisory before matching.
- **Review Date:** **Now (out-of-cycle), within first 4 hours**, then **+12h, +36h, +72h** against signed gates; seven-day follow-up and monthly cadence only after closure evidence. These are relative to the **exercise alert**, not calendar appointments represented as already scheduled.
- **1x00 Gap Trace:** **GAP-015** patch ownership/closure; **GAP-016** flat/broad VPN trust; **GAP-011** identity/MFA; **GAP-007** shared backups; **GAP-006/017** EHR access/export; **GAP-003** PACS recoverability.
- **Validation / Next Action:** Sarah and James establish SSL-VPN feature/listener and WAN reachability **without active exploitation**, preserve current FortiGate logs/configuration with chain of custody, isolate where clinically acceptable, obtain vendor entitlements and signed firmware, and verify patch and all three intersite tunnels. IT tests reject unauthorized VPN→AD/EHR/NAS flows, captures Kerberos ticket-type evidence and protects recoverable backup copies. James and the DPO scope possible PHI exposure; Robert recomputes ARO/`q` using real telemetry and reviews the cash plan. A matched IOC, unauthorized configuration change, positive exfiltration finding, failed restore or clinical disruption triggers immediate incident escalation.

---

## Part 2 — New complete register entry

### RISK-NEW-001 — FortiGate 100F SSL-VPN remote code execution (CVE-2023-27997)

- **Risk ID:** **RISK-NEW-001** — new, **linked as an initiating cause of RISK-002**.
- **Risk Description:** The hospital's sole documented perimeter FortiGate 100F runs **FortiOS 7.0.9**, which is inside the vendor-confirmed **CVE-2023-27997** affected FortiOS 7.0.0–7.0.11 branch. If SSL-VPN is enabled and reachable, an unauthenticated remote actor may exploit the SSL-VPN heap overflow to execute code, compromise gateway integrity, gain network foothold, alter configurations or expose connections serving three MedDefense sites. Actual SSL-VPN mode/reachability and exploitation are **unverified**.
- **Risk Category:** **Operational** (network and clinical service availability/identity); privacy and regulatory impacts are downstream consequences counted via RISK-002 when applicable.
- **Threat Source:** **Crimson Tide (CT) as a course-scenario campaign**, plus any external adversary exploiting a known-exploited critical vulnerability; neither adversary attribution nor MedDefense targeting is confirmed by telemetry.
- **Vulnerability:** **CVE-2023-27997**, FortiOS SSL-VPN heap-based buffer overflow (**CWE-122**), **CVSS v3.1 9.8 Critical** (`CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H`), present in affected **FortiOS 7.0.9**; CISA **KEV-listed**. Patching/contract gap is new scenario-confirmed evidence, **not a historical 1x02 F014**. **Feature exposure prerequisite** must be checked separately. [E1–E3]
- **Affected Asset(s):** **FortiGate 100F (A-086)** Central perimeter, IPsec site-to-site connections supporting Central/Westside/HQ; indirect `ad-dc-01/02`, `ehr-db-01`, `NAS-01`, clinical access paths if an internal foothold is gained. **IPsec is not SSL-VPN**: do not assume the CVE directly affects the separate site-to-site tunnel protocol.
- **Likelihood:** **4/5 — provisional urgent stress classification**, aligned with the RISK-002 Task 5 **0.60 full-campaign ARO** solely for prioritization. **NOT an independently estimated 0.60 FortiGate-specific exploit frequency**; the actual initial-access frequency needs publicly reachable SSL-VPN configuration, attempts/IOCs, patch state and `q` validation.
- **Impact:** **5/5 — Severe/Catastrophic** for a credible single-perimeter compromise with three-site dependencies and multi-system reachability; not a claim of irreversible three-site failure from every exploit attempt.
- **Inherent Risk Score:** **4 × 5 = 20/25 (Critical), conditional on the SSL-VPN exposure hypothesis**; reassess if proven disabled/unreachable.
- **ALE:** **Standalone appliance-specific ALE = NQ** (no independently supported SLE or FortiGate exploit ARO). **Linked full-campaign stress ALE = $5,728,800/year from RISK-002**, usable **only as a shared scenario proxy** for the mitigation economics. **Do not add the two register rows or reuse a $9,548,000 SLE as if every FortiGate exploit directly causes a full campaign**.
- **Risk Owner:** **Sarah Park, IT Director** (accountable for gateway firmware, entitlement, implementation, rollback), with **James Chen** as enterprise risk/incident oversight and **Robert Kim** as financial approver/reconciler; clinical leadership signs patient-safety gates.
- **Treatment Decision:** **Mitigate — emergency priority, do not defer merely because the support contract expired.**
- **Treatment Justification:** A pre-authentication, KEV-listed network RCE on the sole documented perimeter device could bypass identity-based protections and provide the exact starting point anticipated by KC1. **The $2,400 renewal is an enabling expenditure**, not sufficient remediation alone. Renew through official entitlement, confirm the active service and either disable/restrict exposed SSL-VPN safely or complete a tested vendor-approved patch and compromise review. Retain bounded exceptions only with CEO/Board authorization, expiry and compensating controls.
- **Planned Control(s):** **New emergency firmware-management action:** `$2,400/year` Fortinet renewal (subject to verified quote/contract), supported signed firmware, PSIRT cross-check, independent image validation, clinical-approved upgrade/rollback, external reachability verification and change evidence. **C1** VPN zone isolation and **C3** Wazuh/centralized gateway events are downstream mitigations; **C2** MFA limits credential misuse **but does not prevent unauthenticated exploit**; **C4** protected backups reduces extortion/recovery loss, **C6** contains Westside risk. Existing C-002 `ALL` services must be replaced with tested least privilege. The 1x03 C1/C2/C3/C4/C6 portfolio is **proposed, not proven installed**.
- **Residual Risk:** **Current risk remains 20/25 Critical** until the configuration is verified and the exploit path is effectively closed. **Conditional target: L2 × I5 = 10/25 High** *for this specifically patched/nonreachable SSL-VPN attack entry* after supported image installation, successful external negative test, three-site functional tests and IOC/persistence review; severe consequences remain possible from other CVEs and legitimate credential abuse. **Actual standalone residual ALE = NQ; do not invent a validated reduction.**
- **KRI:** **Exposure threshold = one Internet-reachable, unmitigated SSL-VPN listener on an affected version**, or one unauthorized FortiGate administrator/configuration modification; both trigger **immediate triage**. **Process threshold:** no signed containment evidence by **+4h** or no approved firmware/entitlement decision by **+36h** triggers James-to-CEO/Board escalation. Source: vendor inventory, external allowed reachability test, device configuration/change log and signed change ticket.
- **Review Date:** **Immediate**, +4h for exposure, +12h for independent confirmation, +36h for purchase/upgrade readiness, +72h for verified closure or signed time-bounded exception; next month after emergency closure.
- **1x00 Gap Trace:** **GAP-015** (public-facing patch remediation and evidence); **GAP-016** (overly permissive intersite trust); **GAP-011** (limited identity safeguards are not a substitute for CVE patching); **GAP-012** device ownership and inventory assurance if configuration evidence is incomplete.
- **Validation / Next Action:** James declares a security change priority; Sarah uses approved **read-only** configuration/log review to check `ssl-vpn` and WAN listener, ensures forensic preservation where warranted, approves safe alternative remote access and preserves three site-to-site IPsec paths. Robert obtains entitlement and true same-period quote. Vendor confirms appropriate FortiGate 100F image/upgrade path and **all relevant PSIRT issues** before deployment (avoid declaring **7.0.14** wholly secure). Operators record cryptographic signature/checksum verified **against an authenticated vendor reference**, successful post-patch reboot, no exposed vulnerable listener, clinical/VPN positive tests, no unexplained admin persistence and accepted rollback. **Do not perform live exploit attempts on the gateway.**

### RISK-NEW-001 economic decision: is the $2,400 renewal justified?

**Scope:** Demonstrate the *threshold* of value needed from **renewal + effective remediation**, using the already costed **RISK-002 full-campaign outcome** as a non-additive proxy. This is a decision sensitivity, **not** a separate incremental ALE attributed to the FortiGate, and excludes unpriced labor/outage and any additional expense until quoted.

| Quantity | Calculation | Result |
|---|---|---:|
| Reference enterprise SLE | 1x03 T5/T6 R2 | **$9,548,000/event** |
| Reference emergency ARO | 1x05 T5 scenario, full campaign assumption | **0.600/year** |
| Linked scenario ALE | `$9,548,000 × 0.600` | **$5,728,800/year** |
| Annual entitlement cost | scenario quote | **$2,400/year** |
| Break-even annual full-campaign ARO reduction | `$2,400 / $9,548,000` | **0.00025136 events/year** |
| Break-even relative reduction in modeled R2 ALE | `$2,400 / $5,728,800 × 100` | **0.0419%** |
| **Illustration only:** 1% relative modeled ARO reduction | `0.600 × 1% = 0.006 events/year` | **$57,288/year ARR** |
| Illustrative net after entitlement only | `$57,288 − $2,400` | **$54,888/year** |
| Illustrative simple ROI | `($57,288 − $2,400) / $2,400 × 100` | **2,287%** |
| **Renewal alone (without completed mitigations)** | `$0 risk reduction − $2,400` | **−$2,400/year; ROI −100%** |

**Interpretation:** A **very small** modeled annual frequency reduction would cover this narrowly priced dependency, and the severe three-site risk makes emergency remediation compelling. However, the **1% effectiveness in this illustration is assumed, not measured**; if SSL-VPN was already disabled, this specific CVE's exposure may be minimal and the positive modeled ROI does not follow. A pre-existing compromise may survive an upgrade and require specialist investigation/rebuild/rekey. **Recommendation: authorize the official renewal conditional on effective containment/patch validation**, not certify 2,287% as a measured financial return or replace technical evidence with a ratio.

**Budget reconciliation:** The 1x03 selected C1+C2+C3+C4+C6 portfolio costs **$97,000/year annualized** and **$115,000 illustrative first-year cash** against a **single $120,000 six-month program cash ceiling**, before other obligations; it has **not** been signed as funded/deployed. Illustrative arithmetic if the support contract were the only additional cash obligation: **$115,000 + $2,400 = $117,400**, leaving **$2,600 nominal headroom**. That does **not** establish affordability because the cash time bases, unpriced clinical/vendor tasks, upgrade labor, actual contract and other work have not been reconciled. Ask Robert to authorize/reallocate under a documented emergency ceiling or seek a tightly capped Board exception when the real same-period six-month forecast requires it. **Never treat the linked RISK-002 ALE as independently avoided twice.**

---

## Part 3 — Register governance: mandatory out-of-cycle review

### Exact source trigger (1x03 T10 Governance Note)

> "Any newly exploited or KEV-listed relevant vulnerability, significant incident, asset or vendor/firmware change, failed recovery test, patient-safety near miss, overdue high-risk treatment or **breach of a stated KRI threshold** triggers an immediate out-of-cycle review"

**Source:** [1x03 Task 10 — Risk Register, *Risk Register Governance Note*](../1x03_defense_blueprint/10-risk_register.md). The quoted sentence fragment is exact up to the colon; the original continues with the required review workflow.

**Answer: YES — multiple independent triggers apply.** **(1)** The **newly identified relevant KEV-listed CVE** affects the *scenario-verified installed FortiOS version 7.0.9*; **(2)** the unexpected emergency advisory and five-hospital cluster materially revise threat-intelligence assumptions; **(3)** the **expired vendor contract** is a material firmware-remediation dependency; **(4)** any observed unauthorized session, unmitigated reachable listener or verified Crimson Tide IOC would satisfy a corresponding newly introduced KRI. The first three are already sufficient for immediate review; the fourth is a **conditional alert**, not an asserted event. The course's regional hospital incidents are external scenario incidents, not evidence MedDefense itself has been attacked.

### Execute the governance workflow, not just edit a spreadsheet

| Timing | Required workflow item | Accountable evidence owner | Escalation / closure gate |
|---|---|---|---|
| **Immediately (T+0)** | Open an **out-of-cycle risk-review ticket**; preserve 1x03 register v1.0 as immutable reference; create this 1x05 amendment with date, source, revised fields and reasons | Security Analyst maintains; **James** accepts accountability | James notifies Sarah, Robert, DPO/Legal, clinical leads, CEO/Board; mark both entries **Open / Critical** |
| **T+0–4h** | Validate FortiOS build, whether SSL-VPN is listening/reachable, who changed config, what logs survive, and whether usable independent backup exists | **Sarah** + security/backup operator | Verified safe SSL-VPN restriction or written clinical-safe alternative and named exception owner; no indiscriminate IPsec shutdown |
| **T+4–12h** | KRI review, threat-hunt triage for verified IOCs, preserve logs and establish evidence chain; review no unapproved bulk EHR exfiltration | **James** + Security Analyst + DPO | Incident-response escalation if suspicious evidence is corroborated; avoid actor attribution without indicators |
| **T+12–36h** | Quote/renew Fortinet entitlement if approved, obtain current supported image, run vendor security/upgrade-path review, schedule approved testing and rollback | **Robert** funds/reconciles; **Sarah** implements | No unauthorized purchase; no 7.0.14 automatic selection; approve 3-site safety window |
| **T+36–72h** | Confirm effective firmware/SSL-VPN gate, test allowed clinical/IPsec services and denied unauthorized paths, verify restore and telemetry, update scoring based on results | Sarah and James with clinical owners | Only then close the **specific patch/exposure** finding; residual ransomware and data risks persist |
| **After 72h** | Present amended Critical risks, cost, decisions, owner, exceptions and dated evidence to Board; maintain monthly register + quarterly Board rhythm | James / CEO / Board | Any temporary acceptance must have authorized approver, reasons, expiry, clinical/DPO assessment, next review |

### Explicit risk decision record (proposed, not signed)

- **Decision status:** **OPEN — mitigation recommended / emergency approval requested**; not closed until objective evidence exists.
- **Decision authority:** James owns register and recommends action; Sarah owns implementation; Robert verifies cash; CEO/Board approve reserved spend/risk acceptance; clinical and DPO/Legal leads review safety and PHI exposure.
- **Reporting:** Within 4 hours, give James a plain-language *verified exposure vs unknowns* brief. Before the 09:00 Board meeting, give CEO/Board both revised rows and the separate finances. After 72 hours, provide validation results and corrected likelihood/`q`, not merely a completed change ticket.
- **Change log:** This Task 7 report is a **proposed amendment linked to** existing `10-risk_register.md`; do **not silently overwrite** the historical 1x03 file or pretend a Board decision has occurred. Record original date, reviewer, evidence/source, old/new likelihood, ALE and control deployment status in the official risk system when authorized.

---

## References, trace and uncertainties

**Internal MedDefense records** (relative to `blue_team/1x05_board_briefing`):

1. [1x03 T10 — Risk Register v1.0](../1x03_defense_blueprint/10-risk_register.md): **RISK-002 exact original fields**, L3 0.10–<0.50 / L4 0.50–<2.00, risk rating bands, control status and **exact governance review trigger quoted above**.
2. [1x03 T5 — Risk Equation](../1x03_defense_blueprint/5-risk_equation.md) and [T6 — ALE Workshop](../1x03_defense_blueprint/6-ale_workshop.md): joint **$9,548,000 SLE**, 0.30 VPN-compromise/year, $2,864,400 annual classroom conservative full-chain outcome; conditional `q` and overlap cautions.
3. [1x03 T7 — Cost Benefit](../1x03_defense_blueprint/7-cost_benefit_analysis.md), [T8 — Budget Allocation](../1x03_defense_blueprint/8-budget_allocation.md) and [T17 — Security Strategy](../1x03_defense_blueprint/17-security_strategy.md): C1/C2/C3/C4/C6 proposed portfolio, $97,000 annualized, $115,000 first-year illustrative cash, full six-month constraint and unpriced dependencies.
4. [1x05 T0 — Advisory Analysis](0-advisory_analysis.md), [T1 — CVE Deep Dive](1-cve_deep_dive.md), [T2 — Kill Chain Overlay](2-kill_chain_overlay.md), [T3 — Emergency Plan](3-emergency_plan.md), [T4 — Crypto Emergency](4-crypto_emergency.md), [T5 — ALE Update](5-ale_update.md): new scenario facts, preliminary mapping, exposed SSL-VPN uncertainty, revised 0.60 ARO and **conditional** support ROI model.
5. [1x00 T12 — Gap Analysis](../1x00_first_watch/12-gap_analysis.md), [1x02 T16 — Triage](../1x02_the_weak_links/16-triage.md), [1x04 T15 — Crypto Posture Audit](../1x04_crypto_foundation/15-crypto_posture_audit.md): asset/control and crypto dependencies. Do not represent the new FortiGate finding as a historical 1x02 scan result.

**Independent public technical corroboration** (does *not* independently corroborate the course-specific Crimson Tide campaign):

- **[E1]** [CERT-EU Advisory 2023-038](https://cert.europa.eu/publications/security-advisories/2023-038/): CVE-2023-27997, affected 7.0.0–7.0.11, pre-authentication SSL-VPN exploitability and patch guidance.
- **[E2]** [Fortinet PSIRT — FG-IR-23-097](https://fortiguard.fortinet.com/psirt/FG-IR-23-097) and [NVD CVE-2023-27997](https://nvd.nist.gov/vuln/detail/CVE-2023-27997): vendor vulnerability details, CVSS/CWE and version matching.
- **[E3]** [CISA Known Exploited Vulnerabilities Catalog](https://www.cisa.gov/known-exploited-vulnerabilities-catalog?search_api_fulltext=CVE-2023-27997): named CVE publicly tracked as known exploited, not proof of MedDefense compromise.
- **[E4]** [Fortinet FortiOS 7.0.17 Release Notes](https://docs.fortinet.com/document/fortigate/7.0.17/fortios-release-notes/289806): separate CVE-2024-55591 resolution; do not assume 7.0.17 is the latest supported FortiGate 100F release.

**Unresolved before formal Board signature:** original exercise advisory's exact seven phases and IOCs (course-provided text not independently read), SSL-VPN reachability, direct compromise evidence, exposed-hospital denominator, `q`, true incident SLE after de-duplication, latest supported FortiOS build, actual support renewal invoice, and approved cash schedule. **No IOC, claim of compromise, deployment or causal ROI is invented.**
