# MedDefense Health Systems — Vulnerability Triage

## Triage Method

This triage classifies all 31 findings from the MedDefense vulnerability scan according to their real operational context rather than relying only on the scanner-assigned severity.

The categories are:

- **AC — Actionable Critical:** confirmed or strongly applicable vulnerability with immediate high-impact risk requiring remediation within 24–48 hours.
- **AS — Actionable Standard:** real security weakness requiring scheduled remediation within 7–30 days.
- **I — Informational:** valid observation with low direct security impact that should be documented and monitored.
- **FP — False Positive:** scanner result that does not represent a meaningful exploitable vulnerability in the current MedDefense context.

Scanner severity is retained in each line for traceability, but the final triage category also considers asset criticality, exploitability, attack prerequisites, MedDefense's flat network, patient-safety consequences, and conclusions from the previous vulnerability-analysis tasks.

---

## Full Triage

Finding 001 | Critical / CVSS 9.8 | `10.10.2.15 (billing-srv-01)` | Category: AC | Reason: CVE-2021-44790 provides a remote unauthenticated Apache code-execution path on a production billing server and can establish an internal foothold for lateral movement.

Finding 002 | Critical | `10.10.2.15 (billing-srv-01)` | Category: AC | Reason: CVE-2019-0211 can escalate existing Apache execution to higher privileges and forms a direct high-impact chain with Finding 001.

Finding 003 | Critical | `10.10.2.11 (ehr-db-01)` | Category: AC | Reason: PostgreSQL accepts connections from the entire `10.10.0.0/16` network and directly exposes MedDefense's highest-value EHR data store to any suitable internal foothold and credentials.

Finding 004 | Critical | `10.10.1.70 (WS-RAD-01 / MRI controller)` | Category: AC | Reason: The legacy Windows XP clinical workstation is exposed to remotely exploitable SMB risk including EternalBlue, creating both patient-care disruption and lateral-movement potential.

Finding 005 | High | `10.10.2.50 (web-srv-01 / Patient Portal)` | Category: AS | Reason: TLS 1.0 remains enabled on a PHI-handling web service, creating a real transport-security weakness that should be removed through planned TLS hardening.

Finding 006 | High | `10.10.2.15 (billing-srv-01)` | Category: AS | Reason: MySQL is bound to all interfaces and is unnecessarily reachable across the flat internal network, increasing exposure of financial and billing data after any internal compromise.

Finding 007 | High | `10.10.2.20 (ad-dc-01)` | Category: AS | Reason: LDAP signing is not required on the domain controller, leaving Active Directory exposed to relay-related attacks and requiring controlled remediation because compatibility must also be considered.

Finding 008 | High / CVSS 8.8 | `10.10.2.31 (print-srv-01)` | Category: AC | Reason: CVE-2021-34527 can provide SYSTEM-level execution on a broadly reachable Windows print server and the flat network makes the compromised server a strong lateral-movement platform.

Finding 009 | High | `10.10.2.15 (billing-srv-01)` | Category: AS | Reason: SSH password authentication combined with the absence of account lockout creates a real brute-force and credential-reuse path to a production server.

Finding 010 | High | `BD Alaris infusion-pump fleet (A-061–A-067)` | Category: AC | Reason: The Alaris deployment uses the vulnerable 12.1.x generation identified in the vendor bulletin and affects a safety-critical treatment platform, so vendor-supported remediation and segmentation require immediate clinical-security coordination.

Finding 011 | Medium | `10.10.2.15 (billing-srv-01)` | Category: AS | Reason: Ubuntu 18.04 is outside normal standard support and the server is not receiving the ordinary security-maintenance coverage expected for an Internet- or network-facing production system.

Finding 012 | Medium | `10.10.2.50 (web-srv-01)` | Category: AS | Reason: Missing HTTP security headers reduce browser-side defense in depth on the patient portal and should be corrected during planned web hardening.

Finding 013 | Medium | `10.10.2.50 (web-srv-01)` | Category: AS | Reason: The patient-portal TLS certificate expires within 23 days and lacks demonstrated automatic renewal, creating a foreseeable service-availability and trust problem requiring remediation before expiry.

Finding 014 | Medium | `10.10.10.1 (Westside Clinic Netgear router)` | Category: AS | Reason: The router administrative interface is broadly reachable internally and protects important clinic and VPN connectivity, so management-plane access should be restricted.

Finding 015 | Medium | `10.10.2.41 (NAS-01)` | Category: AS | Reason: Synology DSM management on ports 5000/5001 is reachable network-wide and the NAS contains unencrypted backups, making recovery infrastructure unnecessarily accessible after an internal foothold.

