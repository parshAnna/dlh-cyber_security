# The Weak Links — MedDefense Vulnerability Assessment

This project converts MedDefense's vulnerability-scan output into a threat-informed and business-contextualized vulnerability assessment. Findings are cross-referenced with the Project 1x00 Asset Registry and, in later tasks, the Project 1x01 threat analysis.

## Deliverables

- [Task 0 — Vulnerability Scan First Impressions](0-first_impressions.md): scan metadata, severity distribution, asset concentration, first-pass relationships and scope limitations.

## Evidence Approach

Task 0 uses the complete [SecurePoint Consulting OpenVAS report](https://s3.eu-west-3.amazonaws.com/hbtn.intranet/uploads/text/2026/3/3d9524922b7e610ce212603cb9f59167c5926948.txt) supplied with the assignment and the [Project 1x00 Asset Registry](../1x00_first_watch/7-asset_registry.md). It counts numbered scan findings rather than treating each CVE or affected fleet member as a separate report item. No external CVE, exploit or vendor research is used at this stage, and observations are explicitly separated from later validation and prioritization work.
