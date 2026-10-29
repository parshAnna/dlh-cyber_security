# Task 16 — The Risk Appetite Debate

**Organization:** MedDefense Health Systems  
**Project:** 1x03 — Defense Blueprint  
**Prepared for:** CEO and Board; James Chen (Deputy CISO); Robert Kim (CFO); Sarah Park (IT Director); Radiology and Biomedical leadership  
**Assessment date:** 29 October 2026  
**Status:** **PROPOSED** risk appetite and acceptance decisions — no Board/CEO approval, deployment, or change to the live Risk Register is claimed.

## Decision Basis and Non-Negotiable Boundaries

All ten entries in [Task 10](10-risk_register.md) currently have **Treatment Decision: Mitigate**; therefore the three cases below are **proposed changes to acceptance of a narrowly defined residual exposure**, not assertions that the full original risk has been accepted or that existing treatment has stopped. MedDefense's proposed baseline uses the Task 10 matrix: **Low 1–4; Moderate 5–9; High 10–15; Critical 16–25**. "Accept" means an authorized, evidence-based and time-limited decision to retain a defined residual exposure, with a named risk owner, compensating measures and a revocation trigger; it is **not** acceptance of foreseeable, uncontrolled patient harm or legal noncompliance.

**Planning assumptions:** Task 8's five selected controls (**C1 segmentation, C2 VPN/admin MFA, C3 Wazuh SIEM, C4 immutable offsite backups, C6 Westside firewall**) cost **$97,000/year annualized**, with **$115,000 modeled first-year cash** against a $120,000 overall program ceiling. These costs and marginal benefits are *estimates*, not actual quotes or proof of deployment. C5 full EDR and C8 full medical-device isolation were deferred; their modeled incremental risk reductions (**$43,000/year** and **$35,000/year**, respectively) do not establish the price or benefit of MRI replacement, print-server retirement or individual patient-safety actions. In the exercise below, residual scoring is conditional on successful implementation and signed tests; current Task 10 risks remain open until evidence exists.

## Part 1 — Risk Appetite Statement

> The MedDefense Board proposes a **low appetite for cyber and clinical risk overall**, permitting routine acceptance only of **Low (1–4) or Moderate (5–9) residual risks** after controls and evidence have been reviewed. **No uncontrolled risk of patient injury, unsafe medication dosing, critical-care interruption, unlawful patient-data disclosure or breach of mandatory legal duties may be accepted merely to save money**; such exposure requires immediate safeguards and clinical escalation. A **High (10–15)** residual risk can receive only a **specific, time-limited exception signed by the CEO**, with Board oversight for material exposure, James Chen's documented recommendation, the affected business owner's accountability and Clinical/Biomedical or DPO sign-off where relevant. **Critical (16–25)** residual risk is outside normal appetite and must be escalated to the CEO/Board for urgent treatment rather than routinely accepted. Every exception requires a compensating control, a measurable KRI, an expiry date, monthly review and automatic reopening when its limits fail.

**Authority alignment:** Under [Task 4 Governance Architecture](4-governance_architecture.md), **CEO = accountable** for high/critical risk acceptance; James Chen recommends and maintains the register; Sarah Park implements technical measures; clinical/Biomedical owners safeguard patient-care operations; Robert Kim advises on cost and opportunity cost. The Board is informed or approves where its reserved authority applies. A signature or meeting record is required: **none is supplied in this coursework**.

## Part 2 — The Three Decisions

### Decision 1 — RISK-006: Continue Operating the Unsupported Windows XP MRI Controller Under a Controlled Exception

