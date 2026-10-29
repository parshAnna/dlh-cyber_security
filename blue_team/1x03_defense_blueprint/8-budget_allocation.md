# Task 8 — The Budget Game

- **Organization:** MedDefense Health Systems
- **Project:** 1x03 — Defense Blueprint
- **Deliverable:** `8-budget_allocation.md`
- **Assessment date:** 29 October 2026
- **Prepared for:** Board, CFO, CEO and James Chen (Deputy CISO)
- **Decision status:** Proposed allocation requiring Board, Finance and clinical approval; no funds have been committed
- **Constraint:** **$120,000 annual-cost ceiling** for the Task 7 control comparison; separately reconcile the **$120,000 total six-month program ceiling** established in the scenario

## Executive Decision

**Proposed primary allocation:** Fund **C2 (VPN/admin MFA), C1 (segmentation), C3 (Wazuh SIEM), C4 (immutable offsite backup), and C6 (Westside firewall)**. Their **combined Task 7 annualized cost is $97,000**, leaving **$23,000 annualized headroom**. Their sum of *assumed, separately allocated marginal ALE reductions* is **$785,000/year**. This is the highest scoring subset under the $120,000 annualized cost limit when treating the Task 7 control-specific risk-reduction scores as fixed inputs. It is **not a validated or additive enterprise loss saving**: VPN, EHR and billing consequences overlap.

**Cash and authorization caveat:** Paying for the $18,000 segmentation equipment and $9,000 Westside appliance at purchase rather than annualizing each over three years increases first-year modeled cash from **$97,000 to $115,000**, leaving just **$5,000 of first-year cash headroom** before funding a vCISO, legal/privacy work, clinical safety, training, staffing, extra MFA licensing or other blueprint activities. The portfolio should be **selected for planning but released in stages**, with the C3 Wazuh commitment contingent on quotes, staffing and confirmation that the entire six-month program remains within its actual approved limit. **No claim of a finalized affordable whole-program budget is made.**

### Budget Summary — Explicit Values

- **Total spend:** $97,000 annualized (97000); $115,000 first-year modeled cash cost.
- **Budget ceiling:** $120,000 (120000).
- **Budget remaining:** $23,000 annualized; $5,000 first-year cash headroom.

These figures cover the selected control portfolio, not an approved whole-program budget.

## Method: Decision Rules and Exact Budget Test

1. **Reused inputs:** Use each control's annualized cost and *marginal* ARR from [Task 7](7-cost_benefit_analysis.md) unchanged. Do not substitute Task 6's bundled ARR for a single control.
2. **Decision variables:** Each of eight controls is either selected (`x_i = 1`) or not (`x_i = 0`). Annualized-budget model: `maximize SUM(ARR_i × x_i)` subject to `SUM(annual_cost_i × x_i) <= $120,000`.
3. **Enumeration:** Exactly **101 of the 256 subsets** of the eight controls satisfy the annualized constraint (including the empty subset); **C7, at $185,000/year, cannot occur in any feasible subset**. Exhaustive comparison identifies the $97,000 / $785,000 subset as the optimum under these fixed, additive *selection scores*.
4. **Separate objective from real loss modeling:** The mathematical optimum is valid for these assumed individual scores only. Event pathways, loss categories, confidence intervals and control interactions can change the true joint optimum. Do **not** sum the five pre-control ALEs or assert an enterprise-wide $785,000 cash saving. Maintain a risk-event/benefit ledger and recalibrate after deployment.
5. **Funding authority:** CEO/Board approve spending and residual-risk exceptions; James Chen owns risk prioritization; Sarah Park owns technical changes; Security validates; Biomedical, Privacy/DPO and clinical leadership must approve patient-impacting changes. See [Task 4](4-governance_architecture.md).

### Control Input Ledger — Directly from Task 7

