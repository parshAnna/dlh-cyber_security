# MedDefense Health Systems — Task 23: The Validation Plan

**Prepared for:** James Chen, Deputy CISO  
**Prepared by:** Junior Security Analyst  
**Assessment date:** 22 October 2026  
**Scope:** Blue Team / 1x02 The Weak Links — post-remediation verification and ongoing vulnerability management

## 1. Scope, baseline and acceptance rules

Task 20 designated **six findings** for Immediate (24–48-hour) action: **031, 003, 004, 010, 001 and 008**. This task requests validation of **three** Immediate actions. Accordingly, this plan selects the first three in the T16 priority order, **031 (EHR AJP), 003 (EHR database access), and 004 (legacy MRI isolation)**, consistent with the three actions presented in Task 22. Findings 010, 001 and 008 remain Immediate and require their own equivalent verification tickets; omission from the three detailed examples does **not** imply closure or downgrading.

**Evidence baseline:** SecurePoint's 31-finding scan; `16-triage.md`; `17-cvss_contextualizer.md`; `22-patch_briefing.md`; `../1x00_first_watch/6-compensating_controls.md`, `8-criticality_assessment.md`, and `10-complete_control_matrix.md`; `../1x01_know_your_enemy/10-kill_chains.md`. The controls in MRI Task 6 (CC-01–CC-04) are **proposed, not proven deployed**. The scan's version-to-CVE assertions must be checked against installed builds and vendor advisories before declaring a software flaw fixed.

**Definition of verified closure:** (a) an approved change with owner, timestamp, baseline, and rollback plan; (b) configuration/package evidence showing the intended control exists; (c) **negative security test** showing the unauthorized path is blocked; (d) **positive business-function test** showing care services still work; (e) an independently reviewed targeted rescan or configuration audit; and (f) a ticket containing evidence, residual risk, and a sign-off. A changed banner, patch-install success message, or cleared scanner alert **alone is not proof**. If either security or clinical acceptance fails, reopen the finding, apply safe rollback or isolation, and escalate to James Chen; record accepted exceptions with an expiry and monitoring owner.

## 2. Post-remediation verification — three Immediate actions (24–48 hours)

### Finding 031 — EHR AJP connector / Ghostcat allegation

- **Asset and exposure:** `ehr-srv-01` (`10.10.2.10`), TCP **8009**. Scan confirms that the AJP connector listens; it does **not** independently prove exploitation of CVE-2020-1938. The reported Tomcat **9.0.31** is the fixed upstream version for Ghostcat, so validate the exact installed package/build rather than treating port exposure as proof of an unpatched CVE. The business concern is unauthorized access to sensitive EHR configuration or credentials and subsequent movement to patient records (KC5).
- **Expected remediation:** IT Ops and the EHR vendor confirm whether AJP is required. Disable the connector if unnecessary; otherwise restrict **source addresses and destination port 8009** to explicitly approved application peers, verify the Tomcat build/advisory, and preserve normal EHR functions. No blind upgrade or disruptive testing on production.
- **How to verify (Security Analyst + IT Ops):** Save the approved AJP configuration, package/build/version evidence, service inventory, and firewall/ACL change. From a designated **unauthorized test host**, check that TCP 8009 is unreachable/filtered; from an approved peer, verify only the documented required connection, **if** AJP must remain enabled. Run a targeted, non-exploit rescan of `10.10.2.10:8009`; compare with the pre-change scan and host listener/firewall evidence. Have the EHR application owner test authentication, patient-record viewing and updates using synthetic/test records and review application errors and logs.
- **Pass / failure / evidence:** **Pass** if unused AJP is off (no listener), or needed AJP is accessible **only** from approved peers; build/advisory applicability is resolved; EHR workflows pass; and an independent reviewer signs the evidence. **Fail** if the port remains broadly reachable, a claimed CVE persists on a genuinely vulnerable build, or clinical transactions fail. Store pre/post port results, sanitized configuration diff, build inventory, EHR test record, ticket and vendor sign-off. Do not claim the vulnerability was patched solely because the connector was firewalled.

### Finding 003 — PostgreSQL permits broadly sourced EHR database connections