- **Risk:** **RISK-006** — exploitation of `WS-RAD-01` (A-016, Windows XP SP3; Finding 004), affecting Siemens MRI (A-091) and potentially PACS (A-038). Task 10 inherent **L3 × I5 = 15 High**; proposed target **L2 × I5 = 10 High** only after verified isolation; MRI-specific **ALE: not quantified**, not zero.
- **Treatment Decision:** **Accept — proposed, conditional and temporary residual legacy-OS risk only**, **after Mitigate/compensating treatment has been validated**; do **not** accept open SMB/RDP access, unsafe imaging or a proven uncontained attack path. This would revise Task 10's original *Mitigate* disposition only for the residual inability to retire the legacy operating system immediately.
- **Authority:** **CEO approval required, NOT YET GRANTED**, with James Chen's written recommendation, Sarah Park's technical test evidence, **Radiology Head + Biomedical Engineering + Siemens/vendor clinical safety approval**, and Board visibility because severity remains High and could affect patient care. Robert Kim advises on lease/cost constraints but cannot independently approve clinical residual risk.
- **Justification:** The scenario states the **$2.1 million MRI scanner lease expires in 18 months**, making immediate replacement commercially and operationally difficult; **$2.1 million is the lease value, not an established replacement quote or avoidable termination penalty**. Task 7 already prices shared **C1 segmentation at $30,000 annualized**; neither C5 EDR ($41,000/year) nor the deferred C8 pump/device package ($44,000/year) proves a Windows XP MRI replacement is affordable or technically compatible. Accepting the **remaining unsupported-OS exposure** for a short, renewable period may be more rational than disrupting certified MRI workflows, but a known unsafe device path cannot be justified by financial arithmetic.
- **Compensating Measure:** Require Siemens-approved **C1 isolation and source/port allowlisting**, deny unnecessary SMB/RDP, allow only verified MRI-to-PACS DICOM and maintenance workflows, use **C3 passive boundary alerts**, restrict and audit vendor/jump access, confirm downtime/fallback procedures, and maintain a dated upgrade/retirement plan. Do not install unsupported endpoint software or test invasively on a live medical device.
- **Review Trigger:** **Any unauthorized SMB/RDP reachability (KRI threshold = 1), vendor advisory/new exploited vulnerability, abnormal clinical traffic, failed MRI/PACS workflow test, patient-safety incident, or a feasible supported upgrade/replacement quote** revokes this proposed acceptance pending urgent review. **First review: 6 November 2026; monthly thereafter; maximum initial exception expiry: 31 January 2027**, requiring fresh CEO/clinical authorization rather than automatic extension through the 18-month lease.

### Decision 2 — RISK-008: Retain a Limited, Recoverable Billing Service-Outage Risk

- **Risk:** **RISK-008** — billing-server ransomware/revenue interruption on `billing-srv-01` (A-039), Findings 001/002 and adjacent backup Finding 015. Task 10 inherent **L3 × I4 = 12 High**, baseline teaching **ALE $135,143/year**; conditional residual **L3 × I3 = 9 Moderate** with effective recovery, and Task 7's modeled **$45,000** reduction yields **about $90,143/year residual**.
- **Treatment Decision:** **Accept — proposed, conditional residual business interruption only after mitigation**, **not** acceptance of an exploitable Apache RCE/local-privilege-escalation chain, unprotected backups or an untested recovery process. Current T10 *Mitigate* stays in force until remediation evidence and risk-owner approval are recorded.
- **Authority:** **Robert Kim, CFO**, is the accountable *business risk owner* for revenue continuity; **CEO signs the acceptance (NOT YET APPROVED)** under Task 4, after Sarah Park verifies remediation/restoration and James Chen checks security residuals. The DPO/legal and clinical operations must be consulted if downtime can affect patient data or care.
- **Justification:** Task 7 selected **C4 immutable/offsite backup at $21,000/year** with a **$45,000/year modeled marginal R4 ALE reduction** (conditional on actual recoverability), making a limited post-control outage potentially tolerable at **Moderate 9/25**. This does **not** mean the approximate $90,143/year is an invoice, guaranteed loss, or permission to avoid cheap critical patching; the model is uncertain and overlaps broader ransomware cases.
- **Compensating Measure:** Validate Apache version/modules and patch/disable unsafe code paths; enforce C1 server isolation, C3 alert triage, C4 immutable copies with independent administrator credentials, and an **application-plus-data billing restore test** against a CFO-approved RTO/RPO. Maintain a manual claims-processing/downtime process and dated incident communications contacts.
- **Review Trigger:** **Any confirmed exploitable RCE/LPE remaining open, >7 days overdue urgent patch, backup immutability failure, failed full restore, breached billing RTO/RPO, material change in billing-loss assumptions or actual ransomware incident** voids the proposed acceptance. **First review: 6 November 2026; monthly review; initial exception expires 31 January 2027.**

