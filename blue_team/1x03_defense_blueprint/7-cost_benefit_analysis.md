# Task 7 — The Cost-Benefit Analysis

- **Organization:** MedDefense Health Systems
- **Project:** 1x03 — Defense Blueprint
- **Deliverable:** `7-cost_benefit_analysis.md`
- **Assessment date:** 29 October 2026
- **Audience:** CFO, CEO, James Chen (Deputy CISO), Sarah Park (IT Director)
- **Status:** Proposed security-investment analysis; **no vendor quote, deployment, financial loss, or control effectiveness is represented as verified**

## Executive Decision

Assess all eight specified controls using **annual economic value** and explicitly identify the controls that can fit within a **$120,000 annual planning cap**. The preferred provisional package is **C2 (MFA), C1 (segmentation), C3 (Wazuh), C4 (protected offsite backups), and C6 (Westside firewall)**: **$97,000/year** on the modeled annual-cost basis. This leaves **$23,000 of annual headroom**, but estimated first-year cash use is **$115,000**, leaving just **$5,000** before vCISO, clinical approvals, other workstreams, and contingency. **Do not approve this entire package until the overall six-month program budget is reconciled.**

The figures below are **new, conservative, control-specific marginal planning assumptions**, *not* the full five bundled-control reductions in [Task 6](6-ale_workshop.md). Controls aimed at the same pathway receive distinct incremental benefits; the EHR, billing, and VPN scenario losses can still overlap in a real incident, so neither the eight reductions nor their net values are an independently valid enterprise-wide total.

## Financial Rules, Scope and Model Inputs

- **Baseline ALE:** The five Task 6 risk scenarios: **R1 EHR breach $3,025,000/year**, **R2 VPN/compound ransomware $2,864,400/year**, **R3 negligent insider $300,000/year**, **R4 billing ransomware $135,142.86/year**, and **R5 Alaris pump events $70,000/year**.
- **Annual Risk Reduction (ARR):** `ALE_before - ALE_after`, applied to a clearly specified scenario. For multi-risk controls, separately allocate the improvements to the named risk scenarios. These risk-specific values are **not** a portfolio-wide loss estimate.
- **Annual Cost:** Incremental subscription, storage, or annualized equipment (under **License / infrastructure**); internal labor, including configuration and analysis; and maintenance/support. Capital items use a **straight-line three-year illustrative annualization**. This is an economic comparison, **not identical to year-one cash spend**.
- **Net Value:** `ARR - annual cost`; positive net means the control is mathematically favorable **under these assumptions**, not guaranteed. **Verdicts:** *Justified* if positive and not near break-even; *Marginal* if positive by less than **10% of annual cost**; *Not Justified* if zero or negative.
- **Financial assumptions:** All figures are USD/year. Labor is an imputed incremental staff-time cost, not necessarily a new hire. Cloud consumption, endpoints, retention, support levels, licensing and staffing have **not** been confirmed by quotations. Benefits are assumed at steady-state; no time discounting or deployment delay is included.
- **Risk-chain boundaries:** The teaching-case R2 baseline assumes every VPN compromise leads to a full compound campaign (`q=1`); real progression may be far lower. R2 overlaps R1 and R4. To prevent double credit **within the modeled R2 scenario**, the proposed portfolio uses a sequential reduction ledger below. Task 6's bundled risk-reduction estimates cannot also be added.
- **Source caution:** Finding **010** is actionable for default pump-management credentials even though the firmware-based CVE attribution is disputed; Finding **031** confirms AJP reachability but not necessarily Ghostcat on the reported fixed Tomcat version. Both require vendor/build confirmation. The clinical-safety case is broader than monetary ALE.

## Part 1 — Eight Control Evaluations

### Control 1: Network Segmentation — VLANs for Servers, Workstations, Medical Devices and Guests

