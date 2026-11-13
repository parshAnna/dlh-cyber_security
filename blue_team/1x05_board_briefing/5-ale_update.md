# MedDefense Health Systems — Task 5: The ALE Update

**Project:** 1x05 — Emergency Board Briefing  
**Required file:** `blue_team/1x05_board_briefing/5-ale_update.md`  
**Assessment date:** 12 November 2026; **scenario clock:** first 72 hours after the exercise's Crimson Tide alert  
**Prepared for:** Dr. Patricia Morales (CEO), Robert Kim (CFO), James Chen (Deputy CISO), Sarah Park (IT Director), Maria Santos (General Counsel), and the Board  
**Status:** **Emergency scenario model — not an actuarial estimate, approved budget, documented intrusion, or verified control benefit.**

## Executive decision

**Original compound VPN-to-ransomware ALE: $2,864,400/year. Updated 12-month stress case: $5,728,800/year**, assuming the **same $9,548,000 single-loss exposure** and a **hypothetical increase in effective full-campaign ARO from 0.30 to 0.60/year**. The increase is **$2,864,400/year (+100%)** in an explicitly judgment-based high-alert scenario. Five affected hospitals in ten days, including three nearby, establish a **regional threat cluster**, not the per-hospital probability that the course scenario supplies no denominator to estimate. A 90-day-burst illustration yields a less aggressive **$3,570,690/year** equivalent. Neither should be described as a statistically established MedDefense annual forecast.

**Recommendation:** Authorize emergency **$2,400/year Fortinet support renewal, subject to entitlement and procurement verification**, coupled with immediate clinically approved SSL-VPN exposure mitigation, verified firmware/upgrade pathway, forensic triage and backup preservation. Revalidate—not mechanically rewrite—the 1x03 portfolio economics. Seek **separate, capped emergency authority above the $120,000 program planning ceiling only if Finance confirms no reprioritization can safely fund the needed work**, with a named owner, invoice/quote, clinical change gate and Board review within 72 hours. A support payment *without successful risk-reducing action* has **no demonstrated ROI**.

---

## Part 1 — Original versus updated ALE

### 1.1 Exact original model: 1x03 T5/T6 Risk 2 (VPN compromise → compound ransomware/data theft)

The original T6 calculation is for **R2, the combined VPN/AD/EHR/billing ransomware scenario**; it is not the stand-alone billing ransomware case (R4, **$135,142.86/year**), and it must not be added to the full EHR disclosure case (R1, **$3,025,000/year**) as independent losses. R2 already reuses consequences of those pathways.

| Original input | Original value | Origin/meaning |
|---|---:|---|
| Asset Value (AV) | **$13,460,000** | Assumed combined exposure pool in [1x03 T5](../1x03_defense_blueprint/5-risk_equation.md) |
| Exposure Factor (EF) | **$9,548,000 / $13,460,000 = 70.9361%** | Illustrative fraction lost in one *complete* compound event |
| Single Loss Expectancy (SLE) | **$13,460,000 × EF = $9,548,000/event** | Modeled combined attack cost, **not measured** |
| Annualized Rate of Occurrence (ARO) | **0.30 events/year** | Teaching assumption: VPN compromise frequency, **not a hospital-specific measured rate** |
| Conditional chain completion (`q`) | **1.00** | Original exercise effectively assumes every counted VPN compromise produces the *full* compound event |
| **Original ALE** | **$9,548,000 × 0.30 × 1.00 = $2,864,400/year** | Low-confidence classroom baseline |

**Calculation, without rounding the exposure factor prematurely:**

```text
Original SLE = $13,460,000 × ($9,548,000 / $13,460,000) = $9,548,000
Original ALE = SLE × ARO_VPN × q
             = $9,548,000 × 0.30 × 1.00 = $2,864,400/year
```

The original [T6 analysis](../1x03_defense_blueprint/6-ale_workshop.md) explicitly warns that `q=1` is an intentionally conservative full-chain assumption, and some EHR and billing loss categories may overlap. Keep that warning when presenting the new result.

### 1.2 What the new Crimson Tide intelligence does—and does not—tell us

**Exercise-provided observations:** 5 hospitals attacked within 10 days; 3 are in MedDefense's geographic region; Hospital C, about 45 miles away, is in active containment; the attack reportedly uses a FortiGate SSL-VPN vulnerability, lateral movement, Kerberoasting, EHR exfiltration and backup destruction. MedDefense's FortiGate 100F reportedly runs **FortiOS 7.0.9**. A **$2,400/year support renewal** is needed for approved firmware access. **Internet-facing SSL-VPN enablement and evidence of actual MedDefense compromise have not yet been established.**

