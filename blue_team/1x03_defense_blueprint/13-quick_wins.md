# Task 13 — The Quick Wins | MedDefense Health Systems

**Project:** 1x03 — Defense Blueprint  
**Deliverable:** `13-quick_wins.md`  
**Prepared for:** James Chen, Deputy CISO; Sarah Park, IT Director; clinical and privacy risk owners  
**Assessment date:** 29 October 2026  
**Execution window:** Days 1–14, 30 October–12 November 2026  
**Decision state:** Recommended rapid actions; **not evidence of deployment or measured risk reduction**.

## Executive Summary and Guardrails

The five **quick wins** below use existing staff, existing enterprise administration tools, existing Sophos licenses where already assigned, and current clinical change processes. **Incremental procurement and license spend: $0 per win** under the explicitly stated availability assumptions; the work still consumes ordinary staff time and must be authorized by the responsible operational owner, but **does not need new Board budget approval** or major network redesign. If existing capacity, rights, licensed agents or clinical approvals are absent, escalate rather than buy a product or bypass safeguards. None of these actions is a claim that the larger **C1/C2/C3/C4/C6** portfolio from Tasks 7–8 has already been delivered.

**Patient-care safety rule:** Use approved maintenance windows and clinical sign-off where relevant; test on representative systems, keep a documented rollback, and **never disable an active infusion pump, interrupt imaging/pharmacy workflows or block essential clinical USB peripherals** to satisfy a deadline. Recording an exception is not the same as closing a risk.

| Quick win | Primary T10 risk | Existing resource | Target days | Incremental cash | Primary evidence / acceptance check |
|---|---|---|---|---:|---|
| **#1 — Close stale VPN and privileged access** | **RISK-002** | FortiGate/AD account administration and access records | 1–3 | **$0** | Owner-signed stale-account list and disabled-access tests |
| **#2 — Restore the 15 silent Sophos sensors** | **RISK-002**; RISK-008 (supporting) | Current Sophos management and licensed endpoint agents | 2–8 | **$0** | All 15 healthy *or* individually documented unsupported/exception cases |
| **#3 — Restrict removable storage on a safe pilot** | **RISK-007** | Existing Active Directory GPO and approved exception route | 3–10 | **$0** | Denied unauthorized USB on approved pilot; critical peripherals still work |
| **#4 — Introduce a two-person pharmacy release gate** | **RISK-005** | Current pharmacy/IT change ticket and staged test workflow | 1–5 | **$0** | Sample change shows two distinct approvals and recorded dose checks |
| **#5 — Start retrospective EHR bulk-export triage** | **RISK-001**; RISK-007 (supporting) | Existing EHR audit/export reports and approved reviewers | 2–7 | **$0** | Five consecutive dated review records and escalation drill |

**Scope limitation:** The quick wins are **interim, complementary actions**. They do not replace MFA deployment, network segmentation, Wazuh SIEM, immutable offsite backups or the Westside firewall, and they do not fix the EHR database's broad `10.10.0.0/16` connectivity or the disputed Alaris firmware attribution. Their effects are not independently assigned any of Tasks 6–8's modeled monetary benefits.

---

## Quick Win #1: Revoke Stale VPN, Vendor and Privileged Accounts

- **Risk Addressed:** **RISK-002** (VPN foothold / Active Directory ransomware); related **GAP-011** (weak account accountability), **GAP-016** (weak trust boundaries) and **Findings 007/018** (AD protocol weaknesses, supporting context rather than proof of stale VPN accounts).
- **Action:**
  1. **Day 1:** Sarah Park's identity administrator exports current *authorized* FortiGate VPN users/groups, privileged AD accounts, vendor maintenance accounts and last-use/expiry records using existing admin consoles; do **not** export passwords.
  2. **Day 1–2:** Reconcile entries with HR departures, contract owners and department heads; classify **confirmed leavers, expired vendor access and unexplained privilege**. Obtain recorded approval before disabling accounts that might support scheduled clinical maintenance.
  3. **Day 2–3:** Disable confirmed stale access, remove unnecessary VPN group assignments and terminate or expire unneeded vendor sessions; preserve service, break-glass and approved emergency accounts with named owners and an audit trail.
  4. **Day 3:** Confirm with a controlled non-production test that a disabled identity cannot establish a VPN session; verify an approved clinical/vendor support identity still works. Log unresolved identities as time-bounded exceptions for MFA/C2 follow-up.
