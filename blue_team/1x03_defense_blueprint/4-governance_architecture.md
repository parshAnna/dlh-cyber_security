# Task 4 — The Governance Architecture

- **Organization:** MedDefense Health Systems
- **Project:** 1x03 — Defense Blueprint
- **Deliverable:** `4-governance_architecture.md`
- **Assessment date:** 29 October 2026
- **Prepared for:** James Chen, Deputy CISO; Sarah Park, IT Director; MedDefense executive leadership
- **Planning boundary:** Six-month security program; **$120,000 total program ceiling**, not a governance-only allocation
- **Document status:** Proposed governance design — **not** evidence of an approved or implemented structure

## Purpose and Grounding

MedDefense has an unfilled CISO position, disputed operational ownership between the Deputy CISO and IT Director, and clinical departments that need defined authority over patient information without bypassing enterprise security rules. The 1x03 [NIST CSF Current Profile](1-nist_csf_mapping.md) assesses **GOVERN as Partial**; the [CIS audit](2-cis_controls_audit.md) and [eight-gap traceability bridge](3-gap_framework_bridge.md) identify practical dependencies across identity, network boundaries, patient-record exports, recovery, and medical-device safety. This proposal assigns **one accountable role per activity**, separates policy/risk authority from technical implementation, and requires evidence for every important decision.

**Boundaries:** Names and positions below come from the project scenario (CEO, James Chen, Sarah Park, department heads including Dr. Patel, and the security analyst). Proposed assignments must be formally approved. Biomedical Engineering, Legal/Privacy/DPO, Procurement, HR, vendors, and clinical safety officers are necessary participants in some decisions but are **outside the five columns requested**; additional consultation gates are listed below. No named EHR processor, appointed DPO, contracted vCISO, or completed medical-device change is assumed.

## Part 1 — RACI Matrix

**Legend:** **R** = Responsible (performs/coordinates the work); **A** = Accountable (one final owner of the decision or outcome); **C** = Consulted (input required before decision/change); **I** = Informed (receives outcome and relevant reporting). One **A** appears in each row; more than one **R** is permitted where delivery is joint. RACI **does not** replace a contractual obligation or legally mandated clinical/privacy approval.

| Security activity | CEO | Deputy CISO (James Chen) | IT Director (Sarah Park) | Department Heads | Security Analyst (You) |
|---|:---:|:---:|:---:|:---:|:---:|
| **Security budget approval** | **A** | **R** | C | C | I |
| **Vulnerability remediation** | I | C | **A** | C | **R** |
| **Incident response execution** | I | **A** | **R** | C | **R** |
| **Security policy approval** | **A** | **R** | C | C | C |
| **Risk acceptance decisions** | **A** | **R** | C | C | C |
| **Security awareness training** | I | **A** | C | **R** | **R** |
| **Vendor risk assessment** | I | **A** | C | C | **R** |
| **Audit coordination** | I | **A** | **R** | C | **R** |

### Decision rights, controls, and concrete evidence

| Activity | Decision/execution rule | Required record or acceptance evidence |
|---|---|---|
| **Security budget approval** | James submits a prioritized, costed plan; Sarah confirms delivery feasibility; the CEO approves or rejects commitments within the shared **$120,000** ceiling. | Signed budget decision, costed portfolio, owner, renewals and variance log. |
| **Vulnerability remediation** | Sarah owns IT change delivery; the analyst validates findings, tracks tickets, and performs approved verification; James advises on business risk and escalation. | Change ticket with severity, system owner, approved rollback, validation scan/test and overdue exceptions. |
| **Incident response execution** | James directs the security response; Sarah executes IT containment/recovery; the analyst triages, collects evidence and coordinates alerts. Escalate safety-critical decisions to clinical leadership and the CEO according to severity thresholds. | Incident commander, timeline, evidence chain, documented approvals, clinical safety checks and post-incident review. |
| **Security policy approval** | James drafts and maintains policy with implementer and clinical input; the CEO formally approves and publishes it. | Version-controlled policy, signed approval, acknowledgment and scheduled review date. |
| **Risk acceptance decisions** | Only the CEO can formally accept residual **high/critical** cyber risk in this five-role model after James presents mitigations, clinical consequences and alternatives. The Board must be engaged where the organization's reserved powers require it. | Time-limited risk register entry, owner, likelihood/impact rationale, alternatives, compensating controls and expiry/review date. |
| **Security awareness training** | James owns the program; the analyst prepares content and measures results; department heads ensure appropriate clinical staff attend and complete it. | Role-based training plan, attendance/completion evidence, phishing/clinical scenario results and corrective actions. |
| **Vendor risk assessment** | James is accountable for security assessment; the analyst examines questionnaires, exposures and remediation; IT and department owners verify support/dependency and safety requirements. | Approved vendor register, due-diligence report, contractual security requirements, data-role classification and risk exception. |
| **Audit coordination** | James is accountable for the audit plan and consolidated response; Sarah and the analyst provide technical and governance evidence; CEO receives management findings. | Evidence index, named owners, auditor requests, corrective-action tracker and closure verification. |

