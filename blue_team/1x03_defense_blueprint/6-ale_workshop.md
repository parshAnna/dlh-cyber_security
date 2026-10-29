# Task 6 — The ALE Workshop

**Organization:** MedDefense Health Systems
**Project:** 1x03 — Defense Blueprint
**Deliverable:** `6-ale_workshop.md`
**Assessment date:** 29 October 2026
**Status:** Quantitative risk-treatment proposal, not verified financial results.

## Objective and Method

This workshop evaluates five MedDefense risks using evidence from 1x00, 1x01, 1x02, and the 1x03 risk equation.

- SLE = Asset Value (AV) × Exposure Factor (EF).
- ALE = SLE × Annualized Rate of Occurrence (ARO).
- Annual Risk Reduction (ARR) = Baseline ALE − Residual ALE.
- Illustrative first-year net benefit = ARR − Deployment Cost − Annual Operating Cost.

All post-control frequencies, cost allocations and effectiveness assumptions are hypothetical planning estimates. They must be validated before a funding decision. Overlapping ransomware, EHR and VPN scenarios must not be added as independent enterprise losses.

## Risk 1 — EHR Patient-Record Breach

**Assets:** ehr-db-01, ehr-srv-01 and protected patient records.

**Gap references:** GAP-006 (excessive EHR database reachability) and GAP-017 (bulk patient-record export controls).

**Vulnerability evidence:** Finding 003 directly documents broad PostgreSQL connection permissions across 10.10.0.0/16, although database authentication remains required. Finding 031 documents AJP exposure, but Ghostcat applicability to the reported Tomcat build remains disputed.

**Threat context:** Nation-state/APT or compromised vendor access, KC5 (MedTech maintenance channel to EHR data). Insider export scenario S2 is additional context.

**Framework:** NIST CSF PROTECT; CIS Controls 3, 6 and 12.

**Baseline calculation:**
- AV = $9,075,000 modeled full-breach financial exposure.
- EF = 100% for the defined full-breach event.
- SLE = $9,075,000 × 1.00 = $9,075,000.
- ARO = 1/3 = 0.333333 events/year.
- Baseline ALE = $9,075,000 / 3 = **$3,025,000/year**.

**Proposed control:** Restrict PostgreSQL 5432 and pg_hba.conf to approved EHR application sources, enforce least-privilege bulk-export permissions, alert on exceptional downloads and validate AJP exposure.

**Post-control assumptions:** Keep SLE unchanged; assume ARO decreases to 0.15/year through combined preventive and detective controls.

**Residual ALE:** $9,075,000 × 0.15 = **$1,361,250/year**.

**Economic comparison:**
- ARR = $3,025,000 − $1,361,250 = **$1,663,750/year**.
- Illustrative deployment = $30,000.
- Illustrative annual operations = $6,000.
- First-year net benefit = $1,663,750 − $36,000 = **$1,627,750**.

**Confidence: Low.** The full-record breach assumption, incident frequency and possible overlap between per-record and legal/business costs are uncertain.

**Validation:** Confirm authorized EHR access remains functional, block unauthorized database sources and test export alerts. Do not claim risk reduction until verified.

## Risk 2 — FortiGate VPN to Domain Ransomware

**Assets:** VPN gateway, Active Directory, billing and EHR infrastructure.

**Gap references:** GAP-016 (broad trust boundaries) and GAP-011 (shared identities and inadequate MFA coverage).

**Vulnerability evidence:** Findings 007 and 018 document AD authentication weaknesses; they do not directly prove missing VPN MFA. Finding 003 supports the downstream lateral-access concern. No specific FortiGate CVE is asserted as verified.

**Threat context:** Ransomware affiliate using a VPN foothold, KC1 (VPN to AD to domain ransomware). Subsequent EHR theft is a potential related consequence, not an explicitly observed chain.

**Framework:** NIST CSF PROTECT; CIS Controls 6 and 12.

**Baseline calculation:**
- AV = $13,460,000 combined scenario exposure pool.
- EF = $9,548,000 / $13,460,000 = approximately 70.94%.
- SLE = $9,548,000.
- ARO = 0.30 VPN compromises/year.
- Baseline assumes full-campaign progression probability q = 1.
- Baseline ALE = $9,548,000 × 0.30 = **$2,864,400/year**.

**Proposed control:** Enforce named VPN identities and MFA, restrict VPN-to-AD/EHR network paths, limit vendor access and monitor privileged sessions.

**Post-control assumptions:** Initial compromise ARO falls hypothetically to 0.15/year; probability of full campaign progression falls to q = 0.40 through segmentation and detection.

**Residual ALE:** $9,548,000 × 0.15 × 0.40 = **$572,880/year**.

