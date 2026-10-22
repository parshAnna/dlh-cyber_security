# Task 12 — The Legacy Systems

**Project:** MedDefense Health Systems | **Track:** Blue Team / 1x02 The Weak Links  
**Date assessed:** 22 October 2026  
**Scope:** Three systems named in the SecurePoint scan: MRI Windows XP SP3, Windows Server 2012 R2 print server, and Ubuntu 18.04 LTS billing server without ESM.

## Method and evidence limitations

Sources: `16-triage.md`, `4-exploit_hunt.md`, `../1x00_first_watch/8-criticality_assessment.md`, `../1x00_first_watch/10-complete_control_matrix.md`, and `../1x01_know_your_enemy/10-kill_chains.md`; the SecurePoint scan and NVD/vendor resources linked below. The review distinguishes **OS-specific vulnerabilities** from vulnerabilities in installed applications, and an **unsupported deployment** from an OS with absolutely no vendor security-update channel.

**NVD publication window:** 2024-10-22 through 2026-10-22 (inclusive). The executed Fedora queries used the NVD CVE 2.0 API with an exact `cpeName`, `cvssV3Severity=CRITICAL`, and `pubStartDate`/`pubEndDate` in seven non-overlapping intervals of at most 120 days. Consequently, the measured counts are **CVSS v3 Critical matches for each queried CPE**, **not** a comprehensive count of CVSS v4-only ratings, all installed-package CVEs or confirmed exploitable weaknesses on these hosts. Each interval returned successfully for all three systems; results were collected on **22 October 2026**. Historical CVEs and subsequent modifications to old CVE records do not qualify as newly published CVEs. Edition, architecture, actual patches and installed components must still be validated before declaring deployment-specific exploitability.

### NVD API results — verified query output

| System / exact CPE used | All-time NVD CVE count | New CVSS v3 Critical CVEs in specified window | Two highest qualifying examples |
|---|---:|---:|---|
| **Windows XP Embedded SP3 (x86)** — `cpe:2.3:o:microsoft:windows_xp:-:sp3:*:*:embedded:*:x86:*` | **1,087** | **0** | **None available in this window.** Historical CVE-2017-0144 and CVE-2019-0708 are not newly published 2024–2026. |
| **Windows Server 2012 R2** — `cpe:2.3:o:microsoft:windows_server_2012:-:r2:*:*:*:*:*:*` | **5,026** | **13** | **CVE-2025-55234** (SMB authentication/relay hardening exposure), **CVE-2026-72950** (RRAS remote code execution), **both NVD CVSS v3.1 9.8**; their Microsoft CNA scores are 8.8. These are representative tied highest-scoring examples, not proven exploitable on the print server. |
| **Ubuntu 18.04.6 LTS** — `cpe:2.3:o:canonical:ubuntu_linux:18.04.6:*:*:*:lts:*:*:*` | **Not queried** | **0** | **None found by this OS-CPE and CVSS-v3 query.** The count excludes many package-level vulnerabilities requiring a kernel/application inventory. |

For Windows Server 2012 R2, the seven individual interval counts were **0, 0, 1, 0, 0, 11, 1**, summing to **13**. The 13 returned IDs were: `CVE-2025-55234`, `CVE-2026-49164`, `CVE-2026-49181`, `CVE-2026-50694`, `CVE-2026-54995`, `CVE-2026-50330`, `CVE-2026-50439`, `CVE-2026-57089`, `CVE-2026-57090`, `CVE-2026-58594`, `CVE-2026-47304`, `CVE-2026-72950`, `CVE-2026-83888`. Each ID should still be checked for NVD status changes or applicability before remediation. XP and Ubuntu returned **zero in all seven intervals**, not errors or missing requests.

**Interpretation:** A zero in this precisely filtered result does **not** establish that an EOL system is safe. The pre-existing pool of exploitable vulnerabilities, attackable services, absent patches and potential CVSS v4-only/package-level records remain relevant. Conversely, a CPE-match count does not prove that a particular MedDefense host has every included vulnerability. The 2012 R2 CPE is a general identifier because the print server's edition/build is unknown.