**Statistical limit:** `5 attacks / 10 days = 0.5 attacked hospitals/day observed in this cluster`, **not** `0.5 attacks/day for MedDefense`. We do **not** know how many comparable hospitals were exposed, whether incidents are independent, whether the attackers concentrated on one configuration, their campaign duration, or how many attempts failed. Multiplying 0.5 by 365 or treating `3/5` as MedDefense's compromise probability would be invalid. Moreover, our original 0.30 describes **VPN compromises**, while the report's five events are **hospital attacks**: they are different denominators and event definitions.

**Assessment update, not data-estimated posterior:** Use the cluster, FortiOS vulnerability match, regional proximity, unverified SSL-VPN listener, flat network, EHR plaintext and fragile backup isolation to **assign a temporary 2× relative-likelihood stress factor** for *theoretical* planning, **subject to technical verification and review**. The factor **2** is an analyst assumption, **not** a rate derived from the five observed cases. To be dimensionally consistent, the same illustrative full-chain `q=1` is retained. If SSL-VPN is disabled and there is no matching exposure, the factor must be reconsidered promptly.

### 1.3 Updated 12-month stress-case calculation

```text
ARO_updated = ARO_original × assumed regional/exposure stress factor
            = 0.30 × 2.0 = 0.60 full-chain-equivalent events/year
SLE_updated = SLE_original = $9,548,000 per complete event
ALE_updated = SLE_updated × ARO_updated × q
            = $9,548,000 × 0.60 × 1.00 = $5,728,800/year
Absolute increase = $5,728,800 − $2,864,400 = $2,864,400/year
Relative increase = ($5,728,800 / $2,864,400 − 1) × 100 = 100%
```

**Why SLE is unchanged:** The advisory says attacks are more proximate and apparently active; it does **not** provide MedDefense-specific additional cost per clinical outage, an exact patient count exfiltrated, incident duration, regulatory penalty or lost revenue. Thus we adjust **likelihood only**. If evidence shows longer outages or larger data losses, the CFO must independently revisit SLE using de-duplicated cost components.

| Model | ARO/year | SLE/event | ALE/year | Change versus T6 | Interpretation |
|---|---:|---:|---:|---:|---|
| **T6 original** | 0.30 | $9,548,000 | **$2,864,400** | — | Existing low-confidence baseline |
| Low stress | 0.45 | $9,548,000 | $4,296,600 | +$1,432,200 | 1.5× subjective multiplier |
| **Emergency stress (decision case)** | **0.60** | **$9,548,000** | **$5,728,800** | **+$2,864,400** | **2× subjective multiplier; NOT observed per-hospital ARO** |
| Severe stress | 0.90 | $9,548,000 | $8,593,200 | +$5,728,800 | 3× subjective multiplier |
| Extreme repeat-event stress | 1.20 | $9,548,000 | $11,457,600 | +$8,593,200 | Expected frequency may exceed one event/year; **not a probability** |

**Conditional progression sensitivity:** If `q=0.25` rather than 1, the decision-case full-campaign ALE becomes `$9,548,000 × 0.60 × 0.25 = $1,432,200/year`; if `q=0.40`, it is **$2,291,520/year**. These are alternate assumptions, not measurements. The base and updated estimates must use the **same event definition and q** when claiming the difference is solely an ARO change.

### 1.4 A campaign-burst alternative (avoids assuming heightened activity for 12 months)

An alternative sensitivity case assumes **only 90 days** at the doubled annualized hazard and the other **275 days** at the original annualized hazard, without assuming that the hospital's risk has permanently doubled:

```text
Expected events/year = (90/365 × 0.60) + (275/365 × 0.30)
                     = 0.3739726 full-chain-equivalent events/year
12-month loss equivalent = 0.3739726 × $9,548,000
                         = $3,570,690/year (rounded)
```

This is **not** a prediction that the campaign will last 90 days. It shows why a surge whose duration is unknown cannot automatically be extrapolated across the full year. Given the nonstationary threat, **review both ARO and `q` at 24, 48 and 72 hours** using firewall exposure, patch status, observed scans, actual IOCs, working backup isolation and threat-intelligence updates.

### 1.5 Evidence ledger and confidence

