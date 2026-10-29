# Task 2 — The CIS Controls Audit

**Organization:** MedDefense Health Systems
**Project:** 1x03 — Defense Blueprint
**Deliverable:** `2-cis_controls_audit.md`
**Assessment date:** 29 October 2026
**Prepared for:** James Chen, Deputy CISO, and Sarah Park, IT Director
**Scope:** All 18 CIS Critical Security Controls, version 8; MedDefense's three sites and documented cloud, clinical, and business services
**Planning constraints:** Six months; combined security-program budget not to exceed **$120,000**

## Assessment Method and Evidence Standard

This is a **control-level, evidence-based baseline**, not a completed CIS Safeguards assessment, certification, or independent technical audit. The three ratings below are those required by this DLH task:

| Score | Application to this assessment |
|---|---|
| **Implemented** | Operational control is evidenced as functioning across its relevant scope; isolated successful use is insufficient. |
| **Partial** | At least one relevant operational element exists, but necessary scope, reliability, oversight, or verification is incomplete. |
| **Not Implemented** | No operating implementation is evidenced in the supplied assessments; this is a **provisional evidence-based rating**, not proof that an undocumented mechanism does not exist. |

The scoring evidence comes from the **MedDefense 1x00 security posture and control inventory**, **1x01 threat scenarios/kill chains**, and **1x02 vulnerability findings**. Analyst-produced inventories, recommendations, threat models, proposed remediation, and Task 23 validation procedures are **not counted as implemented enterprise controls**. A finding's scanner severity or classification (AC/AS/I) is not a CIS control-maturity score. Findings involving disputed firmware/CVE applicability require vendor confirmation. Each control is scored **as a whole**, not by averaging its individual Safeguards; **IG1 completion cannot be inferred from these 18 ratings**.

The task's six-month aspiration is **all 56 IG1 Safeguards implemented and selected IG2 Safeguards implemented**, subject to a safeguard-by-safeguard baseline, authorized changes, healthcare safety testing, vendor approval where applicable, and funding approval. Controls **13, 16 and 18 have no IG1 Safeguards in CIS v8** and are nevertheless assessed because this task requires all 18 Controls. See the [official CIS v8 Navigator](https://www.cisecurity.org/controls/cis-controls-navigator/v8) and [CIS Implementation Groups](https://www.cisecurity.org/controls/implementation-groups).

## Part 1 — Eighteen-Control Assessment

### CIS Control 1: Inventory and Control of Enterprise Assets
**Score:** Partial
**Evidence:** [1x00 GAP-012](../1x00_first_watch/12-gap_analysis.md) and [1x02 Findings 028/029](../1x02_the_weak_links/16-triage.md) identify undocumented Linux/Grafana devices despite a newly assembled asset registry, so ongoing ownership, authorization and reconciliation are not demonstrated.

### CIS Control 2: Inventory and Control of Software Assets
**Score:** Partial
**Evidence:** [1x02 Task 12](../1x02_the_weak_links/12-legacy_systems.md) documents unsupported systems, including the Windows XP MRI controller, while the [triage](../1x02_the_weak_links/16-triage.md) identifies software exposures without evidence of an enterprise-maintained approved software and version inventory.

### CIS Control 3: Data Protection
**Score:** Partial
**Evidence:** [1x00 Task 9](../1x00_first_watch/9-data_map.md) maps sensitive clinical data, but [GAP-006 and GAP-017](../1x00_first_watch/12-gap_analysis.md) identify overly broad EHR database access and inadequate bulk-export safeguards.

### CIS Control 4: Secure Configuration of Enterprise Assets and Software
**Score:** Partial
**Evidence:** The [1x00 control matrix](../1x00_first_watch/10-complete_control_matrix.md) documents some hardening on `ehr-srv-01`, but [1x02 Findings 004, 007 and 031](../1x02_the_weak_links/16-triage.md) identify legacy SMB, AD configuration and exposed AJP weaknesses elsewhere.

