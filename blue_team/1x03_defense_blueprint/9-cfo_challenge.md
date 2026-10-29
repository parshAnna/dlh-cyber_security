# Task 9 — The CFO Challenge

- **Organization:** MedDefense Health Systems
- **Project:** 1x03 — Defense Blueprint
- **Deliverable:** `9-cfo_challenge.md`
- **Assessment date:** 29 October 2026
- **Audience:** Robert Kim (CFO), Board, James Chen (Deputy CISO) and Sarah Park (IT Director)
- **Source:** DLH-provided `cfo-pushback.txt` (five specific objections)
- **Position:** Proposed, evidence-gated investment case; no security expenditure or risk reduction is claimed as already authorized, delivered or measured.

## Financial Baseline — Figures to Keep Consistent

Task 7 estimates the **preferred five-control portfolio** as **C2 MFA ($11,000/year), C1 network segmentation ($30,000/year), C3 Wazuh SIEM ($22,000/year), C4 immutable offsite backups ($21,000/year), and C6 Westside firewall ($13,000/year)**. Their combined **annualized economic cost is $97,000**, with **$23,000 headroom** against a $120,000 annual comparison ceiling; purchase-date treatment of the C1/C6 hardware raises illustrative **first-year cash to $115,000**, leaving **$5,000** under that same nominal ceiling. Task 8 selected this portfolio using fixed, *assumed marginal* risk-reduction scores of **$785,000/year**; **this is not verified, additive enterprise-wide avoided loss**, because VPN, EHR and billing outcomes can belong to the same campaign. Further, the scenario originally presents **$120,000 for the entire six-month program**, which is not automatically interchangeable with an annual-cost allowance: Finance must reconcile cash dates, contract duration, staff time, clinical safety obligations, vCISO costs and other workstreams before signing purchases.

### Objection 1: We have operated for 12 years without a major patient-data breach; why divert $120,000 from nursing or cardiac equipment?

- **Acknowledgment:** Robert Kim is right that a security allocation competes with essential clinical staffing and equipment, and no analyst can demonstrate that a breach **will** occur on a particular date.
- **Counter-Evidence:** The prior billing crypto-miner is evidence of an actual security incident, even though it was not a documented patient-data breach; separately, the assessed estate includes GAP-016 broad network trust, GAP-011 weak identity controls and Finding 003 overly broad EHR database reachability.
- **Counter-Evidence:** Task 5 models a **$135,143/year billing-ransomware ALE** and a **$3,025,000/year full-EHR-breach ALE**, but these are uncertain scenario-specific planning values, not incident forecasts or additive enterprise losses.
- **Business Framing:** A decision to defer should weigh the cost of preserving clinical operations and avoiding uninsured liability against the **$97,000 annualized / $115,000 first-year cash** price of the selected prevention-and-recovery portfolio.
- **Recommendation:** Approve a staged, independently validated release starting with MFA and verified network restrictions, and require measurable coverage and restoration evidence before releasing later spending rather than asking the Board to accept an unsupported prediction.

### Objection 2: ALE is estimated; how can an uncertain model justify a real $120,000 expenditure?

- **Acknowledgment:** The CFO is correct that changing ARO, exposure factor or loss valuation can materially change any ALE and that a point estimate must not be mistaken for an audited loss reserve.
- **Counter-Evidence:** His illustrative **$300,000 ransomware ALE** using **ARO 0.25 and EF 60%** is a **different example** from Task 5's **$135,143 billing-ransomware ALE** and **$2,864,400 compound VPN campaign ALE**; those models must not be substituted for one another.
- **Counter-Evidence:** Holding asset value constant, changing **both** the CFO's ARO and EF by **−30%** or **+30%** would move that illustrative $300,000 ALE to **$147,000** or **$507,000**, respectively, demonstrating why Task 7's $785,000 sum of marginal control scores is not a guaranteed return.
- **Business Framing:** The proper financial approval threshold is **verified, nonoverlapping annual avoided loss greater than the $97,000 annualized cost**, with the higher $115,000 illustrative first-year cash need and deployment timing evaluated separately.
- **Recommendation:** Use low/base/high loss and control-effectiveness cases, confirm actual vendor costs and insurance response, run measurable pilots, and stop or resize controls if their evidence-backed incremental benefits do not clear Finance's threshold.

### Objection 3: Our $38,000 cyber policy is cheaper than paying for security controls.

- **Acknowledgment:** Insurance is an economically useful risk-transfer mechanism, and the existing **$38,000 annual premium**, **$1,000,000 aggregate limit** and **$50,000 deductible** should be included in the CFO's decision.
- **Counter-Evidence:** Task 5's **$9,075,000 gross-additive full-EHR-breach loss scenario** exceeds the stated aggregate limit by **at least $8,075,000 even if the insurer pays the full $1,000,000**; exact retained loss may be higher depending on how the deductible and coverage terms apply, and the scenario's costs themselves may overlap.
- **Counter-Evidence:** Insurance does not itself block compromised VPN access, keep a clinical system operational or restore an unusable PACS backup, while the selected MFA, segmentation and recovery controls address those failure mechanisms.
- **Business Framing:** The relevant comparison is **retained loss after policy limits, deductibles, exclusions and claims conditions**, plus continuity and patient-safety exposure—not a simple $38,000 premium versus $120,000 security-budget comparison.
- **Recommendation:** Keep the current policy, request a broker-led coverage and incident-scenario review, and fund targeted controls alongside insurance while avoiding the assumption that every modeled EHR or clinical loss is insured.