| Claim | Classification | Verification required |
|---|---|---|
| Five similar hospitals hit in ten days, three nearby | **Course-scenario supplied** | Obtain original provided Crimson Tide advisory; no public CISA incident count independently established |
| FortiOS 7.0.9 is in affected FortiOS 7.0.0–7.0.11 range for CVE-2023-27997 | **Confirmed version match in scenario; independent vendor/CERT vulnerability facts** | Read-only live firmware inventory and FortiGate SSL-VPN exposure check |
| SSL-VPN actually reachable over WAN on MedDefense | **Unknown** | Sarah: configuration and controlled externally observed listener evidence |
| MedDefense already compromised, stolen patient data or NAS deleted | **Unknown—not confirmed** | James: incident triage, approved telemetry and preserved evidence |
| New ARO = 0.60/year | **Analyst stress assumption, low confidence** | Develop relevant hospital denominator, exposure-weighted incident-rate model and campaign duration |
| Full `q=1` event after every VPN compromise | **Teaching assumption; low confidence** | Test whether segmentation, access paths, key custody and recoverability permit real full-chain progression |

---

## Part 2 — Budget impact and investment decisions

### 2.1 Preserve the actual 1x03 T7/T8 starting point

The original [T7 cost-benefit analysis](../1x03_defense_blueprint/7-cost_benefit_analysis.md) assessed eight **annualized** controls. T8 **conditionally selected**, but did **not approve or deploy**, `C2+C1+C3+C4+C6` at **$97,000/year modeled annual cost** and **$115,000 illustrative first-year cash**. The exercise separately states a **$120,000 six-month program cash ceiling**; first-year and six-month cost bases cannot be compared without a cash-flow schedule. The apparent `$5,000` first-year headroom is **not an available certified emergency reserve**.

| Control | Original annual cost | Original modeled marginal ARR | Original net | Original T7/T8 decision | Campaign relevance |
|---|---:|---:|---:|---|---|
| **C1 — Segmentation** | $30,000 | $240,000 | **+$210,000** | Selected conditionally | **High:** constrains phases 2–4 and 7 after perimeter access |
| **C2 — VPN/admin MFA** | $11,000 | $310,000 | **+$299,000** | Selected conditionally | **Qualified:** helps stolen-credential access, **not pre-auth CVE-2023-27997** |
| **C3 — Wazuh SIEM** | $22,000 | $155,000 | **+$133,000** | Selected conditionally | High detection/response value; does **not** stop initial exploit by itself |
| **C4 — Immutable offsite backup** | $21,000 | $45,000 | **+$24,000** | Selected conditionally | **High:** limits **total** backup destruction and recovery loss, not initial compromise |
| **C5 — Full Sophos EDR** | $41,000 | $43,000 | **+$2,000** | **Marginal; defer full estate** | Relevant to server persistence and ransomware, if coverage works |
| **C6 — Westside firewall** | $13,000 | $35,000 | **+$22,000** | Selected conditionally | Partial lateral/site boundary; Central perimeter needs separate attention |
| **C7 — Outsourced staffed 24/7 SOC** | $185,000 | $80,000 | **−$105,000** | **Not justified; rejected full scope** | Better response hours, but benefit/coverage not established |
| **C8 — Full medical-device isolation** | $44,000 | $35,000 | **−$9,000** | **Not justified financially; full rollout deferred** | Important clinical safety objective; primary modeled risk is pump/biomedical (R5), not FortiGate entry |

**Important:** T7's original assumed `ARR` values are **marginal allocations to different risk cases**, not real-world measured prevented attacks and **not a percentage of total ALE**. In the original ledger C3 comprises `$65,000` for R2 and `$90,000` for R1; C5 alternative comprises `$10,000` R2 + `$20,000` R1 + `$13,000` R4; C7 alternative `$40,000` R2 + `$40,000` R1. R1/R2/R4 overlap in a real campaign, so arithmetic is illustrative and must not be presented as additive total savings.

### 2.2 Would previously Not Justified controls change status?

**Decision: No automatic reversal.** A new ARO for **VPN-linked R2** does not increase the **separate pump-event R5 ARO** used for C8; its `$35,000` ARR against `$44,000` cost remains **−$9,000/year** under the existing R5 assumptions. Nonetheless biomedical safeguards and patient safety may need immediate action for reasons independent of financial ROI.