- **CIS Control Reference:** **12 — Network Infrastructure Management**; supporting **6 — Access Control Management** and **13 — Network Monitoring and Defense**.
- **Annual Cost:** **$30,000** = **$6,000 infrastructure** (annualized $18,000 switching/ACL-capable equipment over three years) + **$18,000 labor** (network design, staged ACL deployment, clinical flow tests) + **$6,000 maintenance** (rule review, support, change validation).
- **Risk(s) Addressed:** **T6 R2**, VPN-to-AD/domain ransomware; supporting benefit to **R1/R4** is *not separately monetized*. **GAP-016**, Finding **003** (wide PostgreSQL source permissions), Finding **004** (radiology controller exposure), **KC1/KC5**.
- **ALE Reduction:** Allocate **$240,000/year of additional R2 reduction**, conditional on MFA first: `R2 $2,554,400 (after C2) - $2,314,400 (after C1) = $240,000`. This is an assumed improvement in lateral-movement progression, **not** a measured probability reduction.
- **Net Value:** `$240,000 - $30,000 = +$210,000/year`.
- **Verdict:** **Justified**.
- **Recommendation:** **Implement** a phased, default-deny-by-exception zone design with approved VPN, EHR, DICOM and medical-device traffic and documented rollback; avoid assuming VLAN labels alone enforce security.
- **Validation gate:** Tested *denied* unauthorized paths and *allowed* clinical workflows; vendor/Biomedical sign-off and firewall-rule ownership.

### Control 2: MFA on VPN and Administrative Accounts — Reuse Existing O365 E3 Where Possible

- **CIS Control Reference:** **6 — Access Control Management**; supporting **5 — Account Management**.
- **Annual Cost:** **$11,000** = **$0 assumed incremental license** (only if existing licenses and the FortiGate/identity integration actually cover the use case) + **$8,000 labor** (enrollment, legacy account cleanup, conditional policy and rollback design) + **$3,000 maintenance** (joiner/mover/leaver, exceptions, support). **Potential extra licensing is an unpriced dependency**, not presumed free.
- **Risk(s) Addressed:** **T6 R2**, compromised VPN or privileged identity; **GAP-011**, **GAP-016**, Findings **007/018** as *supporting AD-hardening evidence* (not direct proof of VPN MFA status); **KC1**.
- **ALE Reduction:** `R2 $2,864,400 (baseline) - $2,554,400 (after C2) = $310,000/year`, a deliberately limited subset of T6's bundled VPN treatment estimate.
- **Net Value:** `$310,000 - $11,000 = +$299,000/year`.
- **Verdict:** **Justified**.
- **Recommendation:** **Implement first**, subject to verifying the exact O365 versus M365 SKU, Conditional Access/Entra entitlements, integration, clinical/vendor emergency access and licensing.
- **Licensing gate:** *Microsoft 365 E3* includes Entra ID P1; *Office 365 E3* should **not** automatically be treated as including P1/Conditional Access. Standard MFA methods may already be available, but exact conditional policies and third-party VPN enforcement must be tested. If additional P1 or VPN licenses are necessary, reprice the control before approval.

### Control 3: Enterprise SIEM — Self-Hosted Wazuh

- **CIS Control Reference:** **8 — Audit Log Management** and **13 — Network Monitoring and Defense**.
- **Annual Cost:** **$22,000** = **$0 software license/infrastructure** (Wazuh open-source and **reuse of already available capacity assumed**) + **$18,000 labor** (collection, rules, tuning, analyst review) + **$4,000 maintenance labor** (updates, storage hygiene, backup and rule maintenance). **This is labor-only under the task's stated configuration; hardware/storage procurement would increase the cost.**
- **Risk(s) Addressed:** **T6 R2 and R1**; **GAP-017** delayed record-export alerts, **GAP-016** perimeter/trust visibility; Findings **003/031** are technical context, not proof of successful exfiltration; **KC1/KC5**.
- **ALE Reduction:** **$65,000 R2 + $90,000 R1 = $155,000/year**, allocated to distinct detection/response opportunities rather than a second claim of MFA or segmentation benefit. `R2 $2,279,400 (after C2, C1, C6) - $2,214,400 = $65,000`; `R1 $3,025,000 - $2,935,000 = $90,000`.
- **Net Value:** `$155,000 - $22,000 = +$133,000/year` **as a scenario-allocation score, not an additive enterprise saving**.
- **Verdict:** **Justified**.
- **Recommendation:** **Implement** a limited-scope, business-hours analyst-operated Wazuh deployment starting with VPN/AD, firewall, PostgreSQL, critical EHR logs and endpoint sensor health; do not label Wazuh itself a 24/7 staffed SOC.
- **Validation gate:** Alert drills, log-source freshness and retention, owner acknowledgement times, host capacity and clinician-safe non-agent monitoring for medical devices.

### Control 4: Offsite Immutable Backup Replication — AWS S3 Glacier

