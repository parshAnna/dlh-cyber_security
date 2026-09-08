# MedDefense Health Systems — Risk Treatment Decisions

Prepared for: James Chen, Deputy CISO  
Prepared by: Junior Security Analyst  
Budget ceiling: **$120,000 for the fiscal year**  
Status: Proposed treatment plan; no spending, implementation or risk acceptance authorized by this document.

## Decision basis

This plan selects **GAP-001 through GAP-007**, the seven highest-priority entries in the [Task 12 Gap Analysis](12-gap_analysis.md): five Critical, then the first two High gaps in its documented order. **No Task 13 update was supplied**, so titles and current ratings are preserved rather than assuming new threat intelligence. Task 12's provisional data classifications and evidence limitations remain applicable. If Task 13 changes priorities, review this selection before commitment.

All seven primary decisions are **Mitigate**. Their services are clinically necessary or shared recovery dependencies, and the proposed package fits the planning budget. The assignment does not require artificially using all four strategies. Transfer may limit covered financial loss but cannot restore safe clinical operation; no insurance quote or coverage of existing events is assumed. Avoiding MRI/infusion/EHR activities is incompatible with the stated clinical requirements. Acceptance is not justified without a defensible loss/cost comparison and accountable management sign-off. Residual risk and any deferred work are not silently accepted by the analyst.

Costs below are **planning allowances, not supplier quotes or verified market prices**. They represent incremental first-year cash above existing operational contracts and payroll. Each treatment has a rough-order band plus a dollar allowance for arithmetic; proposals are conditional on vendor pricing, taxes, licensing, capacity and safe compatibility. The one source-backed anchor is the historical $14,400/year offsite quote, whose scope and currency are unverified. No assumed savings from discontinued contracts fund this plan.

## Risk Treatment Decisions

### GAP-001

**Gap ID:** GAP-001  
**Gap Title:** Infusion pumps lack device-specific detection and recovery  
**Risk Level:** Critical — unchanged; Task 13 unavailable  
**Treatment Strategy:** Mitigate

**Justification:** Patient-facing infusion functions cannot be eliminated, and financial transfer would not prevent unsafe delivery. Fund a vendor-reviewed pilot and phased safeguards rather than patching or isolating devices without clinical validation; use existing network capability where verified.

**If Mitigate:**

- **Proposed Control(s):**
  - Technical — Preventive/Compensating: create a pump network zone with enforced allowlisted clinical/update flows after biomedical and vendor validation; a VLAN without enforcement is insufficient.
  - Technical — Detective: collect supported device/network events and assign review/escalation to IT and biomedical staff; use passive monitoring where device agents are unsupported.
  - Technical and Administrative — Corrective: obtain vendor-supported configuration exports/recovery instructions, protect copies through GAP-007 and exercise safe replacement/recovery using test equipment and a clinical continuity procedure.
- **Estimated Cost:** $10-50K; **$22,000** first-year allowance. $12,000 network/pilot equipment and configuration; $6,000 vendor/biomedical validation; $4,000 monitoring integration. Protected storage infrastructure is funded only under GAP-007.
- **Implementation Effort:** Long-term > 1 month — staged rollout over 6–10 weeks; initial flow inventory and recovery review in week 1. Approximately 14 internal person-days, spread across IT, security, clinical/biomedical and procurement staff as applicable.
- **Expected Risk Reduction:** Material reduction in reachable attack paths and time to recognize/recover from device problems; target High residual risk only after authorized flows and clinical recovery are demonstrated. Firmware limitations, permitted channels and unknown device behavior remain; no percentage reduction is asserted.

**Trade-offs:** Clinical validation and staged maintenance consume biomedical/nursing time; incorrect rules could affect updates or care. Pilot one approved cohort and retain a tested rollback; do not assume network loss stops or safely preserves infusion.

### GAP-002

**Gap ID:** GAP-002  
**Gap Title:** Pharmacy dosage changes lack validated recovery and systematic checking  
**Risk Level:** Critical — unchanged; Task 13 unavailable  
**Treatment Strategy:** Mitigate