For **C7 full 24/7 SOC**, use a transparent **sensitivity only**, scaling **only** the original `$40,000` allocated R2 benefit by the 2× ransomware stress factor, while holding its distinct `$40,000` R1 allocation fixed:

```text
Illustrative C7 updated ARR = ($40,000 × 2) + $40,000 = $120,000/year
Illustrative C7 net         = $120,000 − $185,000 = −$65,000/year
```

Thus even this *optimistic simple proportional* sensitivity **does not make the full C7 contract financially justified**. Because C3 Wazuh alert handling overlaps C7 services, seek a **short, priced emergency MDR/on-call arrangement** before contemplating a new full-year `$185,000` contract. Obtain its response SLA, deployment lead time and incremental efficacy evidence.

**C5 was already marginally positive, not originally a Not Justified item.** Applying the same hypothetical scaling only to its T7 R2 `$10,000` component gives `($10,000 × 2) + $20,000 + $13,000 = $53,000 ARR`, net **+$12,000/year** versus `$41,000` cost; the improvement is **assumption-dependent** and not evidence of measured EDR effectiveness. Adding C5 to the originally selected `$97,000/year` package produces **$138,000/year**, exceeding the original `$120,000` **annualized** optimization cap before any other emergency spending. Prioritize restoring existing inactive agents, targeted server coverage and vendor-priced options, not an unfunded full rollout tonight.

**C1/C2/C3/C4/C6:** high priority for different control points, but **do not double C2's anti-credential benefit for a pre-authentication heap-overflow attack**; MFA cannot be modeled as preventing exploit of CVE-2023-27997. Likewise encryption at rest will not prevent authorized live database reads by a domain administrator, and immutability primarily reduces consequences (**SLE / q**) rather than VPN attack frequency (**ARO**). A fresh control-by-control conditional probability model and actual technical evidence are needed before asserting a new ROI ranking.

### 2.3 Fortinet support renewal: break-even, conditional ROI, decision

**Scenario:** FortiGate 100F is on FortiOS 7.0.9, within the CVE-2023-27997 affected range. Access to a vendor-approved firmware image is blocked by an expired support contract. **Renewal costs $2,400 per year.** This is a procurement **dependency**, not the patched firmware itself; it does not harden the appliance unless the correct image is installed and validated, with the SSL-VPN listener/paths appropriately contained in the meantime. FortiOS 7.0.14 fixes this **specific** CVE but is also inside a **separate** FortiOS 7.0.0–7.0.16 affected range for CVE-2024-55591; choose a current vendor-supported 100F build after checking *all* applicable PSIRT advisories and upgrade path, not automatically the first downloadable 7.0.14 image. [E1–E3]

**Economic test:** `ARR attributable to renewal + safe patch/containment = SLE × (ARO_before_full_event − ARO_after_full_event)`. This requires **same SLE and event definition**, includes effective risk-chain progression, and cannot be set equal to the whole `$5.7288m` unless all probability is eliminated. For direct economic break-even ignoring labor and service downtime:

```text
Break-even ARR >= $2,400/year
Required reduction in full-event ARO >= $2,400 / $9,548,000
                                    = 0.00025136 events/year
As fraction of decision-case ALE = $2,400 / $5,728,800
                                 = 0.000418936 = 0.0419%
```

**Illustration, not predicted patch effectiveness:** If the verified remediation package reduces the modeled *full-event ARO* by **1% relative**, from `0.600` to `0.594` per year, while holding SLE/q fixed, then `ARR = $9,548,000 × 0.006 = $57,288/year`; **net annual modeled benefit = $54,888**, and **ROI = ($57,288 − $2,400)/$2,400 × 100 = 2,287%**. That result is *conditional* on actual exposed SSL-VPN, 1% realized risk reduction, and no offsetting risk transfer. **With renewal alone and no deployed change, modeled ARR = $0 and financial net = −$2,400/year**. A compromised gateway could also remain compromised after a version upgrade; preserve logs, investigate persistence and determine whether rebuild/rekey is required.

**Recommendation:** **Approve the $2,400 emergency entitlement with written conditions**, because it is a relatively inexpensive *enabler* for correcting a known-exploited critical CVE on a single perimeter device, **not** because an unverified 2,287% ROI is a certified return. Sarah obtains the official entitlement, signed image, approved 100F release and tested upgrade/rollback; James requires incident assessment and safe SSL-VPN mitigation; Robert reconciles invoice, labor, support duration, procurement and budget category; clinical leadership verifies all three site VPN and care workflows.