| ID | Proposed control | Annualized cost | Assumed marginal ARR/year | Net value/year | Task 7 economic judgment |
|---|---|---:|---:|---:|---|
| C1 | Network segmentation | $30,000 | $240,000 | +$210,000 | Justified |
| C2 | VPN/administrator MFA | $11,000 | $310,000 | +$299,000 | Justified |
| C3 | Wazuh SIEM | $22,000 | $155,000 | +$133,000 | Justified |
| C4 | Immutable offsite backup | $21,000 | $45,000 | +$24,000 | Justified |
| C5 | Sophos EDR upgrade | $41,000 | $43,000 | +$2,000 | Marginal |
| C6 | Westside firewall | $13,000 | $35,000 | +$22,000 | Justified |
| C7 | Outsourced 24/7 SOC | $185,000 | $80,000 | -$105,000 | Not Justified |
| C8 | Full medical-device isolation / dedicated monitoring | $44,000 | $35,000 | -$9,000 | Not Justified on financial grounds |

### Cross-Task Traceability and Safety Constraints

- **C2 / C1 / C6:** Primarily **T6 R2**, VPN-to-domain ransomware (1x01 **KC1**, **GAP-011 / GAP-016**, Findings **007/018** as AD-supporting evidence, **003** as a downstream database path). The Findings do not independently prove VPN MFA is disabled.
- **C3:** **T6 R2** and **T6 R1** (KC1 / KC5, **GAP-017** delayed EHR monitoring and broad internal reachability, Findings **003/031**; Ghostcat applicability for the reported Tomcat version remains unverified).
- **C4:** **T6 R4** billing recovery, **GAP-007 / GAP-003**, Finding **015** exposed backup-NAS management, KC1 / possible KC3 imaging disruption. The $45,000 ARR **does not price the potentially substantial unquantified PACS recovery benefit**.
- **C5:** T6 R2/R1/R4, Finding **027** non-reporting Sophos sensors; **C8:** T6 R5, **GAP-001**, Finding **010** management credentials, **KC4**. Firmware-CVE applicability is contested; safe controls remain necessary.
- **C7:** T6 R1/R2 detection/escalation. Its proposed $80,000 ARR is *incremental to* selected Wazuh and preventive controls, not a duplicate claim for the SIEM.

## Part 1 — Binding-Style Selection and Trade-offs

### Fund These Five Controls (subject to release gates)

| Fund | Annualized cost | Assumed marginal ARR/year | Annualized net value | Budget committed cumulatively | Control-specific release/evidence gate |
|---|---:|---:|---:|---:|---|
| **C2 — MFA** | $11,000 | $310,000 | +$299,000 | $11,000 | Confirm Office 365 E3 vs Microsoft 365 E3/Entra entitlement, VPN integration, named accounts and emergency access; verify enforcement |
| **C1 — Network segmentation** | $30,000 | $240,000 | +$210,000 | $41,000 | Approved traffic matrix, denied unauthorized paths and successful clinical/EHR/DICOM workflows |
| **C3 — Wazuh SIEM** | $22,000 | $155,000 | +$133,000 | $63,000 | Verify existing compute/storage, analyst capacity, log ingestion, alert triage and full-program budget; staged funding release |
| **C4 — Immutable offsite backups** | $21,000 | $45,000 | +$24,000 | $84,000 | S3 Object Lock/credential separation, app-consistent restores, PACS scope and recovery tier fast enough for clinical RTO |
| **C6 — Westside firewall** | $13,000 | $35,000 | +$22,000 | **$97,000** | Replace consumer router safely, centralize rules/logs and test protected intersite clinical traffic |
| **Total** | **$97,000** | **$785,000** | **+$688,000** | **$97,000** | **Model estimates only; not summed actual enterprise savings** |

**Annualized spending check:** `$11,000 + $30,000 + $22,000 + $21,000 + $13,000 = $97,000 <= $120,000`; unallocated annualized balance: **$120,000 − $97,000 = $23,000**.

**Year-one cash check:** C1 annualized infrastructure `$6,000` corresponds to an assumed `$18,000` purchase; C6 annualized appliance `$3,000` corresponds to an assumed `$9,000` purchase. Replacing `$9,000` of depreciation charges with `$27,000` up-front cash yields **`$97,000 − $9,000 + $27,000 = $115,000` estimated year-one cash**, only **$5,000 below** the same nominal cap. Actual six-month cash timing and total-program affordability **cannot be inferred** from annualized figures. Task 6's five-workstream `$110,000` six-month plan is a **different illustrative packaging**, not extra funding to add to this Task 8 selection.