**Justification:** An incorrect dosage update has already affected all three sites. The application is clinically necessary; low-cost change validation and tested rollback address the observed failure directly. Insurance or acceptance would leave unsafe values in use.

**If Mitigate:**

- **Proposed Control(s):**
  - Administrative — Preventive: identify the host, owner and vendor; require pharmacy approval, test data and peer review before dosage changes.
  - Technical — Detective: implement vendor-supported comparison/range checks against an approved clinical reference, with pharmacist review of exceptions; do not invent medication limits.
  - Technical and Administrative — Corrective: take a consistent pre-change recovery point, rehearse rollback in a safe environment and document pharmacist-approved reconciliation; use the shared protected repository from GAP-007.
- **Estimated Cost:** $1-10K; **$8,000** first-year allowance. $5,000 vendor/application assistance; $2,000 validation and rollback tooling/setup; $1,000 targeted staff instruction. Shared backup storage/hosting is excluded here.
- **Implementation Effort:** Short-term < 1 month — approximately 3–4 weeks after locating the application and vendor. Approximately 8 internal person-days, spread across IT, security, clinical/biomedical and procurement staff as applicable.
- **Expected Risk Reduction:** Material reduction in repeat erroneous releases and recovery uncertainty; target High residual risk after a demonstrated validation/rollback exercise. Human approval errors and software defects remain; until hosting and recovery are verified, retain current Critical priority.

**Trade-offs:** Changes may take longer and require pharmacist availability. Unknown hosting or vendor restrictions may extend the schedule; a manual check is an interim safeguard, not a replacement for tested restoration.

### GAP-003

**Gap ID:** GAP-003  
**Gap Title:** PACS imaging has no documented recovery copy  
**Risk Level:** Critical — unchanged; Task 13 unavailable  
**Treatment Strategy:** Mitigate

**Justification:** PACS is explicitly excluded from backups and receives MRI studies supporting approximately 45 examinations per day. Avoiding imaging is operationally unacceptable; restoration capability reduces the direct clinical consequence that outsourcing payments alone cannot address.

**If Mitigate:**

- **Proposed Control(s):**
  - Technical — Corrective: size the study archive and growth, procure a supported PACS backup/export connector and restore workspace, and include both images and associated patient/index metadata.
  - Technical — Corrective: send consistent recovery sets to the isolated/offsite platform funded under GAP-007, with retention and recoverability agreed by Radiology; protect credentials and keys separately.
  - Administrative — Detective/Corrective: demonstrate restoration of representative studies plus index consistency and a service recovery exercise against clinically agreed recovery objectives; document a temporary imaging-access workflow.
- **Estimated Cost:** $10-50K; **$24,000** first-year allowance. $14,000 PACS-specific local restore workspace/storage allowance; $6,000 supported connector/licensing allowance; $4,000 vendor restore validation. Offsite service cost is counted only in GAP-007.
- **Implementation Effort:** Long-term > 1 month — approximately 6–8 weeks, dependent on capacity sizing and GAP-007. Approximately 10 internal person-days, spread across IT, security, clinical/biomedical and procurement staff as applicable.
- **Expected Risk Reduction:** High reduction in the chance that a single storage/ransomware event leaves no usable studies; target High residual risk after restore acceptance. Large data volumes and restoration time remain material; backups do not remove integrity or access-control risks.

**Trade-offs:** Initial copy and restore tests use bandwidth, storage and vendor time. Data size is unknown, so the allowance is conditional; do not describe the existing 24 TB NAS as sufficient or promise complete protection before sizing.

### GAP-004

**Gap ID:** GAP-004  
**Gap Title:** Central core-switch configuration and failover protection are unverified  
**Risk Level:** Critical — unchanged; Task 13 unavailable  
**Treatment Strategy:** Mitigate

**Justification:** The core supports multiple clinical dependencies, but the reported gap may partly be missing documentation. Start by verifying model, topology and any existing failover before buying hardware; pay for recoverability and controlled administration rather than assume a full redundant-core replacement fits this allowance.