- **Asset and exposure:** `ehr-db-01` (`10.10.2.11`), PostgreSQL TCP **5432**. Scan reports `listen_addresses='*'` and `pg_hba.conf` allowing `10.10.0.0/16` with **MD5 authentication**. This is excessive reachability, **not** proof of password-free access. Patient data ranks highest in the asset assessment; KC5 could exploit a stolen legitimate database credential.
- **Expected remediation:** After recording verified application, administrative and vendor dependencies, IT Ops/database owner narrow host-based PostgreSQL rules and network ACLs to **specific required sources and roles**; deny unrelated source networks and use least privilege. Apply changes with a pre-approved rollback plan; avoid disrupting the EHR application's database path.
- **How to verify (Security Analyst + Database Administrator):** Inspect effective `pg_hba.conf`, `listen_addresses`, the service reload status, network ACLs and relevant listening services. From an **authorized EHR application peer**, confirm the expected account can complete a safe test query/transaction. From a **non-approved internal test host**, confirm that a test connection to TCP 5432 is blocked at the boundary or rejected by PostgreSQL before authentication. Use a controlled targeted rescan and verify server/firewall log entries for both outcomes. Check that no overly broad fallback rule restores `/16` access and that privileged/vendor paths have explicit approval.
- **Pass / failure / evidence:** **Pass** if approved EHR source traffic works, unrelated source traffic cannot establish database access, least-privilege rules and effective configuration agree, and synthetic-record EHR read/write and application health checks succeed. **Fail** if a non-approved source still reaches an unrestricted login path or clinical application transactions break. Retain redacted rules, approved source list, connection tests, PostgreSQL/ACL logs, change ticket and DBA/EHR-owner sign-off. A narrower `pg_hba.conf` entry alone is insufficient if an earlier permissive rule remains active.

### Finding 004 — Windows XP MRI control workstation: containment, not patch closure

- **Asset and exposure:** `WS-RAD-01` (`10.10.1.70`), legacy **Windows XP Embedded/SP3** MRI controller with RPC/NetBIOS/SMB services (**135/139/445**) and required image-transfer dependency on `pacs-srv-01` (`10.10.2.12`). The scanner associates EternalBlue/BlueKeep/MS08-067 risks with the host, but individual exploit compatibility and patch state require confirmation. The unsupported controller cannot be routinely OS-patched within the scenario; approximately **45 MRI studies/day** depend on it (G2, KC3).
- **Expected remediation:** Implement proposed **CC-01**, an **externally enforced**, default-deny MRI segment/firewall boundary. Allow only vendor/Radiology-validated PACS, approved management and other essential clinical flows; block unrelated workstations, unnecessary SMB/RPC and arbitrary outbound paths. Preserve certified controller configuration and do not run intrusive scans, exploit payloads or unsupervised changes against the medical device.
- **How to verify (Security Analyst + Network Ops + Biomedical/Vendor):** Record firewall policy, approved flow matrix and boundary placement. Validate on the **network equipment** that traffic from an unrelated staff VLAN to the controller's unnecessary services is denied and logged; do not stress the live MRI with attack probes. Using a **vendor-approved supervised clinical test**, prove transfer of a test MRI study to PACS, image visibility, required device operation and authorized maintenance access. Verify unauthorized outbound destinations are denied, and check the boundary rule counters/logs. Test rollback and clinical downtime escalation in a scheduled window.
- **Pass / failure / evidence:** **Pass** if only approved clinical flows cross the enforcement boundary, negative segmentation tests are denied, PACS exchange and required MRI functions work, and Radiology/Biomedical and the vendor sign off. **Fail** if the workstation remains broadly reachable or clinical transfers fail. Capture redacted rules, permitted/denied flow logs, PACS receipt evidence, safety checklist and rollback result. Mark the vulnerability **"Mitigated by compensating control — residual EOL risk remains"**, never "patched".

## 3. Validate compensating controls — MRI and medical IoT

| Control / population | Safe validation test | Evidence and acceptance | Cadence / owner |
|---|---|---|---|
| **MRI CC-01 — network isolation** | Review actual enforcement rules; run source-to-destination deny/allow tests on boundary and perform vendor-supervised PACS workflow test | All undesired routes denied, permitted DICOM/maintenance works; rule log and clinical sign-off | At implementation, each relevant change, quarterly; Network Ops + Biomedical |
| **MRI CC-02 — passive monitoring** | Replay benign/simulated alert signals in detection system or a test network; verify approved-traffic baseline and escalation workflow | Alert appears with source/time; assigned Security Analyst acknowledges and Radiology receives escalation; no agent on MRI | Monthly alert drill, weekly telemetry-health check; Security Analyst |
| **MRI CC-03 — console/media restrictions** | Inspect authorized access list, service visitor register and approved port/media handling without obstructing MRI safety | No unauthorized access path; escorted vendor visits and maintenance media inventory documented | Monthly physical audit and each visit; Biomedical + Facilities |
| **MRI CC-04 — vendor maintenance/recovery** | Audit time-limited maintenance authorization, named vendor identity, session records; vendor-supervised recovery tabletop or non-production restore | Approved access only, usable recovery media/instructions, escalation contact and tested rollback/downtime process | Per visit; quarterly tabletop; Biomedical + Vendor |
| **BD Alaris infusion pumps (A-061–A-067 / inventory reconciliation)** | Inventory firmware and authorized management origins; review medical-device segmentation/ACLs; confirm authentication hardening and approved configuration baseline **offline or on a vendor-approved test device** | Only documented biomedical management sources allowed; no default/shared admin credentials where safely verifiable; approved settings and audit trail intact; clinical operation checked | At change, monthly rule/telemetry audit, quarterly vendor review; Biomedical + Vendor |
| **Philips IntelliVue monitors / clinical IoT** | Compare inventory with allowed HL7/web-service peers; check ACL denials using network controls and synthetic/test devices; inspect monitoring alerts | Unnecessary network paths blocked, permitted clinical telemetry flows remain available and incident alerts reach owner | At change and quarterly; Network Ops + Biomedical + Security Analyst |

