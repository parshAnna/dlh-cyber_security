# MedDefense Health Systems — Significant Control Gaps

Prepared for: James Chen, Deputy CISO  
Prepared by: Junior Security Analyst  
Scope: Task 5 — analysis of the Task 4 Control Summary Matrix and its supporting artifacts, supplemented by onboarding notes and supplied walk-through observations.

The baseline is the [Task 4 Control Inventory](4-control_inventory.md); C-identifiers below retain that document's meanings. **A1–A8** refer to its eight source artifacts. **O** refers to onboarding documents summarized in [Task 0](0-environment_summary.md); **W** refers to observations analyzed in [Task 3](3-physical_assessment.md). G-identifiers are local to this assessment and are distinct from the later GAP-identifiers in Task 12. No live systems were tested.

A populated matrix cell does not demonstrate protection of every asset, and an empty cell alone does not prove a universal deficiency. The gaps below distinguish explicit absence, limited scope and missing evidence. Existing weak controls are acknowledged rather than described as nonexistent; proposed controls are not counted as deployed.

## Significant Gaps

```text
Gap ID: G-001
Gap Description: Centralized security-event collection, intrusion detection and automated alerting are not evidenced as operational; local records are reviewed primarily after operational problems occur, and EHR audit exports take 48 hours.
Category x Function Missing: Technical Detective — timely cross-system detection and actionable alerting are missing/inadequate, despite existing local logs.
Affected Asset(s) or Zone: EHR application/database, billing server, AD and the Central internal network.
Risk if Unaddressed: An intrusion can remain unnoticed while an attacker accesses patient information (Confidentiality), changes systems or records (Integrity), and eventually disrupts clinical or billing services (Availability).
Evidence: The Technical Detective cell contains C-004, C-011 and C-034–C-037, but A8 explicitly states no centralized log management or automated security alerting; Wazuh was never installed. C-038 is reactive review, not continuous monitoring; no IDS capability is evidenced in A1/A8.
```

```text
Gap ID: G-002
Gap Description: No formal incident-response or disaster-recovery procedure is documented to assign responsibilities, guide containment, restore complete clinical services and validate recovery.
Category x Function Missing: Administrative Corrective — documented, repeatable response and recovery procedures.
Affected Asset(s) or Zone: EHR, billing, imaging and organization-wide clinical operations.
Risk if Unaddressed: Staff may improvise during a breach, delaying containment of disclosure (Confidentiality), restoration of trusted information (Integrity) and return of clinical services (Availability).
Evidence: The Task 4 Administrative Corrective cell is empty. O D3 explicitly reports no formal IR, business-continuity or disaster-recovery plan and an improvised four-day billing ransomware response. A5/C-024 records one partial file-server restore eight months ago, not a full DR test or a documented response program.
```

```text
Gap ID: G-003
Gap Description: The backup control excludes PACS imaging, Westside's server and medical-device configurations; no alternative recovery mechanism for these assets is evidenced.
Category x Function Missing: Technical Corrective — asset-specific recovery coverage.
Affected Asset(s) or Zone: pacs-srv-01, ws-srv-01 and connected medical-device configurations.
Risk if Unaddressed: Destruction or corruption could leave imaging, clinic files/scheduling or device settings unavailable (Availability) or prevent restoration of correct configurations and data (Integrity), disrupting diagnosis and care workflows.
Evidence: A5 explicitly excludes these assets from backup. C-022 in the Technical Corrective cell covers only six named servers, and C-019 antivirus quarantine cannot restore missing PACS images or device configurations. No alternative recovery copy is supplied.
```

```text
Gap ID: G-004
Gap Description: Existing backups share the production network and server room, with no offsite/cloud copy, creating a common exposure to destructive incidents.
Category x Function Missing: Technical Corrective — independently recoverable copies outside the production failure domain.
Affected Asset(s) or Zone: NAS-01 and the recovery copies for ehr-srv-01, ehr-db-01, billing-srv-01, ad-dc-01, file-srv-01 and web-srv-01.
Risk if Unaddressed: A room disaster or attack reaching both servers and NAS could remove production and recovery data together, prolonging clinical outages (Availability) and eliminating trusted recovery versions (Integrity).
Evidence: A5 places the NAS in the same room/network and explicitly states no offsite backup. C-022 provides local backups; C-023 RAID5 addresses limited disk failure rather than room loss or malicious deletion. O D3 corroborates the shared-location concern. Existing backups are therefore inadequate for this scenario, not absent altogether.
```

```text
Gap ID: G-005
Gap Description: Workstation antivirus capabilities do not extend to Windows or Linux servers, and physician iPads lack the documented mobile-management/protection layer.
Category x Function Missing: Technical Preventive, Technical Detective and Technical Corrective — malware blocking, detection and quarantine coverage on excluded assets; mobile enforcement also absent.
Affected Asset(s) or Zone: Windows servers including PACS and AD, Linux servers including EHR and billing, and physician iPads.
Risk if Unaddressed: Malicious software may run without these host-level safeguards, exposing readable patient information (Confidentiality), modifying software or data (Integrity), or consuming/encrypting resources required by clinical services (Availability).
Evidence: A4 explicitly lists Windows servers as not covered because the server license was not purchased, Linux as outside the current tier and mobile devices as out of scope with no MDM/EMM. C-017–C-021 demonstrate protection/reporting on covered endpoints only. Local server logs do not substitute for malware-specific protection, and inconsistent deployment counts require reconciliation.
```