**Economic comparison:**
- ARR = $2,864,400 − $572,880 = **$2,291,520/year**.
- Illustrative deployment = $25,000.
- Illustrative annual operations = $5,000.
- First-year net benefit = $2,291,520 − $30,000 = **$2,261,520**.

**Confidence: Low.** A VPN compromise does not necessarily become a complete ransomware and EHR breach; q = 1 is a conservative classroom assumption, not a measured fact.

**Validation:** Audit VPN MFA and accounts, verify denied unauthorized paths, inspect sign-in alerts and test clinical access continuity.

## Risk 3 — Negligent Insider Disclosure

**Assets:** Patient data accessible through clinical workstations.

**Gap references:** GAP-017 (bulk patient-record export control) and GAP-011 (user accountability).

**Vulnerability evidence:** Finding 023 reports unrestricted USB mass-storage use on clinical endpoints, which could facilitate accidental disclosure. It does not prove that negligence has occurred or that EHR exports lack authorization checks.

**Threat context:** Negligent employee or contractor. The 1x01 insider scenario S2 provides adjacent patient-data export context, although it models intentional rather than accidental misuse; no direct negligent-disclosure kill chain is established.

**Framework:** NIST CSF PROTECT; CIS Controls 3, 6 and 14.

**Baseline calculation:**
- AV = $120,000 defined average-event loss pool.
- EF = 100% of this event-specific loss pool.
- SLE = $120,000 × 1.00 = $120,000.
- ARO = 2.5 negligent incidents/year.
- Baseline ALE = $120,000 × 2.5 = **$300,000/year**.

**Proposed control:** Restrict unauthorized exports and USB transfers, provide role-based privacy training, record approved exceptions and improve reporting and containment.

**Post-control assumptions:** ARO falls hypothetically to 1.5/year, and faster containment reduces average SLE to $100,000.

**Residual ALE:** $100,000 × 1.5 = **$150,000/year**.

**Economic comparison:**
- ARR = $300,000 − $150,000 = **$150,000/year**.
- Illustrative deployment = $14,000.
- Illustrative annual operations = $3,000.
- First-year net benefit = $150,000 − $17,000 = **$133,000**.

**Confidence: Low to Medium.** Incident reporting completeness and attainable reduction in human error are not established.

**Validation:** Measure real incidents, approved export exceptions, training completion and policy enforcement without disrupting patient care.

## Risk 4 — Billing-Server Ransomware

**Assets:** billing-srv-01, billing records and revenue continuity.

**Gap references:** GAP-016 (network trust boundaries) and GAP-007 (shared backup failure domain).

**Vulnerability evidence:** Finding 001 identifies Apache mod_lua remote-execution exposure; Finding 002 identifies an Apache privilege-escalation opportunity after an initial foothold. Finding 015 supports the backup-management exposure concern.

**Threat context:** Ransomware affiliates; a billing-server foothold could enable KC1-style lateral movement, but the server is not a named step in the original KC1.

**Framework:** NIST CSF PROTECT and RECOVER; CIS Controls 7 and 11.

**Baseline calculation:**
- AV = $4,385,000 modeled financial exposure.
- EF = $473,000 / $4,385,000 = approximately 10.79%.
- SLE = $473,000.
- ARO = 1/3.5 = approximately 0.285714/year.
- Baseline ALE = $473,000 / 3.5 = **$135,143/year**, rounded.

**Proposed control:** Patch or safely disable vulnerable Apache functionality, restrict unnecessary network access, isolate protected backups and rehearse billing-service restoration.

**Post-control assumptions:** ARO decreases hypothetically to 0.12/year; tested recovery capability is assumed to lower SLE to $300,000.

**Residual ALE:** $300,000 × 0.12 = **$36,000/year**.

**Economic comparison:**
- ARR = $135,142.86 − $36,000 = **$99,142.86/year**.
- Illustrative deployment = $12,000.
- Illustrative annual operations = $2,000.
- First-year net benefit = $99,142.86 − $14,000 = **$85,142.86**.

**Confidence: Low to Medium.** Billing losses may include delayed rather than permanently lost transactions. Recovery effectiveness is not yet verified.

**Validation:** Check patched versions, verify technical remediation and time an end-to-end billing restoration test.

## Risk 5 — BD Alaris Infusion-Pump Compromise

**Assets:** Seven BD Alaris infusion pumps and patient-care continuity.

**Gap references:** GAP-001 (missing device-specific detection and tested recovery) and GAP-016 (management reachability).

**Vulnerability evidence:** Finding 010 reports default management credentials and exposed access paths. Its firmware-specific CVE association is disputed and requires confirmation with BD.

**Threat context:** Malicious or misusing biomedical/clinical/IT insider, KC4 (unauthorized device changes affecting treatment integrity or availability).

