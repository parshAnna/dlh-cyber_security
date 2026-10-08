# MedDefense Health Systems — OSINT Vulnerability Hunt

## Scope and Method

This assessment supplements the SecurePoint automated vulnerability scan with manual open-source intelligence research. The purpose is to identify relevant vulnerabilities or attack techniques affecting technologies used by MedDefense that were not identified in the original scan report.

Research was performed using vendor security advisories, NVD, CISA KEV information, and Microsoft security research.

A vulnerability is not treated as confirmed on a MedDefense asset unless the affected product version is known to match. Where MedDefense's exact firmware or build is unknown, the finding is classified as potentially applicable and requires version validation.

---

## 1. FortiGate FortiOS — CVE-2024-55591

Source: [Fortinet PSIRT FG-IR-24-535](https://www.fortiguard.com/psirt/FG-IR-24-535); [NVD CVE-2024-55591](https://nvd.nist.gov/vuln/detail/CVE-2024-55591); [CISA Known Exploited Vulnerabilities Catalog](https://www.cisa.gov/known-exploited-vulnerabilities-catalog)

CVE: CVE-2024-55591

Affected Product: MedDefense FortiGate 100F running FortiOS. Fortinet identifies FortiOS 7.0.0 through 7.0.16 as affected. The exact FortiOS version installed on the MedDefense FortiGate must be verified before vulnerability status can be confirmed.

Why the Scan Missed It: The SecurePoint report did not identify a FortiOS firmware vulnerability on the FortiGate. The assessment focused primarily on hosts and services visible in the scanned environment, and the firewall's own firmware version was not established as a vulnerability finding. An unauthenticated or externally scoped network scan may also be unable to determine the exact FortiOS build required to match this CVE reliably.

CVSS / Severity: Critical. NVD assigns CVSS v3.1 Base Score 9.8. Fortinet rates the issue Critical and reports exploitation in the wild. CISA also includes CVE-2024-55591 in the Known Exploited Vulnerabilities catalog.

MedDefense Impact: This vulnerability is an authentication bypass that can allow a remote attacker to obtain super-admin privileges on affected FortiOS systems. For MedDefense, compromise of the FortiGate would be especially serious because the firewall protects the Internet perimeter and participates in VPN connectivity. Administrative control of the firewall could allow an attacker to change firewall policies, create accounts, alter VPN configuration, establish access into internal networks, or weaken segmentation controls. Because the internal environment already has broad connectivity, firewall compromise could significantly increase the likelihood of lateral movement toward clinical, EHR, billing, and backup systems.

Recommendation: Immediately determine the FortiOS version and build installed on the FortiGate 100F. If it is running FortiOS 7.0.0 through 7.0.16, upgrade to FortiOS 7.0.17 or a supported fixed release using Fortinet's recommended upgrade path. Restrict administrative interfaces to trusted management networks, review administrator accounts and firewall configuration for unauthorized changes, review FortiGate logs for indicators associated with unexpected administrator creation or SSL-VPN activity, and monitor Fortinet PSIRT and CISA KEV for newly exploited FortiOS vulnerabilities.

Applicability Status: Potentially applicable — exact FortiOS version requires validation.

---

## 2. Microsoft 365 / Entra ID — Storm-2372 Device Code Phishing

Source: [Microsoft Security Blog — Storm-2372 conducts device code phishing campaign](https://www.microsoft.com/en-us/security/blog/2025/02/13/storm-2372-conducts-device-code-phishing-campaign/)

CVE: N/A — this is an identity attack technique rather than a software vulnerability.

Affected Product: MedDefense Microsoft Office 365 E3 / Microsoft Entra ID environment and organizational user accounts.

Why the Scan Missed It: The SecurePoint infrastructure vulnerability scan did not assess MedDefense's Microsoft 365 cloud tenant or Entra ID authentication flows. Device code phishing is also not a traditional version-based vulnerability that a network vulnerability scanner can identify. It abuses a legitimate OAuth authentication mechanism together with social engineering and valid authentication tokens.

CVSS / Severity: N/A because this is not a CVE. MedDefense-specific severity assessment: High. Microsoft documented an active and successful device code phishing campaign targeting organizations across multiple sectors, including healthcare.

MedDefense Impact: An attacker could trick a MedDefense employee into completing a legitimate-looking device code authentication request. The attacker could then obtain valid access and refresh tokens and access Microsoft 365 resources available to that user. Microsoft observed attackers using compromised accounts for Microsoft Graph searches, email harvesting, email exfiltration, lateral phishing, and device registration. For MedDefense, this could expose internal correspondence, patient-related communications, billing information, credentials, reset messages, and trusted organizational identities that could be abused to target additional employees.

Recommendation: Block device code flow wherever it is not operationally required. Where it must remain available, control it using Microsoft Entra Conditional Access. Require phishing-resistant MFA such as FIDO2 security keys or passkeys for privileged and sensitive accounts, monitor risky and anomalous sign-ins, restrict device enrollment, and monitor for suspicious token or device-registration activity. If compromise is suspected, revoke sign-in sessions and refresh tokens and force re-authentication.

Applicability Status: Applicable attack technique — MedDefense uses Microsoft 365 / Entra ID, although exposure depends on tenant configuration and whether device code authentication is permitted.

---

## 3. Synology DSM — CVE-2024-45538

Source: [Synology Product Security Advisory — Synology-SA-24:27 DSM](https://www.synology.com/en-us/security/advisory/Synology_SA_24_27); [NVD CVE-2024-45538](https://nvd.nist.gov/vuln/detail/CVE-2024-45538)

CVE: CVE-2024-45538

Affected Product: MedDefense `NAS-01`, which runs Synology DSM 7. Synology identifies affected DSM versions before DSM 7.2.1-69057-2 and DSM 7.2.2-72806. The exact DSM version installed on `NAS-01` must be verified before exposure can be confirmed.

Why the Scan Missed It: The SecurePoint scan identified the Synology DSM management interface as reachable but did not report CVE-2024-45538. The scanner may not have been able to determine the exact DSM build, may not have authenticated deeply enough to identify the affected WebAPI component, or may not have had the corresponding vulnerability check available when the scan was performed.

CVSS / Severity: CVSS v3.1 Base Score 9.6. Synology rates the advisory Important. The vulnerability is a cross-site request forgery issue in the DSM WebAPI Framework that can allow a remote attacker to execute arbitrary code through unspecified vectors when the required user interaction occurs.

MedDefense Impact: `NAS-01` stores MedDefense server backups. Successful code execution on the NAS could threaten the confidentiality, integrity, and availability of backup data. An attacker could potentially use control of the NAS to access sensitive backup information, alter stored data, disrupt backup services, or interfere with recovery operations. This would be particularly damaging during a ransomware incident because MedDefense depends on reliable backups to restore clinical, billing, and infrastructure systems.

Recommendation: Verify the exact DSM version and build on `NAS-01`. If the NAS is running an affected release, upgrade to DSM 7.2.1-69057-2 or later, DSM 7.2.2-72806 or later, or another supported fixed DSM release. Restrict DSM management access to dedicated administrator systems, require MFA for administrative accounts, monitor DSM logs for suspicious activity, and maintain offline or immutable backup copies so compromise of the NAS does not eliminate MedDefense's recovery capability.

Applicability Status: Potentially applicable — MedDefense uses DSM 7, but the exact DSM version and build must be validated.

---

## OSINT Assessment Summary

The OSINT review identified risks that were not represented in the original vulnerability scan: a Critical and actively exploited FortiOS authentication bypass, a current Microsoft 365 identity attack technique that cannot be detected through normal CVE-based infrastructure scanning, and a Critical Synology DSM vulnerability affecting versions of the operating system used by MedDefense's backup NAS. These findings demonstrate that vulnerability assessment cannot stop at the scanner output. Internet-edge appliances, SaaS identity platforms, and specialized storage systems require continuous vendor-advisory and threat-intelligence monitoring in addition to scheduled vulnerability scans. The highest immediate priority is to verify the exact FortiOS and DSM versions because both technologies can expose high-value control points: the network perimeter and the backup infrastructure.
