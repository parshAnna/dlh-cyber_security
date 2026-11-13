# MedDefense Health Systems — Task 3: The 72-Hour Emergency Response Plan

**Project:** 1x05 — Emergency Board Briefing  
**Deliverable:** `3-emergency_plan.md`  
**Exercise incident:** Crimson Tide; Tuesday 18:47 (T+0) → Friday 18:47 (T+72 h)  
**Incident commander:** James Chen, Deputy CISO | **Technical change authority:** Sarah Park, IT Director  
**Operating capacity:** Sarah + **two IT staff tonight**; Security Analyst supports evidence/coordination, not a third IT implementer. Clinical leadership and vendors are *approval/assistance dependencies*, not assumed extra technicians.  
**Status:** **PROPOSED EMERGENCY RUNBOOK — no completed deployment, compromise or incident response is claimed.**

## Executive decision — act in the right order

**First 4 hours:** establish whether the FortiGate 100F's vulnerable **SSL-VPN** is reachable, contain that entry point with approved clinical continuity, and preserve at least one usable **independently protected backup** before making disruptive changes. Then collect volatile evidence, protect privileged access, and prepare an emergency vendor-approved firmware route. A genuine containment decision must not be delayed until the Board meeting; James can use existing emergency change authority, while **new procurement** needs the appropriate financial authorization.

The MedDefense baseline supports **5/7 EXPOSED, 2/7 PARTIALLY PROTECTED, 0/7 PROTECTED** as a *conditional pathway assessment*, **not** proof that Crimson Tide has compromised MedDefense. SSL-VPN enablement/public reachability and all campaign indicators remain **unverified**. The course's signed advisory was not independently retrieved in Task 0; phase headings below are its **working phase names** and must be reconciled with the original advisory before final Board sign-off. The campaign's geography and hospital counts are scenario facts, not independently authenticated CISA news.

**Seven-phase working key** ([T0](0-advisory_analysis.md)): **P1** FortiGate SSL-VPN exploit → **P2** foothold/persistence → **P3** reconnaissance/lateral traversal → **P4** Kerberoasting/domain privilege → **P5** EHR exfiltration → **P6** backup destruction → **P7** ransomware/clinical disruption. "Phase Blocked" identifies an *intercept or damage limitation*, not guaranteed eradication or a confirmed attack.

### Command, cost and safety rules

1. **James** declares the elevated threat/incident status, authorizes containment, owns incident communications and evidence preservation. **Sarah** is the single change coordinator; **IT-A (network)** and **IT-B (systems/backup)** are her only two available operators. **Security Analyst (you)** maintains the timeline, IOC/evidence register and reports; **Robert Kim** reviews any expense; **clinical duty lead/Biomedical** approves patient-impacting changes; **Maria Santos/DPO** assess legal notifications if evidence warrants them.
2. **Tier 1 has no procurement, license purchase or new budget commitment.** It still requires existing emergency change and clinical safety authorization. No untested full network shutdown, mass credential rotation, global Kerberos encryption-type switch or firmware flash tonight.
3. Every change gets an incident/change ID, approver, scope, baseline capture, immediate rollback method, positive clinical checks and independent evidence. A dangerous change is **NO-GO** if emergency workflows cannot be maintained. Preserve logs in restricted, time-synchronized evidence storage and do not run exploitation against a live clinical perimeter.
4. Existing controls **C-002/C-003/C-004**, limited Sophos and local backups are *partial baseline defenses*. **C1 segmentation, C2 MFA, C3 Wazuh, C4 immutable offsite backups, C6 Westside firewall** were **selected for conditional funding** in 1x03; none is verified deployed or Board-funded. Task 7 annualized control envelopes are **C1 $30k, C2 $11k, C3 $22k, C4 $21k, C6 $13k**. Staff effort and emergency work are not silently priced at $0.

## Tier 1 — Tonight (T+0 to T+12 h): no purchase, minimum disruption

### Action T1-01 — Identify and contain the exposed FortiGate SSL-VPN entry point (first 0–4 h)