**Benefit-allocation check (non-additive across related scenarios):**

| Task 6 event model | Task 7 sequence | Allocated ARR within that scenario | Modeled ALE left after selected controls |
|---|---|---:|---:|
| **R2 VPN/compound** | C2 `$310,000`; C1 `$240,000`; C6 `$35,000`; C3 `$65,000` | `$650,000` | `$2,864,400 − $650,000 = $2,214,400` |
| **R1 EHR breach** | C3 `$90,000` | `$90,000` | `$3,025,000 − $90,000 = $2,935,000` |
| **R4 billing outage** | C4 `$45,000` | `$45,000` | `$135,142.86 − $45,000 = $90,142.86` |
| **R3 negligent insider** | No direct Task 7 control budgeted for export policy/training | `$0` directly credited | `$300,000` baseline proxy still unaddressed |
| **R5 Alaris events** | Full C8 not funded | `$0` directly credited | `$70,000` baseline proxy, pending safety mitigations |

The column above is a **scenario-specific scorekeeping exercise**. R2 already contains EHR/billing consequences; the five rows do **not** represent five statistically independent losses, and neither their residual ALEs nor their benefits may be added into an official total. Benefits must not also be counted from Task 6's bundled after-control results.

### Defer to Next Fiscal Year

**C5 — Full-estate Sophos EDR upgrade ($41,000 annualized; $43,000 modeled ARR).** Its just **$2,000** net-value margin is only 4.9% of cost; adding C5 to the selected five costs **$138,000**, exceeding the cap by **$18,000**. Defer enterprise-wide upgrade, first restore reporting for existing Sophos sensors (Finding 027), inventory supported servers/OSs and obtain a smaller high-risk pilot/quote. A new quote or observed failure rate may change the decision. **This is not permission to leave existing antivirus coverage broken.**

**C8 — Full medical-device isolation and dedicated monitoring ($44,000 annualized; $35,000 modeled ARR).** Adding it to the chosen package costs **$141,000**, exceeding the cap by **$21,000**; annualized net value is **negative $9,000** under Task 7 estimates. Defer the *full package* to next-year clinical/vendor review, **not patient-safety protection**: require Biomedical/BD-approved unique pump-management credentials, source restrictions, passive observation, safe configuration recovery and time-bounded residual-risk sign-off now. Escalate if clinical safety standards require further immediate isolation irrespective of ALE.

### Reject the Current Proposal

**C7 — $185,000/year outsourced, continuously staffed SOC.** The contract alone exceeds the entire cap by **$65,000**, while its incremental modeled benefit is only `$80,000/year`, giving **−$105,000/year net value**. **Reject this full-scope contract under current assumptions**, not detection/incident response itself. Continue scoped Wazuh alerts, on-call escalation and an approved incident response plan; reassess a materially cheaper targeted MDR service or a new fiscal-year budget if threat/coverage requirements change.

### Decision and Exception Register

| Decision | Owner / approval | Action before purchase or acceptance |
|---|---|---|
| Approve the $97,000 annualized *selection* | CEO/Board + CFO | Validate **$115,000 year-one cash**, other required program costs and incremental licensing before binding purchase orders |
| Release C2/C1/C4/C6 deployment | Sarah Park; James oversight | Verified support/clinical network paths, restore-test plan, accountable change and rollback |
| Release C3 Wazuh allocation | James + Sarah + Finance | Prove staff coverage and host capacity; no assumption of a 24/7 SOC; verify residual cash headroom |
| Accept deferral of C5 | James / Sarah | Repair existing non-reporting protection; reassess price, endpoint coverage and R2/R1/R4 response outcomes |
| Accept deferral of C8 | Clinical risk owner + Biomedical + James, escalate to CEO | Obtain BD approvals, safe minimum protections and documented clinical residual-risk/exception review |
| Reject C7 contract | CEO / Board with James | Preserve incident-response ownership and SLAs; revisit only on new cost/benefit evidence |

