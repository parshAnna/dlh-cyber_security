# Task 0 — The Framework Landscape

- **Organization:** MedDefense Health Systems
- **Project:** 1x03 — Defense Blueprint
- **Deliverable:** `0-framework_landscape.md`
- **Assessment date:** 26 October 2026
**Decision context:** Regional healthcare provider; one security analyst and one deputy CISO; six-month planning horizon; maximum program budget of **$120,000**.

## Part 1 — Three-Framework Summary

### NIST Cybersecurity Framework (CSF) 2.0

The **NIST Cybersecurity Framework 2.0** is published by the U.S. National Institute of Standards and Technology (NIST) and is usable by organizations of any size or sector, not only government agencies. Its primary purpose is to organize and communicate cybersecurity risk-management outcomes so leaders can assess current exposure, set priorities, and guide improvement without mandating a specific technology. Its **Framework Core** comprises six Functions—**Govern, Identify, Protect, Detect, Respond, and Recover**—which are divided into Categories and Subcategories; **Organizational Profiles** compare current and target outcomes, while **Tiers** characterize risk-governance and management practices. It is particularly suitable for executive reporting, enterprise risk prioritization, and the construction of a staged security strategy. [N1][N2]

### CIS Critical Security Controls v8

The **CIS Critical Security Controls v8**, published by the Center for Internet Security (CIS), are a consensus-based, prioritized collection of actionable cybersecurity defenses. Their primary purpose is to turn common attack patterns and security gaps into specific, measurable safeguards that technical teams can implement and assess. Version 8 has **18 Controls and 153 Safeguards**, prioritized through three cumulative **Implementation Groups (IG1, IG2, IG3)**; **IG1 contains 56 foundational safeguards** and is an entry point, not a universal ceiling for higher-risk organizations. CIS Controls are used by IT operations, security practitioners, and resource-constrained organizations seeking a practical and risk-based implementation sequence. [C1][C2][C3]

### ISO/IEC 27001:2022

**ISO/IEC 27001:2022** is an international standard jointly published by the International Organization for Standardization (ISO) and the International Electrotechnical Commission (IEC). Its primary purpose is to establish, implement, maintain, and continually improve a risk-based **Information Security Management System (ISMS)** with accountable governance and demonstrable management processes. The standard contains management-system requirements in **Clauses 4–10** and a reference set of **93 Annex A controls** grouped into organizational, people, physical, and technological themes; applicable controls are determined through risk treatment and documented in a **Statement of Applicability (SoA)**, rather than treating every Annex A control as mandatory. Organizations across sectors use it for internal governance, audit readiness, stakeholder assurance, and—when independently pursued—formal certification; certification is optional and is not performed by ISO itself. [I1][I2][I3]

## Part 2 — Relationship Map

These frameworks are complementary rather than competing standards: **NIST CSF 2.0 provides the strategic outcomes and the Current-to-Target Profile (“what outcomes are needed and why?”), CIS Controls v8 supplies prioritized, testable actions (“which practical safeguards help achieve those outcomes?”), and ISO/IEC 27001 provides the management-system discipline for approving risks, assigning responsibility, retaining evidence, reviewing performance, and demonstrating conformity (“how do we manage and substantiate the program?”)**. MedDefense can start with a CSF gap such as insufficient detection, select relevant CIS safeguards for logging and monitoring, then record the responsible owner, risk treatment, testing evidence, exceptions, and periodic review within an ISO-aligned ISMS. Mapping controls to outcomes avoids maintaining three independent programs and allows a single piece of validated implementation evidence to support multiple reporting views; mapping alone does not prove regulatory compliance or ISO certification. [N1][N2][C2][C4][I1][I2]

## Part 3 — MedDefense Framework Selection

### Decision

**Adopt NIST CSF 2.0 as the strategic backbone, use CIS Controls v8 as the implementation baseline, and introduce a proportionate ISO/IEC 27001-aligned governance and assurance process.** Do not commit to ISO certification or full implementation of every CIS safeguard during the initial six months without confirming cost, scope, staffing, and clinical safety. This selection builds directly on Task 1's evidence-based CSF Current Profile and its proposed six-month Managed targets, which are **objectives—not achieved control states**.

### Why this combination fits MedDefense

1. **Board-level direction without excessive overhead.** The Board and James Chen need clear risk priorities, measurable milestones, and defensible investment decisions. NIST CSF's six Functions and Current/Target Profiles support that communication without forcing a federal-agency compliance program on a regional hospital. Task 1 found **Partial** activity across all six Functions, making a staged target more credible than claiming immediate full maturity.
2. **Actionable controls for a very small security team.** CIS IG1 provides an initial implementation baseline, but MedDefense's critical clinical systems and sensitive patient information justify **selected IG2 safeguards where risk warrants them**, with IT Operations, Biomedical Engineering, system owners, and approved vendors sharing execution responsibility. Controls must be phased and validated against clinical dependencies; blanket disabling of medical-device services is unacceptable.
3. **Auditable ownership rather than paperwork alone.** ISO/IEC 27001's ISMS model can guide policies, documented risk acceptance, an accountable risk register, supplier security reviews, management review, and evidence retention. MedDefense should build these records before considering external certification; framework alignment does not by itself establish compliance with any particular healthcare or privacy law. Legal/Privacy must identify the applicable obligations and map actual evidence to them.
4. **Budget discipline.** The **$120,000** limit is a hard cap for the overall defense blueprint, not an assumed allocation to frameworks or certification. Each proposed investment must later show its owner, dependency, initial/recurring cost, risk assumptions, expected reduction, and validation method. Reuse existing licenses, tools, and staff capacity where verified rather than assigning unsupported savings or claiming quantitative risk reduction without calculations.

