# MedDefense Health Systems — Threat-Vulnerability Correlation

## Correlation Basis

This matrix connects the current eight highest-priority MedDefense findings to the threat actors, attack vectors, kill chains, threat scenarios and control gaps identified in Projects 1x00 and 1x01.

The selected findings are 031, 003, 004, 010, 001, 008, 002 and 007. They represent the seven Actionable Critical findings identified during vulnerability triage plus the highest-priority Actionable Standard identity-infrastructure finding.

---

## Threat-Vulnerability Correlation Matrix

Finding 031 | Threat Actor(s): Ransomware Groups (Organized Crime); Nation-State APT | Vector: Internal exploitation of a vulnerable service after initial foothold; compromised vendor or maintenance access can also provide the trusted path toward the EHR tier | Kill Chain: #5 — Compromised MedTech Channel to EHR Records | Scenario: Scenario 3 — Trusted MedTech Update, Hidden EHR Collection | Gap: GAP-006; GAP-016

Finding 003 | Threat Actor(s): Ransomware Groups (Organized Crime); Nation-State APT; Insider (Malicious) | Vector: Lateral movement or valid-account abuse from an internal foothold directly to PostgreSQL across the broadly trusted internal network | Kill Chain: #5 — Compromised MedTech Channel to EHR Records | Scenario: Scenario 3 — Trusted MedTech Update, Hidden EHR Collection | Gap: GAP-006; GAP-016

Finding 004 | Threat Actor(s): Ransomware Groups (Organized Crime); Unskilled/Opportunistic Attacker | Vector: Remote exploitation of legacy SMB services followed by lateral movement across the flat network | Kill Chain: #3 — Radiology Phish to PACS Extortion | Scenario: Scenario 1 — Vendor Patch Lure to Hospital-Wide Extortion | Gap: GAP-016

Finding 010 | Threat Actor(s): Insider (Malicious); Nation-State APT | Vector: Privileged or trusted access to the medical-device management environment, including misuse of legitimate credentials or a trusted maintenance path | Kill Chain: #4 — Privileged Insider Manipulation of Infusion Pumps | Scenario: Scenario 2 — The Quiet Export Before Departure | Gap: GAP-001; GAP-018

Finding 001 | Threat Actor(s): Ransomware Groups (Organized Crime); Unskilled/Opportunistic Attacker | Vector: Exploitation of an exposed or reachable vulnerable web service using public exploit tooling, followed by internal discovery and lateral movement | Kill Chain: #1 — VPN Foothold to Domain-Wide Ransomware | Scenario: Scenario 1 — Vendor Patch Lure to Hospital-Wide Extortion | Gap: GAP-015; GAP-016; GAP-008

Finding 008 | Threat Actor(s): Ransomware Groups (Organized Crime); Unskilled/Opportunistic Attacker | Vector: Exploitation of a reachable Windows Print Spooler service from an existing internal foothold to obtain SYSTEM-level execution and expand access | Kill Chain: #1 — VPN Foothold to Domain-Wide Ransomware | Scenario: Scenario 1 — Vendor Patch Lure to Hospital-Wide Extortion | Gap: GAP-016

Finding 002 | Threat Actor(s): Ransomware Groups (Organized Crime); Unskilled/Opportunistic Attacker | Vector: Local privilege escalation after obtaining an initial foothold on billing-srv-01, converting lower-privileged execution into deeper server control | Kill Chain: #1 — VPN Foothold to Domain-Wide Ransomware | Scenario: Scenario 1 — Vendor Patch Lure to Hospital-Wide Extortion | Gap: GAP-015; GAP-008

Finding 007 | Threat Actor(s): Ransomware Groups (Organized Crime); Nation-State APT | Vector: Credential relay and privilege expansion against Active Directory after initial network access, enabled by LDAP signing not being required | Kill Chain: #1 — VPN Foothold to Domain-Wide Ransomware | Scenario: Scenario 1 — Vendor Patch Lure to Hospital-Wide Extortion | Gap: GAP-016

---

## Highest-Damage Vulnerability

**Finding 031 — CVE-2020-1938 (Ghostcat) on `ehr-srv-01` would cause the greatest damage when the full threat context is considered.** The vulnerability is manually confirmed on the EHR application server and has a CVSS Base score of 9.8; exploitation can allow an attacker to read application files that may contain database credentials. This places the vulnerability directly on a path toward `ehr-db-01`, which the earlier criticality assessment ranks as MedDefense's highest-value asset because it contains Restricted patient records. Both ransomware groups and a capable Nation-State APT have plausible motives to exploit this path: ransomware operators could use patient-data access for double extortion and operational disruption, while an APT could use the same route for long-term collection or record manipulation. The risk is amplified by GAP-006, which permits broader database reachability than the documented application need, and GAP-016, which reflects weak internal boundaries. In combination, a confirmed exploitable EHR-tier vulnerability, capable threat actors, a documented attack path and the criticality of the underlying patient database make Finding 031 the most damaging single vulnerability in the prioritized set.

---

## Synthesis

The correlation shows that the most serious vulnerabilities do not exist independently. Findings 001, 002, 007 and 008 can support the foothold, privilege-escalation and lateral-movement stages associated with ransomware activity; Findings 031 and 003 create a direct route toward the EHR and Restricted patient information; Finding 004 extends the same weak internal architecture into radiology; and Finding 010 demonstrates how cyber compromise can cross into a safety-critical medical-device environment. The recurring control theme is that GAP-015 and GAP-016 allow vulnerable services and weak network boundaries to convert individual technical weaknesses into organization-wide attack paths, while asset-specific gaps such as GAP-006, GAP-001 and GAP-018 increase the impact on EHR and infusion-pump systems.