**Reproducibility and record verification:** NVD CVE 2.0 API: <https://nvd.nist.gov/developers/vulnerabilities>. Query with `cpeName`, `cvssV3Severity=CRITICAL`, `pubStartDate` and `pubEndDate`; split the requested two years into windows of no more than 120 days, inspect each `totalResults`, and retain IDs to check for duplication. See <https://nvd.nist.gov/vuln/detail/CVE-2025-55234> and <https://nvd.nist.gov/vuln/detail/CVE-2026-72950> for the two selected 9.8 examples. Microsoft scores both at **8.8**, reflecting different metric assumptions; do not silently equate an NVD severity with the vendor's assessment.

## System 1 — Windows XP SP3 MRI controller

**Asset:** `WS-RAD-01` (`10.10.1.70`, A-016), controlling Siemens MRI (A-091) and dependent on PACS (A-038). The earlier scenario calls the controller Windows XP Embedded, whereas the scan fingerprints XP SP3; exact product/edition/build requires confirmation. **Support:** legacy Windows XP is out of normal security support and a supported vendor-certified upgrade path has not been established.

### EOL research and permanent exposure

The exact XP Embedded SP3 x86 CPE query returned **0 new CVSS v3 Critical CVEs** in the window (1,087 total CVE matches across all dates and severities). **Therefore, two qualifying recent Critical examples cannot be supplied.** The actual MRI edition and patch level remain unverified. The scan's older, important reference vulnerabilities are **CVE-2017-0144 (EternalBlue/MS17-010), CVE-2019-0708 (BlueKeep), and CVE-2008-4250 (MS08-067)**; T4 rates each **5/5** and reports CISA KEV inclusion. Their original disclosure years do not qualify as 2024–2026 publications.

An unpatched but supported system can often receive a security fix once the operator deploys it; XP has no dependable routine vendor patch stream for emerging OS vulnerabilities. Exceptionally released historical fixes or a vendor-supplied update do not restore continuous future support, so permanently acceptable risk reduction requires supported replacement or isolation and sharply restricted access, not patching alone.

### Scan findings and applicability

**Finding 004 (Critical / AC):** Windows XP and its exposed SMB/RPC/RDP attack surface, including the historical EternalBlue, BlueKeep and MS08-067 issues. Other generic Windows-workstation group findings (e.g., 019 RDP, 023 USB, 027 Sophos) should **not be attributed to this particular host** without host membership or agent evidence. Its EOL state makes sustained OS patch remediation unavailable; exploitability of each CVE still depends on installed components, actual patch level and network reachability.

### Compensating controls and gaps

**1x00 T6 — exact proposed controls (not implemented):**

| ID | Proposed control | Effect and relevant limitation |
|---|---|---|
| **CC-01** | **Enforced MRI network isolation**: dedicated zone and external deny-by-default firewall; allow only verified PACS, imaging and separately approved maintenance flows. | Most directly reduces SMB/RPC reachability and lateral movement without modifying the certified controller; allowed peers and incorrectly configured rules remain attack paths. |
| **CC-02** | **Passive monitoring with an assigned response process**: tap/SPAN/firewall telemetry, baseline traffic, alert on unusual peers/scans, assign Security/IT and Radiology responders. | Adds visibility without an on-host agent, but cannot prevent attacks and must not automatically shut down clinical operations. |
| **CC-03** | **Restricted console and removable-media access**: authorized Radiology/biomedical access, approved physical port protection and recorded service visits. | Helps against local malware introduction and unauthorized maintenance; does not prevent network exploits and must respect MRI safety. |
| **CC-04** | **Controlled vendor maintenance and recovery readiness**: approved/supervised time-limited vendor access, custody of vendor recovery media, recovery rehearsal and clinically approved downtime procedure. | Constrains trusted access and supports restoration; uncertain manufacturer support and untested recovery preserve residual risk. |

