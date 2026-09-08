# First Watch — MedDefense Security Posture Assessment

This project analyzes the supplied MedDefense Health Systems documentation to develop an evidence-based understanding of its environment. Work is artifact-based; no systems were scanned, accessed or tested.

## Deliverables

- [Task 0 — Structured Environment Summary](0-environment_summary.md): organization, identified infrastructure, data/services and known unknowns.

- [Task 1 — Incident Classification](1-incident_classification.md): CIA classification of six incidents, with justified primary impacts and evidence-qualified secondary impacts.

- [Task 3 — Physical Security Risk Assessment](3-physical_assessment.md): five observations decomposed into vulnerability, threat, CIA impact and justified severity.

- [Task 4 — Security Control Inventory](4-control_inventory.md): evidence-based control records across three categories and five functions, with a summary matrix and coverage limitations.

- [Task 7 — Asset Registry](7-asset_registry.md): consolidated onboarding, incidents, billing diagnostics, walk-through, controls, MRI scenario and network scan, with reconciliation notes.

- [Task 8 — Asset Criticality Assessment](8-criticality_assessment.md): ten CIA-rated categories, complete registry-ID mapping and a justified top-five ranking.

- [Task 10 — Complete Control Matrix](10-complete_control_matrix.md): consolidated control effectiveness, category/function averages and coverage of the five most critical assets.

- [Task 12 — Prioritized Gap Analysis](12-gap_analysis.md): 14 source-linked gaps and distribution summaries; data classifications are provisional pending separate Task 9/11 evidence.

## Evidence and methodology

Task 0 uses the [provided onboarding packet](https://s3.eu-west-3.amazonaws.com/hbtn.intranet/uploads/text/2026/3/f313f31b0157a0d741006a77b1aff5d54bf3a4c8.txt). D1–D6 in the summary refer to its six documents. Reported facts, functional inferences and unresolved gaps are distinguished. Historical notes are not treated as independently verified current configurations. Sensitive credential values are omitted.

Task 1 uses the six incident descriptions supplied in the assignment. Confirmed effects are distinguished from potential risks, particularly for the personal-laptop incident.

Task 3 uses the five supplied walk-through observations. Risk scenarios are distinguished from confirmed incidents, and location discrepancies with the onboarding packet are flagged.

Task 4 reviews all eight sections of the supplied security-controls artifact package. Existing controls are distinguished from proposals and unevidenced capabilities; each record cites its source and appears once in the classification matrix.

Task 7 distinguishes responding assets, undocumented devices, logical services and aggregate inventory gaps. It incorporates the supplied Task 2 diagnostics and Task 6 MRI scenario, distinguishing operational facts from proposed controls and unresolved vendor/OS details.

Task 8 evaluates impact separately from likelihood, takes the highest CIA rating as overall criticality, and distinguishes group-level importance from individual component outages.

Task 10 preserves Task 4 control IDs and adds cross-project evidence. Proposed or unevidenced protections are excluded from deployed counts, and coverage distinguishes direct controls from shared perimeter or organizational measures.

Task 12 distinguishes missing controls from weak controls and records its prioritization-rule interpretation. It uses a provisional data crosswalk because separate Task 9 and Task 11 materials have not been supplied.

## Repository placement

Place this directory at `blue_team/1x00_first_watch` in the `dlh-cyber_security` repository. Deliverables for Tasks 0, 1, 3, 4, 7, 8, 10 and 12 are available. Task 2 diagnostics were used for Task 7; no separate Task 2 deliverable is included. Task 6 scenario evidence was incorporated into Task 7; no separate Task 6 strategy deliverable is included. Task numbers follow the assignment filenames, which may differ from the platform navigation order.