### 2.4 Should the Board approve spending above $120,000?

**Yes, conditionally authorize a narrowly scoped exception if needed to remove the known perimeter exposure and preserve recovery—not an unlimited increase of the six-month plan.** Do **not** imply the original `$120,000` is available cash: the 1x03 `$97,000` annualized portfolio, `$115,000` illustrative year-one cash and six-month program cap have **different time bases** and the controls are **proposals, not committed contracts**. If the `$2,400` renewal is the only increment to the illustrative `$115,000` year-one cash plan, arithmetic gives `$117,400`, apparently still under `$120,000` by `$2,600`; **this does not prove affordability** because six-month obligations, other work, service contracts and the actual schedule are unknown. The Board should approve an emergency **spend authority/cap outside the routine sequence only after a same-period Finance reconciliation**, not assert an overrun is inevitable.

| Emergency decision | Recommended treatment | Owner, validation and time |
|---|---|---|
| Fortinet renewal $2,400/year | **Authorize immediately** from demonstrably available cash or explicit emergency exception; purchase legally supported access only | CEO/Robert approval and procurement; Sarah confirms entitlement and correct patch; James signs off risk handling in first 12–36 h |
| Safe temporary SSL-VPN containment and triage | **Start without waiting for a purchase**, with patient-care and intersite checks; preserve configuration and logs | James incident authority; Sarah executes read-only confirmation then clinically approved restrict/disable; first hours |
| Independent isolated backup and verified restore | Preserve known-good copies before any disruptive change; **get quote and authorizations** if immutable offsite needs new provider | Sarah/backup lead; DPO and clinical owners approve storage/location/restore; within 72 h |
| Temporary detection, EDR expansion or MDR | Use existing licenses and emergency on-call first; approve additional vendor work only against a scoped quote/SLAs | James, Sarah, Robert; 24–72 h |
| Full C7 or C8 procurement | **Do not auto-approve** based on ARO doubling; require updated benefits, clinical criteria and cash plan | CFO and Board in later gated decision |

**Clinical safety and legal:** All network and backup work requires named downtime/rollback limits, evidence custody, privacy assessment and Biomedical/Radiology approvals before touching medical equipment. A risk number cannot justify disrupting patient care without safe alternative workflows. Maria Santos must be informed promptly if logs indicate unauthorized access; notification duties follow confirmed facts and legal assessment, not the hypothetical ALE.

---

## 3. Decision gates: what would change the estimate within 72 hours?

| Deadline relative to advisory | Minimum evidence and numerical decision |
|---|---|
| **0–12 hours** | Confirm FortiGate SSL-VPN mode and WAN listener; preserve configuration, logs and current session/administration evidence; inventory latest signed firmware and support renewal status; verify backup integrity and isolated copy. **If SSL-VPN demonstrably disabled/nonreachable**, reduce the assumed exposure multiplier and reassess other intrusion paths. |
| **12–36 hours** | Board authorizes `$2,400` dependency plus any bounded procurement exception; Sarah/James validate approved contain-or-patch method and telemetry; Robert produces same-period program cash forecast and fresh Fortinet invoice/quotes. Re-estimate `q`, SLE and ARO **without mechanically reusing** scenario parameters as facts. |
| **36–72 hours** | Validate firmware against PSIRT/upgrade path and three-site connectivity; test denies on unwanted VPN→AD/EHR/NAS paths, strong service identities and independent restore; review logs for actual exploitation; recompute risk scenarios with evidence, not assumed closure. |

**Risk owners:** James maintains the incident/risk ledger; Sarah tracks tested remediation and change rollback; Robert owns cash/ROI assumptions; CEO/Board approves exceptional risk/funding decisions; DPO/Legal and clinical leaders assess PHI and treatment impacts. **Escalate immediately** if confirmed compromise, PHI extraction, lost recovery copies or patient-safety harm is observed; do not wait for the next spreadsheet refresh.

## 4. Explicit residual-risk and accounting boundaries