**Coverage assessment:** CC-01 best addresses the scan's SMB/RPC exposure (Finding 004) and lateral movement, while CC-02 adds attempted-exploitation detection and CC-03/CC-04 cover local or maintenance-related paths. **None of the four patches the underlying XP flaws or provides a fully supported replacement**, and all remain *proposed* according to 1x00 T6. CC-01 must be tested with Radiology and biomedical engineering to preserve PACS study delivery, maintenance access and rollback.

**Additional safeguards:** implement and verify CC-01–CC-04; where the vendor permits, add a time-limited MFA-protected management jump path, explicitly block unnecessary SMBv1/RDP/RPC at the external network boundary, and restrict any browsing or removable-media workflows through approved operating procedures. Test approved image transfer and safe rollback before enforcing changes. These reduce exposure but cannot remove the unsupported OS's latent flaws.

**Residual risk:** **Critical** pending vendor-certified replacement and validated isolation. In 1x00 G2 (PACS and diagnostic imaging), the category is C **High**, I **Critical**, A **Critical**; MRI processes approximately 45 studies/day. KC3 (radiology phish → PACS extortion) is relevant as an adjacent lateral-movement route, not proof that this controller appears literally in every chain step.

## System 2 — Windows Server 2012 R2 print server

**Asset:** `print-srv-01` (`10.10.2.31`, A-043), Windows Server 2012/2012 R2 according to different project observations; verify the precise edition/build. Standard Windows Server 2012/R2 support ended in October 2023; eligibility for paid Extended Security Updates (ESU) must be verified rather than assumed absent.

### EOL research and permanent exposure

The selected general 2012 R2 CPE yielded **13 newly published CVSS v3 Critical CVEs** from 2024-10-22 through 2026-10-22. Two representative NVD 9.8 examples are **CVE-2025-55234** (SMB relay/hardening-related privilege escalation, published September 2025; requires relevant authentication/security configuration) and **CVE-2026-72950** (RRAS remote code execution, published September 2026; the RRAS role is **not shown as installed** on `print-srv-01`). Microsoft assigns each an **8.8 High** CVSS v3.1 base score; the NVD 9.8 classification reflects a different metric vector. These CPE associations do not establish successful exploitation on the actual host. The scan instead identifies the older **CVE-2021-34527 (PrintNightmare)**, CVSS 8.8 in the MedDefense scan, not a newly published CVE within the requested two years. NVD searches must distinguish new publication from updates to old entries and from results for later Windows Server releases.

Leaving standard support means security updates are no longer delivered through the normal supported lifecycle; paid ESU coverage, if purchased and applicable, is a limited temporary bridge, not a permanent replacement strategy. Patching PrintNightmare alone does not fix the broader unsupported OS, excessive spooler exposure or future unsupported components.

### Scan findings and applicability

**Finding 008 (High in scan, AC in T16):** end-of-life Server 2012 R2, exposed Windows Print Spooler and CVE-2021-34527/PrintNightmare-family privilege escalation and code-execution risk. No other numbered scan finding is directly assigned to `10.10.2.31` in T16. EOL worsens long-term patch coverage; the 2021 PrintNightmare vulnerability itself did have vendor patches, so do **not** claim it is exploitable *solely* because this OS is EOL.

### Compensating controls and gaps

Existing C-003 filters traffic that crosses the FortiGate; C-034/C-038 provide weak local/reactive Windows event review. Windows account policies C-013–C-015 are not verified per print host, and Sophos C-017–C-021 does **not** document server coverage. No tested print-spooler restriction, server EDR, or East–West traffic segmentation is evidenced.

**Recommended:** disable spooler where not necessary; restrict RPC/SMB/printing to approved client and administrator subnets; remove unnecessary printer-driver installation and Point-and-Print privileges; validate vendor patches/ESU status; monitor spooler service, driver installation and privileged logons; add supported server EDR; back up print configurations; migrate to a supported print service and retire the old host. **Residual risk: High**, potentially Critical if lateral movement to AD or sensitive services is demonstrated. The G7 category is C/I/A **High**, but the original 1x00 assessment explicitly cautions that an individual routine print outage may have lower impact.