**Medical-device safety rule:** Do not use exploit demonstrations, unauthorised credential attempts, aggressive network scanning, forced sessions, firmware changes or unplug/reboot tests on active bedside devices. The medical-device vendor and clinical owner must approve method, maintenance window, contingency plan and acceptance conditions. Where a test cannot safely be run, use firewall-config review, passive capture, vendor evidence or a lab device; explicitly record the resulting assurance gap. The baseline 1x00 control matrix identifies medical IoT as **under-protected**; none of the proposed measures is credited as deployed without evidence. Firmware/CVE applicability (including Alaris) must be checked against the actual installed version and vendor bulletin before asserting a patch need.

## 4. Rescan and validation schedule

| When | Activity | Why / operational limitation | Accountable owner |
|---|---|---|---|
| **Within 24 hours of a critical remediation** | Targeted safe rescan/configuration check and positive clinical service test; close only when both pass | Rapid detection of ineffective fixes; T16 Immediate exposure has a 24–48-hour action window | Security Analyst verifies; IT Ops/Vendor fixes |
| **Every week** | Authenticated or credentialed vulnerability checks for high-value **supported IT servers**; review overdue tickets and scanner coverage | EHR, AD, billing, web and backup services are exposed through internal trust paths | Security Analyst + IT Ops |
| **Every month** | Complete approved, authenticated IT vulnerability scan at all sites; reconcile live assets with registry and scan exclusions | Discover new weaknesses, drift, unmanaged hosts, expired exceptions and missing endpoint coverage | Security Analyst; asset owners |
| **After a significant change/new critical advisory** | Event-driven narrow rescan following vendor notice, firewall change, patch, new host, exposure change or incident | A fixed calendar cannot capture a newly exploited issue quickly enough | Security Analyst + relevant owner |
| **Quarterly** | Review segmentation negative/positive controls, clinical IoT coverage, management paths, documented exceptions and recovery exercises | Test sustained effectiveness beyond one passing post-change scan | Security + Network Ops + Biomedical + Management |
| **Medical equipment continuously/periodically** | Passive traffic/asset monitoring and **vendor-authorized** targeted checks; no intrusive production scanning | Protect patients and preserve certification/availability | Biomedical + Vendor + Security |

**Decision SLAs:** Immediate (T16 AC) should receive containment/remediation work within **24–48 hours** with same-window or next-day verification. Standard (T16 AS) is planned within **7–30 days**, shortened if KEV, reachable attack paths, clinical risk or exploitation evidence escalates it. If validation is unsafe or blocked by vendor constraints, keep the finding **Open/Mitigated**, log compensating controls and an agreed decision date; never auto-close because a patch was scheduled.

## 5. Continuous vulnerability intelligence and response