### CIS Control 5: Account Management
**Score:** Partial
**Evidence:** [1x00 GAP-011](../1x00_first_watch/12-gap_analysis.md) documents shared PACS identities, password-based SSH and weak account accountability despite existing Windows account policies.

### CIS Control 6: Access Control Management
**Score:** Partial
**Evidence:** [1x00 GAP-011](../1x00_first_watch/12-gap_analysis.md) states that MFA is evidenced only for James Chen's unspecified account, while [KC1](../1x01_know_your_enemy/10-kill_chains.md) models the risk of a VPN foothold combined with overly broad access toward AD.

### CIS Control 7: Continuous Vulnerability Management
**Score:** Partial
**Evidence:** The [1x02 triage](../1x02_the_weak_links/16-triage.md) prioritizes 31 assessed findings, but [Task 23](../1x02_the_weak_links/23-validation_plan.md) describes **proposed** verification and remediation rather than an evidenced recurring patch-and-rescan closure process.

### CIS Control 8: Audit Log Management
**Score:** Partial
**Evidence:** The [1x00 control matrix](../1x00_first_watch/10-complete_control_matrix.md) records local firewall/Windows logging (`C-004`, `C-034`) and delayed EHR audit exports (`C-037`, 48 hours), without demonstrated centralized, timely security-log review.

### CIS Control 9: Email and Web Browser Protections
**Score:** Not Implemented
**Evidence:** [KC3](../1x01_know_your_enemy/10-kill_chains.md) recommends centrally managed email/attachment/link protection as a future break point, but the supplied assessments provide no verified operational DNS filtering or managed email/browser-protection control.

### CIS Control 10: Malware Defenses
**Score:** Partial
**Evidence:** The [1x00 control matrix](../1x00_first_watch/10-complete_control_matrix.md) confirms Sophos detection on some workstations (`C-018`), whereas [1x02 Finding 027](../1x02_the_weak_links/16-triage.md) reports 15 inactive or non-reporting endpoints and server/medical-device protection gaps remain.

### CIS Control 11: Data Recovery
**Score:** Partial
**Evidence:** The [1x00 control matrix](../1x00_first_watch/10-complete_control_matrix.md) shows local backups and limited restoration tests (`C-022`–`C-024`), while [GAP-003 and GAP-007](../1x00_first_watch/12-gap_analysis.md) show that PACS lacks a documented recovery copy and production/backups share a failure domain.

### CIS Control 12: Network Infrastructure Management
**Score:** Partial
**Evidence:** [1x00 GAP-016](../1x00_first_watch/12-gap_analysis.md) and the [control matrix (`C-002`/`C-003`)](../1x00_first_watch/10-complete_control_matrix.md) show some perimeter enforcement but overly broad VPN/intersite access and unverified least-privilege segmentation of critical zones.

### CIS Control 13: Network Monitoring and Defense
**Score:** Partial
**Evidence:** The [1x00 control matrix (`C-004`)](../1x00_first_watch/10-complete_control_matrix.md) establishes limited firewall traffic logging, but [GAP-001](../1x00_first_watch/12-gap_analysis.md) identifies no evidenced infusion-pump-specific detection and central alerting is unverified.

### CIS Control 14: Security Awareness and Skills Training
**Score:** Partial
**Evidence:** [1x01 KC3](../1x01_know_your_enemy/10-kill_chains.md) references existing training controls (`C-032`/`C-033`) but [1x00 GAP-014](../1x00_first_watch/12-gap_analysis.md) describes incomplete coverage and insufficient Radiology-specific phishing preparation.

### CIS Control 15: Service Provider Management
**Score:** Partial
**Evidence:** [1x00 supplier controls (`C-054`/`C-055`)](../1x00_first_watch/10-complete_control_matrix.md) evidence MedTech support/update obligations, while [1x01 KC5](../1x01_know_your_enemy/10-kill_chains.md) identifies unverified vendor-specific MFA, time-bound access and independent maintenance-session monitoring.