**If Mitigate:**

- **Proposed Control(s):**
  - Administrative — Preventive: identify the core owner/model and approved topology; validate existing redundancy and documented change approval.
  - Technical — Preventive/Detective: restrict management to approved administrative paths, use supported individual authentication, export configuration-change/system events and assign alert review.
  - Technical and Administrative — Corrective: automate protected configuration backups, verify a compatible cold spare or contracted replacement arrangement within the allowance, and rehearse restoration in a lab/approved window.
- **Estimated Cost:** $10-50K; **$15,000** first-year allowance. $8,000 compatible spare/replacement-service allowance; $5,000 engineering and recovery exercise; $2,000 logging/configuration integration. Shared repository costs are excluded.
- **Implementation Effort:** Short-term < 1 month — validation, configuration protection and recovery drill in 3–4 weeks; delivery delays may extend completion. Approximately 8 internal person-days, spread across IT, security, clinical/biomedical and procurement staff as applicable.
- **Expected Risk Reduction:** Material reduction in undetected changes and recovery uncertainty; target High residual risk after a restore drill and a documented hardware-replacement path. A cold spare is not seamless high availability, and remaining single-core interruption risk is retained for explicit review.

**Trade-offs:** Management restrictions can lock out administrators and a production failover test can interrupt care; maintain tested access/rollback. A compatible replacement may exceed the allowance; no full high-availability pair is promised.

### GAP-005

**Gap ID:** GAP-005  
**Gap Title:** Legacy MRI controller remains on the general workstation network  
**Risk Level:** Critical — unchanged; Task 13 unavailable  
**Treatment Strategy:** Mitigate

**Justification:** Task 6 rules out patching, OS upgrades, replacement and total disconnection. External compensating controls preserve MRI-to-PACS study transfer while reducing exposure without changing the certified OS. Neither accepting an unbounded clinical risk nor transferring its financial cost solves this operational need.

**If Mitigate:**

- **Proposed Control(s):**
  - Technical — Compensating (preventive effect): place the MRI controller behind an enforced boundary allowing only validated PACS and essential vendor/clinical flows; restrict maintenance through a supported controlled access path.
  - Technical — Detective: passively monitor the permitted flows/boundary and route actionable events to named responders without installing an unapproved agent on the controller.
  - Physical — Preventive and Administrative — Preventive/Corrective: restrict console/removable-media access, log approved maintenance, and obtain vendor-approved recovery media/configuration restoration with Radiology downtime arrangements; recovery-copy infrastructure is shared with GAP-007.
- **Estimated Cost:** $10-50K; **$12,000** first-year allowance. $5,000 dedicated boundary hardware/support allowance; $5,000 vendor validation and configuration; $2,000 access-control/maintenance procedure integration. This is MRI-specific, separate from pump zoning.
- **Implementation Effort:** Short-term < 1 month — approximately 3–4 weeks subject to vendor and Radiology approval. Approximately 7 internal person-days, spread across IT, security, clinical/biomedical and procurement staff as applicable.
- **Expected Risk Reduction:** Material reduction in opportunistic lateral access plus improved detection/recovery; target High residual risk after imaging-transfer and recovery tests. The unpatched controller and allowed PACS pathway remain exposed; no assurance of eliminating all compromise paths.

**Trade-offs:** External controls can still affect clinical communication. Vendor must validate the design, required flows and supported recovery method; do not infer PACS protocol rules solely from scanned ports. Keep the controller OS unchanged.

### GAP-006

**Gap ID:** GAP-006  
**Gap Title:** EHR database access is broader than the documented application need  
**Risk Level:** High — unchanged; Task 13 unavailable  
**Treatment Strategy:** Mitigate

**Justification:** Existing host/network controls can narrow PostgreSQL exposure at relatively low cost. Preserve the necessary EHR connection and verified backup, monitoring or administrative clients; avoid a blind rule that permits only one hostname and breaks legitimate operations.

**If Mitigate:**

