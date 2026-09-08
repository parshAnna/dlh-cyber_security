# MedDefense Health Systems — Physical Security Risk Assessment

Prepared for: James Chen, Deputy CISO  
Prepared by: Junior Security Analyst  
Source: Task 3, “The Walk-Through” — five supplied observations at MedDefense Central.

Scope: Documentary analysis of the supplied walk-through; no physical inspection or technical testing was performed by the author. Threats and impacts below are plausible scenarios, not claims that exploitation has occurred. Severity is a qualitative judgment combining ease of exploitation, exposure and potential business or patient-care consequences. High denotes a readily exploitable weakness with potentially serious consequences; Critical would require stronger evidence of likely catastrophic or widespread clinical disruption.

```text
Observation 1:
  Vulnerability: Every employee's generic badge opens the server room regardless of job need, while the absence of a camera covering the door and a visitor log limits monitoring and accountability for physical access.
  Threat: A malicious employee, or an intruder using a stolen employee badge, enters the server room and removes storage media, tampers with equipment or disconnects power or network cables.
  Impact: Confidentiality could be compromised if removed media contains readable sensitive information; Integrity could be compromised through unauthorized equipment or data changes; Availability could be lost if interference interrupts hosted services, potentially disrupting clinical operations and billing.
  Severity: High — Broad employee access makes unauthorized entry feasible, and interference with concentrated server infrastructure could cause serious data exposure or service disruption with limited supporting evidence for investigation.

Observation 2:
  Vulnerability: The network closet is unlocked and ajar, exposing switches and patch panels to physical interference, and switch-management credentials are displayed beside the equipment.
  Threat: A person entering the closet copies the posted credentials and, if they remain valid, signs into the switch management interface to alter configuration; the person could also unplug cables without needing authentication.
  Impact: Integrity could be compromised by unauthorized network configuration changes; Availability could be lost through disabled ports or disconnected links, disrupting dependent staff and clinical services; Confidentiality could be compromised if the attacker redirects or copies traffic and obtains readable sensitive information.
  Severity: High — Unrestricted access to network equipment and exposed management credentials substantially lower the effort required to disrupt connectivity or manipulate traffic serving hospital operations.

Observation 3:
  Vulnerability: An unattended workstation exposes an authenticated EHR session and a visible patient record after at least 15 minutes of apparent inactivity, while the instruction not to log out between shifts undermines secure session handover and individual accountability.
  Threat: A passerby reads or photographs the displayed record, or uses the active session to access other records and make changes within the logged-in user's permissions.
  Impact: Confidentiality would be compromised by unauthorized viewing or capture of patient information; Integrity could be compromised if the session permits changes to clinical records, potentially misleading care decisions and attributing actions to the wrong staff member.
  Severity: High — Patient information is immediately exposed without an additional login, and misuse of the active clinical session could affect both privacy and the reliability of care information.

Observation 4:
  Vulnerability: The monitor exposes its IP address and firmware details and reports no firmware update since 2019, creating a potential patch-management gap; its apparent placement in the workstation IP range raises concern about insufficient separation, but the display alone proves neither a known firmware flaw nor unrestricted network reachability.
  Threat: An attacker controlling a workstation uses the exposed device details to identify a matching firmware weakness and, if the monitor is reachable and susceptible, exploits it to interfere with monitoring or access device data.
  Impact: Integrity could be compromised if vital-sign readings or device settings are altered; Availability could be lost if monitoring is interrupted, potentially delaying recognition of patient deterioration; Confidentiality could be compromised if patient-related information processed by the device is exposed.
  Severity: High — A potentially outdated patient-monitoring device apparently sharing workstation addressing presents a serious patient-care risk if reachable and exploitable, although the rating is provisional pending verification of firmware support, relevant flaws and effective network controls.

Observation 5:
  Vulnerability: A wooden wedge holds open the fire exit between a public waiting area and a restricted administrative wing, bypassing the intended access boundary, while the staff-passage sign encourages the unsafe arrangement to persist.
  Threat: An unauthorized visitor walks through the open doorway into the administrative corridor and reaches an unattended office to view documents, steal equipment or tamper with accessible systems.
  Impact: Confidentiality could be compromised by exposure of administrative or security information; Integrity could be compromised through unauthorized document or system changes; Availability could be affected by theft or interference with equipment needed for operations, while holding the door open may also impair its intended fire-protection function.
  Severity: High — The opening provides a direct, low-effort route from a public area into restricted offices, increasing the opportunity for sensitive-information exposure, theft and operational interference.
```

## Evidence limitations and reconciliation

- **Location conflicts:** Task 3 places the server room on the ground floor, whereas the onboarding packet places it in the basement; Task 3 also describes a route to the IT department at Central, whereas the packet locates IT at Corporate HQ. This assessment follows the current observations for the scenarios and flags the differences for confirmation rather than assuming a relocation or a second facility.
- **Access and attribution:** Missing cameras and visitor logs do not prove that electronic badge logs are absent. Posted switch credentials have not been validated, and their privilege level is unknown. The unattended EHR session does not establish the organization-wide timeout configuration or the user's write permissions.
- **Medical-device validation:** Confirm the monitor's model, approved firmware and support status, applicable vulnerabilities, subnet mask, VLAN placement and effective access restrictions. Similar IP addresses alone do not establish a common broadcast domain or unrestricted communication; the packet's historical flat-network report strengthens the concern but does not verify current controls.
- **Emergency egress:** Confirm the door's intended access and fire-protection functions with facilities personnel. Restoring the boundary must preserve required emergency exit operation; blocking or disabling emergency egress is not an appropriate treatment.