## System 3 — Ubuntu 18.04 LTS without ESM on billing server

**Asset:** `billing-srv-01` (`10.10.2.15`, A-039), including the billing web application and MySQL financial data (A-113/A-123). Ubuntu 18.04 standard security maintenance ended May 2023. **Important qualification:** Ubuntu 18.04 still has Canonical **Ubuntu Pro/Expanded Security Maintenance through May 2028**, but the MedDefense scan reports **no active ESM subscription**. Therefore the **deployment** lacks a supported patch stream, not that patches for every Ubuntu 18.04 vulnerability are forever impossible.

### EOL research and permanent exposure

The query for the Ubuntu 18.04.6 LTS **OS-level CPE returned 0 newly published CVSS v3 Critical CVEs** in the requested interval, so **there are no two qualifying CVEs to name from that result**. This is a narrow OS-CPE result, not a comprehensive Ubuntu vulnerability count. Ubuntu's exposure is package-specific: record the actual installed kernel and vulnerable package builds and check Ubuntu Security Notices/OSV/NVD CPE matches rather than counting every vulnerability mentioning Linux or Ubuntu. The scan reports **47 kernel CVEs** for an outdated `4.15.0-213-generic` kernel, but **47 is a scanner count, not the requested 2024–2026 Critical-only NVD count**.

An ordinary delayed update leaves an available patch unapplied; the current billing deployment lacks standard support and has not enrolled in ESM, so future security fixes may never reach it through its existing repositories. Unlike fully unsupported XP, enabling eligible Ubuntu Pro/ESM can restore some coverage as a **temporary risk-reduction bridge**, but cannot replace upgrading to a currently supported OS and maintaining Apache, MySQL and the application.

### Scan findings and applicability

- **001 (Critical / AC):** Apache `mod_lua` CVE-2021-44790, reported CVSS 9.8, conditional on module/configuration exposure; T4 exploitability **4/5**, KEV **No**.
- **002 (Critical / AC):** Apache CVE-2019-0211 local privilege escalation; T4 **5/5**, KEV **Yes**. Requires an existing lower-privileged execution position, potentially supplied by 001.
- **006 (High / AS):** MySQL listens on `0.0.0.0`, allowing unnecessary broad connection attempts.
- **009 (High / AS):** SSH password authentication without account lockout.
- **011 (Medium / AS):** Ubuntu 18.04 without active ESM.
- **026 (Low / AS):** outdated Linux kernel with scanner-reported CVE exposure.

None of 001, 002, 006, or 009 is caused exclusively by EOL: application flaws and insecure configurations can affect supported machines too. EOL/no ESM chiefly blocks routine, reliable remediation and extends the attacker's exploitation window; the kernel (026) is most directly tied to the old OS maintenance baseline.

### Compensating controls and gaps

Existing C-003 boundary filtering, C-035/C-036 weak Linux/Apache local logs, C-022 weak local backups, C-047 temporary service restarts and C-048 ad hoc billing response are insufficient. C-051 records password-based SSH on Linux servers; Sophos C-017–C-021 is not established on this Linux server. Perimeter ACLs do not prove MySQL isolation on the flat internal network.

**Recommended:** isolate the billing server from clinical subnets; close MySQL 3306 to all but validated application hosts; restrict Apache to required routes; disable unnecessary `mod_lua` functionality or remediate the vulnerable package; use SSH keys and a restricted admin jump path; investigate and eradicate the already observed mining process before restoring service; enable ESM where contractually and technically eligible as an interim measure; patch/rebuild Apache, OS kernel and database; move the application to supported Ubuntu LTS with regression testing; deploy server EDR and central log alerting; test clean isolated backups and recovery. **Residual risk: Critical operational remediation priority.** G3 billing is C/I/A **High**, and historical incident evidence reports interrupted claims processing and active mining; KC1-like ransomware movement is a plausible continuation after foothold, not an explicitly documented billing step in KC1.