Finding 016 | Medium | `10.10.3.10-32 (Philips IntelliVue monitors)` | Category: AS | Reason: Medical-monitor web and HL7 interfaces are broadly accessible across the flat network, exposing clinical information and increasing the attack surface of patient-monitoring systems.

Finding 017 | Medium | `10.10.2.10 (ehr-srv-01)` | Category: I | Reason: Tomcat version and stack-trace disclosure is a real reconnaissance aid but is not directly exploitable by itself, while the resulting Ghostcat exposure is separately captured and prioritized as Finding 031.

Finding 018 | Medium | `10.10.2.20 (ad-dc-01), 10.10.2.21 (ad-dc-02)` | Category: AS | Reason: DES and RC4 remain enabled for Kerberos, increasing susceptibility to credential cracking and Kerberoasting-related abuse on MedDefense's identity infrastructure.

Finding 019 | Medium | `10.10.1.10, 10.10.1.50-52, 10.10.10.10` | Category: AS | Reason: RDP is enabled on five hosts and, although NLA reduces risk, remote administration should be limited to systems and users with a documented operational requirement.

Finding 020 | Medium / CVSS 9.8 | `10.10.2.40 (backup-srv-01)` | Category: FP | Reason: CVE-2023-38408 requires forwarded `ssh-agent` PKCS#11 conditions that SecurePoint considered unlikely in this server context, so the finding should be dismissed from the vulnerability queue unless manual configuration validation proves those prerequisites exist.

Finding 021 | Medium | `10.10.2.50 (web-srv-01)` | Category: AS | Reason: HTTP TRACE is unnecessarily enabled and can contribute to Cross-Site Tracing attacks when combined with another web weakness, so it should be disabled during normal web remediation.

Finding 022 | Low | `10.10.2.10 (ehr-srv-01)` | Category: FP | Reason: A 47-second clock difference is an operational NTP-hygiene issue rather than a meaningful exploitable vulnerability in this context and should not remain in the vulnerability remediation queue.

Finding 023 | Low | `10.10.1.20-42 and other clinical workstations` | Category: AS | Reason: Unrestricted USB mass storage affects approximately 280 clinical endpoints and creates preventable malware-entry and data-exfiltration paths that require endpoint-policy remediation.

Finding 024 | Low | `10.10.2.12 (pacs-srv-01)` | Category: AS | Reason: DICOM traffic carrying patient identifiers and medical images crosses the network without TLS, creating a real confidentiality exposure within the radiology environment.

Finding 025 | Low | `10.10.2.20 (ad-dc-01)` | Category: AS | Reason: DNS zone transfers are allowed to any requester, enabling unnecessary disclosure of internal hostnames, addresses, and network structure useful for attacker reconnaissance.

Finding 026 | Low | `10.10.2.15 (billing-srv-01)` | Category: AS | Reason: The outdated Ubuntu kernel has numerous known patched vulnerabilities and compounds the unsupported-platform and privilege-escalation risks already present on the billing server.

Finding 027 | Informational | `Multiple Windows workstations` | Category: AS | Reason: Sophos is the intended primary endpoint protection but 15 systems are inactive or not reporting, so those endpoints require identification and restoration of security coverage.

Finding 028 | Informational | `10.10.2.99 (unknown Linux device)` | Category: AS | Reason: An unregistered server-subnet device exposing SSH, Cockpit, and a Jupyter interface represents unmanaged shadow IT and must be identified, authorized, secured, or removed.

Finding 029 | Informational / CVSS 7.5 associated | `10.10.10.200 (unknown Westside device)` | Category: AS | Reason: The undocumented host exposes Grafana 8.2.0 with the publicly exploitable CVE-2021-43798 unauthenticated file-read vulnerability, so scanner informational severity understates the remediation need.

Finding 030 | Informational | `10.10.2.10 (ehr-srv-01)` | Category: FP | Reason: The certificate is valid for `ehr.meddefense.local` and warnings occur when clients access the server directly by IP, making this primarily an operational naming issue rather than an exploitable security vulnerability.

Finding 031 | High / CVSS 9.8 | `10.10.2.10 (ehr-srv-01)` | Category: AC | Reason: Manual verification confirmed an active AJP connector vulnerable to CVE-2020-1938 Ghostcat, allowing arbitrary file reads including configuration files that may expose EHR database credentials.

---

## Triage Summary

| Category | Code | Count | Required Action |
|---|---:|---:|---|
| Actionable Critical | AC | **7** | Immediate remediation within 24–48 hours |
| Actionable Standard | AS | **20** | Scheduled remediation within 7–30 days |
| Informational | I | **1** | Document and monitor |
| False Positive | FP | **3** | Document and dismiss from vulnerability queue |
| **Total** |  | **31** |  |