## Part 2 — Opportunity Cost of Deferred Controls

**Definition used in this assignment:** The opportunity cost of not selecting a control is the **Task 7 estimated *additional avoidable annual ALE*** attributable to that control *if it could be deployed successfully*. It is **not the entire residual ALE of the underlying event**, is not a guaranteed benefit, and cannot be summed with overlapping breach pathways into a portfolio total.

| Deferred item | T6 risk allocation in Task 7 | ALE potentially avoidable but not funded | Annual cost avoided by deferral | What risk remains |
|---|---|---:|---:|---|
| **C5 — Full EDR** | R2 `$10,000` + R1 `$20,000` + R4 `$13,000` | **$43,000/year** | **$41,000/year** | Existing malware detection gaps and the additional modeled avoidable portion of ransomware/EHR/billing loss |
| **C8 — Full device isolation** | R5: pump DoS and patient-safety event rates | **$35,000/year** | **$44,000/year** | R5 modeled baseline `$70,000/year`; about `$35,000/year` of it is the *hypothetical* incremental benefit of C8, before any mandatory minimum-safety improvements |

**Required opportunity-cost statements:**

- **By deferring C5 (Sophos EDR), MedDefense accepts an estimated $43,000 in *additional potentially avoidable annual risk exposure*** under the Task 7 incremental model; that number is allocated to R2, R1 and R4 and does not equal their total residual ALE.
- **By deferring C8 (full medical-device isolation), MedDefense accepts an estimated $35,000 in *additional potentially avoidable annual risk exposure*** under the full C8 model. The remaining **$70,000 baseline pump ALE** and patient-safety duties must still be managed; the exact residual will change after minimum safe protections.

**Rejected C7 (not classed as a next-year commitment):** The modeled `$80,000/year` *potential* marginal reduction is foregone by rejecting the `$185,000/year` contract, but would cost **$105,000/year more than its modeled reduction** and is individually unaffordable. This is a documented rejection trade-off, **not** a claim that MedDefense should accept uncontrolled 24/7 monitoring gaps.

**Avoid false totals:** The C5 `$43,000` can overlap incident consequences already in other models, and C8's patient-safety severity can be poorly represented by money. Do not characterize `$43,000 + $35,000 + $80,000` as the organization's actual residual ALE; these are **separate counterfactual marginal benefits**, not mutually exclusive independent events.

## Part 3 — A Lower-Cost Alternative Allocation

**Alternative B: Fund C2 + C1 + C3 + C6; postpone C4 offsite immutable replication subject to demonstrably acceptable interim backup protections.**

| Allocation comparison | **Primary A** (C2+C1+C3+C4+C6) | **Alternative B** (C2+C1+C3+C6) |
|---|---:|---:|
| Annualized control cost | **$97,000** | **$76,000** |
| Annualized headroom from $120,000 | $23,000 | **$44,000** |
| Assumed incremental ARR selection score | **$785,000/year** | **$740,000/year** |
| Share of primary modeled ARR | 100% | **94.27%** |
| Sum-of-marginal-scores net/year (ARR − annualized cost) | $688,000 | **$664,000** |
| Year-one cash after C1/C6 equipment purchase adjustment | **$115,000** | **$94,000** |
| Year-one cash headroom | **$5,000** | **$26,000** |
| Benefit sacrificed by cheaper choice | — | **$45,000/year** (C4) |
| Annualized cost saved vs primary | — | **$21,000/year** |

**Math:** Alternative ARR `C2 $310,000 + C1 $240,000 + C3 $155,000 + C6 $35,000 = $740,000/year`; alternative annualized cost `$11,000 + $30,000 + $22,000 + $13,000 = $76,000/year`. It retains **94.27%** of the primary's modeled benefit while saving **$21,000/year** in annualized spending and approximately **$21,000 in modeled year-one cash**. Its modeled annual net score is **$24,000 below** the primary (`$688,000 − $664,000`).