- **Proposed Control(s):**
  - Technical — Preventive: enforce approved-source PostgreSQL network and database access rules using existing supported controls; validate ehr-srv-01 and every additional required service before deny rules.
  - Administrative — Preventive: review service accounts, least-privilege permissions and ownership with the DBA; move supported administration to controlled authentication paths.
  - Technical/Administrative — Detective: enable supported database access/change logging and an assigned review/escalation workflow, minimizing unnecessary patient-data logging; verify backup and access functionality after changes.
- **Estimated Cost:** $1-10K; **$6,000** first-year allowance. $4,000 DBA/security engineering assistance; $2,000 database logging/integration allowance. Existing hardware is assumed reusable after validation, not a new SIEM purchase.
- **Implementation Effort:** Quick Win < 1 week — initial access restriction within five working days if approved-flow validation is complete; broader review within one month. Approximately 5 internal person-days, spread across IT, security, clinical/biomedical and procurement staff as applicable.
- **Expected Risk Reduction:** Substantial reduction in unnecessary access opportunities; target Medium residual risk for this specific broad-reachability gap once allowed/denied connection tests and audit review pass. EHR remains Critical as an asset, and the separate recovery/identity gaps do not disappear.

**Trade-offs:** Misconfigured rules can block care-system access or scheduled backups; prepare rollback and change-window verification. Quick Win is conditional on known dependencies, not a deadline to bypass validation.

### GAP-007

**Gap ID:** GAP-007  
**Gap Title:** Production and recovery copies share a failure domain  
**Risk Level:** High — unchanged; Task 13 unavailable  
**Treatment Strategy:** Mitigate

**Justification:** Local RAID does not survive loss of the server room or shared administrative compromise. Fund one shared protected recovery platform for existing critical backups and the newly included workloads; this reduces multiple gaps without paying separately for duplicate offsite services.

**If Mitigate:**

- **Proposed Control(s):**
  - Technical — Preventive/Corrective: implement an isolated offsite repository with independently controlled credentials, suitable encryption/key recovery and immutable or offline recovery copies where supported; validate current backup edition/licensing compatibility.
  - Administrative — Preventive: define owners, workload scope, clinical recovery objectives, retention and recurring funding; verify the provider arrangement and capacity before purchase.
  - Technical — Detective and Administrative — Detective/Corrective: monitor backup failures and run documented workload-specific restore tests, including EHR and dependencies; maintain accessible recovery procedures and escalation ownership.
- **Estimated Cost:** $10-50K; **$23,000** first-year allowance. $14,400 first-year offsite-service allowance based on the historical quote in control Artifact 5; $5,000 compatibility/isolation/key setup; $3,600 restore and recovery exercise. Includes shared service capacity only as a provisional allowance, not a verified sizing guarantee.
- **Implementation Effort:** Long-term > 1 month — approximately 6–8 weeks including restore tests and dependent PACS/pharmacy onboarding. Approximately 10 internal person-days, spread across IT, security, clinical/biomedical and procurement staff as applicable.
- **Expected Risk Reduction:** Material reduction in common-event destruction of both production and recovery copies; target Medium residual risk for the shared-failure-domain gap after isolated recovery succeeds. Total service recovery risk remains dependent on data volume, credentials, restore times and clinical validation.

**Trade-offs:** Offsite recovery can be slower and adds recurring cost and key-management responsibility. The historical cloud quote is a planning anchor, not proof that PACS growth, egress, restore requests or expanded licensing fit it; re-quote the combined scope.

## Budget Summary

| Gap | First-year incremental allowance | Treatment-specific coverage |
|---|---:|---|
| GAP-001 | $22,000 | Infusion pumps lack device-specific detection and recovery |
| GAP-002 | $8,000 | Pharmacy dosage changes lack validated recovery and systematic checking |
| GAP-003 | $24,000 | PACS imaging has no documented recovery copy |
| GAP-004 | $15,000 | Central core-switch configuration and failover protection are unverified |
| GAP-005 | $12,000 | Legacy MRI controller remains on the general workstation network |
| GAP-006 | $6,000 | EHR database access is broader than the documented application need |
| GAP-007 | $23,000 | Production and recovery copies share a failure domain |
| **Mitigation subtotal** | **$110,000** | Seven work packages |
| Contingency reserve | $10,000 | Quote variance, essential compatibility/licensing and restore-cost variance |
| **Total annual allocation** | **$120,000** | Meets the stated budget ceiling |

