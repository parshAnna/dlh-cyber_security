# MedDefense Health Systems — Task 9: The Board Presentation

**Project:** 1x05 — Emergency Board Briefing
**Required repository file:** `blue_team/1x05_board_briefing/9-board_presentation.md`
**Audience:** Emergency Board meeting, 09:00 | **Speaking time:** 15 minutes
**Basis:** 1x00–1x05 assessments | **Status:** Scenario-based decision brief; no confirmed MedDefense breach, executed production changes, approved spend, or insurance coverage is evidenced.

---

## Part 1 — BOARD SECURITY BRIEF | ONE-PAGER

**MEDDEFENSE HEALTH SYSTEMS — EMERGENCY BOARD DECISION | 09:00**
**Decision required:** authorize safe containment, vendor-supported remediation, recovery verification and controlled emergency finance.

**CURRENT THREAT STATUS — 2 sentences**

In the exercise's *Crimson Tide* scenario, five comparable hospitals were attacked in ten days, three nearby, through perimeter compromise, identity abuse, patient-data theft, backup deletion and ransomware; the named campaign is not independently verified as a CISA advisory. MedDefense is in the scenario's blast radius: its FortiGate 100F runs vulnerable FortiOS 7.0.9, but external SSL-VPN reachability and actual intrusion are unverified, and site-to-site IPsec is separate.

**SECURITY POSTURE VERDICT — 2 sentences**

Our posture is **CRITICAL**: all six NIST CSF functions were rated *Partial*, and 27 of 31 vulnerability findings require action, including excessive database reachability, legacy clinical devices and weak network boundaries. Only **3 of 21 cryptographic data-state cells (14.3%)** were rated Adequate in the exercise baseline; independent backups, clinical recovery, endpoint coverage and verified production remediation are incomplete, so we cannot certify resilience.

**EMERGENCY RESPONSE — 4 sentences**

Within four hours, James Chen directs an evidence-preserving assessment and Sarah Park verifies and, if exposed, safely restricts SSL-VPN while protecting clinical access and intersite IPsec. Tonight, Sarah's two IT operators preserve independently recoverable EHR/PACS/billing backups, collect gateway/AD/EHR/NAS evidence, monitor privileged activity and prepare clinical downtime workflows; they must not disconnect the sole usable backup. In hours 12–36, secure Fortinet support, establish a vendor-vetted upgrade route, validate an isolated restore and pilot narrow access restrictions. In hours 36–72, implement only approved firmware and segmented pilot changes, confirm safe clinical function and recovery, and report objectively validated outcomes rather than assuming purchase or installation equals closure.

**INVESTMENT AND EXPOSURE — 4 sentences**

No security-control implementation or expenditure is verified: C1/C2/C3/C4/C6 were proposed at **$97,000 annualized**, approximately **$115,000 illustrative first-year cash**, against a separate **$120,000 six-month cash ceiling**. Request a conditional **$2,400 annual Fortinet renewal**, with Finance reconciliation and capped, quoted exceptions if needed; entitlement alone does not patch the appliance. Under Task 5's explicitly hypothetical full-campaign ARO increase from **0.30 to 0.60**, compound ransomware ALE doubles from **$2,864,400 to $5,728,800 annually**, not a statistically established forecast. Renewal breaks even against that stress model at a **0.0419% reduction in ALE** before labor/downtime, but ROI requires verified remediation and overlapping EHR/billing losses must not be added.

**PROFESSIONAL RECOMMENDATION — 2 sentences**

**Approve clinically governed containment, protected recoverability and conditional Fortinet entitlement today**, but release further funds only against Robert Kim's reconciled cash plan, priced scope and explicit safety gates. Hold James accountable for incident/risk decisions, Sarah for safe production changes and Maria Santos/DPO for breach assessment; demand a verified exposure report within four hours and a 72-hour Board review, without declaring compromise, insurance coverage or risk acceptance absent evidence.

---

## Part 2 — Stakeholder Talking Point Map

### Dr. Patricia Morales — CEO | Patient safety and reputation

“Our first duty is uninterrupted safe treatment: an avoidable firewall outage or disconnection of the only viable backup can injure patients just as a cyber incident can.” I recommend clinically approved VPN containment, protected EHR/PACS recovery and tested paper-workflow continuity before disruptive changes. We should communicate promptly and truthfully, without claiming a breach or a clean bill of health before forensic verification.

### Robert Kim — CFO | Loss, ROI and cost of inaction

“The **$5.7288 million annual ALE** is a high-alert *stress case*, not a forecast or an invoice; it shows why the potential cost of inaction deserves urgent scrutiny, but should not be combined with overlapping EHR and billing ALEs.” The **$2,400 renewal** needs only a **0.0419%** modeled loss reduction to break even before implementation costs, yet its ROI is conditional on a compatible, safely installed fix. Please reconcile the **$115,000 illustrative year-one cash**, the actual six-month **$120,000 cap**, outstanding obligations, vendor quotes and any emergency exception before approving purchases.