## Business decision — migrate ONE system next quarter

**Choose: System 1, the Windows XP MRI controller (`10.10.1.70`), subject to clinical/vendor-certified migration feasibility.** Its asset group has **Critical integrity and availability** because compromised or unavailable imaging can delay or misdirect diagnosis; its controller is tied to the 45-studies/day PACS workflow. It has multiple historically exploited remote-protocol vulnerabilities, a difficult-to-patch legacy platform, and no demonstrated medical VLAN, making a compromised radiology workstation a plausible pivot toward KC3 (phishing → PACS extortion). A replacement must preserve MRI safety, certification, vendor compatibility and clinical downtime planning; replacing the OS informally on the controller could be unsafe.

**Second priority:** Ubuntu billing, because a reachable Apache RCE + LPE chain, weak MySQL/SSH boundaries, and an already observed miner suggest urgent compromise/containment. Its migration should be planned next, but immediate incident investigation, containment, configuration fixes and **Ubuntu Pro/ESM where eligible** can improve risk before an OS migration. **Third:** Windows print server, with immediate spooler restrictions and supported patch/ESU validation while print services are migrated. This is a budgeted **migration order**, not permission to defer immediate containment on billing or print.

| Rank for funded migration | System | Patient-care consequence | Threat/attack-path evidence | Near-term non-migration action |
|---:|---|---|---|---|
| **1** | XP MRI | **Critical** imaging integrity/availability | Legacy SMB/RDP, T4 KEV vulnerabilities; KC3 adjacency | Vendor-coordinated medical VLAN / approved access allowlist |
| **2** | Ubuntu 18.04 billing | High direct business impact; Critical chained security urgency | Findings 001+002, 006/009, miner, reachable flat network | Contain/eradicate miner, close unnecessary access, consider ESM |
| **3** | Server 2012 R2 print | Lower direct clinical criticality, meaningful domain lateral-movement risk | Finding 008 / PrintNightmare, spooler | Restrict spooler, validate patch/ESU, monitor admin actions |

## Evidence required before sign-off

1. **Completed:** executed seven date-bounded NVD CVE API queries per queried OS CPE with CVSS v3 Critical filter; counted **XP 0 / Windows Server 2012 R2 13 / Ubuntu 0**, and recorded two Windows Server 9.8 examples. **Still required before asserting host-level exposure:** confirm build, CPE coverage, package-specific Ubuntu findings and CVSS-v4-only exclusions.
2. **Completed:** cross-checked MRI CC-01–CC-04 against `../1x00_first_watch/6-compensating_controls.md`; obtain implementation evidence before counting them as active controls.
3. Confirm exact OS editions/builds, XP patches and exposed ports, Windows Server ESU/patch status, Ubuntu Pro status and package inventory, and the MRI vendor-approved upgrade path.
4. Verify clinical and business owners accept the migration sequencing and interim residual risks; prioritize active containment independently of capital-spending decisions.

## References

- NVD Vulnerability Search: https://nvd.nist.gov/vuln/search
- NVD API guidance: https://nvd.nist.gov/developers/vulnerabilities
- NVD CVE-2025-55234 (SMB relay): https://nvd.nist.gov/vuln/detail/CVE-2025-55234
- NVD CVE-2026-72950 (RRAS RCE): https://nvd.nist.gov/vuln/detail/CVE-2026-72950
- Ubuntu Pro/ESM support schedule: https://ubuntu.com/security/esm and https://ubuntu.com/about/release-cycle
- Microsoft lifecycle / ESU: https://learn.microsoft.com/en-us/lifecycle/products/windows-server-2012-r2
- MedDefense: `16-triage.md`, `4-exploit_hunt.md`, 1x00 Tasks 6/8/10, 1x01 Task 10, and SecurePoint scan.