### CIS Control 16: Application Software Security
**Score:** Not Implemented
**Evidence:** [1x02 Finding 031](../1x02_the_weak_links/16-triage.md) identifies an exposed EHR AJP/Ghostcat path, while the supplied reports do not evidence a deployed, repeatable application security development, testing or vendor-assurance process.

### CIS Control 17: Incident Response Management
**Score:** Partial
**Evidence:** The [1x00 control matrix](../1x00_first_watch/10-complete_control_matrix.md) records weak ad-hoc billing response and service restarts (`C-047`/`C-048`), whereas the [1x02 validation plan](../1x02_the_weak_links/23-validation_plan.md) proposes—not proves—formal escalation, rollback and sign-off.

### CIS Control 18: Penetration Testing
**Score:** Not Implemented
**Evidence:** [1x02 Task 4](../1x02_the_weak_links/4-exploit_hunt.md) provides exploit-availability research and [Task 23](../1x02_the_weak_links/23-validation_plan.md) provides planned safe retesting, but neither documents an authorized periodic penetration-testing program or completed penetration-test reports.

## Part 2 — Scorecard Summary

| Score | Number of controls | Control IDs | Percentage of 18 |
|---|---:|---|---:|
| **Implemented** | **0** | None verified at enterprise scope | **0.0%** |
| **Partial** | **15** | 1–8, 10–15, 17 | **83.3%** |
| **Not Implemented** | **3** | 9, 16, 18 | **16.7%** |
| **Total** | **18** | 1–18 | **100%** |

**Calculation:** `0 + 15 + 3 = 18`; percentages are `count / 18 × 100`, rounded to one decimal place. These figures show the **distribution of whole-Control judgments**, **not** the fraction of CIS Safeguards met, a measured cyber-risk reduction, or a certified compliance percentage. No control is rated Implemented because the available evidence does not establish sustained, complete operational coverage; the three Not Implemented ratings are provisional where deployment evidence was not provided and should be confirmed with system owners before a formal audit.

## Part 3 — Top Five Priority Controls

The priority order emphasizes patient safety, ransomware exposure, protection of clinical records, recoverability, and control dependencies; it is **not** a quantitative return-on-investment ranking, which requires separately verified cost and risk estimates.

| Rank | CIS Control | One-sentence MedDefense justification | Proof required before calling the risk reduced |
|---|---|---|---|
| **1** | **6 — Access Control Management** | Closing [GAP-011](../1x00_first_watch/12-gap_analysis.md) with verified MFA and controlled privileged/vendor access would interrupt the credential-based escalation opportunities in [KC1 and KC5](../1x01_know_your_enemy/10-kill_chains.md). | Tested MFA on required VPN/admin/vendor paths, access revocation and clinical/vendor compatibility approvals. |
| **2** | **12 — Network Infrastructure Management** | Replacing overly broad [GAP-016](../1x00_first_watch/12-gap_analysis.md) trust boundaries with approved, validated flows would reduce exposure of AD, EHR, MRI/PACS and pumps across multiple modeled kill chains. | Denied unauthorized flows **and** successful authorized EHR, MRI-to-PACS and pump-management workflows. |
| **3** | **11 — Data Recovery** | Addressing [GAP-003 and GAP-007](../1x00_first_watch/12-gap_analysis.md) with protected, tested PACS/EHR/AD recovery would limit the clinical and extortion consequences in [KC1/KC3](../1x01_know_your_enemy/10-kill_chains.md). | Protected-copy inventory, clinical RTO/RPO approval and full representative service/data restore tests. |
| **4** | **7 — Continuous Vulnerability Management** | A recurring owner-led remediation and verification cycle would address urgent [Findings 031/003/004](../1x02_the_weak_links/16-triage.md) before exposed EHR or legacy clinical pathways remain indefinitely open. | Approved fixes or vendor-safe compensating controls, targeted rescans, positive workflow tests and closure tickets. |
| **5** | **13 — Network Monitoring and Defense** | Centralized alerting and passive/vendor-approved medical-device monitoring would narrow the detection gap represented by [GAP-001](../1x00_first_watch/12-gap_analysis.md) and provide actionable signals for [KC4](../1x01_know_your_enemy/10-kill_chains.md). | Verified critical log/flow sources, a tested pump-management change alert and assigned escalation/acknowledgment. |