- **Action:** Sarah/IT-A perform **read-only** FortiGate configuration, firmware, interface, SSL-VPN listener, WAN policy and external reachability checks; preserve the appliance's running configuration and change record. If SSL-VPN is internet-reachable on 7.0.9, James authorizes the **smallest safe emergency restriction** (approved-source allowlist or disable SSL-VPN) once a tested staff/clinical alternative is confirmed; verify site-to-site **IPsec remains intact**. If the service is already disabled, record proof instead of inventing exposure or breaking another VPN function.
- **Phase Blocked:** **P1** initial access; downstream P2–P7 *only if attackers have not entered through another route*.
- **Owner:** **Sarah** (decision/execution), **IT-A** (read-only checks and approved rule change); **James** authorizes containment; clinical lead confirms care access.
- **Prerequisites:** Emergency change approval, approved admin console, network/service dependency list, baseline configuration backup, rollback instructions, verified alternate route for essential remote clinicians and intersite operations.
- **Risk of Action:** Locking out approved remote workers or accidentally interrupting all three sites if SSL-VPN is confused with site-to-site IPsec; unverified firewall rules may harm clinical traffic.
- **Risk of Inaction:** A known vulnerable **FortiOS 7.0.9** SSL-VPN listener, if reachable, remains a plausible **pre-auth RCE** entry, even when MFA is enabled.
- **Validation / stop rule:** Outside-the-network test shows the unsafe SSL-VPN path unavailable or narrowly restricted, authorized clinical work and all site-to-site IPsec tunnels still work, firewall logs capture the change. Roll back *only the specific rule* if a critical clinical route fails and activate pre-approved compensating access; escalate immediately if safe containment is impossible.
- **Trace:** New **CVE-2023-27997**; 1x02 F014 refers to **Westside Netgear**, not this FortiGate; **GAP-015/GAP-016**, baseline C-002; target C1/C2. **No Tier 1 procurement**; `$2,400/year` support renewal is a separate Tier 2 request.

### Action T1-02 — Preserve an independent, isolated backup before attackers can destroy it

- **Action:** IT-B identifies the latest *completed* EHR, AD and billing backup sets plus PACS's documented backup gap; records manifests, timestamps, ownership and backup job state. Under Sarah's authorization, **physically disconnect/isolate NAS-01 from the network tonight** *after verifying it is not a live clinical dependency or mid-write target*; if it is the only active recovery target, first stage and verify a separate offline copy or an approved safe backup pause, then disconnect. Place isolated media and recovery credentials in separately controlled custody; do **not** store encryption unlock keys on the NAS or delete existing copies.
- **Phase Blocked:** **P6** backup destruction and **P7** total loss of recoverability; isolation does **not** prevent P1/P5 or stop ransomware already running.
- **Owner:** **Sarah** (go/no-go), **IT-B** (backup and physical isolation); **Security Analyst** logs custody; clinical/backup owner signs off on interruption risk.
- **Prerequisites:** Identify whether `NAS-01` is used for active patient-care shares vs backup only; inventory scheduled jobs; get an available offline medium/location without purchasing; protect the last known-good copies and retained keys; confirm EHR/AD/billing recovery coverage and acknowledge PACS scope gaps.
- **Risk of Action:** Disconnection could interrupt active backups/restores, expose stale recovery points or accidentally disconnect a live share; unverified copied data may be unusable.
- **Risk of Inaction:** **F015** broad NAS DSM access, flat network and unencrypted reachable copies can enable both PHI disclosure and destruction of the recovery path.
- **Validation / stop rule:** Confirm the isolation link is down, write-protected/offline copy and manifest exist, backup agent status and loss-of-new-backup interval are documented, and essential clinical applications stay available. If NAS dependency or copy integrity is uncertain, **do not blindly pull the only live cable**; use a narrower approved access restriction, retain services and escalate at once.
- **Trace:** 1x02 **F015**, 1x00 **GAP-007/GAP-003/GAP-016**, 1x04 **CRYPTO-013**; future **C4 $21,000/year** plus C1 $30,000/year; T14 key custody external to NAS. Existing offline media only in Tier 1.

### Action T1-03 — Preserve and triage indicators without destabilizing the hospital