### Mandatory cross-functional gates not represented as separate RACI columns

1. **Biomedical Engineering and medical-device vendors:** Must be consulted and provide the required technical/clinical clearance **before** modifying MRI controllers, Alaris pump management, medical-device VLANs or firmware. This is essential for **GAP-001** and **GAP-016**; urgent cyber exposure does not authorize unsafe unilateral device changes.
2. **Clinical/department leaders:** Dr. Patel and other relevant heads define appropriate patient-care access, clinical data usage and acceptable downtime; they **cannot independently exempt** their teams from centrally approved access policies, logging, retention rules or GDPR duties. Clinically disruptive containment needs a documented safety decision and escalation path.
3. **Privacy/DPO and Legal:** Must review personal-data processing, patient-record bulk export, breach duties, data-subject rights and processor contracts. Security acceptance never waives a statutory obligation; the DPO's independence must be respected.
4. **Procurement, HR and Finance:** Procurement/Legal review contracts; HR owns employment/offboarding workflow; Finance verifies spend against the **single** program cap. These functions are consultation/approval dependencies, not assumed to be performed by the analyst.

**Example of the disputed endpoint ownership:** Sarah is **A** for actually deploying and maintaining endpoint protection because IT controls managed endpoints and changes; the analyst is **R** for security validation and follow-up; James is **C** on risk/priority and **A** for the overarching security program's incident handling and awareness. Thus an unreporting Sophos sensor (1x02 Finding **027**) has a delivery owner without treating James and Sarah as competing technical approvers.

## Part 2 — Data Roles and Named/Position-Based Assignments

**Terminology rule:** **Data Controller** and **Data Processor** are legal classifications under the EU GDPR, applied to particular processing activities; **Data Owner**, **Data Custodian** and **Data Steward** are internal governance/operational roles, **not independent GDPR legal roles**. A person can serve as an internal owner while the *organization* remains controller. Determinations must reflect actual purposes, means, contracts and working arrangements. [G1–G3]

| Role | Proposed MedDefense assignment | Meaning and why this assignment fits | Authority / limitation |
|---|---|---|---|
| **Data Owner** *(internal business role)* | **Relevant clinical Department Head**, e.g., **Dr. Patel for Cardiology records**, and designated EHR/PACS service or clinical information owners for shared datasets. | Accountable internally for defining legitimate clinical uses, classification, access criteria, retention needs and quality expectations for the department's data. | Approves business access requirements **within** hospital policy; cannot personally authorize unrestricted exports or become the GDPR controller merely by being a physician. Cross-department EHR/PACS data need a named enterprise clinical owner. |
| **Data Controller** *(GDPR Art. 4(7))* | **MedDefense Health Systems as the legal organization**, represented for executive decisions by its **CEO**. | The organization determines the purposes and essential means of processing patients' health records for its healthcare activities and bears controller accountability. | **The CEO is the executive representative, not automatically a separate personal controller.** Joint or independent controllership for external practitioners/partners requires case-specific Legal/DPO assessment. |
| **Data Processor** *(GDPR Art. 4(8), Art. 28)* | **A contracted external EHR hosting, cloud backup or medical-records service provider — only if it actually processes identifiable patient data on MedDefense's behalf.** *Named vendor: not established in the available project evidence; designation pending contract review.* | A **separate entity** processes data for the controller under documented instructions and a qualifying contract; it does not determine its own independent purposes for that activity. | Record the specific vendor, service, processing activity, security terms and subprocessor controls before formal assignment. **Sarah, James, Dr. Patel and the analyst are not GDPR processors just because they handle data as employees.** A device-maintenance supplier with no access to personal data is not automatically a processor. |
| **Data Custodian** *(internal technical role)* | **Sarah Park, IT Director**, acting through system/database/backup administrators. | Responsible for technical storage, backups, recovery, configuration, access enforcement, logging and system availability according to approved owner requirements. | Can implement/maintain security controls but cannot independently expand the clinical purpose of data processing or accept high/critical residual risk. |
| **Data Steward** *(internal quality/usage role)* | **Health Information Management / Medical Records Lead** (proposed position; individual not named in the evidence). | Maintains record definitions, metadata, data-quality checks, retention/handling procedures and consistency of EHR/PACS datasets across departments. | Coordinates with clinical data owners, IT custodian and Privacy/DPO; does not replace the controller or hold unilateral access-exception authority. |