### Decision 3 — RISK-010: Temporarily Retain a Segmented Legacy Print Server Until Supported Replacement

- **Risk:** **RISK-010** — unsupported Windows Server 2012 R2 `print-srv-01` (A-043), Finding 008/PrintNightmare-family exposure, possible KC1-style internal pivot. Task 10 inherent **L3 × I4 = 12 High**; target **L2 × I4 = 8 Moderate** only after tested Print Spooler restrictions and isolation; **ALE: not quantified**.
- **Treatment Decision:** **Accept — proposed, time-limited residual unsupported-platform exposure only after proven containment**, while continuing mitigation, patch verification and the supported-replacement workstream. **Do not accept** a remotely reachable, exploitable Print Spooler simply because new hardware is inconvenient.
- **Authority:** **Sarah Park** owns IT print-service exposure and proves isolation; **James Chen** recommends the bounded exception; **CEO signs (NOT YET APPROVED)** under Task 4 even if the target score is Moderate, because the pre-control risk is High and an unsupported domain-connected host could affect AD. Robert Kim reviews lifecycle costs; clinical department leads confirm printing dependencies and downtime alternatives.
- **Justification:** The Task 7 **C1 $30,000/year** segmentation investment is already selected and shared with other risks; its price must **not be added again** as a print-only purchase. Task 7 provides **no print-server replacement quotation or separate ALE**, so a temporary operating exception with verified controls is rational only as a **bounded transition**, not because printing risk has been proven cheaper than remediation. Prompt retirement remains expected as soon as the actual replacement price and service dependency are validated.
- **Compensating Measure:** Restrict print RPC/SMB to named print clients and administration jump hosts, disable unnecessary spooler features, apply available supported mitigations/patches where possible, block general VLAN and VPN access, forward logs to **C3 Wazuh**, review privileged activity, and maintain a documented migration/fallback ticket. Use safe positive (authorized printing works) and negative (unapproved sources cannot reach spooler) tests.
- **Review Trigger:** **Any unauthorized RPC/SMB reachability (threshold = 1), newly verified exploited vulnerability, domain pivot evidence, failed print continuity test, missed retirement milestone or cessation of vendor-safe mitigation** reopens the risk immediately. **First review: 30 November 2026; monthly thereafter; exception expires 31 January 2027** unless re-authorized or replacement completed.

### Acceptance Decision Log — Not Yet Signed

| Risk ID | Prior Task 10 decision | Proposed conditional decision | Score eligible for acceptance *after evidence* | Required decision authority | Status |
|---|---|---|---|---|---|
| RISK-006 | Mitigate | Accept bounded legacy-OS residual; maintain C1/C3 safeguards | **10 High**; exceptional CEO + clinical review | CEO + Radiology/Biomedical safety sign-off; Board visibility | **Pending — NOT accepted** |
| RISK-008 | Mitigate | Accept limited recoverable billing interruption after C4 and patch validation | **9 Moderate** | CFO risk owner; CEO signature | **Pending — NOT accepted** |
| RISK-010 | Mitigate | Accept temporary legacy-host residual after verified isolation | **8 Moderate** | Sarah Park risk owner; CEO signature | **Pending — NOT accepted** |

**Evidence gates for changing the live [Risk Register](10-risk_register.md):** named accountable owner; dated clinical/business and technical impact assessment; current-versus-target likelihood/impact; alternative treatments and priced evidence; test results; monitored KRI and response owner; expiry and next review; CEO signature and Board minutes if applicable. Until every gate is met, **keep the register's existing `Mitigate / Open` decision**. No unilateral risk acceptance by IT, CFO or the author is authorized.

## Part 3 — The Debate: Windows XP MRI Workstation (RISK-006)

### James Chen — Argument for Mitigation (4 sentences)

The Windows XP MRI controller has documented end-of-life exposure and legacy remote services (Finding 004), and a compromised imaging endpoint could disrupt diagnosis or reach PACS through KC3. **L3 × I5 = 15 High** is not a normal operating exception where patients depend on MRI availability and image integrity. The already-selected **C1 segmentation** can limit that path without immediately replacing the scanner, provided Siemens and Radiology validate its DICOM and maintenance flows. We must isolate, monitor, test and retain a concrete replacement milestone; the lease cannot excuse leaving a clinically unsafe pathway open.