**Framework:** NIST CSF PROTECT, DETECT and RECOVER; CIS Controls 6, 11 and 13.

**Baseline calculation:**
- DoS-only event: SLE $100,000 × ARO 0.10 = $10,000/year.
- Patient-safety event: SLE $3,000,000 × ARO 0.02 = $60,000/year.
- Assuming nonoverlapping event classes, baseline ALE = **$70,000/year**.

**Proposed control:** With Biomedical Engineering and BD approval, replace default credentials, restrict management origins, monitor approved configuration changes and test clinically safe recovery.

**Post-control assumptions:** DoS ARO decreases hypothetically to 0.05/year; patient-safety event ARO decreases to 0.01/year. Event severities remain unchanged.

**Residual ALE:** ($100,000 × 0.05) + ($3,000,000 × 0.01) = **$35,000/year**.

**Economic comparison:**
- ARR = $70,000 − $35,000 = **$35,000/year**.
- Illustrative deployment = $19,000.
- Illustrative annual operations = $4,000.
- First-year net benefit = $35,000 − $23,000 = **$12,000**.

**Confidence: Low.** Patient-safety severity, rare-event probabilities and control effectiveness are highly uncertain. Medical safety must take priority over ALE.

**Validation:** Obtain vendor authorization, verify safe management access, test non-disruptive alerts and document clinically supervised recovery.

## Five-Risk Ranking and Economic Comparison

Ranked from highest to lowest baseline ALE.

| Rank | Risk | Gap(s) | Finding(s) | Threat | Before ALE | After ALE | ARR/year |
|---:|---|---|---|---|---:|---:|---:|
| 1 | EHR breach | GAP-006, GAP-017 | 003; 031 conditional | KC5 / S2 | $3,025,000 | $1,361,250 | $1,663,750 |
| 2 | VPN network compromise | GAP-016, GAP-011 | 007, 018, 003 supporting | KC1 | $2,864,400 | $572,880 | $2,291,520 |
| 3 | Negligent insider | GAP-017, GAP-011 | 023 supporting | S2 adjacent | $300,000 | $150,000 | $150,000 |
| 4 | Billing ransomware | GAP-016, GAP-007 | 001, 002, 015 | KC1-compatible | $135,143 | $36,000 | ~$99,143 |
| 5 | Alaris compromise | GAP-001, GAP-016 | 010, contested CVE | KC4 | $70,000 | $35,000 | $35,000 |

The ranking compares modeled standalone risk scenarios. EHR, VPN and billing consequences may arise from the same campaign. Their ALEs and benefits must not be added to claim total enterprise savings.

## Six-Month Budget Check

| Proposed workstream | Deployment cost | Annual operations |
|---|---:|---:|
| EHR protection | $30,000 | $6,000 |
| VPN and segmentation | $25,000 | $5,000 |
| Insider controls | $14,000 | $3,000 |
| Billing resilience | $12,000 | $2,000 |
| Alaris device protection | $19,000 | $4,000 |
| **Total** | **$100,000** | **$20,000** |

Assuming operating costs accrue uniformly from the start:

Six-month operations = $20,000 / 2 = $10,000.

Six-month modeled spend = $100,000 + $10,000 = **$110,000**.

Remaining amount under the shared $120,000 program ceiling = **$10,000**.

These are illustrative allocations, not vendor quotations or approved purchases. Shared controls must be costed only once. Governance/vCISO, staffing, procurement and contingency requirements must be reconciled before accepting this portfolio as affordable.

## Conclusions and Validation Requirements

1. Rank treatment opportunities by expected loss while retaining patient-safety and legal obligations as nonfinancial priorities.
2. Verify all proposed reductions in ARO or SLE through deployment evidence, clinical testing, monitoring and restoration exercises.
3. Recalculate residual ALE using observed performance and actual vendor costs before CFO approval.
4. Avoid double-counting compound ransomware and EHR events, shared controls or overlapping breach expenses.
5. Record accountable risk owners and review accepted residual risks under the Task 4 governance structure.

## Evidence References

- [Task 3 — Gap-to-Framework Bridge](3-gap_framework_bridge.md)
- [Task 4 — Governance Architecture](4-governance_architecture.md)
- [Task 5 — Risk Equation](5-risk_equation.md)
- [1x01 — Kill Chains](../1x01_know_your_enemy/10-kill_chains.md)
- [1x02 — CVSS Contextualizer](../1x02_the_weak_links/17-cvss_contextualizer.md)

**Assessment boundary:** The baseline losses originate from the supplied training scenarios. The post-control effectiveness and costs are transparent hypothetical estimates, not guarantees or measured financial outcomes.