- **Owner:** **Sarah Park, IT Director** (accountable); AD/VPN administrators execute; HR and vendor contract owners validate.
- **Timeline:** **3 calendar days** (Days 1–3); no procurement, new licenses or firewall redesign.
- **Cost:** **$0 incremental cash**; already authorized FortiGate/AD administration and normal staff time. **Does not assume** Conditional Access or additional Entra licenses are available for the later MFA rollout.
- **Risk Reduction:** Removes usable old credentials and unnecessary privileged paths at the **initial-access step of KC1 (stolen VPN identity → AD → ransomware)**; also narrows possible vendor-access abuse relevant to **KC5**, without claiming the KC5 vendor compromise has occurred. Reduction is **qualitative/unquantified**; do not credit C2's separate **$310,000/year** assumed ARR without deployed MFA.
- **Verification:** Retain dated before/after counts, account owner approvals, redacted disablement/change-ticket logs, failed authentication result for a disabled test identity and successful authorized emergency-access check. **Pass criterion:** 100% of *confirmed* stale identities disabled; each unresolved account has an owner, expiry and follow-up ticket. **Rollback:** restore only a specifically approved critical identity using documented access-control escalation, then re-review.

## Quick Win #2: Repair the 15 Existing Sophos Agents That Are Not Reporting

- **Risk Addressed:** **RISK-002** (ransomware spread) with a supporting early-endpoint-detection benefit for **RISK-008**; direct vulnerability **Finding 027** reports **15 inactive or non-reporting Sophos endpoints**. This win does **not** patch the Linux billing server or replace full-estate C5 EDR.
- **Action:**
  1. **Day 1–2:** Export the fifteen host identities, last check-in time, OS support state and current license assignment from the existing Sophos console; reconcile devices to assigned departments and asset owners.
  2. **Day 2–5:** For **supported, already licensed** workstations, use vendor-supported repair/restart/re-enrollment procedures through normal IT endpoint management, one small noncritical group first; investigate duplicate records, stopped services and network connectivity rather than disabling protection.
  3. **Day 4–7:** Expand repairs after a successful pilot, with department-approved maintenance for clinical workstations; do not install unapproved agents on XP MRI controllers or infusion pumps.
  4. **Day 7–8:** Escalate unsupported, inaccessible or unlicensed assets as named exceptions with owner, temporary restrictions and a C5 procurement decision *outside* this no-new-spend quick win.
- **Owner:** **Sarah Park, IT Director**, through endpoint/desktop support; department leads confirm workflow safety.
- **Timeline:** **8 calendar days** (Days 1–8).
- **Cost:** **$0 incremental cash**, **only** for existing licensed Sophos agents and available management capacity; internal troubleshooting is absorbed into current operations. New endpoint licenses, servers, EDR replacement and vendor support contracts are **excluded**.
- **Risk Reduction:** Restores an existing opportunity to detect/quarantine endpoint malware **before the KC1 workstation/VPN-to-domain ransomware progression** and may help with **KC3 radiology-phishing footholds** where a supported agent is installed. This is a supporting reduction in attack progression, **not a quantified standalone ALE saving** and not proof of billing Linux-server protection.
- **Verification:** Keep a baseline screenshot/export showing **15** silent endpoints; a final report listing each host as current/healthy with definition updates and an alert-health test, **or** a documented exception ticket. **Pass criterion:** no unexplained silent entries among the original 15; the count restored and exceptions are reported separately. **Rollback:** use supported agent re-enrollment/repair reversal if a workflow breaks, never silently suppress console warnings.

