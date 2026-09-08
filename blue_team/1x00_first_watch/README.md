# First Watch — MedDefense Security Posture Assessment

This project analyzes the supplied MedDefense Health Systems documentation to develop an evidence-based understanding of its environment. Work is artifact-based; no systems were scanned, accessed or tested.

## Deliverables

- [Task 0 — Structured Environment Summary](0-environment_summary.md): organization, identified infrastructure, data/services and known unknowns.

- [Task 1 — Incident Classification](1-incident_classification.md): CIA classification of six incidents, with justified primary impacts and evidence-qualified secondary impacts.

- [Task 3 — Physical Security Risk Assessment](3-physical_assessment.md): five observations decomposed into vulnerability, threat, CIA impact and justified severity.

- [Task 4 — Security Control Inventory](4-control_inventory.md): evidence-based control records across three categories and five functions, with a summary matrix and coverage limitations.

## Evidence and methodology

Task 0 uses the [provided onboarding packet](https://s3.eu-west-3.amazonaws.com/hbtn.intranet/uploads/text/2026/3/f313f31b0157a0d741006a77b1aff5d54bf3a4c8.txt). D1–D6 in the summary refer to its six documents. Reported facts, functional inferences and unresolved gaps are distinguished. Historical notes are not treated as independently verified current configurations. Sensitive credential values are omitted.

Task 1 uses the six incident descriptions supplied in the assignment. Confirmed effects are distinguished from potential risks, particularly for the personal-laptop incident.

Task 3 uses the five supplied walk-through observations. Risk scenarios are distinguished from confirmed incidents, and location discrepancies with the onboarding packet are flagged.

Task 4 reviews all eight sections of the supplied security-controls artifact package. Existing controls are distinguished from proposals and unevidenced capabilities; each record cites its source and appears once in the classification matrix.

## Repository placement

Place this directory at `blue_team/1x00_first_watch` in the `dlh-cyber_security` repository. Tasks 0, 1, 3 and 4 are complete at this stage. Task 2 has not yet been supplied; later deliverables will be added when their instructions and artifacts are available.