### Objection 4: Security should come from Sarah Park's existing $1.2 million IT budget rather than a new line item.

- **Acknowledgment:** The CFO's concern about competing departmental requests and avoiding duplicated IT spending is valid, particularly because standard patching, system support and maintenance belong in normal IT operations.
- **Counter-Evidence:** The requested **$120,000** equals **10%** of the stated **$1,200,000 annual IT budget**, but the budget's *uncommitted portion is unknown*; similarly, the preferred security portfolio is **$97,000 annualized** rather than proof of a free $97,000 inside IT.
- **Counter-Evidence:** MedDefense's gaps span clinical devices, EHR privacy, outsourced/vendor access and recovery across sites, requiring James Chen, Sarah Park, Finance, Privacy/DPO and Biomedical to own different decisions under Task 4's governance.
- **Business Framing:** Separating incremental, Board-approved risk treatment from ordinary IT operating expense improves cost-center accountability, avoids double billing and gives the CFO clear evidence of what is funded, by whom, and for which residual risk.
- **Recommendation:** Have Sarah and Finance identify already-funded IT activities first, transfer only genuinely available amounts toward eligible controls, then seek a documented incremental security allocation for the unfunded remainder with explicit shared ownership and no duplicate charges.

### Objection 5: Why not authorize $60,000 first, measure results, and ask for the rest later?

- **Acknowledgment:** A staged proof of value is reasonable for a new program, provided the first tranche is evaluated against **actual first-year cash**, not only equipment costs annualized over three years.
- **Counter-Evidence:** Under Task 7 estimates, **C2 MFA ($11,000 annualized) plus C1 segmentation ($30,000 annualized)** score **$550,000/year of assumed marginal ALE reduction** at **$41,000 annualized cost**, but C1's $18,000 equipment purchase raises their modeled first-year cash to **$53,000**, leaving **$7,000** of a strict $60,000 cash tranche.
- **Counter-Evidence:** That narrower pilot postpones Wazuh, Westside's dedicated firewall and the **C4 immutable backup**, so its $550,000 selection score cannot be promised as realized savings and any unprotected clinical-recovery gap must be escalated rather than silently accepted.
- **Business Framing:** Finance can release the $53,000 tranche against documented MFA enrollment, blocked unauthorized inter-zone connections, functioning clinical traffic and a before/after evidence register, then base further commitments on real costs and measured control operation.
- **Recommendation:** Authorize the **$53,000 cash-gated C2+C1 pilot** only if Biomedical, IT and clinical owners confirm an adequate interim protected-backup and recovery arrangement; otherwise substitute the **$54,000 C2+C3+C4 alternative** (assumed **$510,000/year marginal score**) to prioritize detection and immutable recovery, with deferred segmentation explicitly risk-accepted and repriced.

## Closing Statement

The cost of inaction is not provably zero simply because MedDefense has had no documented major patient-data breach: Task 5 estimates separate annual loss exposures of **$135,143 for billing ransomware, $300,000 for negligent insider disclosure, $70,000 for Alaris pump events, $3,025,000 for a full EHR breach, and $2,864,400 for a compound VPN campaign**, yet the EHR/billing consequences overlap the compound campaign, so **there is no defensible single total ALE from adding those five figures**. Against these uncertain but material exposures—and a cyber policy capped at **$1 million aggregate** with a **$50,000 deductible**—the Task 8 preferred five-control package costs **$97,000/year annualized** or approximately **$115,000 first-year cash**, with a **$785,000/year modeled marginal risk-reduction selection score that must not be sold as guaranteed enterprise savings**. The financially defensible choice is to approve only controls that pass procurement, clinical-safety, insurance and measured-effectiveness gates, to reconcile spending with the **single $120,000 six-month program limit**, and to offer a tightly scoped **$53,000 first-year pilot** if the Board insists on a $60,000 tranche while protecting essential clinical recovery throughout the deferral.

## Audit Trail and Evidence Boundaries

- **CFO objections:** DLH-supplied `cfo-pushback.txt`, Robert Kim's five objections (12-year history and miner; ARO/EF critique; existing policy; $1.2m IT budget; proposed $60k tranche).
- **Financial estimates:** [Task 7 — Cost-Benefit Analysis](7-cost_benefit_analysis.md) supplies per-control costs, marginal ARR, hardware annualization and exclusions; [Task 8 — Budget Game](8-budget_allocation.md) supplies the preferred portfolio, $97k annual/$115k year-one cash and deferral trade-offs.
- **Risk bases:** [Task 5 — Risk Equation](5-risk_equation.md) and [Task 6 — ALE Workshop](6-ale_workshop.md) supply severity, occurrence and overlap qualifications.
- **Control evidence and accountability:** [Task 3 — Gap-to-Framework Bridge](3-gap_framework_bridge.md), [Task 4 — Governance Architecture](4-governance_architecture.md), [1x01 Kill Chains](../1x01_know_your_enemy/10-kill_chains.md), and [1x02 CVSS Contextualizer](../1x02_the_weak_links/17-cvss_contextualizer.md).

**Interpretation:** These are scenario-based analyst estimates, not contracted prices, certified insurance coverage, measured prevention rates, certain future losses or authorization to spend.
