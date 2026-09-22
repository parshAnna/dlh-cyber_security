# MedDefense Health Systems — Vulnerability Scan First Impressions

**Document status:** Initial triage summary; no individual CVE or exploit research performed

**Primary source:** SecurePoint Consulting, [*MedDefense Vulnerability Scan Report*](https://s3.eu-west-3.amazonaws.com/hbtn.intranet/uploads/text/2026/3/3d9524922b7e610ce212603cb9f59167c5926948.txt)

**Cross-reference:** [Project 1x00 Task 7 Asset Registry](../1x00_first_watch/7-asset_registry.md)

## 1. Scan Metadata

| Field | Reported scope or value |
|---|---|
| Scanner | OpenVAS 22.x, Greenbone Community Edition |
| Scan date | Five days before the report's stated current date; the supplied report does not provide an absolute calendar date |
| Scan window | 02:00–06:00 during off-peak hours |
| Target | `10.10.0.0/16`, described as all internal subnets |
| Responsive hosts scanned | 47; this is a scan-window response count, not a complete asset-inventory count |
| Scan policy | Full and Deep; authenticated where credentials were available |
| Authentication | Linux servers were assessed through SSH and Windows systems through domain credentials where available; medical devices were scanned without credentials |
| Requested by | James Chen, Deputy CISO |
| Executed by | SecurePoint Consulting, a third party |
| Test method | Version detection, configuration analysis and authenticated checks; no active exploitation was attempted |
| Stated quality caveat | OpenVAS false-positive rate in this configuration is estimated at 5–10%; manual verification is recommended for high-value findings |
| Explicit exclusions | Microsoft 365/O365 cloud services, mobile devices such as iPads and any assets offline during the scan window |

The report therefore describes a time-bounded internal-network snapshot. “Full and Deep” does not mean that every MedDefense asset or every vulnerability class was tested.

## 2. Finding Distribution

| Severity | Findings | Share of 31 |
|---|---:|---:|
| Critical | 4 | 12.9% |
| High | 7 | 22.6% |
| Medium | 11 | 35.5% |
| Low | 5 | 16.1% |
| Informational | 4 | 12.9% |
| **Total** | **31** | **100.0%** |

**Medium is the largest severity group, with 11 of 31 findings (35.5%).** Critical and High findings together account for 11 findings, also 35.5% of the report.

## 3. Asset Heat Map

The count below treats each numbered finding as one occurrence for every host expressly named or included by the report's `Host` field. A fleet-level finding can therefore affect many hosts, while several CVEs bundled into one finding still count as one finding. This method measures report concentration rather than unique CVEs or unique vulnerable instances.

| Rank | Host | Asset Registry role | Finding count | Finding IDs |
|---:|---|---|---:|---|
| 1 | `billing-srv-01` (`10.10.2.15`) | **A-039** — Central billing/claims server running Apache and MySQL | 6 | 001, 002, 006, 009, 011, 026 |
| 2= | `ehr-srv-01` (`10.10.2.10`) | **A-036** — Central EHR application server | 4 | 017, 022, 030, 031 |
| 2= | `web-srv-01` (`10.10.2.50`) | **A-046** — website and patient-portal server | 4 | 005, 012, 013, 021 |
| 4 | `ad-dc-01` (`10.10.2.20`) | **A-040** — primary Active Directory domain controller providing directory, authentication and DNS services | 3 | 007, 018, 025 |
| 5= | `WS-RECEPT-01` (`10.10.1.10`) | **A-001** — Central reception workstation | 2 | 019, 027 |

Fifth place is not unique. `WS-RECEPT-01` is shown as a representative host because it is explicitly included in the RDP group in Finding 019 and in the all-Windows-workstations group in Finding 027. Other identified Windows endpoints included in two group findings tie at two occurrences, including RDP-enabled administrative workstations and nurse-station endpoints affected by both the USB-control and endpoint-protection status findings. Finding 027 does **not** identify which individual endpoints are among the 15 inactive or non-reporting Sophos agents, so that condition must not be attributed to `WS-RECEPT-01` without endpoint-level evidence.

## 4. First Observations

1. **Critical risk is partly concentrated but not isolated to one host.** Findings 001 and 002 place two of the four Critical findings on `billing-srv-01`; Finding 003 affects `ehr-db-01`, and Finding 004 affects the MRI control workstation. The Critical set therefore spans three hosts and the financial, patient-data and clinical-imaging functions.
2. **Several findings form obvious chains or share a root condition.** The report explicitly links Finding 001's remote code execution to Finding 002's local privilege escalation on the billing server. Findings 011 and 026 also reflect the same unsupported Ubuntu 18.04 patching condition, while Findings 006 and 009 add database and remote-administration exposure on that host.
3. **The EHR findings show progression from identification to confirmation.** Finding 017 exposes the Tomcat version and flags the AJP connector as unconfirmed; SecurePoint then manually verifies the connector and records Ghostcat as Finding 031. Separately, Finding 003 makes the EHR database reachable from the whole internal `/16`, so application-tier credential exposure and direct database reachability are related concerns even though they are separate findings.
4. **The flat network repeatedly increases the significance of otherwise local or internal weaknesses.** Broad PostgreSQL and MySQL access, reachable LDAP, medical-device interfaces, RDP, the Westside VPN endpoint and unsegmented MRI and IoT systems all assume that an attacker has first obtained an internal foothold. Once that occurs, the report describes few network barriers between the foothold and sensitive services.
5. **Severity labels do not map cleanly to CVSS values or CVE presence.** Finding 003 is Critical without a CVE because it exposes the patient database, while Finding 020 has a 9.8 base score but is rated Medium and is explicitly identified as a possible false positive because exploitation requires specific `ssh-agent` forwarding conditions. End-of-life status, unsafe architecture and misconfiguration are therefore material even when no single CVE score exists.
6. **Thirty-one finding records understate the affected-device population.** One High finding covers seven infusion pumps, one Medium finding covers 13 patient monitors, and a Low finding reports approximately 280 clinical endpoints without USB restrictions. Conversely, one record can bundle several vulnerabilities, as shown by the MRI workstation finding.
7. **Informational does not necessarily mean harmless.** The two undocumented Linux hosts expose administrative or development interfaces; the Westside device is also reported with an old Grafana version and a publicly available attack path. Their ownership and purpose must be established before their risk can be judged.

These are first-pass relationships visible in the scan report itself. They are not conclusions about exploit reliability, current vendor status or remediation priority.

## 5. Scan Limitations

- **Incomplete asset coverage:** only 47 hosts responsive between 02:00 and 06:00 were scanned. Offline, sleeping, intermittently connected or nonresponsive assets are absent, and the report does not provide a list of expected hosts that failed to respond.
- **Explicit platform exclusions:** O365 and iPads were not assessed. The internal `10.10.0.0/16` target also does not establish the security of cloud configurations, mobile applications or MedDefense's internet-facing perimeter and upstream services.
- **Uneven authentication depth:** authenticated checks were used only where credentials were available, and medical devices were unauthenticated. The report does not enumerate the exact credential level achieved on every host, so a clean result cannot be interpreted uniformly across systems.
- **No exploitation validation:** SecurePoint did not actively exploit findings. Version matching, service banners and configuration checks can produce both false positives and false negatives; the report itself estimates a 5–10% false-positive rate.
- **Limited application assurance:** the scan does not demonstrate source-code review, dependency/SBOM analysis, authenticated business-workflow testing, API authorization testing or detection of logic flaws such as IDOR. It also cannot establish the absence of zero-days.
- **Threats outside a vulnerability scanner's reach:** phishing, social engineering, malicious use of legitimate access, physical compromise and most supply-chain governance failures are not tested by this scan.
- **Incomplete infrastructure visibility:** the Asset Registry includes switches, the FortiGate, VMware hosts, additional medical equipment, cloud services and other physical or logical assets that are not individually evidenced in the report. Their absence may reflect scope, responsiveness or identification limitations and must not be interpreted as proof that they are secure.
- **No historical or continuous view:** the report is one snapshot. It does not show when each weakness first appeared, whether exploitation occurred, whether configurations changed after the scan or what vulnerabilities were disclosed later.
- **No complete risk decision:** the scanner provides technical evidence and preliminary severity labels but not business impact, clinical constraints, threat-actor relevance, attack-path position, remediation effort or acceptance authority. Those factors must be added during later vulnerability analysis and prioritization.

## Initial Conclusion

The report's dominant pattern is not simply “four Critical findings.” It is the clustering of six findings on the billing server, four each on the EHR application and patient-portal servers, and repeated dependence on a flat internal network. Immediate follow-up should validate the high-value chains and ambiguous results, but this first-impressions stage does not yet research individual CVEs or assign final remediation priorities.