1. **ALE is not a probability**. ARO is expected event frequency per year; it can exceed 1.00, while a per-year probability cannot.
2. **The source-data denominator is missing**. The advisory's five events cannot yield a defensible per-hospital ARO without a population of comparable, exposed hospitals and a defined observation window.
3. **The campaign may be transient**. Use the 90-day sensitivity and 24/48/72-hour intelligence review instead of presenting a permanent 2× baseline as fact.
4. **Frequency, progression and severity differ**. Vulnerable firmware, compromised credentials, full EHR export, and total restoration loss are separate conditional events; an incident can stop short of `q=1`.
5. **Pre-auth and MFA differ**. MFA is not a fix for the exposed SSL-VPN heap overflow; applying its old T7 benefit to this entry point would overstate control value.
6. **Immutable ≠ encrypted**. Encryption protects confidentiality of backup data; independent immutability/offline custody preserves recoverability against deletion. Conversely, online/unlocked disk encryption does not prevent authorized-file exfiltration.
7. **No double-counting**. R2's full-event SLE includes EHR/billing consequences; do not add R1 or R4 ALE to it as if each were independent; do not count the same saved event multiple times across C1/C2/C3/C4.
8. **No unwarranted financial certification**. T7 ARR inputs and this task's stress multipliers are classroom planning values, not observed intervention effectiveness or actual vendor quotes.

## 5. Sources and traceability

### Prior MedDefense work (same repo)

- [1x03 T5 — The Risk Equation](../1x03_defense_blueprint/5-risk_equation.md): `$13,460,000` R2 AV; `$9,548,000` SLE, `0.30` VPN-compromise ARO; original `$2,864,400` full-chain ALE and `q` caveat.
- [1x03 T6 — The ALE Workshop](../1x03_defense_blueprint/6-ale_workshop.md): original and after-control R2/R1/R4; **bundled** control benefit must not substitute for T7 marginal benefit.
- [1x03 T7 — The Cost-Benefit Analysis](../1x03_defense_blueprint/7-cost_benefit_analysis.md): C1–C8 original costs/ARR/decisions and R2/R1/R4 marginal allocation.
- [1x03 T8 — The Budget Game](../1x03_defense_blueprint/8-budget_allocation.md): selected C1+C2+C3+C4+C6 provisional `$97,000/year`, first-year illustrative `$115,000`, six-month cash-ceiling reconciliation.
- [1x03 T17 — Security Strategy](../1x03_defense_blueprint/17-security_strategy.md): controls unapproved/not deployed and governance/clinical gates.
- [1x05 T0 — Advisory Analysis](0-advisory_analysis.md), [T1 — CVE Deep Dive](1-cve_deep_dive.md), [T2 — Kill Chain Overlay](2-kill_chain_overlay.md), [T3 — Emergency Plan](3-emergency_plan.md), [T4 — Crypto Emergency](4-crypto_emergency.md): course threat claims, FortiGate exposure uncertainty, seven-stage kill chain and 72-hour decisions.
- [1x04 T15 — Crypto Posture Audit](../1x04_crypto_foundation/15-crypto_posture_audit.md), [T20 — Implementation Playbook](../1x04_crypto_foundation/22-implementation_playbook.md): distinct unencrypted EHR/NAS risks and approved-change requirements.

### Independent technical and risk-method references

- [E1] [CERT-EU, Security Advisory 2023-038 (13 June 2023)](https://cert.europa.eu/publications/security-advisories/2023-038/) — CVE-2023-27997 affects FortiOS 7.0.0–7.0.11 and is pre-auth SSL-VPN RCE; patched in FortiOS 7.0.12 for this specific flaw.
- [E2] [Fortinet PSIRT, analysis of CVE-2023-27997](https://www.fortinet.com/blog/psirt-blogs/analysis-of-cve-2023-27997-and-clarifications-on-volt-typhoon-campaign) — SSL-VPN enablement is a key prerequisite; vendor recommends immediate action when enabled.
- [E3] [Fortinet FortiOS 7.0.12 resolved issues](https://docs.fortinet.com/document/fortigate/7.0.12/fortios-release-notes/289806/resolved-issues) and [NVD CVE-2024-55591](https://nvd.nist.gov/vuln/detail/CVE-2024-55591) — do not treat a historical CVE fix as proof of protection from subsequent separate issues.
- [E4] [NIST SP 800-30 Rev. 1](https://csrc.nist.gov/pubs/sp/800/30/r1/final) — threat-source likelihood considers targeting, susceptibility, threat capability, evidence, timeframe and uncertainty; not an invented incident-rate denominator.

**Final audit disposition:** **ALE increase is an explicitly modeled decision scenario, not a measured 100% rise in MedDefense incident probability.** Financial recommendations require verified exposed path, installed mitigation and a deduplicated same-period budget before the Board can treat the risk reduction as achieved.