### How this division resolves the MedDefense conflict

For a proposed **bulk export of cardiology EHR records** (1x03 **GAP-017**; 1x02 **Finding 003** supports the access-path concern but does **not** prove an export-control failure), **Dr. Patel as data owner** specifies legitimate purpose and the minimum cohort; **MedDefense as controller** determines lawful purpose/essential means, with **Privacy/DPO** advising; the **data steward** validates data definitions; **Sarah as custodian** enforces approved access, export limits and logging; and **James/the analyst** assess security and alerting. An external provider handles it as a **processor only where a reviewed Art. 28 arrangement genuinely applies**. Physician status alone does not authorize an unlogged or unrestricted export. This is a **proposed workflow**, not a statement that it currently operates.

**DPO is a separate requirement, not another name for CISO.** The Luxembourg CNPD identifies large-scale hospital processing of health data as an example normally requiring a **Data Protection Officer** under GDPR Article 37. MedDefense should confirm its DPO designation and contact/independent reporting arrangements immediately; no appointed DPO is identified in the project evidence. The DPO must be engaged in data-protection issues and independently report to the highest management level; a vCISO does **not** replace that obligation. [G4–G5]

## Part 3 — The CISO Question

### Consequences of an unfilled CISO position

Without a formally designated security leader, **cross-department risk priorities and escalation can drift**, Sarah and James can give conflicting instructions about endpoint ownership, clinical departments can interpret data access rules inconsistently, vendor and medical-device decisions may lack an enterprise security voice, and the Board may receive no single consolidated view of accepted risk, exceptions or implementation evidence. These problems are especially consequential for **GAP-011** (identity and MFA), **GAP-016** (network trust boundaries), **GAP-017** (patient data exports), **GAP-007/GAP-003** (recovery), and the documented **KC1/KC3/KC4/KC5** threat paths. The vacant title does **not** by itself prove a legal violation, but it leaves the **GOVERN (GV.RR, GV.RM, GV.OV)** leadership structure insufficiently explicit unless duties are formally delegated. [N1]

### Recommendation — contracted vCISO for the initial six months

**Recommend a time-limited, contracted virtual CISO (vCISO) instead of immediately hiring a full-time CISO**, subject to a competitively scoped proposal and explicit CEO/Board authorization: MedDefense has a small internal security team, an immediate need for senior governance and clinical-risk prioritization, and a **$120,000 ceiling for the entire six-month Defense Blueprint**, which must also fund high-impact technical protections, monitoring and recoverability. A fractional vCISO can supply executive-level strategy, independent challenge, Board reporting, risk-register/exception governance, policy sponsorship, vendor oversight and measurable review checkpoints while **James Chen remains the named internal program liaison and operational incident lead**, **Sarah Park remains accountable for IT remediation**, and the **CEO retains final budget and high/critical risk-acceptance authority**; contracting does not transfer MedDefense's legal or executive accountability. **Do not invent a consulting rate or claim automatic savings:** procure a fixed deliverable-and-hours scope, assess conflicts of interest and hospital/medical-device experience, reserve funding only after comparing bids against the overall $120,000 portfolio, and reassess whether a permanent CISO is justified at month six.

### Six-month decision and accountability cadence (proposed)

| Timing | Governance practice | Owner and output |
|---|---|---|
| **First 30 days** | CEO approves the RACI, interim security leadership charter, high/critical risk-acceptance rule, DPO/vendor-role verification and clinical change gates. | CEO + James; signed charter, named escalation contacts and initial risk register. |
| **Weekly** | Review critical findings, patch/segmentation change status, sensor coverage, exceptions, clinical dependencies and incidents. | James convenes; Sarah/analyst provide tickets, clinical representatives consulted. |
| **Monthly** | Review CSF GOV maturity, CIS IG1 delivery, top eight gaps, vendor decisions, spending/forecast and overdue corrective actions. | vCISO/James present to CEO; minutes, dashboard and approved actions. |
| **Quarterly / major incident** | Review risk appetite breaches, serious patient-safety/data events, unaccepted residual risks and potential external reporting duties. | CEO/Board; documented decisions, Privacy/DPO and medical leadership engaged as required. |
| **Month 6** | Validate actual evidence, review vCISO performance, residual-risk trend, total cost and decision on longer-term CISO staffing. | CEO/Board; renewed governance plan and budget-aware hiring decision. |