- **CIS Control Reference:** **11 — Data Recovery**; supporting **3 — Data Protection**.
- **Annual Cost:** **$21,000** = **$12,000 cloud storage/requests/retrieval allowance** (not a conventional software license) + **$6,000 labor** (replication, credential separation, full-service restore tests) + **$3,000 maintenance** (retention review, backup monitoring, retrieval testing).
- **Risk(s) Addressed:** **T6 R4**, billing ransomware/recovery; **GAP-007** shared backup failure domain, **GAP-003** PACS exclusion; Finding **015** reachable NAS management; **KC1**, with **KC3** as an imaging-recovery concern. **No unmeasured PACS benefit is included in ARR.**
- **ALE Reduction:** Assume R4 incident **frequency unchanged** at `1/3.5/year`, but full-event **SLE decreases** from `$473,000` to `$315,500` after a proven protected recovery path. Then `($473,000 - $315,500) / 3.5 = $45,000/year`. `R4 $135,142.86 - $90,142.86 = $45,000`.
- **Net Value:** `$45,000 - $21,000 = +$24,000/year`.
- **Verdict:** **Justified**, conditional on restoring real usable services within approved times.
- **Recommendation:** **Implement** S3 Versioning and Object Lock with separated backup credentials and scheduled restores, but pair archival Glacier with an appropriately fast recovery tier for EHR/PACS if clinical RTO requires it.
- **Validation gate:** Prove immutability, restore a consistent data-plus-application service, measure recovery time and obtain clinical acceptance. Glacier Flexible Retrieval can require hours for standard/bulk restoration; it is **not automatically suitable as the sole rapid-recovery copy**.

### Control 5: EDR Upgrade — Sophos Intercept X / Current Sophos Endpoint Equivalent

- **CIS Control Reference:** **10 — Malware Defenses**.
- **Annual Cost:** **$41,000** = **$28,000 incremental endpoint/server subscriptions** + **$9,000 labor** (deployment and integration, fixing non-reporting sensors) + **$4,000 maintenance** (agent health, licensing, tuning). The endpoint count and server SKU are assumptions pending an inventory and reseller quote; **unsupported MRI/medical-device operating systems may be ineligible**.
- **Risk(s) Addressed:** **T6 R2, R1 and R4**; Finding **027** non-reporting Sophos endpoints and Findings **001/002** as billing threat context; **KC1**.
- **ALE Reduction:** Incremental *after* the five preferred controls, assume **$10,000 R2 + $20,000 R1 + $13,000 R4 = $43,000/year**. Sample marginal outcomes: `R2 $2,214,400 → $2,204,400`; `R1 $2,935,000 → $2,915,000`; `R4 $90,142.86 → $77,142.86`. Do not credit the same attack interruption to both SIEM and EDR.
- **Net Value:** `$43,000 - $41,000 = +$2,000/year`.
- **Verdict:** **Marginal** (net margin ≈ 4.9% of annual cost; vulnerable to licensing and efficacy uncertainty).
- **Recommendation:** **Defer** an all-estate upgrade; first repair existing Sophos coverage and seek a smaller, verified high-risk server/endpoint quote and pilot.
- **Product gate:** Current Sophos product naming and license bundles may differ from the legacy “Intercept X” wording; confirm appropriate supported server coverage and incremental cost rather than assuming a generic upgrade applies to every endpoint.

### Control 6: Dedicated Westside Clinic Firewall — Replace Consumer Router

- **CIS Control Reference:** **12 — Network Infrastructure Management**; supporting **13 — Network Monitoring and Defense**.
- **Annual Cost:** **$13,000** = **$5,000 infrastructure/licensing** ($9,000 replacement appliance annualized over three years = $3,000, plus $2,000 security subscriptions) + **$6,000 labor** (site design, changeover, policy, testing) + **$2,000 maintenance** (support, backup config, rule review).
- **Risk(s) Addressed:** **T6 R2**, cross-site entry/lateral spread; **GAP-016**, heterogeneous site boundaries, Finding **003** broad internal EHR source reachability (supporting, not evidence the consumer router caused it); **KC1**.
- **ALE Reduction:** Allocate **$35,000** incremental R2 reduction after MFA and segmentation: `R2 $2,314,400 - $2,279,400 = $35,000/year`.
- **Net Value:** `$35,000 - $13,000 = +$22,000/year`.
- **Verdict:** **Justified**.
- **Recommendation:** **Implement** a centrally managed, vendor-supported Westside firewall with authenticated intersite traffic, explicit ACLs, VPN and telemetry integrated with the segmentation rollout.
- **Validation gate:** Confirm business continuity, permitted clinical traffic, rejected disallowed lateral paths, reliable logs and documented failover.