**Alternative B's added opportunity cost:** By deferring **C4**, MedDefense also accepts an estimated **$45,000/year of additional potentially avoidable billing-recovery ALE** from T6 R4 (modeled `$135,142.86` remains instead of `$90,142.86`). More importantly, backups/PACS restoration are an existing **GAP-007/GAP-003** clinical continuity obligation. Therefore **Alternative B is only acceptable if** existing protected, independently recoverable copies and clinically agreed RTO/RPO can be demonstrated or paid for from another specifically identified fund; otherwise the cheaper plan creates an unacceptable recovery gap. **The primary remains the preferred model-based selection.**

A second mathematically near-equal feasible option is **C1+C2+C3+C5+C6**, costing **$117,000** for a modeled **$783,000/year** score—**$20,000 more** than the primary for **$2,000 less** modeled benefit. It is therefore *dominated by* the primary under the supplied annualized numbers and is not recommended as a cost-saving alternative.

## Sensitivity, Approval Gate and Final Board Recommendation

- **Modeled maximum, not a proven optimum:** The $97,000/$785,000 portfolio is the exact optimum of the Task 7 *fixed-score annualized knapsack*. Because the R2 VPN teaching baseline assumes every compromise becomes a full joint campaign (`q = 1`), realized risk reduction may be substantially lower; review event-tree probabilities and correlated EHR/billing impacts before a CFO savings claim.
- **Reconcile two time bases:** Task 7 is an **annual economic comparison**; the program context gives **$120,000 for the full six-month blueprint**. Record actual payment dates, one-time purchases, vendor contract terms, internal labor and any previously promised Task 6/vCISO expenditure in **one** signed cash plan; do not layer different Task 6 and Task 7 portfolio costs as if independently funded.
- **Protect residual safety and privacy obligations:** Even without full C8, do not defer vendor-approved pump-management security, clinical fallback, DPO/privacy reviews, and required backup integrity. An annual monetary ALE comparison is not a substitute for patient safety or GDPR duties.
- **Funding conditions:** Confirm MFA licensing (Office 365 E3 is not interchangeable with Microsoft 365 E3), Wazuh storage/analyst availability, S3 Object Lock and acceptable retrieval speed, network/intersite interoperability and hardware purchase terms. Unquoted dependencies could exhaust the **$5,000 first-year cash margin**.
- **Governance release order:** Approve the *priority ranking* now, fund C2/C1/C4/C6 only after their validation gates, reserve C3 as a conditional release, and explicitly document the C5/C8 deferred risks and C7 rejection with accountable sign-off. If the whole-program cash ceiling is breached, return a repriced portfolio to the Board; do not present this analysis as permission to overspend.

**Final recommendation:** Use **Primary A** as the best modeled investment allocation (**$97,000 annualized; $115,000 illustrative first-year cash; $785,000 in non-additive marginal ARR selection scores**). Preserve clinical safety and privacy obligations, secure Board/Finance acceptance of deferred exposures, and convert estimated benefits into evidence-backed loss-frequency/severity changes before claiming ROI or declaring controls implemented.

## Evidence and Source Index

- [Task 7 — Cost-Benefit Analysis](7-cost_benefit_analysis.md): eight control costs, annualized cash adjustments, per-control marginal ARR and validation conditions.
- [Task 6 — ALE Workshop](6-ale_workshop.md): five before/after quantitative risk scenarios, uncertain loss rates and overlap caution.
- [Task 5 — Risk Equation](5-risk_equation.md): definitions of AV/EF/SLE/ARO/ALE and scenario estimation assumptions.
- [Task 3 — Gap-to-Framework Bridge](3-gap_framework_bridge.md): MedDefense GAP IDs and associated vulnerabilities/threat chains.
- [Task 4 — Governance Architecture](4-governance_architecture.md): RACI, CISO/vCISO governance, clinical safety escalation and acceptance authority.
- [1x01 — Kill Chains](../1x01_know_your_enemy/10-kill_chains.md) and [1x02 — CVSS Contextualizer](../1x02_the_weak_links/17-cvss_contextualizer.md): context for modeled risks; not proof of exploitation.

**Evidence standard:** All costs and ALE improvements are **analyst planning assumptions from Task 7**, not vendor quotations, empirically measured benefit, guaranteed savings, certified compliance or approval to spend.