```text
Gap ID: G-006
Gap Description: Physical surveillance does not cover Central's server-room area or network closets, and no dedicated camera-monitoring service is contracted.
Category x Function Missing: Physical Detective — surveillance at sensitive IT access points and effective observation of those areas.
Affected Asset(s) or Zone: Central server room, hosted critical servers and network closets.
Risk if Unaddressed: Unauthorized entry, media removal or equipment interference may escape observation, enabling disclosure (Confidentiality), tampering (Integrity) or interruption of connected clinical systems (Availability).
Evidence: A6/C-029 places Central's four cameras at public entrances and explicitly excludes the server-room area and network closets. W1 has no camera or visitor log at the server-room door. C-025/C-027 cover the main entrance, not the server room; electronic badge-log availability is unknown, not proven absent.
```

```text
Gap ID: G-007
Gap Description: Physical entry controls do not restrict IT access to authorized roles: generic employee badges open the server room, while the observed network closet is unlocked and exposes switch-management credentials.
Category x Function Missing: Physical Preventive and Administrative Preventive — effective role-restricted entry and secure credential-handling procedures.
Affected Asset(s) or Zone: Central server room and second-floor switch stack/patch panels; Westside server closet also reportedly does not lock.
Risk if Unaddressed: An employee or intruder could interfere with equipment or use exposed management credentials to change network settings (Integrity), interrupt services (Availability), or obtain readable information (Confidentiality).
Evidence: W1/W2 document broad badge access, the unlocked closet and a posted management password; O D3 reports the Westside closet does not lock. Task 4's Physical Preventive cell contains C-025 main-entrance guard checks only; these do not establish restricted access to internal IT spaces. The observed switch stack is not assumed to be the core switch.
```

```text
Gap ID: G-008
Gap Description: Internal medical-device and database access is insufficiently separated from general computing, and no deployed compensating isolation is evidenced for the legacy MRI platform.
Category x Function Missing: Technical Preventive — enforced internal least-privilege network paths; Technical Compensating — alternative protection for a legacy clinical system where ordinary maintenance is constrained.
Affected Asset(s) or Zone: Central medical devices, MRI control environment, EHR database and server subnet reached from remote sites.
Risk if Unaddressed: A compromised endpoint could reach additional clinical targets and attempt unauthorized reading (Confidentiality), record/device changes (Integrity) or service disruption (Availability), increasing the potential spread beyond the initial asset.
Evidence: O D3/D5 reports a flat network and broad PostgreSQL reachability. A1/C-002 permits ALL services from the site VPNs to the server subnet; C-003 perimeter denial does not remove those permissions or establish internal isolation. The Compensating column is empty, and O D2 identifies the MRI's Windows XP environment. W4's similar IP addresses alone would not prove a shared network; O provides the additional architectural evidence.
```

```text
Gap ID: G-009
Gap Description: The strongest documented remote-authentication controls are confined to ehr-srv-01, while other Linux servers retain password authentication and organizational MFA is not required.
Category x Function Missing: Technical Preventive and Administrative Preventive — consistent supported authentication safeguards and enforced access policy across critical systems.
Affected Asset(s) or Zone: ehr-db-01, billing-srv-01 and other Linux remote-administration services; relevant remote-access accounts.
Risk if Unaddressed: Stolen or guessed credentials could enable unauthorized access to readable information (Confidentiality), changes within the account's permissions (Integrity), or service disruption (Availability).
Evidence: A2 says Marcus migrated only ehr-srv-01; C-005–C-010 cannot be credited to other Linux hosts. A3/C-012 recommends but does not require MFA and says Linux is individually configured. O D3 describes MFA only on James's personal account, not a general deployment. Existing password authentication is acknowledged, but does not establish equivalent protection.
```

```text
Gap ID: G-010
Gap Description: Unattended clinical sessions expose patient information in use, while shared radiology credentials undermine individual accountability and current training does not adequately address healthcare-specific handling.
Category x Function Missing: Technical Preventive — effective clinical-session locking and individual access; Administrative Preventive — secure handover and role-specific patient-information handling.
Affected Asset(s) or Zone: Third-floor EHR workstation, radiology PACS workstation and staff accessing patient records.
Risk if Unaddressed: Passersby may read visible records (Confidentiality), and misuse of an active session may permit unauthorized changes if the logged-in role allows them (Integrity), with actions attributed to the wrong staff member.
Evidence: W3 describes an unattended record after at least 15 minutes and a sign discouraging logout; this demonstrates the observed exposure, not every workstation's timeout setting. O D3 reports the shared radiology account. A7/C-032 has incomplete participation and no digital PHI or role-specific content; C-033 tracks completion but does not close the gap. A2/C-008 SSH liveness probes are not a clinical workstation screen lock.
```

## Overall Pattern

MedDefense is more prevention-oriented than detection-oriented in its deployment emphasis: the Task 4 matrix lists 19 preventive controls versus 16 detective controls, but many detective entries are local records, occasional checks or limited-area surveillance rather than timely security monitoring. Corrective capability is concentrated in narrow technical measures, with an empty Administrative Corrective cell and no documented deployed compensating controls. If prevention is bypassed, an incident may therefore remain unnoticed until services fail, after which incomplete coverage and untested response procedures can prolong clinical disruption even though some logs and backups exist.