1. **Daily ingestion / Security Analyst:** Retrieve and diff the official [CISA Known Exploited Vulnerabilities catalog](https://www.cisa.gov/known-exploited-vulnerabilities-catalog) and its published [JSON feed](https://www.cisa.gov/sites/default/files/feeds/known_exploited_vulnerabilities.json); subscribe to NVD CVE updates and security bulletins from Microsoft, Canonical/Ubuntu, Apache Tomcat/HTTP Server, PostgreSQL, Fortinet, BD Alaris, Siemens and Philips. Use a timestamped feed snapshot and retain source links, affected versions, severity, published exploitation evidence and vendor fixes.
2. **Match and verify / Security Analyst + asset owner:** Join CVE/product/version information to the asset registry and installed software/firmware. Separate **confirmed affected, potentially affected, fixed, not applicable, and unknown**; vendor bulletins take precedence over superficial version banner matching where the build differs. A KEV listing proves exploitation somewhere, not vulnerability on this particular MedDefense host.
3. **Risk-based escalation / Security Analyst:** When a new KEV matches an exposed asset, or vendor evidence identifies urgent clinical harm, open or raise a ticket immediately; consider the asset's CIA category, KC1–KC5 pathways, exploit availability, segmentation and existing controls. Page IT Ops, Biomedical/Vendor and James Chen for critical patient-care or PHI exposure; do not apply arbitrary CVSS point boosts.
4. **Remediate and verify / IT Ops or Vendor + Security:** Assign technical owner and a feasible change window, choose vendor-supported patch or approved compensating isolation, perform negative/positive tests, rerun targeted verification, and record outcomes. If patching is impossible (legacy MRI), document residual risk, exception owner, expiry and migration decision instead of claiming closure.
5. **Management visibility / James Chen:** Review critical unvalidated changes and overdue high-risk items daily; receive a weekly dashboard showing **new KEV matches, exposed critical assets, confirmed fixes, failed validations, overdue SLAs, EOL exceptions and inventory coverage**. Reopen validated findings if a later scan detects recurrence or configuration drift.

**Governance:** CISA KEV is an important risk input; federal-agency KEV deadlines are **not assumed automatically binding on a Luxembourg healthcare organization**. MedDefense uses its own documented internal 24–48h / 7–30d targets, adapted to patient safety and vendor-approved change windows. This process follows NIST's principle that enterprise patch management includes verifying installation, not just deploying a package.

## 6. Lifecycle diagram — responsibility and evidence

```text
Scan (Security Analyst; IT Ops/Biomedical supply asset access)
  -> Triage (Security Analyst; Vendor validates disputed CVEs)
  -> Prioritize (Security Analyst recommends; James Chen approves risk/SLAs)
  -> Remediate (IT Ops/Network Ops or Biomedical + approved Vendor)
  -> Validate (Security Analyst independently tests; clinical owner signs off)
  -> Repeat (Security Analyst schedules rescans/feeds; Management reviews trends)
         ^______________________ reopen on failure/drift ______________|
```

| Stage | Responsible / accountable | Output required to proceed |
|---|---|---|
| **Scan** | Security Analyst runs approved IT scans/passive IoT discovery; IT Ops and Biomedical provide scope | Dated findings, affected host/service, scan configuration, exclusions, discovery-to-inventory reconciliation |
| **Triage** | Security Analyst; Vendor/IT Ops confirm affected version and configuration | Validated CVE/applicability, false-positive rationale, duplicate links, business impact |
| **Prioritize** | Security Analyst proposes; **James Chen/Management** accepts deadline and risk exception; clinical leads advise | AC/AS priority, CIA asset, kill-chain role, KEV, owner, mitigation plan and SLA |
| **Remediate** | IT Ops/Network Ops for supported IT; **Biomedical and Vendor** for medical technology | Approved change record, snapshot/config diff, maintenance and rollback plan, completion evidence |
| **Validate** | **Security Analyst** independently verifies; DBA/EHR/Radiology/Biomedical owners sign functional acceptance; Management accepts any residual risk | Negative exposure test, positive service test, targeted rescan, logs, sign-offs, final status **Verified/Mitigated/Open** |
| **Repeat** | Security Analyst runs feeds/rescans; IT Ops tracks drift; James Chen reviews report | Updated register, new tickets, reopened failures, overdue items and trend dashboard |

## 7. Audit record / definition-of-done template

For each finding, retain: **finding ID; CVE and affected build (or misconfiguration); asset/IP/owner; baseline evidence; work order/change ID; patch/ACL or mitigation details; change date/time; test source and method; negative security result; positive clinical/application result; post-change scan ID/time; deviations; vendor approval where necessary; residual risk/expiry; independent Security Analyst approval; clinical owner and management approval for exceptions; next recheck date.** Redact passwords, patient identifiers and proprietary medical configuration from shared reports.

## References

- Project evidence: `16-triage.md`, `17-cvss_contextualizer.md`, `22-patch_briefing.md`; 1x00 Tasks 6, 8 and 10; 1x01 Task 10; SecurePoint scan. Task 20's full file should be checked for final cross-reference to exact Immediate item titles, while its previously documented six-item Immediate set is distinguished above from the three examples requested here.
- [CISA — Known Exploited Vulnerabilities Catalog](https://www.cisa.gov/known-exploited-vulnerabilities-catalog).
- [NIST SP 800-40 Rev. 4 — Guide to Enterprise Patch Management Planning](https://csrc.nist.gov/pubs/sp/800/40/r4/final).