- **Action:** Security Analyst opens a timestamped evidence register; IT-A exports available **FortiGate config/admin/auth/SSL-VPN/session/traffic logs** and records time source, while IT-B preserves **AD KDC events**, EHR PostgreSQL access/export logs and NAS DSM/backup audit trails. Check only supplied, validated **CISA/vendor or course-advisory IOCs** and suspicious novel admin accounts, policy edits, off-hours Kerberos service-ticket spikes, large EHR exports and unauthorized backup deletions. Preserve originals and hashes where feasible; **no exploit scans or wide destructive collection**.
- **Phase Blocked:** Primarily detection/containment of **P1–P6**; earlier warning may reduce **P7** impact, but logging is **not preventive**.
- **Owner:** **You (Security Analyst)** coordinate and analyze; IT-A / IT-B perform restricted exports; **James** determines incident escalation.
- **Prerequisites:** Read-only access approvals, secure evidence location, retention and clock-offset record, a clear rule for separating verified IOCs from generic abnormal activity; access should not interrupt logs needed for clinical forensics.
- **Risk of Action:** Competing for the two implementers' time, sensitive log disclosure, excessive polling or accidental log rotation/overwriting.
- **Risk of Inaction:** A compromised perimeter or identity may persist unseen; FortiGate **C-004 local 30-day logging** and fragmented host logging could disappear or be altered before investigation.
- **Validation / stop rule:** Evidence index lists source/time/range/custodian/hash or integrity note and gaps; James receives an initial **known / unknown / suspected** status update. A confirmed malicious indicator triggers the incident plan and targeted isolation, not unsupported assurance that systems are clean.
- **Trace:** 1x02 **F007/F018/F027** and new FortiGate CVE; **GAP-011/GAP-015/GAP-016**; target **C3 Wazuh $22,000/year** (*not yet deployed*), current local logs.

### Action T1-04 — Freeze risky privileges and activate clinical continuity governance

- **Action:** James announces an emergency change freeze except approved security/clinical recovery work; Sarah reviews active FortiGate/admin/VPN accounts and AD privileged changes **read-only**, cancels stale temporary access where owner-confirmed safe, and introduces a second-person approval for new privileged logins, mass exports and backup deletion. Clinical leads check paper EHR, imaging and cross-site communications continuity; Maria Santos/DPO start a **breach-assessment decision log**, not an automatic declaration that a breach occurred.
- **Phase Blocked:** **P2** persistence, **P4** privilege misuse, **P5** unauthorized export and **P7** prolonged care disruption (*containment/limitation, not guaranteed prevention*).
- **Owner:** **James** (incident/governance), **Sarah** (IT policy), **You** (decision log); clinical lead / Legal consulted.
- **Prerequisites:** Approved communication channel, verified identity of system and clinical owners, break-glass emergency access, existing access logs.
- **Risk of Action:** Restrictive account policy can block urgent treatment or delay safe repairs; reporting an unverified compromise as fact can cause harm.
- **Risk of Inaction:** Privileged changes, bulk exports and attacker persistence may continue unnoticed while the three sites lack a coordinated safety response.
- **Validation / stop rule:** Written incident commander, clinical contact roster, approved exception log and secure escalation route; essential EHR/pharmacy/PACS access remains available; any emergency access is time-limited and attributable.
- **Trace:** 1x02 **F007/F018**, 1x00 **GAP-011/GAP-017**, controls **C2 $11,000/year** and C3 $22,000/year (*future portfolio; tonight procedural only*).

## Tier 2 — Tomorrow (T+12 to T+36 h): Board decisions and brief safe changes

### Action T2-01 — Obtain emergency Fortinet entitlement and a vendor-vetted upgrade route

- **Action:** Sarah presents the Board with FortiGate **7.0.9** exposure, current containment status and a **$2,400/year support renewal** decision; Robert Kim verifies contractual entitlement and fiscal authority; obtain official signed firmware only through an authorized vendor channel and request the **model-supported current safe release, Fortinet upgrade-path tool and change/recovery guidance**. Download into a protected staging area, validate checksums/signatures and test an upgrade plan **before** any flash.
- **Phase Blocked:** **P1** through a future verified patch; purchase/download alone blocks **none**.
- **Owner:** **Sarah** (technical owner), **James** (security justification), **Robert Kim/CEO/Board** (financial authority); vendor contingent on availability.
- **Prerequisites:** Written emergency funding approval, support entitlement, exact model/config and current PSIRT/upgrade-path review; schedule vendor call rather than assuming instant help.
- **Risk of Action:** Unplanned support spend or an incompatible firmware selection; flashing the only perimeter device without recovery can disconnect three sites.
- **Risk of Inaction:** An exposed SSL-VPN, if one exists, stays vulnerable until effective containment or upgrade; support expiry blocks an ordinary verified patch workflow.
- **Validation / stop rule:** Approved purchase/entitlement, **official validated image and compatible upgrade/rollback plan** documented; no production patch until Tier 3 safety gates pass.
- **Trace:** **CVE-2023-27997**, GAP-015, C1/C2 adjacent. **Important:** FortiOS **7.0.14** fixes the 2023 CVE but remains in the separately affected **CVE-2024-55591** 7.0.0–7.0.16 range; **do not default to 7.0.14**. This `$2,400` is **additional**, not inside the $97k/year C1/C2/C3/C4/C6 proposal.

