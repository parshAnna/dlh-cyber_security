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

## 2. Microsoft 365 / Entra ID — Device Code Phishing

Source: [Microsoft Security Blog — Inside an AI-enabled device code phishing campaign](https://www.microsoft.com/en-us/security/blog/2026/04/06/ai-enabled-device-code-phishing-campaign-april-2026/)

CVE: N/A — this is an identity attack technique rather than a software vulnerability.

Affected Product: MedDefense Microsoft Office 365 E3 / Microsoft Entra ID environment and organizational user accounts.

Why the Scan Missed It: The SecurePoint infrastructure vulnerability scan did not assess MedDefense's Microsoft 365 cloud tenant or Entra ID authentication behavior. Device code phishing is also not a traditional version-based software vulnerability that a network scanner can detect. The attack abuses a legitimate OAuth authentication workflow together with social engineering, valid Microsoft sign-in infrastructure, and stolen access or refresh tokens.

CVSS / Severity: N/A because this is not a CVE. MedDefense-specific severity assessment: High. Microsoft has documented active campaigns successfully compromising organizational accounts through device code authentication abuse.

MedDefense Impact: An attacker could socially engineer a MedDefense employee into authorizing an attacker-controlled device-code session. Successful authentication can issue valid access and refresh tokens without the attacker directly stealing the user's password. Microsoft has observed post-compromise activity including Microsoft Graph reconnaissance, email collection and exfiltration, malicious inbox rules, device registration, token-based persistence, and targeting of financial and executive users. For MedDefense, compromise of an O365 account could expose internal communications, patient-related correspondence, billing information, credentials or reset messages, and could provide a trusted identity for additional phishing against clinical or administrative staff.

Recommendation: Block OAuth device code flow where it is not operationally required and control any necessary use through Microsoft Entra Conditional Access. Enable phishing-resistant authentication such as FIDO2/passkeys for privileged and sensitive users. Configure Defender for Office 365 anti-phishing protections and Safe Links, monitor risky and anomalous sign-ins, restrict device registration permissions, and alert on unusual device-code authentication. If compromise is suspected, revoke sign-in sessions and refresh tokens, force re-authentication, investigate inbox rules and Graph activity, and temporarily disable the affected account where necessary for immediate containment.

Applicability Status: Applicable attack technique — MedDefense uses Microsoft 365 / Entra ID, although exposure depends on tenant configuration and whether device-code authentication is permitted.

---

## 3. Synology DSM — CVE-2026-13684

Source: [Synology Product Security Advisory — Synology-SA-26:13 DSM](https://www.synology.com/en-global/security/advisory/Synology_SA_26_13)

CVE: CVE-2026-13684

Affected Product: MedDefense `NAS-01`, which runs Synology DSM 7. Synology identifies vulnerable releases in the DSM 7.2.1, 7.2.2, 7.3 and 7.4 branches. The exact DSM version and build installed on `NAS-01` must be checked before confirming exposure.

Why the Scan Missed It: The SecurePoint scan identified the Synology DSM management interface and configuration exposure but did not report CVE-2026-13684. The scanner may not have obtained the exact DSM build required for vulnerability matching, or its vulnerability plugin/database may not have included the advisory. Manual OSINT research therefore identifies a software risk that requires direct version validation on the NAS.

CVSS / Severity: Critical — CVSS v3.1 Base Score 9.8.

MedDefense Impact: CVE-2026-13684 is an unauthenticated remote vulnerability in the DSM SCGI component that can allow attackers to read or write arbitrary files and conduct denial-of-service attacks. This is particularly serious for MedDefense because `NAS-01` stores server backup data. Unauthorized file access could expose sensitive backup contents, while arbitrary file modification or service disruption could damage backup integrity or availability. During a ransomware incident, loss of trustworthy backups could significantly reduce MedDefense's ability to restore clinical, billing, or infrastructure systems.

Recommendation: Determine the exact DSM branch and build on `NAS-01`. Upgrade to the Synology-fixed release appropriate for that branch, including DSM 7.2.1-69057-12 or later, DSM 7.2.2-72806-9 or later, DSM 7.3.2-86009-4 or later, or DSM 7.4-90075 or later as applicable. Restrict DSM management ports to dedicated administrator systems, prevent unnecessary network-wide access to the NAS, enable MFA for administrative accounts, review logs for suspicious access, and ensure backups are protected by offline or immutable copies so compromise of the NAS does not eliminate recovery capability.

Applicability Status: Potentially applicable — DSM 7 is present, but exact version/build requires validation.

---

## OSINT Assessment Summary

The OSINT review identified risks that were not represented in the original vulnerability scan: a Critical and actively exploited FortiOS authentication bypass, a current Microsoft 365 identity attack technique that cannot be detected through normal CVE-based infrastructure scanning, and a Critical Synology DSM vulnerability affecting versions of the operating system used by MedDefense's backup NAS. These findings demonstrate that vulnerability assessment cannot stop at the scanner output. Internet-edge appliances, SaaS identity platforms, and specialized storage systems require continuous vendor-advisory and threat-intelligence monitoring in addition to scheduled vulnerability scans. The highest immediate priority is to verify the exact FortiOS and DSM versions because both technologies can expose high-value control points: the network perimeter and the backup infrastructure.