### Control 7: Outsourced 24/7 Security Operations Center (Managed SOC)

- **CIS Control Reference:** **13 — Network Monitoring and Defense**; supporting **17 — Incident Response Management**.
- **Annual Cost:** **$185,000** = **$150,000 managed monitoring subscription/service** + **$25,000 internal labor** (triage coordination, vendor escalation and clinical incident decisions) + **$10,000 maintenance** (integrations, onboarding/retention changes, rule and SLA management).
- **Risk(s) Addressed:** **T6 R2 and R1**, ransomware and EHR breach escalation; **GAP-017**, fragmented security monitoring, **KC1/KC5**.
- **ALE Reduction:** Hypothetically **$40,000 R2 + $40,000 R1 = $80,000/year**, **incremental after the selected Wazuh/SIEM and prevention controls**, not a duplicate credit for Wazuh's existing alert coverage. Illustrative before→after: `R2 $2,214,400 → $2,174,400`; `R1 $2,935,000 → $2,895,000`.
- **Net Value:** `$80,000 - $185,000 = −$105,000/year`.
- **Verdict:** **Not Justified** by the modeled ALE comparison; it also independently exceeds the $120,000 budget.
- **Recommendation:** **Reject/defer this full 24/7 SOC contract** for the present funding cycle; use alert routing, on-call escalation and a scoped managed-detection quote if coverage requirements warrant it.
- **Validation gate:** Get an actual 24/7 service quote, incident SLAs, response authority and evidence of marginal reduction beyond Wazuh; statutory or clinical requirements can override a purely financial verdict.

### Control 8: Full Medical-Device Network Isolation with Dedicated Monitoring

- **CIS Control Reference:** **12 — Network Infrastructure Management**, **13 — Network Monitoring and Defense**; supporting **6 — Access Control Management**.
- **Annual Cost:** **$44,000** = **$14,000 equipment/software annualization** + **$24,000 labor** (Biomedical/vendor-supported design, staged clinical workflow validation, monitoring integration) + **$6,000 maintenance** (vendor service, change control and alert review).
- **Risk(s) Addressed:** **T6 R5**, Alaris patient-care DoS/integrity events; **GAP-001** device-specific detection/recovery and **GAP-016** broad management reachability; Finding **010** (default credentials; firmware CVE still disputed), **KC4**.
- **ALE Reduction:** Preserve nonoverlapping DoS-only and patient-safety cases from T6. `Before = $100,000 × 0.10 + $3,000,000 × 0.02 = $70,000/year`. Assume safely isolated management and monitoring reduce rates to `0.05` and `0.01`; `After = $100,000 × 0.05 + $3,000,000 × 0.01 = $35,000/year`. ARR = **$35,000/year**; assumes other T6 device fixes are *not* credited a second time.
- **Net Value:** `$35,000 - $44,000 = −$9,000/year`.
- **Verdict:** **Not Justified** for the **full dedicated isolation/monitoring scope** under the financial-only ALE model. **Patient safety remains a separate decision constraint.**
- **Recommendation:** **Defer full-scale procurement**, but immediately fund or reallocate toward vendor-approved unique management credentials, restricted management sources, clinical fallback and passive monitoring; escalate residual clinical risk to patient-safety owners even if ALE is modest.
- **Validation gate:** BD/Biomedical sign-off, successful infusion workflow testing, approved maintenance paths, benign alert drill and independent clinical risk acceptance. Never isolate active devices in a way that interrupts treatment.

## Part 2 — Cost-Benefit Summary, Ranked by Net Value

All amounts are USD per **year**. `L/I` = license, cloud or annualized equipment/infrastructure; `Labor` and `Maint.` complete the **annual cost**. ARR values are **marginal scenario allocations**, not independently additive enterprise savings.