### Action T2-02 — Pilot narrow, reversible emergency east-west restrictions

- **Action:** IT-A maps minimum approved traffic for VPN-to-Central server, AD and EHR; Sarah stages a **small allowlist/deny rule replacing the broad C-002 `ALL` access** for nonessential admin and data services, with logging and a saved policy version. Apply a canary source/route first; monitor EHR logins, LDAP/Kerberos, billing, DNS and clinical site-to-site communications before expanding. **No blanket switch reconfiguration** in this tier.
- **Phase Blocked:** **P2/P3**, partially **P4/P5/P6/P7**, conditional on source and services being outside approved flows; a pre-auth FortiGate exploit is **not** fixed by these rules.
- **Owner:** **Sarah** (change lead), **IT-A** (network); **James/clinical owner** approve blast radius.
- **Prerequisites:** Confirm gateway integrity reasonably enough to trust policy changes; existing configs and audit baseline, authorized source/destination/port matrix, backup of policy, clinical check and fast rollback.
- **Risk of Action:** Broken AD RPC/DNS, EHR, PACS or cross-site connectivity; canary rule may miss legitimate traffic until observed.
- **Risk of Inaction:** **GAP-016** flat trust and F003's broad PostgreSQL source access facilitate post-VPN lateral movement and EHR access.
- **Validation / stop rule:** Blocked nonapproved access evidenced in logs, approved workflows and all three-site connectivity work, rollback under Sarah if clinical workflow fails; do not claim full segmentation delivered.
- **Trace:** 1x02 **F003/F006/F015**, **GAP-006/GAP-016**, target **C1 $30,000/year** (formal 2–3-day switch redesign deferred to Tier 3).

### Action T2-03 — Complete a controlled recovery rehearsal and maintain independent copies

- **Action:** IT-B restores **one known-good EHR or billing backup sample using isolated test storage**, validates file/database consistency, timestamps, required keys and application-readable records **without real PHI exposure**; check PACS catalog/study coverage and flag explicitly missing backups. Keep the physical NAS isolation from T1-02 if viable; build a staged, separately authenticated encrypted offsite/immutable repository proposal rather than reconnecting it to the compromised network just for convenience.
- **Phase Blocked:** **P6** destruction of *all* recovery copies; limits **P7** downtime, not ransomware execution.
- **Owner:** **IT-B** (restore), **Sarah** (recovery changes), **You** (evidence), clinical/Radiology data owner (acceptance).
- **Prerequisites:** Isolated safe host/media, known backup set and decrypt/recovery material held outside NAS, approved test dataset, maintenance coordination and restore objective.
- **Risk of Action:** Contaminated backup imported into production, overwriting live records, missing key versions or a restore exercise consuming the only good copy.
- **Risk of Inaction:** Assumed backup availability might fail precisely when all sites need restoration; RAID-5 and 14-day local retention do not prove ransomware resilience.
- **Validation / stop rule:** Restore log and checksum/application smoke test, copy remains offline and source intact; **never restore onto the live EHR during this test**; escalate any absent PACS recovery immediately.
- **Trace:** **F015**, **GAP-007/GAP-003**, 1x04 CRYPTO-013, target **C4 $21,000/year** (cost proposal; no unfunded cloud procurement in this action).

### Action T2-04 — Contain identified compromised identities; stage MFA and Kerberos migration