### Minimum implementation acceptance criteria

The governance model is **implemented** only when: (1) the CEO has signed a version-controlled RACI/authority charter; (2) all eight activities have named operational owners; (3) high/critical risk acceptance uses documented, expiry-bound decisions; (4) medical-device changes have Clinical/Biomedical/vendor safety approval; (5) DPO and actual vendor controller/processor roles are confirmed; (6) at least one monthly governance review and a tabletop/escalation exercise leave auditable records; and (7) the vCISO option has a documented cost/scope decision consistent with the shared **$120,000** program cap. Drafting this task does not satisfy these gates.

## Traceability and References

### Internal MedDefense evidence

- [1x03 Task 0 — Framework Landscape](0-framework_landscape.md): NIST strategic outcomes + CIS implementation + ISO-aligned management evidence; six-month, $120,000 planning limit.
- [1x03 Task 1 — NIST CSF Mapping](1-nist_csf_mapping.md): current **GOVERN Partial**, unproven enterprise RACI, risk governance and supplier oversight.
- [1x03 Task 2 — CIS Controls Audit](2-cis_controls_audit.md): partial access, audit, vendor and incident-response control maturity; evidence must not be confused with proposed deployment.
- [1x03 Task 3 — Gap-to-Framework Bridge](3-gap_framework_bridge.md): eight reprioritized gaps **GAP-016, GAP-011, GAP-017, GAP-006, GAP-007, GAP-001, GAP-002 and GAP-003**, related 1x02 findings and modeled kill chains.
- [1x00 — Complete Control Matrix](../1x00_first_watch/10-complete_control_matrix.md): existing responsibilities/control evidence; [1x00 — Gap Analysis](../1x00_first_watch/12-gap_analysis.md).
- [1x01 — Kill Chains](../1x01_know_your_enemy/10-kill_chains.md): modeled KC1–KC5 scenarios, not observed breaches.
- [1x02 — Triage](../1x02_the_weak_links/16-triage.md): contextualized technical findings, including incomplete endpoint telemetry and identity/EHR/clinical device concerns.

### Normative guidance and legal terminology

- **[N1]** NIST, *Cybersecurity Framework 2.0* (2024), especially **GV.RR-01–03, GV.RM, GV.PO and GV.OV**: https://doi.org/10.6028/NIST.CSWP.29
- **[G1]** EU GDPR Article 4(7) and 4(8), official Luxembourg CNPD text (controller/processor definitions): https://cnpd.public.lu/en/legislation/droit-europ/union-europeenne/rgpd/chapitre-1.html
- **[G2]** European Commission, *Application of the GDPR — Roles of controller and processor*: https://commission.europa.eu/law/law-topic/data-protection/information-business-and-organisations/application-gdpr_en
- **[G3]** EDPB, *Guidelines 07/2020 on the concepts of controller and processor in the GDPR*: https://www.edpb.europa.eu/documents/guideline/guidelines-072020-on-the-concepts-of-controller-and-processor-in-the-gdpr_en
- **[G4]** Luxembourg CNPD, *Data Protection Officer (DPO)* — large-scale hospital processing and designation criteria: https://cnpd.public.lu/en/professionnels/dpo.html
- **[G5]** Luxembourg CNPD, *GDPR Chapter IV* (Articles 28, 37–39 and DPO reporting): https://cnpd.public.lu/en/legislation/droit-europ/union-europeenne/rgpd/chapitre-4.html

**Conclusion:** The proposed RACI makes the **CEO accountable for strategic approvals and risk acceptance**, **James accountable for security program execution**, **Sarah accountable for IT vulnerability remediation**, **clinical leaders owners of clinical data requirements and safety consultation**, and the **analyst responsible for assessment and validation**. GDPR controller/processor status remains legally distinct from these internal job titles. A deliverable-based **vCISO** can bridge the missing CISO leadership during the initial six months, but only with formal authority, independently reviewable evidence and a verified total-cost fit.