| Rank | Control | CIS | L/I | Labor | Maint. | Annual Cost | ALE Reduction (ARR) | Net Value | Verdict | Budget proposal |
|---:|---|---|---:|---:|---:|---:|---:|---:|---|---|
| **1** | **C2 — VPN/admin MFA** | 6 | $0* | $8,000 | $3,000 | **$11,000** | **$310,000** | **+$299,000** | Justified | **Select** |
| **2** | **C1 — Network segmentation** | 12 | $6,000 | $18,000 | $6,000 | **$30,000** | **$240,000** | **+$210,000** | Justified | **Select** |
| **3** | **C3 — Wazuh SIEM** | 8, 13 | $0† | $18,000 | $4,000 | **$22,000** | **$155,000** | **+$133,000** | Justified | **Select conditionally** |
| **4** | **C4 — Immutable offsite backup** | 11 | $12,000 | $6,000 | $3,000 | **$21,000** | **$45,000** | **+$24,000** | Justified | **Select** |
| **5** | **C6 — Westside firewall** | 12 | $5,000 | $6,000 | $2,000 | **$13,000** | **$35,000** | **+$22,000** | Justified | **Select** |
| **6** | **C5 — Sophos EDR upgrade** | 10 | $28,000 | $9,000 | $4,000 | **$41,000** | **$43,000** | **+$2,000** | Marginal | Defer |
| **7** | **C8 — Full device isolation** | 12, 13 | $14,000 | $24,000 | $6,000 | **$44,000** | **$35,000** | **−$9,000** | Not Justified (financial) | Defer full scope; do safety minimum |
| **8** | **C7 — 24/7 managed SOC** | 13, 17 | $150,000 | $25,000 | $10,000 | **$185,000** | **$80,000** | **−$105,000** | Not Justified | Reject/defer |

`*` MFA price assumes existing entitlements/integration; **Office 365 E3 vs Microsoft 365 E3 must be validated**. `†` Wazuh reuse of existing infrastructure assumed; no incremental hardware/cloud costs. **Prices are analyst estimates, not market quotations.**

### Explicit ALE Allocation and Non-Duplication Ledger

This ledger describes a **sequence**, *not an empirical forecast*. Within R2, each selected control receives only an incremental benefit. R1/R4 overlap R2 in a real campaign, so totals across risk rows remain non-additive.

| Scenario | Stage | ALE before | Allocated improvement | ALE after |
|---|---|---:|---:|---:|
| **R2 VPN/compound** | Baseline → **C2 MFA** | $2,864,400 | $310,000 | $2,554,400 |
| R2 | After C2 → **C1 segmentation** | $2,554,400 | $240,000 | $2,314,400 |
| R2 | After C1 → **C6 firewall** | $2,314,400 | $35,000 | $2,279,400 |
| R2 | After C6 → **C3 Wazuh** | $2,279,400 | $65,000 | $2,214,400 |
| **R1 EHR** | Baseline → **C3 Wazuh** | $3,025,000 | $90,000 | $2,935,000 |
| **R4 billing** | Baseline → **C4 backup** | $135,142.86 | $45,000 | $90,142.86 |
| **R5 pumps** | Alternative **C8**, not selected | $70,000 | $35,000 | $35,000 |

**Alternative, non-selected marginal cases:** If C5 were added *after* the selected portfolio, allocate $10,000 to R2, $20,000 to R1, and $13,000 to R4; if C7 were instead added, allocate $40,000 each to R2/R1 *after* Wazuh. **Do not claim both alternative estimates as completed savings**, and never stack these allocations on top of Task 6's already bundled ARR. R3 is not credited to any of the eight controls here; direct insider export/DLP/training investment remains a separate, currently unpriced workstream.

## Part 3 — Which Controls Fit the $120,000 Annual Budget?

| Selected, in risk-priority order | Annual cost | Cumulative annual cost |
|---|---:|---:|
| C2 — MFA | $11,000 | $11,000 |
| C1 — Segmentation | $30,000 | $41,000 |
| C4 — Offsite immutable backups | $21,000 | $62,000 |
| C6 — Westside firewall | $13,000 | $75,000 |
| C3 — Wazuh SIEM (conditional) | $22,000 | **$97,000** |
| **Annual cap** | | **$120,000** |
| **Unallocated annual headroom** | | **$23,000** |

**First-year cash correction:** Annualized equipment includes C1 `$18,000 / 3 = $6,000` and C6 `$9,000 / 3 = $3,000`. If these appliances must be paid for immediately, replacing the `$9,000` annualized charges with `$27,000` purchase cash increases first-year cash requirements from `$97,000` to **`$115,000`** (`+$18,000`). Thus **only $5,000** remains in the year of purchase, assuming all other cost allocations apply. Existing hardware, grants or installment terms could change this. **Do not conflate annualized economic cost, first-year cash and the earlier six-month implementation cap.**