**No double counting:** GAP-003 funds PACS-specific capture/restore capacity and vendor integration; GAP-007 alone funds the shared offsite service and base isolation/recovery setup. GAP-001, GAP-002, GAP-004 and GAP-005 fund their device/application-specific configuration and validation, not additional copies of the same storage service. Monitoring allowances cover workload-specific integration and a limited shared review process, not five independent platforms or a staffed 24/7 SOC.

**Staff capacity:** The package estimates **62 internal person-days** in addition to the priced external assistance. These are existing staff time, not free effort; Sarah and clinical leads must confirm release from routine duties. Deliver in stages over roughly 10–12 weeks where dependencies permit. If backfill is required, price it within the reserve or re-scope explicitly; the budget does not include a new full-time security hire.

**Recurring cost:** At least $14,400/year is provisionally recurring offsite service. Renewal portions of boundary support, replacement arrangements and connectors are not yet quoted and must be separated during procurement. The $120,000 first-year fit does not establish an approved next-year operating budget or guarantee that expanded PACS capacity fits the old cloud quote.

## Execution sequence, acceptance evidence and deferrals

1. **Week 1:** Validate the pharmacy host and core topology; document permitted MRI/pump/EHR flows. Deliver the conditional EHR access Quick Win when safe. Confirm existing controls before buying replacements. These discovery steps may reduce expenditure if the provisional gaps were documentation failures.
2. **Weeks 2–4:** Implement pharmacy change/rollback checks, core configuration protection, and the vendor-approved MRI pilot. Assign responders for every new alert source. Establish clinically agreed recovery targets rather than inventing universal recovery times.
3. **Weeks 4–12:** Complete the protected recovery platform, PACS data onboarding, pump cohorts and workload-specific restore exercises. GAP-007 is a dependency for the protected copies used by the other recovery packages; until it passes validation, their remaining recovery risk stays open.

IT/Sarah owns implementation coordination; James owns security-policy/risk tracking. Pharmacy, Radiology and biomedical representatives validate their clinical changes, and Finance confirms quotes. A supplier response-time SLA is not a tested recovery result. Close or downgrade a gap only after its relevant permitted/denied access tests, alert escalation and/or clinically representative restore succeeds. Current ratings remain unchanged until those results exist; target residual levels are estimates, not guarantees, and must be rescored under Task 12's rubric.

The base package is $10,000 below the ceiling, so **no mandatory element of the seven packages is intentionally deferred for budget reasons**. Defer an enterprise SIEM purchase, organization-wide 24/7 monitoring expansion and a fully redundant core architecture to a later funding review; these are enhancements beyond the limited measures costed here. The $80,000 SIEM figure comes from James's scenario, not a current product quote. Interim named log review remains required, and a core cold spare is not equivalent to uninterrupted operation. MRI replacement remains ruled out by the scenario, not promised next year.

If updated quotes exceed the reserve, first reuse verified existing infrastructure and revise optional scope; do not quietly remove PACS or bedside recovery. Bring the revised cost and clinical consequence to management for additional funding or an explicit time-limited decision on deferral. A changed schedule is not risk acceptance. For any genuinely deferred exposure, document the accountable signatory, rationale, temporary controls and review date, with earlier review after a related incident, failed restore, vendor constraint or revised Task 13 finding.

**Operational exception:** GAP-008 billing mining is outside the selected seven because this plan follows Task 12's ranking, but its evidenced activity still requires prompt incident triage under James/Sarah. Existing-team triage is not a budgeted guarantee of full forensic remediation; any external response or rebuild cost must be separately priced and reconciled with the reserve or additional funding.