## Quick Win #3: Pilot an Existing GPO to Block Unapproved USB Storage

- **Risk Addressed:** **RISK-007** (negligent patient-data disclosure); **Finding 023** (unrestricted USB storage on clinical workstations), 1x00 **GAP-017** (patient-data exports). Also complements the proposed AUP **Section 4.1**, which is **not yet enforceable until approved and acknowledged**.
- **Action:**
  1. **Day 1–3:** DPO, Sarah Park and a clinical representative list permitted removable-media workflows, essential diagnostic/peripheral devices, approved encrypted drives and urgent-care exceptions. Select **10 noncritical billing/administrative workstations** for a reversible pilot; do not start with MRI, PACS, infusion pumps or clinical equipment.
  2. **Day 3–5:** Use the **existing Active Directory Group Policy** removable-storage restriction on a dedicated pilot organizational unit/group; apply computer policy only to the pilot and document existing settings and rollback.
  3. **Day 5–7:** Test an unauthorized standard USB drive (must be blocked), an allowed keyboard/mouse and a legitimately authorized workflow (must function), then obtain department sign-off.
  4. **Day 7–10:** Extend to other **approved nonclinical** endpoints only if the pilot is clean; give staff an existing approved encrypted-transfer/IT-issued-media request path and log exceptions. Clinical endpoints remain an explicitly owned follow-up pending workflow validation.
- **Owner:** **Sarah Park, IT Director** (IT/GPO administrator); **DPO** approves patient-data rules; Nursing/Clinical Operations approves any patient-care impact.
- **Timeline:** **10 calendar days** (Days 1–10); restricted *phased policy configuration*, not a new appliance or network change.
- **Cost:** **$0 incremental cash** using existing AD/GPO and currently available approved transfer channels; staff testing uses scheduled operations time. No new DLP suite, device-control licenses or encrypted-drive purchases are implied.
- **Risk Reduction:** Blocks one **removable-media leakage path** in RISK-007 and a possible USB malware *alternative foothold* that could later support **KC1 ransomware or KC3 radiology compromise**; **USB is not a documented named step in KC1 or KC3**, and this pilot does not prevent all insider misuse. No new ALE reduction is claimed beyond the Task 5 R3 baseline **$300,000/year**.
- **Verification:** Save GPO change ID and scoped device list, `gpresult`/policy application evidence, two logged allow/deny tests, clinical/peripheral success check and signed exception list. **Pass criterion:** unauthorized mass storage denied on every tested scoped host without breaking essential peripherals; tally enrolled endpoints and excluded clinical systems. **Rollback:** unlink or revert the pilot GPO, update affected users and incident/change log.

## Quick Win #4: Require Independent Pharmacist Approval Before Dose-Table Changes

- **Risk Addressed:** **RISK-005** (unsafe pharmacy changes); **1x00 GAP-002 and GAP-022**, past pharmacy dosage integrity incident / **C-044**. **No numbered 1x02 Finding proves an application CVE here**.
- **Action:**
  1. **Day 1:** The **Chief Pharmacist** issues an immediately usable **interim change checklist** for production medication formulary/dose tables; identify named clinical approvers and IT change executor, using the current ticket/email approval mechanism.
  2. **Day 1–2:** Require two distinct humans for **request/technical preparation** and **independent pharmacist clinical approval**, with medication, dose/unit, affected sites, approved reference and time recorded. Do not let the executor self-approve.
  3. **Day 2–4:** For the next proposed change, validate the intended dose against the approved reference in the **already available staging/test workflow** or an existing read-only comparison; verify effects at **all three sites** and document a practical rollback/restore contact before production release. No new software development is assumed.
  4. **Day 4–5:** Perform a tabletop/sample ticket drill with a deliberately **incorrect test-only value**: independent review must reject it; rehearse emergency physician/pharmacist escalation without changing real patient orders or live dosage settings.