### Robert Kim — Argument for Acceptance (4 sentences)

The **$2.1 million scanner lease still has 18 months remaining**, so ordering an immediate replacement without a vendor quote, termination analysis or continuity plan would not be financially responsible. Task 7 shows **C1 is already budgeted at $30,000 annualized**, whereas no incremental cost-benefit estimate establishes that early MRI replacement offers proportionate additional risk reduction. A monitored, vendor-approved exception with working imaging services preserves patient access while Finance plans the next procurement cycle. If the residual remains bounded and the CEO and clinical owners approve, **temporary acceptance is preferable to premature replacement**, not to all mitigation.

### Analyst Verdict — My Decision (4 sentences)

**James's safety-first reasoning is more compelling about the required safeguards**, because a potential patient-care outage cannot be offset by an unverified dollar comparison. **Robert is right about timing**: the $2.1 million lease is a contractual constraint, not evidence that an urgent replacement would cost exactly $2.1 million or that a premature swap is clinically safer. I recommend **mitigate immediately with vendor-approved segmentation, controlled access and monitoring, then seek a time-limited CEO/clinical acceptance of only the residual Windows XP exposure**, subject to the tests, KRIs and expiry above. If isolation or safe clinical operation cannot be demonstrated, **do not accept**: escalate for interim clinical protections and an accelerated vendor-supported alternative regardless of the normal lease timetable.

## Governance, Limits and Linkage

- **Board reporting:** James Chen should show both *inherent* and *verified residual* scores, outstanding High exceptions, safety overrides, dates, KRIs and funding consequences monthly; the CEO must sign the actual exception before changing treatment status.
- **Hard-stop conditions:** Do not defer correction of validated unsafe pharmacy dosing (RISK-005), unmanaged pump/default-management exposure with patient consequences (RISK-004), unlawful patient-data exports (RISK-001/007), or a proven urgent exploitable path on the theory that insurance or a low modeled ALE compensates for patient harm.
- **Financial discipline:** C1/C3/C4/C2/C6 are **shared portfolio controls**, not separate purchases for each risk; the T7 C8 estimate is **not** a quote for MRI replacement. Do not add overlapping R2 VPN/EHR/billing ALEs or treat the five-control `$785,000` selection score as realized savings.
- **Reversibility:** Every exception is revocable, requires renewed approval by its expiry, and returns to **Mitigate / Escalate** whenever a hard-stop condition or KRI is breached.

## Evidence References

1. [Task 4 — Governance Architecture](4-governance_architecture.md): CEO decision rights, James's recommendation and clinical/Biomedical involvement.
2. [Task 5 — Risk Equation](5-risk_equation.md) and [Task 6 — ALE Workshop](6-ale_workshop.md): baseline event estimates and uncertainty.
3. [Task 7 — Cost-Benefit Analysis](7-cost_benefit_analysis.md): C1/C3/C4 costs and marginal effects; absence of MRI/print replacement quotes.
4. [Task 8 — Budget Allocation](8-budget_allocation.md): selected five controls, C5/C8 deferrals, cash-vs-annualized caveat.
5. [Task 10 — Risk Register](10-risk_register.md): RISK-006/008/010 initial Mitigate decisions, scoring and KRIs.
6. [Task 11 — Control Selection](11-control_selection.md) and [Task 14 — Segmentation Architecture](14-segmentation_architecture.md): safeguards and clinical verification dependencies.
7. [1x00 Asset Registry](../1x00_first_watch/7-asset_registry.md), [1x01 Kill Chains](../1x01_know_your_enemy/10-kill_chains.md), and [1x02 Triage](../1x02_the_weak_links/16-triage.md): asset, threat and vulnerability traceability.

**Final decision requested:** The Board should adopt the appetite *for review*, and the CEO should **conditionally consider**, not pre-approve, these three bounded exceptions only after evidence and business/clinical sign-off. The actual risk-treatment decision remains **Mitigate** until the documented authorization workflow is complete.
