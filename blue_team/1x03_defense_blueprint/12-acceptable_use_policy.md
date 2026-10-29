# MedDefense Health Systems — Acceptable Use Policy (AUP)

| Document ID | Version | Status | Policy owner | Approver | Effective date | Review |
|---|---|---|---|---|---|---|
| AUP-001 | 1.0 | **DRAFT — not yet in force** | James Chen, Deputy CISO | CEO (pending) | Upon written CEO approval | Annually and after material incidents |

**Operating rule:** Protect patient care first, then document and report any necessary emergency exception. This policy becomes enforceable only after approval, staff communication and acknowledgment.

## 1. Purpose and Scope

This policy protects patients, confidential information and continuity of MedDefense's three-site healthcare operations. It applies to employees, clinicians, temporary staff, contractors, students and suppliers using MedDefense accounts, facilities, devices, data or networks, whether on site or remotely. Covered resources include EHR (`ehr-srv-01`, `ehr-db-01`), PACS/Radiology, pharmacy systems, billing, Microsoft 365, shared workstations, Wi-Fi, VPN, servers and authorized clinical or biomedical equipment. Clinical safety rules and vendor-approved device procedures take precedence over unsafe technical actions; no one may independently disrupt an active infusion or imaging service.

## 2. Acceptable Use of Systems

**2.1** Use only assigned, authorized access for patient care, billing, administration or approved training; view the *minimum necessary* records for the task. Incidental personal use is permitted only when brief, lawful, non-disruptive and consistent with local departmental rules, and never on clinical equipment during patient care.

**2.2** Use approved applications, managed workstations, secure messaging, approved storage and the designated VPN for authorized remote work. Lock or sign out of shared terminals when leaving them; follow approved rapid reauthentication or badge-tap workflows where available. Check recipient identity and patient identity before sending information or changing clinical records.

## 3. Prohibited Activities

**3.1** Do not access, browse, photograph, copy, bulk-export or discuss a patient record without a treatment or approved work need; do not use patient information for curiosity, teaching, research or personal purposes without the required authorization. This addresses **GAP-017**, EHR exposure **Finding 003**, and **RISK-001/007**.

**3.2** Do not install unauthorized applications, host servers, connect unsanctioned Wi-Fi/routers, or create personal cloud, notebook, dashboard or remote-access services on MedDefense networks. Report unfamiliar hosts to IT rather than probing them. This addresses undocumented Linux/Grafana **Findings 028/029**, Westside perimeter **Finding 014**, and **RISK-009**.

**3.3** Do not disable endpoint protection, security alerts, logging, backups or patches; bypass network restrictions; lend credentials; or use remote-support tools without IT authorization. The inactive Sophos estate (**Finding 027**) and weak identity boundaries (**GAP-011/016**) make these restrictions essential.

**3.4** Do not change production pharmacy dosage tables, infusion-pump settings, PACS or MRI configurations, or connect diagnostic tools without the authorized change process and clinical/Biomedical/vendor approval. Patient-care integrity risks are tracked as **RISK-003/004/005/006**.

## 4. Personal Devices and Removable Media

**4.1** Personal USB drives and unapproved external disks are **not permitted** on MedDefense workstations or clinical devices (**Finding 023**). For a genuine care or vendor-transfer need, request an IT-issued encrypted drive or a secure approved transfer channel; the data owner authorizes the exception, IT logs issuance/return and the drive is scanned before use. Urgent care transfers follow the documented downtime process; staff must not improvise a personal-USB workaround.

**4.2** Personal phones/laptops may use designated guest access only. They may not connect to clinical, server, medical-device or administrative networks or store EHR/PACS/billing files unless explicitly enrolled in an approved managed-device/BYOD program with required protection and remote revocation. Never take patient photos or use personal messaging, email, consumer AI tools or cloud accounts for identifiable patient information. Report lost devices that may contain MedDefense information immediately.

## 5. Password and Authentication Requirements

**5.1** Use an individual account and a unique, non-reused passphrase of **at least 15 characters** wherever supported; use an approved password manager and do not disclose, share, post or store passwords in plain text. Password changes are required upon suspected compromise or IT-directed reset, not arbitrary routine rotation. IT must enforce lockout/rate-limiting and disable stale accounts where technically supported.