- **Action:** From validated ticket and authentication telemetry, James approves **targeted** disable/revoke/recredential of confirmed suspect VPN/admin/service identities; Sarah stages C2 MFA for supported remote/admin access with break-glass, and inventories all **RC4/DES** Kerberos consumers. Gather ticket-encryption-type events and vendor dependencies to design, **not yet apply**, an AES-only maintenance-window change.
- **Phase Blocked:** **P2/P4**, limits **P3/P5** when stolen identity is required; **MFA does not block FortiGate's pre-auth SSL-VPN RCE**.
- **Owner:** **James** (evidence/response decision), **Sarah/IT-B** (AD and access), **You** (auth-log correlation); AD application owners approve changes.
- **Prerequisites:** Corroborated suspect identity, emergency clinical access, privileged account inventory, AES-support audit, rollback credential vault and tested MFA enrollment.
- **Risk of Action:** Disable a legitimate clinical service account, break AD authentication or silently strand a vendor-supplied medical system.
- **Risk of Inaction:** RC4-enabled service accounts remain plausible Kerberoasting targets; stolen admin credentials permit privileged persistence and ransomware delivery.
- **Validation / stop rule:** Only identified accounts changed, successful critical sign-ins and service starts, security events collected, no unexplained authentication failures; abandon broad crypto hardening until Tier 3 window.
- **Trace:** 1x02 **F007/F018**, **GAP-011**, controls **C2 $11,000/year**, **C3 $22,000/year** (future, budget-dependent).

## Tier 3 — This week (T+36 to T+72 h): vendor/maintenance and controlled pilots

### Action T3-01 — Patch the single FortiGate perimeter safely after entitlement

- **Action:** With licensed vendor support, stage the **FortiGate 100F-compatible, currently supported, PSIRT-reviewed** firmware and the official staged upgrade route; preserve independent configuration backup and evidence before any upgrade, choose approved outage window, have vendor and local console recovery ready. Upgrade only if there is **no clinical continuity objection**, then check actual version, SSL-VPN restrictions, internet access, IPsec tunnels to all three sites and firewall policy; complete compromise triage even after patching.
- **Phase Blocked:** **P1** specifically, if the new version removes exploitable defects; does not undo attacker persistence from an earlier breach.
- **Owner:** **Sarah/IT-A**, **External Fortinet partner** if available; **James** approves security change; clinical duty lead signs off.
- **Prerequisites:** **T2-01 support/firmware**, correct device backup and approved release/upgrade-path, access to console and rollback image, verified offline backup, post-change clinical tests, signed outage/rollback decision.
- **Risk of Action:** Single perimeter without HA may interrupt all-site VPN, routing or portal access; in-place downgrades may not be safe due to configuration migration.
- **Risk of Inaction:** Continued exploitability if the vulnerable service is reachable; exposure persists if compensating restriction is incomplete.
- **Validation / stop rule:** Vendor-confirmed fixed build, allowed/blocked SSL-VPN tests, end-to-end EHR/PACS/site-to-site checks, log review; use vendor-approved recovery or tested standby connectivity if care-impact stop condition occurs. **If vendor/image/safety gates fail by T+72, maintain verified SSL-VPN containment and escalate the patch as overdue — do not flash blindly.**
- **Trace:** New **CVE-2023-27997** plus separate **CVE-2024-55591**, **GAP-015/GAP-016**; additional **$2,400/year** contract, other implementation/vender cost **unpriced**.

### Action T3-02 — Start the 2–3-day segmentation project as a restricted pilot

- **Action:** Build/stage new switch/VLAN and firewall policies for **Z-VPN → approved jump host**, protected AD/EHR and **isolated backup management**. Inventory AD RPC, DICOM, HL7 and vendor-approved device flows, enable logging, verify asymmetric routing and test a single noncritical segment or selected VPN source first. Expand **only after** clinical sign-off and documented rollback; never assert a full multi-site redesign was completed in 72 hours.
- **Phase Blocked:** **P3** primary; partly **P2/P4/P5/P6/P7** where direct lateral pathways are removed.
- **Owner:** **Sarah/IT-A**, supported by network vendor **if procured**; clinical/Biomedical service owners approve device paths.
- **Prerequisites:** Board authorization for purchase/change, vendor/IT availability, validated IP/port dependency matrix, test window and rollback; **minimum 2–3 days** for switch changes even after work begins.
- **Risk of Action:** Disrupt EHR logins, PACS DICOM, nurse-call/pumps, AD/RPC or cross-site routing by overbroad denies.
- **Risk of Inaction:** Broad `C-002 ALL` reach and flat network continue to permit ransomware spread from any internal foothold.
- **Validation / stop rule:** Canary approved clinical traffic succeeds, nonapproved lateral paths denied, policy logs and emergency revert tested; if new switches/approvals aren't available, finish detailed design and deploy only approved low-risk existing-rule tightening.
- **Trace:** **F003/F006/F015/F024**, **GAP-016/GAP-006**, **C1 $30,000/year** and complementary **C6 $13,000/year** Westside firewall; selected in 1x03, **not proven purchased**.