**Approval recommendation:** Finance should reserve funding for the vacant-CISO/vCISO governance requirement (Task 4), DLP/insider control needs (T6 R3), pump minimum-safe controls, clinical/vendor testing and a contingency. The full **five-control package is mathematically under the annual cap but not yet a complete, funded six-month security program**. A safer initial authorization is **C2 + C1 + C4 + C6** (`$75,000/year` annualized; about `$93,000` first-year cash), with **C3 released only after actual resource, staffing and portfolio quotes are confirmed**. This keeps approximately **$27,000 first-year cash headroom** at that gate, rather than assuming Wazuh and governance have no competing resource needs.

**Governance and ethics:** The CEO approves spending and exceptional risk acceptance; James owns prioritization and reporting, Sarah owns technical change execution, the Security Analyst measures evidence, and Biomedical/clinical leaders must approve medical-device changes. A negative financial net value **never automatically authorizes unsafe patient care, noncompliance or the acceptance of an unreviewed critical risk**.

## Part 4 — Verification and Sensitivity Tests

1. **License gate:** Determine whether the existing subscription is **Office 365 E3** or **Microsoft 365 E3**, what Entra ID P1/Conditional Access and FortiGate MFA licenses are actually available, and reprice C2.
2. **Price gate:** Obtain scoped vendor quotes for managed firewall, Sophos servers/endpoint counts and AWS storage footprint, requests, egress, retention and emergency retrieval; record actual year-one purchases and ongoing costs separately.
3. **Effectiveness gate:** Perform authorized positive/negative access tests after C1/C2/C6; alert simulation and observed acknowledgement times after C3; complete application-consistent backups, restore and recovery-time tests for C4. Re-estimate loss severity and occurrence *after* validation.
4. **Clinically safe implementation:** Medical device VLAN/ACL changes, PACS/DICOM paths and pump management require Biomedical/vendor approvals, rollback, and witnessed clinical workflow testing; network segmentation is not a license to block patient care.
5. **CFO sensitivity:** If actual R2 event frequency or full-campaign progression (`q`) is half the classroom baseline, the monetary justification for C1/C2/C6 weakens. If endpoint license cost increases by more than `$2,000`, the nominal C5 margin disappears even before benefit uncertainty. If cloud storage, retrieval or rapid-tier needs exceed the `$12,000` allowance, C4 must be repriced. If clinical event likelihood is higher than assumed, C8 may warrant investment despite negative modeled net value.
6. **Residual coverage:** The eight controls do not directly complete privileged account cleanup, PACS backup scope, pharmacy change validation or the formal vCISO/risk-acceptance architecture; log these as separate program dependencies rather than declaring the strategy complete.

## Evidence Index and Product-Feature Checks

**MedDefense project evidence:**

- [Task 6 — ALE Workshop](6-ale_workshop.md): five baseline ALEs and distinct bundled-control post-treatment models. **This Task 7 does not reuse those full bundled ARR values for individual controls.**
- [Task 5 — Risk Equation](5-risk_equation.md): AV, EF, SLE, ARO math and uncertainty/sensitivity of original scenario figures.
- [Task 3 — Gap-to-Framework Bridge](3-gap_framework_bridge.md): GAP-016, 011, 017, 006, 007, 001 and related 1x02 findings and 1x01 threat chains.
- [Task 4 — Governance Architecture](4-governance_architecture.md): RACI, approval and clinical/vendor consultation.
- [Task 2 — CIS Controls Audit](2-cis_controls_audit.md): CIS Control numbering and MedDefense's provisional assessments.

**Official vendor/product documentation (features, *not* quoted prices):**

- Microsoft Entra licensing: <https://learn.microsoft.com/en-us/entra/fundamentals/licensing> — Entra ID P1/Conditional Access entitlement distinctions.
- Wazuh official documentation: <https://documentation.wazuh.com/current/quickstart.html> — free platform and required components; personnel and platform capacity are not free.
- AWS S3 Object Lock: <https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock.html> — immutable retention and version governance.
- AWS S3 restore options: <https://docs.aws.amazon.com/AmazonS3/latest/userguide/restoring-objects-retrieval-options.html> — restoration latency can be hours.
- Sophos endpoint portfolio update: <https://www.sophos.com/es-es/partner-news/powerful-refresh-of-the-sophos-endpoint-security-portfolio> — current endpoint product naming and licensing review requirement.

**Decision disclaimer:** The annual costs, control-specific risk reductions, rankings and staged portfolio are transparent analyst scenarios. They are **not** measured ALE changes, vendor quotations, actuarially reliable probabilities, a regulatory compliance certification or approval to spend.