- **Owner:** **Chief Pharmacist / Pharmacy Department Head** (clinical risk owner); pharmacy application-change lead and Sarah Park's IT change team execute.
- **Timeline:** **5 calendar days** (Days 1–5), with required approval applied immediately to **new** changes.
- **Cost:** **$0 incremental cash** for a manual sign-off/checklist implemented using existing workflows and staff. Any *new* automated dose-validation engine, application refactor or recovery infrastructure belongs to a later funded project, **not** this quick win.
- **Risk Reduction:** Introduces an independent clinical approval barrier **before the KC2 unreviewed pharmacy change → incorrect dose reaches three sites**. The previous case showed an integrity failure; a dual check can reduce recurrence probability but **no measured probability or pharmacy-specific ALE exists** in Tasks 5–6, so reduction is **unquantified**.
- **Verification:** Chief Pharmacist signs the one-page procedure; a synthetic ticket contains distinct requester/approver identity, approved reference values, three-site verification and rollback details; a bad-dose test is visibly rejected. **Pass criterion:** **zero unauthorised production dose changes** and 100% independent approval in the first-week sample. **Rollback/safety:** do not promote a failed or unapproved change; invoke existing clinical downtime/change reversal procedure if a problem is discovered.

## Quick Win #5: Begin a Daily Human Review of Existing EHR Bulk-Export Logs

- **Risk Addressed:** **RISK-001** (patient-record exfiltration) and supporting **RISK-007**; **GAP-017** (bulk exports with weak authorization/alerting), **Finding 003** (broad *authenticated* PostgreSQL network reachability). Do not assert Finding 031 is an exploitable Ghostcat case: Tomcat 9.0.31 is reported and applicability is unverified.
- **Action:**
  1. **Day 1–2:** The EHR Clinical Data Owner and DPO approve a short list of authorized bulk-export roles, ordinary volumes and exceptional clinical/reporting purposes; Sarah Park confirms **existing EHR audit/report access**, its actual delay and which export details are recorded.
  2. **Day 2–3:** Assign a named privacy/EHR reviewer and backup; create a **daily retrospective check** of **already available** EHR export/access logs, focusing on unusual record counts, broad queries, off-hours exports and unfamiliar vendor identities. View minimum necessary metadata; do not copy patient datasets into the review record.
  3. **Day 3–7:** Record each day's log availability, coverage interval, reviewed exceptions and outcome in a restricted ticket/logbook; verify unusual exports with the clinical data owner, escalate unapproved activity to the **DPO and James Chen** for incident handling and preserve relevant audit evidence.
  4. **Day 5–7:** Run a **synthetic/log-based test** (not a real patient export) to verify the reviewer would recognize a flagged event and escalate it with a case ID. Document the known **approximately 48-hour EHR audit delay** as an unresolved KRI breach; manual daily reviews do **not** make delayed logs real-time.
- **Owner:** **EHR Clinical Data Owner** (accountable); **DPO/privacy analyst** reviews; Sarah Park's EHR administrator supplies existing reports; James Chen owns escalation.
- **Timeline:** **7 calendar days** (Days 1–7), followed by a daily recurring review until automated controls are implemented.
- **Cost:** **$0 incremental cash**, assuming existing audit reports and assigned reviewer time are available; **no Wazuh deployment, new log-retention license or software purchase** is assumed. If logs do not record bulk-export activity, report the gap, not a false success.
- **Risk Reduction:** May identify abnormal authenticated EHR data collection and unauthorized vendor exports in **KC5 (compromised maintenance channel → EHR exfiltration)** sooner *after records become available*, limiting time to management escalation. It does **not** prevent exfiltration, bypass the ~48-hour logging delay, or earn **C3's $90,000/year R1 marginal benefit** before Wazuh and validated response are in place.
- **Verification:** Retain access-approval list, a five-day sample of dated reviewer attestations, log-coverage timestamps, synthetic-alert ticket and DPO escalation receipt. **Pass criterion:** **five consecutive reviews of available logs** with a named backup and no unowned suspicious export; formally record EHR security-review lag >24 hours as an **open KRI exception**, not a resolved control. **Fallback:** if report availability is insufficient, retain manual clinical-owner export approval and create an incident/remediation ticket for delayed logging.