### Action T3-03 — Pilot AES-only Kerberos with application-safe rollback, not a global overnight toggle

- **Action:** IT-B/AD owner inventories RC4/DES-dependent SPNs/service accounts, collects KDC encryption-type events, verifies domain and third-party system AES support, updates a **test/approved canary service account** and rotates that account's credential safely. Run critical AD, PACS, pharmacy and billing login tests; schedule phased disabling of DES/RC4 and LDAP signing/LDAPS work only after vendor compatibility is proven.
- **Phase Blocked:** **P4** Kerberoasting and privileged expansion **partially**; AES lowers offline crackability for well-managed service passwords but cannot prevent ticket requests or compromise of weak passwords alone.
- **Owner:** **Sarah/IT-B** (AD), **James** (risk authority), vendor/application owners for service-account dependencies.
- **Prerequisites:** AD and SPN inventory, KDC telemetry, maintenance window, supported cipher list, gMSA/strong password options, documented old/new credentials and service rollback.
- **Risk of Action:** Breaking legacy application/domain logons, stalled clinical workflows, authentication outages during RC4/DES retirement.
- **Risk of Inaction:** **F018** legacy algorithms and **F007** LDAP signing gap preserve a credential attack route.
- **Validation / stop rule:** Selected service signs in with AES ticket type and all dependent workflows work; retain approved rollback. **If prerequisites fail, deliver the signed migration plan, not a forced production AES-only claim.**
- **Trace:** 1x02 **F007/F018**, 1x00 **GAP-011**, **C2 $11,000/year** (MFA is a different layer), **C3 $22,000/year** (detection); Kerberos remediation effort is **not separately priced** in 1x03.

### Action T3-04 — Stage immutable recovery and monitoring with evidence-based acceptance

- **Action:** IT-B/backup team, if vendor and funding are ready, pilot **client-side encrypted**, independently administered **immutable offsite copies** with retention lock, **key material NOT on NAS-01**, least-privilege backup vs restore credentials, and an isolated restoration. The analyst maps FortiGate/AD/backup/EHR high-value events to proposed **Wazuh C3** rules and named escalation ownership; if no compatible endpoint/collector exists, retain protected manual log export until provisioned.
- **Phase Blocked:** **P6** loss of every backup copy; **P7** recovery impact, with early detection of **P2–P5** *if telemetry actually arrives and is monitored*.
- **Owner:** **Sarah/IT-B** for backup, **You** for detection mapping, **James** for acceptance; supplier/DPO/clinical leads as appropriate.
- **Prerequisites:** Authorised destination and data-sovereignty/privacy review, recovery escrow held apart from NAS/cloud console, immutable provider feature confirmed, funded service/available staff, sample restore test and DPO/clinical approvals.
- **Risk of Action:** Cloud data exposure or prohibited region, unrecoverable encryption keys, unexpectedly immutable erroneous copies, restore-time bottlenecks and workload competing with gateway/AD recovery.
- **Risk of Inaction:** Backup deletion/decryption risk persists despite disk encryption, while unmonitored domain/gateway changes may go undetected.
- **Validation / stop rule:** Verify remote ciphertext without reachable delete permissions from compromised production role, independent key recovery, successful isolated restore and alert owner response. **If procurement cannot finish within 72 h, preserve T1 offline copies, obtain firm quotes and written deployment dates — do not label C3/C4 deployed.**
- **Trace:** **F015/F027**, **GAP-007/GAP-003/GAP-016**, controls **C4 $21,000/year**, **C3 $22,000/year**; storage/key integration and legal review can add **unpriced costs**.

## Decision timeline, evidence and escalation gates