The original scanner severity therefore does not map directly to operational priority. Some scanner Informational findings become actionable after context is added, while some apparently severe results become false positives when their exploitation prerequisites do not exist in the MedDefense environment.

---

## Actionable Findings List

### Actionable Critical — Immediate Remediation (24–48 Hours)

1. **Finding 031 — Ghostcat on `ehr-srv-01`**
   Manually confirmed CVE-2020-1938 on the EHR application server can expose application and database credentials and directly supports movement toward MedDefense's highest-value EHR data.

2. **Finding 003 — PostgreSQL unrestricted network access on `ehr-db-01`**
   The EHR database accepts connections across the entire internal `/16`, turning any compromised internal system with usable credentials into a potential direct route to patient records.

3. **Finding 004 — Legacy MRI controller / EternalBlue exposure**
   Remote SMB exploitation on the Windows XP MRI controller combines mature exploitability with clinical availability and patient-safety consequences.

4. **Finding 010 — BD Alaris infusion-pump security exposure**
   The affected Alaris generation supports a real vendor-documented security concern on a safety-critical treatment platform and requires immediate version validation, segmentation, and vendor-coordinated remediation.

5. **Finding 001 — Apache CVE-2021-44790 on `billing-srv-01`**
   Remote unauthenticated code execution can create the initial billing-server foothold and open access to the flat internal network.

6. **Finding 008 — PrintNightmare on `print-srv-01`**
   SYSTEM-level execution on a shared Windows infrastructure server creates a high-value lateral-movement platform.

7. **Finding 002 — Apache CVE-2019-0211 on `billing-srv-01`**
   Local privilege escalation can convert the foothold created through Finding 001 or another entry path into privileged server control.

### Actionable Standard — Scheduled Remediation (7–30 Days)

1. **Finding 007 — LDAP signing not required on `ad-dc-01`**
2. **Finding 015 — NAS management interface accessible network-wide**
3. **Finding 016 — Philips IntelliVue web and HL7 interfaces broadly reachable**
4. **Finding 029 — Undocumented Grafana 8.2.0 host with CVE-2021-43798**
5. **Finding 006 — MySQL unrestricted network binding**
6. **Finding 009 — SSH password authentication without lockout**
7. **Finding 018 — Weak Kerberos DES/RC4 encryption**
8. **Finding 011 — Unsupported Ubuntu 18.04 platform**
9. **Finding 026 — Outdated billing-server kernel**
10. **Finding 027 — Fifteen Sophos endpoints inactive or not reporting**
11. **Finding 014 — Westside router management interface broadly accessible**
12. **Finding 028 — Unidentified server-subnet Linux device / shadow IT**
13. **Finding 023 — USB mass storage unrestricted across clinical endpoints**
14. **Finding 024 — Unencrypted DICOM traffic**
15. **Finding 005 — TLS 1.0 enabled on the patient portal**
16. **Finding 013 — Patient-portal certificate nearing expiration**
17. **Finding 012 — Missing HTTP security headers**
18. **Finding 019 — RDP enabled on five hosts**
19. **Finding 025 — DNS zone transfer available to any requester**
20. **Finding 021 — HTTP TRACE enabled**

---

## Informational / Monitoring Queue

**Finding 017 — Tomcat information disclosure:** Retain as evidence of unnecessary information exposure and monitor remediation, but the immediately exploitable follow-on condition is already represented by Finding 031.

---

## False Positive / Dismissed Vulnerability Queue

**Finding 020 — OpenSSH CVE-2023-38408:** Dismiss from the active vulnerability queue if manual validation confirms that the required forwarded `ssh-agent` / PKCS#11 condition is absent.

**Finding 022 — 47-second clock skew:** Handle as routine NTP configuration hygiene rather than a security vulnerability.

**Finding 030 — TLS common-name mismatch:** Treat as an operational access/naming issue because the certificate mismatch occurs when clients use the IP instead of the certificate hostname.

---

## Final Triage Position

The triage reduces the 31 scanner results to **27 actionable security findings**, consisting of seven immediate Critical actions and twenty scheduled Standard actions. One finding is retained as informational context and three are removed from the active vulnerability queue as false positives or non-security operational conditions.

The highest priorities are not determined by scanner color alone. Manual verification elevated Finding 031 from a Medium information-disclosure lead into a confirmed high-impact EHR vulnerability, while environmental analysis raised the urgency of medical-device and flat-network findings. Conversely, exploitation prerequisites and operational context reduce the priority of Findings 020, 022 and 030. This is the purpose of vulnerability triage: convert raw scanner output into a remediation queue based on exploitability, asset importance, business and patient impact, and the actual MedDefense environment.