**Immediate supporting dependencies:** Control **1** (asset and ownership reconciliation) is required before reliable scoping of Controls 7, 12 and 13; Controls **5** (account inventory), **8** (audit logs), **10** (malware defenses) and **17** (incident response) should be linked into the same delivery tickets rather than deferred as unrelated work. A missing IG1 safeguard remains a gap even if its parent Control is Partial.

## Six-Month Verification and Budget Guardrails

- **Month 1 — Validate the baseline:** Confirm Control 9/16/18 provisional ratings with Email/IT, application vendors and procurement; establish accountable control owners and an **individual Safeguard** checklist for all 56 IG1 items; inventory shadow devices and identify clinical exclusions.
- **Months 2–3 — Deploy foundational risk breakers:** Phase in remote/admin MFA, verified EHR network restrictions and MRI/pump network allowlists under approved maintenance windows; validate urgent remediation without live medical-device exploit testing.
- **Months 4–5 — Test detection and recovery:** Add scoped central alert intake, restore endpoint reporting, protect critical backup copies and conduct patient-care-approved PACS/EHR/AD recovery exercises.
- **Month 6 — Reassess and report:** Recheck every Safeguard's deployed state, evidence, exceptions and ownership; report IG1/selected-IG2 completion separately from this 18-Control scorecard and refresh the Task 1 NIST CSF profile.

**Funding rule:** The total **$120,000** ceiling covers the complete Defense Blueprint, not each priority separately; **no license pricing, labor estimate, savings figure or ALE reduction is assumed here**, and commitments require the subsequent quantitative risk and portfolio tasks to show costs, dependencies, alternatives and residual risk. All medical-device changes require Biomedical and vendor approval and demonstrably preserved clinical operation. A plan, an inventory spreadsheet or a cleared scanner alert alone is not proof of deployed protection.

## References and Traceability

- **[CIS v8 official Controls](https://www.cisecurity.org/controls/v8)** — version selected by the assignment.
- **[CIS v8 Safeguards Navigator](https://www.cisecurity.org/controls/cis-controls-navigator/v8)** — Control titles and safeguard/IG designations.
- **[CIS Implementation Groups](https://www.cisecurity.org/controls/implementation-groups)** — IG1 baseline and cumulative IG2/IG3 model.
- **DLH supplied `cis-controls-summary.txt`** — abridged reference accompanying Task 2; consulted alongside the official v8 Navigator, which is authoritative if a safeguard is omitted from the summary.
- **[1x00 — Control Matrix](../1x00_first_watch/10-complete_control_matrix.md)**, **[Gap Analysis](../1x00_first_watch/12-gap_analysis.md)**, **[Asset Registry](../1x00_first_watch/7-asset_registry.md)** and **[Data Map](../1x00_first_watch/9-data_map.md)**.
- **[1x01 — Kill Chains](../1x01_know_your_enemy/10-kill_chains.md)**, including KC1, KC3, KC4 and KC5.
- **[1x02 — Triage](../1x02_the_weak_links/16-triage.md)**, **[Legacy Systems](../1x02_the_weak_links/12-legacy_systems.md)**, **[Exploit Hunt](../1x02_the_weak_links/4-exploit_hunt.md)** and **[Validation Plan](../1x02_the_weak_links/23-validation_plan.md)**.
- **[1x03 — Task 0 Framework Selection](0-framework_landscape.md)** and **[Task 1 NIST CSF Current Profile](1-nist_csf_mapping.md)**.

**Assessment conclusion:** MedDefense has several *operating but fragmented* defensive mechanisms, while robust email/browser protection, a repeatable application security process and an authorized penetration-testing program are **not evidenced** in the available material. The next step is to validate the three provisional absence ratings, assign Safeguard-level owners, and prioritize controls against the fixed budget without mistaking recommendations for deployed protection.