**5.2** MFA is required for VPN and administrative/privileged access **when the C2 rollout is enabled**; until then, IT applies approved compensating restrictions and records coverage gaps. Use only approved MFA factors; never approve unexpected prompts. Existing **Office 365 E3** must not be assumed to include every Conditional Access entitlement without licensing validation (**RISK-002; C2**).

**5.3** For an urgent clinical emergency, use the approved, individually attributable *break-glass* procedure, with a stated care reason, time-limited privileges and a post-event audit. Do not share a colleague's login as an emergency shortcut. If technology is unavailable, use the hospital's signed downtime workflow and notify the clinical lead and IT Security as soon as patient safety permits.

## 6. Data Handling and Confidentiality

**6.1** Apply the approved 1x00 Asset Registry, Criticality Assessment and Data Map to access decisions. Pending confirmation of MedDefense's formal labels, the **proposed handling tiers** are: **Restricted** — identifiable patient/EHR/PACS/pharmacy information, passwords, secrets and privileged credentials; **Confidential** — billing, staff and non-public financial/contract data; **Internal** — routine operational information; **Public** — material explicitly approved for release. These names are policy proposals, **not asserted quotations from an approved 1x00 classification standard**.

**6.2** Restricted data stays in authorized clinical systems; share only with verified authorized recipients through approved encrypted channels and use the minimum necessary detail. Confidential data requires role-based access, approved storage and encrypted transfer outside trusted systems. Never export data to personal accounts, removable media, consumer AI services or unapproved collaboration tools. Do not leave patient printouts visible; use secure disposal bins. Credentials must never be transmitted as ordinary unprotected email or embedded in tickets or screenshots.

**6.3** Report suspected wrong-recipient messages, misplaced records, unusual EHR bulk exports, phishing, unexpected MFA prompts and lost media **immediately after safeguarding the patient**, through the approved IT Security/help-desk or clinical incident channel. Preserve relevant evidence; do not conceal an error or attempt unauthorized forensic investigation. The DPO/Privacy team determines any required notification under applicable confidentiality and GDPR processes.

## 7. Monitoring, Exceptions and Enforcement

**7.1** MedDefense may log account sign-ins, VPN sessions, privileged changes, USB connection attempts, endpoint health and security events, and authorized EHR/PACS access or export activity for security, patient safety, audit and incident response (**C3 Wazuh is proposed, not yet deployed**). Monitoring must be proportionate, access-controlled, disclosed to staff and retained under the approved privacy/retention schedule; this policy does not authorize unrestricted private-content surveillance.

**7.2** Report suspected breaches promptly. IT Security records and investigates alerts with HR, the relevant clinical owner and DPO as necessary; suspected violations receive a fair, documented review and proportionate action, up to access restriction, retraining, disciplinary measures or contract remedies under applicable rules. Clinical emergencies are considered in the investigation; deliberate concealment or misuse is not excused.

**7.3** Exceptions require an identified care/business need, affected system, risk owner, compensating control, expiry date and written approval by the department lead and IT Security; Privacy/DPO or Biomedical/vendor approval is additionally required where relevant. The Deputy CISO maintains the exception register and reviews it monthly. No exception may authorize unsafe clinical modification or bypass a legal obligation.

## 8. Employee Acknowledgment

I have received and read this Acceptable Use Policy, understand how to seek guidance or request an exception, and agree to follow it after its effective date. I understand that suspected violations may be investigated under MedDefense's approved procedures.

**Employee/contractor name:** __________________________________________

**Department / role:** __________________________________________________

**Signature:** __________________________________  **Date:** ______________

**Manager / onboarding verifier:** _______________________________________

---

*Internal evidence trace (not part of employee instructions):* [1x00 Asset Registry](../1x00_first_watch/7-asset_registry.md), [Criticality Assessment](../1x00_first_watch/8-criticality_assessment.md), [Data Map](../1x00_first_watch/9-data_map.md), [Gap Analysis](../1x00_first_watch/12-gap_analysis.md); [1x02 Triage](../1x02_the_weak_links/16-triage.md); [Task 10 Risk Register](10-risk_register.md); [Task 11 Control Selection](11-control_selection.md). Scope, rules and numeric authentication minimums are **proposed policy choices** requiring CEO, clinical, HR and Privacy review, not existing proven MedDefense enforcement.