### Dr. Angela Reeves — Board Chair | Judgment and confidence

“My professional recommendation is to **contain the verified entry point, preserve independently recoverable backups and stage a clinically safe vendor-approved patch now**, while requiring evidence before declaring closure.” Confidence is **high** in the FortiOS 7.0.9 vulnerable-version match and documented architectural gaps, **low** in the exact 0.60 ARO and unknown live SSL-VPN reachability, and **insufficient** to allege an ongoing MedDefense intrusion. Authorize a narrow emergency mandate with named owners, stop/go gates and a 72-hour return to the Board.

### Thomas Wright — Former banker | Industry-maturity comparison

“Compared with commonly expected financial-sector disciplines—strong privileged identity, segmented critical networks, centralized monitoring, immutable recovery and tested incident playbooks—MedDefense's six *Partial* NIST CSF functions signal a material assurance gap.” This is a **qualitative controls comparison**, not a measured bank-versus-hospital industry percentile, and hospital life-safety and legacy medical-device constraints prevent simply copying a banking change schedule. We should adopt the same evidence and governance rigor while making clinical uptime a non-negotiable release condition.

### Maria Santos — General Counsel | Liability, notification and insurance

“For this exercise MedDefense is treated as a HIPAA covered entity, but the identified ePHI encryption, authentication, audit and recovery gaps show **compliance readiness is not demonstrated**, not that a violation or reportable breach has already been legally established.” If an actual breach of **unsecured PHI** is discovered, counsel must perform and document the legal breach assessment and applicable notifications; under the HIPAA framework, individual notices and qualifying HHS/media reports generally must occur **without unreasonable delay and no later than 60 calendar days**, with scope-specific exceptions and reporting rules. **Cyber-insurance policy existence, coverage limits, exclusions, deductibles and insurer-notice deadlines are unverified**: obtain the policy and notify carriers only in line with counsel's and contractual requirements, while preserving evidence and privilege as appropriate.

## Fifteen-minute delivery cue (speaker use, not part of the one-pager)

- **00:00–02:00:** Plain-language threat, exposed version versus unverified real intrusion (Morales, Reeves).
- **02:00–05:00:** Patient-care dependencies, weakness and continuity control points (Morales, Wright).
- **05:00–09:00:** First 4 hours and staged 72-hour decision gates; responsible owners (Reeves).
- **09:00–12:00:** Conditional $2,400 approval, cash reconciliation, ALE/ROI uncertainty (Kim).
- **12:00–15:00:** Notification and insurance questions, request explicit vote and 72-hour report-back (Santos, Chair).

## Source and evidence notes — outside the one-pager

**Internal exercise documents:** [1x00 gaps](../1x00_first_watch/12-gap_analysis.md), [1x01 threat priority](../1x01_know_your_enemy/16-threat_priority.md), [1x02 triage](../1x02_the_weak_links/16-triage.md), [1x03 strategy](../1x03_defense_blueprint/17-security_strategy.md), [1x03 cost-benefit](../1x03_defense_blueprint/7-cost_benefit_analysis.md), [1x04 crypto posture](../1x04_crypto_foundation/15-crypto_posture_audit.md), [1x04 HIPAA assessment](../1x04_crypto_foundation/19-hipaa_checkpoint.md), [1x05 emergency plan](3-emergency_plan.md), [1x05 ALE update](5-ale_update.md), [1x05 Risk Register update](7-risk_register_update.md), [1x05 comprehensive assessment](8-comprehensive_assessment.md).

**External authority for legal and gateway facts only, not evidence of the fictional campaign:** [HHS Breach Notification Rule](https://www.hhs.gov/hipaa/for-professionals/breach-notification/index.html), [HHS Secretary reporting thresholds (reviewed February 2026)](https://www.hhs.gov/hipaa/for-professionals/breach-notification/breach-reporting/index.html), [CERT-EU FortiOS SSL-VPN CVE-2023-27997](https://cert.europa.eu/publications/security-advisories/2023-038/), [CERT-EU separate CVE-2024-55591 risk](https://cert.europa.eu/publications/security-advisories/2025-003/).

**Delivery / evidence rules:** The Part 1 text alone is the one-pager; Parts 2 and the notes are speaker support, not additional one-pager content. Actual print pagination depends on the Markdown renderer, font and margins; check print preview and use a compact layout rather than presenting an automatically generated multi-page print as one page. The course's exact Crimson Tide phase headings and advisory IOCs have not been independently re-obtained. All costs and benefits are planning assumptions, not audited financials or proof of deployment.