---

## Fourteen-Day Delivery and Evidence Checkpoint

| Checkpoint | Evidence due to James Chen | Escalation if unmet |
|---|---|---|
| **Day 3** | Stale VPN identities disabled and tested; pharmacist two-person gate issued; Sophos baseline captured | Confirm system owner/HR authorization and stop unsafe disablement; report missing vendor/clinical approvers |
| **Day 7** | Pharmacist sample negative-dose drill; EHR first five available-log reviews and latency exception; Sophos repair progress | Escalate unapproved production changes immediately; notify DPO on suspicious EHR exports; obtain endpoint exceptions |
| **Day 10** | Sophos original-15 closure/exception ledger; USB pilot allow/deny results and scoped rollout list | Roll back USB policy if essential peripherals fail; create owner-assigned unsupported-device tickets |
| **Day 14** | Signed five-win completion pack: tickets, scoped assets, pass/fail tests, unresolved items, owners and dates | James Chen updates Task 10 Risk Register; raise patient-safety/privacy issues immediately, not at monthly review |

**Evidence and status rules:** For each win store `owner`, `started`, `completed`, `assets in scope`, `change/ticket ID`, `test evidence`, `exceptions`, `rollback`, and `next review` in MedDefense's existing ticketing process. James Chen and Sarah Park sign off only tested, authorized changes. **At Day 14, mark each win Completed / Partial / Blocked**; do not mark a Task 10 risk Mitigated or lower the inherent/residual score solely because a policy or ticket exists. Clinical safety issues and patient-data breaches trigger immediate out-of-cycle risk review. Unresolved default Alaris management credentials (Finding 010), the unsegmented MRI controller (Finding 004), unsafe Apache findings (001/002), and PACS recovery gaps **remain urgent parallel remediation needs**; they are **not** presented as closed by these five wins.

## Why Quick Wins Matter Beyond Immediate Risk Reduction

Quick wins turn the first month of a security program into **visible, testable progress**: the Board and Robert Kim see that James Chen and Sarah Park can reduce obvious exposure using resources already paid for, without waiting for the six-month infrastructure roadmap. Cross-functional approvals give clinicians, Pharmacy, HR, Privacy and IT a shared way to make secure decisions, while short change tickets and pass/fail checks establish repeatable accountability, a baseline for KRIs and evidence for later audits. Equally important, small pilots reveal workflow conflicts and licensing or coverage gaps early, making the later C1/C2/C3/C4/C6 investments more realistic and easier to defend; they **complement rather than replace** the funded control portfolio and preserve safe patient care.

## Traceability to Existing Work

- [Task 10 — Risk Register](10-risk_register.md): RISK-001, RISK-002, RISK-005, RISK-007, RISK-008; inherent risk, owners, ALE limitations and KRI breaches.
- [Task 11 — Control Selection](11-control_selection.md): C1/C2/C3/C4/C6 shared future controls; deferred C5 and clinical exception requirements; no double counting of estimated benefits.
- [Task 12 — Acceptable Use Policy](12-acceptable_use_policy.md): draft USB, credentials, data-handling and clinical-change authority; **CEO approval pending**.
- [Task 7 — Cost-Benefit Analysis](7-cost_benefit_analysis.md) and [Task 8 — Budget Allocation](8-budget_allocation.md): existing five-control plan **$97,000 annualized**, **$115,000 illustrative year-one cash**; neither is an incremental cost or actual realized saving of these quick wins.
- [1x00 — Gap Analysis](../1x00_first_watch/12-gap_analysis.md), [1x01 — Kill Chains](../1x01_know_your_enemy/10-kill_chains.md), [1x02 — Triage](../1x02_the_weak_links/16-triage.md): risk evidence, KC1/KC2/KC3/KC5 threat pathways and Finding IDs 003/023/027, with precise applicability limits.