| Time | Mandatory deliverable / gate | Decision authority |
|---|---|---|
| **T+0–1 h** | Declare incident posture, incident ID, clinical contact and rule that production changes require Sarah + James + clinical safety as relevant | James / Sarah |
| **T+1–4 h** | Prove SSL-VPN reachable or not; contain if exposed; document verified safe access. In parallel preserve an independent backup path. | Sarah + IT-A; IT-B on backup |
| **T+4–12 h** | Isolated NAS/copy state, initial IOC triage and last-known-good manifest; overnight brief with unknowns explicitly stated | James / Analyst |
| **T+12–16 h** | **09:00 Board meeting is ~T+14 h**; emergency funding decision for `$2,400/year` and patch-entitlement plan; risk acceptance cannot occur by silence | CEO/Board; Robert Kim |
| **T+16–36 h** | Reversible microsegmentation pilot, backup restore evidence and targeted identity containment; vendor change plan prepared | Sarah / IT-A / IT-B |
| **T+36–72 h** | Conditional FortiGate patch, single-zone pilot, staged AD crypto and immutable copy proof. Unfinished work must show blocker, owner, interim control and next authorized date | Sarah / James / clinical owners |

**Immediate incident escalation triggers:** suspicious FortiGate administrators or policy changes, confirmed unauthorized VPN sessions, unexplained KDC service-ticket patterns with correlated compromise, EHR bulk export not approved by owner, backup deletion/encryption, ransomware indicators, or clinical outage. Preserve evidence; use authorized targeted containment and safe hospital downtime procedures. A disclosed compromise invokes Maria Santos/DPO-led legal analysis; no automatic assertion of patient breach or fixed reporting deadline without facts.

**Board money statement:** 1x03's selected **C1+C2+C3+C4+C6** portfolio costs **$97,000 annualized** and estimates **$115,000 first-year cash** against the **single $120,000 six-month cash cap**; at most **$5,000 apparent headroom before reconciliation**, **not** a spendable authorization. If Finance separately approves the **$2,400 Fortinet renewal**, the arithmetic headroom would appear **$2,600**, but only if the prior cash assumptions truly apply; vendor upgrade fees, cryptographic recovery, clinical time and procurement may exceed it. The $2,400 renewal is not a component of the selected five-control budget. The **$2.8644m/year RISK-002 ALE** is an uncertain overlapping teaching scenario, not measurable 72-hour savings. No security purchase occurs in Tier 1.

## Resource Conflict Assessment — the two-operator bottleneck

| Conflict | Why it occurs | Resolution and trade-off |
|---|---|---|
| **IT-A: FortiGate isolation vs log extraction vs next-day ACL work** | All use the only skilled network operator and possibly the same appliance. | **Strict serial priority:** SSL-VPN reachability/containment first, short read-only evidence export second, microsegmentation only after a verified baseline. Analyst can handle analysis and documentation, **not privileged firewall changes**. Avoid patch+ACL modifications in the same window; do not change two fault domains simultaneously. |
| **IT-B: Backup isolation vs AD review vs recovery testing** | A single systems operator cannot safely disconnect NAS, rotate credentials and restore backups simultaneously. | **Serial priority:** prevent destruction of last usable recovery copy first; do read-only AD triage while copy verifies; test restore tomorrow; stage AES migration after gateway risk is contained and clinical maintenance approval exists. Clinical staff perform workflow acceptance, not IT-only validation. |
| **Sarah: single change authority across FortiGate/NAS/AD** | All technically risky changes seek her approval; single perimeter and no redundancy amplify consequences. | James owns incident risk and escalation; Sarah owns one production change ticket at a time with explicit clinical approval and stop/rollback gate. Board procurement decision is delegated to Finance/CEO, not waited on for Tier 1 containment. |
| **Physical NAS disconnect vs ongoing backup jobs** | Isolation prevents remote deletion but can stop new recovery points or interrupt live shared storage. | Confirm service dependencies and quiesce jobs; keep independently protected recent copy, document the backup-gap window and, if unsafe, temporarily restrict DSM/delete paths instead. Never cut clinical storage blindly. |
| **FortiGate patch vs segmentation/AD authentication changes** | Several changes can break all three hospitals, complicating attribution and rollback. | Stabilize and capture gateway baseline before any patch; make **one major gateway/network change per window**, with all-site positive tests before expanding. Schedule Kerberos only after dependency inventory and safe fallback. If staffing/vendor readiness fails, defer Tier 3 deployment with effective interim containment and signed owner, not false completion. |
| **Analyst overload / 24-hour coverage** | A single analyst cannot continuously watch logs while reporting to the 09:00 Board. | Use **timeboxed triage** (P1/AD/NAS/EHR high-value alerts), James triages high-confidence escalations and assigns temporary on-call decision coverage; keep custody log and mandatory handover. Do not imply a staffed 24/7 SOC is operating (C7 was rejected). |