### Illustrative cross-framework application to existing findings

| MedDefense evidence from Projects 1x00–1x02 | CSF 2.0 outcome area | CIS v8 control family to consider | ISO/IEC 27001-aligned evidence to retain |
|---|---|---|---|
| **GAP-012; Findings 028/029:** unidentified Linux/Grafana assets | **Identify** — Asset Management (ID.AM) | **Control 1:** Inventory and Control of Enterprise Assets | Approved inventory, asset owners, authorization/disposition records and reconciliation history |
| **GAP-011; Findings 007/018; KC1:** shared identities, limited MFA and AD authentication exposure | **Protect** — Identity Management, Authentication and Access Control (PR.AA) | **Controls 5–6:** Account Management and Access Control Management | Access policy, identity owners, exception approvals, compatibility tests and access reviews |
| **GAP-006/GAP-016; Findings 003/031; KC5:** broad EHR database access and exposed EHR application path | **Protect** — Platform Security / Infrastructure Resilience (PR.PS/PR.IR) | **Controls 4, 7 and 12:** Secure Configuration, Vulnerability Management and Network Infrastructure Management | Approved source allowlist, remediation tickets, negative/positive tests, clinical sign-off and residual risk |
| **GAP-001; Finding 010; KC4:** insufficient infusion-pump visibility and recovery | **Detect / Recover** — Monitoring and Recovery | **Controls 8, 11 and 13:** Audit Logs, Data Recovery and Network Monitoring | Vendor-approved passive-monitoring test, device-safe recovery evidence and biomedical approval |
| **GAP-003/GAP-007; KC3:** PACS backup exclusion and shared recovery failure domain | **Recover** — Recovery Plan Execution (RC.RP) | **Control 11:** Data Recovery | Protected-copy inventory, tested PACS restoration, clinical RTO/RPO approval and signed test results |

**Evidence limitation:** These are **risk-to-control planning mappings**, not evidence that the controls have already been deployed or that any modeled kill chain occurred. Finding 010's device-firmware/CVE applicability requires vendor verification; KC3 is a phishing-led PACS scenario, not proof of exploitation of the legacy MRI controller. The mappings must be revised if subsequent technical or vendor validation changes the underlying facts.

### Six-month adoption sequence (proposed, subject to budget approval)

| Period | Governance and delivery focus | Acceptance evidence |
|---|---|---|
| **Month 1** | Approve the CSF strategic baseline, identify accountable owners, define risk appetite and the ISMS scope, and review urgent clinical exposures | Board/management approval, risk ownership and prioritized control backlog |
| **Months 2–3** | Implement verified high-priority CIS safeguards: inventory reconciliation, identity controls, constrained EHR access, critical logging and clinical-safe containment | Updated inventory, verified change records, access tests, alert samples and vendor sign-off |
| **Months 4–5** | Expand prioritized monitoring and protected recovery; create response and recovery procedures; run supervised tests | Alert exercises, incident tabletop evidence, protected-backup tests and restoration results |
| **Month 6** | Reassess the CSF Current/Target gaps and CIS safeguard status; hold an ISO-aligned management review and document residual risks | Updated profiles, risk register, documented exceptions, management minutes and Board report |

**Approval condition:** This document selects a framework architecture; it does **not** authorize spending, assert compliance, or assign unverified dollar savings. The subsequent risk and investment tasks must keep the combined program within **$120,000** using explicit calculations and documented trade-offs.

## References

- **[N1]** NIST, *Cybersecurity Framework 2.0*, CSWP 29 (2024): https://doi.org/10.6028/NIST.CSWP.29
- **[N2]** NIST, *CSF 2.0 Organizational Profiles* and guidance: https://www.nist.gov/cyberframework/profiles
- **[C1]** Center for Internet Security, *CIS Controls Version 8*: https://www.cisecurity.org/controls/v8
- **[C2]** Center for Internet Security, *Implementation Groups*: https://www.cisecurity.org/controls/implementation-groups
- **[C3]** Center for Internet Security, *CIS Controls IG1*: https://www.cisecurity.org/controls/implementation-groups/ig1
- **[C4]** Center for Internet Security, *CIS Controls Navigator v8*: https://www.cisecurity.org/controls/cis-controls-navigator/v8
- **[I1]** ISO/IEC, *ISO/IEC 27001:2022 — ISMS Requirements*: https://committee.iso.org/standard/27001
- **[I2]** ISO/IEC 27001 Auditing Practices Group, *What is Annex A?*: https://committee.iso.org/files/live/sites/jtc1sc27/files/resources/ISO-IECJTC1-SC27-WG1_N3297_Auditing%20Practices%20Note%20-%20Annex%20A.pdf
- **[I3]** IEC, *ISO/IEC 27001:2022 overview*: https://webstore.iec.ch/en/publication/79694
- **MedDefense 1x00:** `../1x00_first_watch/12-gap_analysis.md`, `../1x00_first_watch/10-complete_control_matrix.md`.
- **MedDefense 1x01:** `../1x01_know_your_enemy/10-kill_chains.md`.
- **MedDefense 1x02:** `../1x02_the_weak_links/16-triage.md`, `../1x02_the_weak_links/23-validation_plan.md`.
- **MedDefense 1x03 Task 1:** `1-nist_csf_mapping.md`.