### Practical shift assignment (only two IT implementers)

| Time block | Sarah Park | IT-A (network) | IT-B (systems/backup) | James / Analyst |
|---|---|---|---|---|
| T+0–4 | Authorize/verify high-risk decisions | P1 SSL-VPN check/approved containment | Preserve backups + safe NAS isolation | James commands; analyst opens ledger and correlates vendor/AD signals |
| T+4–12 | Review clinical impact and change log | Read-only FortiGate evidence / continuity test | Finish backup manifest; targeted AD audit | Deliver Board-facing known/unknown list; prepare escalation |
| T+12–36 | Controlled change windows and vendor coordination | Canary VPN/AD/EHR access restrictions | Isolated recovery test; authorized identity actions | Board budget decision; evidence and incident/legal review |
| T+36–72 | Gate each rollout and terminate unsafe changes | Vendor-approved gateway patch **or** segmentation canary per window | Kerberos canary **or** offsite-copy pilot according to readiness | Analyst monitors validated outcomes; James updates risk register and Board |

**Priority when resources collide:** **(1) patient safety and existing care continuity → (2) contain exposed SSL-VPN / preserve evidence → (3) preserve last recoverable backup → (4) stop proven compromise → (5) tested network/identity hardening → (6) longer-term procurement and rollout.** If a phase cannot be safely completed, document **deferred**, responsible owner, interim control and next decision time. Do not claim that every threat phase is blocked or every proposed control deployed at T+72.

## Verification checklist and final handoff

- [ ] FortiGate SSL-VPN listener/public reachability established, safe P1 interim containment evidenced, IPsec for three sites verified.
- [ ] Gateway and KDC/AD/NAS/EHR logs preserved with provenance; suspected compromise clearly separated from confirmed evidence.
- [ ] At least one last-known-good backup copy independently protected; restoration or tested verification evidence; PACS gap documented.
- [ ] Every change has ticket, safety sign-off, rollback, on-call owner and clinical smoke test, or a stated NO-GO.
- [ ] $2,400 renewal authorized or declined explicitly, vendor model-compatible safe firmware and path checked; **7.0.14 not mistaken for current safe endpoint**.
- [ ] C1/C2/C3/C4/C6 status **proposed vs approved vs installed vs tested** recorded separately; no fictional funded/deployed claims.
- [ ] By T+72, publish open risks, phase-level defenses with real validation, next authorized maintenance windows and patient/Legal implications.

## Traceable supporting materials

**MedDefense:** [1x05 T0 advisory analysis](0-advisory_analysis.md); [T1 CVE deep dive](1-cve_deep_dive.md); [T2 kill chain overlay](2-kill_chain_overlay.md); [1x00 GAP analysis](../1x00_first_watch/12-gap_analysis.md) and [control matrix](../1x00_first_watch/10-complete_control_matrix.md); [1x01 KC1 kill chain](../1x01_know_your_enemy/10-kill_chains.md); [1x02 triage](../1x02_the_weak_links/16-triage.md); [1x03 security strategy](../1x03_defense_blueprint/17-security_strategy.md), [budget](../1x03_defense_blueprint/8-budget_allocation.md), [risk register](../1x03_defense_blueprint/10-risk_register.md); [1x04 crypto audit](../1x04_crypto_foundation/15-crypto_posture_audit.md), [key management](../1x04_crypto_foundation/14-key_management.md).

**Independent product guidance (technical corroboration, not proof of this fictional campaign):** [Fortinet analysis of CVE-2023-27997](https://www.fortinet.com/blog/psirt-blogs/analysis-of-cve-2023-27997-and-clarifications-on-volt-typhoon-campaign); [Canadian Centre for Cyber Security SSL-VPN mitigation](https://www.cyber.gc.ca/en/alerts-advisories/vulnerability-impacting-fortigatefortios-cve-2023-27997); [NVD CVE-2024-55591](https://nvd.nist.gov/vuln/detail/CVE-2024-55591); [FortiOS 7.0.17 release notes](https://docs.fortinet.com/document/fortigate/7.0.17/fortios-release-notes/289806); [CERT-FR CVE-2023-27997 advisory](https://cert.ssi.gouv.fr/alerte/CERTFR-2023-ALE-004/).
