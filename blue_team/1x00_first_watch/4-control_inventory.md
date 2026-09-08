# MedDefense Health Systems — Security Control Inventory

Prepared for: James Chen, Deputy CISO  
Prepared by: Junior Security Analyst  
Scope: Task 4 — review of all eight supplied control artifacts; no live configuration validation.

Source package: [MedDefense Security Controls — Source Artifacts](https://s3.eu-west-3.amazonaws.com/hbtn.intranet/uploads/text/2026/3/4d60fdc88bfa972be72be44bd40f3d496bd87c39.txt). Artifact numbers below refer to the numbered sections in that package. Relative dates are retained because no absolute compilation date is supplied.

## Classification method

Each record uses one category and one principal function. Where one platform provides distinct functions, those mechanisms are separated (for example, antivirus blocking, detection and quarantine). The guard's access checks and visible deterrent presence are likewise separate functions of the same deployment; the record count is not a count of independent products or defensive layers. Policies and human review processes are Administrative, software-enforced mechanisms are Technical, and entrance guards and surveillance equipment are Physical under the assignment taxonomy.

A documented or reported control may be incomplete, weak or unverified. Its inclusion does not certify effectiveness. Policy-stated GPO enforcement is distinguished from exported configuration evidence. Ordinary configuration settings without a clear evidenced security mechanism are not counted merely to increase the inventory. No compensating control is asserted without evidence of an alternative protection adopted for an infeasible primary control.

## Control records

```text
Control ID: C-001
Control Name: Inbound web-service filtering
Description: Enabled rule 1 permits WAN traffic to web-srv-01 on the dmz interface for HTTP and HTTPS; together with the displayed deny rule, this provides service-scoped inbound access, but HTTP remains permitted and the partial export does not prove the complete effective policy.
Category: Technical
Function: Preventive
Asset(s) Protected: web-srv-01 and the configured DMZ boundary
Source: Artifact 1 — FortiGate policy, edit 1, Allow-Web-Inbound
```

```text
Control ID: C-002
Control Name: VPN source and destination scoping
Description: Enabled rules 2 and 3 scope VPN access to the Westside/HQ source objects and server-subnet destination object; both allow ALL services, so they provide limited zone/address scoping rather than least-privilege service access, and object definitions and tunnel cryptography are not supplied.
Category: Technical
Function: Preventive
Asset(s) Protected: Central server subnet and intersite VPN boundaries
Source: Artifact 1 — FortiGate policies, edits 2 and 3
```

```text
Control ID: C-003
Control Name: Catch-all firewall denial
Description: Enabled rule 5 denies traffic matching its any-interface/all-address scope if it reaches this rule; it does not undo the broad permissions in preceding rules, and full rule order must be verified from the complete configuration.
Category: Technical
Function: Preventive
Asset(s) Protected: Traffic traversing the FortiGate policy boundary
Source: Artifact 1 — FortiGate policy, edit 5, Deny-All
```

```text
Control ID: C-004
Control Name: Firewall traffic logging and local retention
Description: Rules 1 and 5 specify logtraffic all; rules 2–4 specify logtraffic utm, which does not by itself establish complete session logging or enabled inspection profiles; firewall logs are stored locally for 30 days with no forwarding or automated security alerting.
Category: Technical
Function: Detective
Asset(s) Protected: FortiGate-protected network zones and traffic investigations
Source: Artifacts 1 and 8 — policy logging settings and local FortiGate logs
```

```text
Control ID: C-005
Control Name: SSH key-only authentication
Description: PubkeyAuthentication yes, PasswordAuthentication no and ChallengeResponseAuthentication no implement the key-only migration confirmed by the administrator; PermitEmptyPasswords no additionally rejects empty passwords where relevant, but is not a separate effective password barrier while password authentication is disabled.
Category: Technical
Function: Preventive
Asset(s) Protected: ehr-srv-01 SSH access only
Source: Artifact 2 — SSH Authentication section and Tom Reeves note
```

```text
Control ID: C-006
Control Name: SSH direct root-login prohibition
Description: PermitRootLogin no blocks direct SSH login as root, requiring access through another permitted identity; it does not establish how subsequent privilege elevation is controlled.
Category: Technical
Function: Preventive
Asset(s) Protected: ehr-srv-01 privileged remote access
Source: Artifact 2 — PermitRootLogin no
```

```text
Control ID: C-007
Control Name: SSH authentication attempt and time limits
Description: MaxAuthTries 3 limits authentication attempts per connection and LoginGraceTime 60 limits the unauthenticated login window; these settings constrain individual connections but do not prove cross-connection account lockout or global brute-force blocking.
Category: Technical
Function: Preventive
Asset(s) Protected: ehr-srv-01 SSH authentication service
Source: Artifact 2 — MaxAuthTries and LoginGraceTime
```

```text
Control ID: C-008
Control Name: SSH unresponsive-client termination
Description: ClientAliveInterval 300 and ClientAliveCountMax 2 configure probes and termination of clients that stop responding; this is connection-liveness handling, not proof of a timeout for an idle human user whose SSH client still responds.
Category: Technical
Function: Preventive
Asset(s) Protected: ehr-srv-01 SSH connection resources
Source: Artifact 2 — ClientAliveInterval and ClientAliveCountMax
```

```text
Control ID: C-009
Control Name: SSH forwarding restrictions
Description: X11Forwarding no and AllowTcpForwarding no disable SSH-provided X11 and TCP forwarding to reduce use of the server as a forwarding path; they do not establish that every possible user-created tunnel is prevented.
Category: Technical
Function: Preventive
Asset(s) Protected: ehr-srv-01 and resources reachable through it
Source: Artifact 2 — Other section, forwarding settings
```

```text
Control ID: C-010
Control Name: SSH protocol-version restriction
Description: The configuration declares Protocol 2, expressing SSH version 2-only operation; effective behavior depends on the installed daemon version and is not independently tested.
Category: Technical
Function: Preventive
Asset(s) Protected: ehr-srv-01 SSH transport
Source: Artifact 2 — Protocol 2
```

```text
Control ID: C-011
Control Name: Verbose SSH authentication logging
Description: SyslogFacility AUTH and LogLevel VERBOSE configure detailed SSH authentication logging; no centralized collection, automated alerting or integrity protection is evidenced.
Category: Technical
Function: Detective
Asset(s) Protected: ehr-srv-01 access accountability and investigations
Source: Artifact 2 — Logging section; Artifact 8 — logging limitations
```

```text
Control ID: C-012
Control Name: Approved password requirements policy
Description: Policy version 1.2 sets password requirements for employees, contractors and vendors, including length, complexity, rotation, history and lockout; it was approved two years ago and last reviewed 18 months ago, and its MFA recommendation is not a mandate.
Category: Administrative
Function: Preventive
Asset(s) Protected: MedDefense information-system accounts within the stated policy scope
Source: Artifact 3 — sections 1, 2, 4 and 5, approval and review metadata
```

```text
Control ID: C-013
Control Name: Windows password length and complexity enforcement
Description: The policy states AD Group Policy enforces an eight-character minimum and uppercase, lowercase, number and special-character requirements on Windows systems; no GPO export is supplied to verify effective settings or exceptions, and Linux-wide enforcement is not established.
Category: Technical
Function: Preventive
Asset(s) Protected: Windows accounts governed by the stated AD Group Policy
Source: Artifact 3 — Password Requirements and Enforcement
```

```text
Control ID: C-014
Control Name: Windows password aging and reuse restrictions
Description: The stated AD Group Policy enforcement requires changes every 90 days and retains the last five passwords to restrict reuse; this documents the existing settings rather than endorsing them as an optimal password standard.
Category: Technical
Function: Preventive
Asset(s) Protected: Windows accounts governed by the stated AD Group Policy
Source: Artifact 3 — Rotation, History and Enforcement
```

```text
Control ID: C-015
Control Name: Windows failed-login account lockout
Description: The policy specifies account lockout after five failed attempts for 30 minutes and states Windows enforcement through AD Group Policy; effective deployment is reported in the policy, not demonstrated by a configuration export.
Category: Technical
Function: Preventive
Asset(s) Protected: Windows accounts governed by the stated AD Group Policy
Source: Artifact 3 — Lockout and Enforcement
```

```text
Control ID: C-016
Control Name: Shared-account departure password-change requirement
Description: The policy requires shared-account passwords to change whenever a user with access leaves, limiting continued access by departed users if followed; shared accounts remain permitted when individual accounts are technically infeasible, and execution records are absent.
Category: Administrative
Function: Preventive
Asset(s) Protected: Permitted shared accounts and their associated resources
Source: Artifact 3 — section 3, Shared Accounts
```

```text
Control ID: C-017
Control Name: Sophos malicious-content blocking
Description: Recent detections show PUA.CryptoMiner blocked on WS-FIN-12 and Phish.URL blocked on WS-ADMIN-03, evidencing a preventive blocking capability on those endpoints; the report does not establish complete endpoint or server protection.
Category: Technical
Function: Preventive
Asset(s) Protected: Reported Sophos-protected Windows workstations, including WS-FIN-12 and WS-ADMIN-03
Source: Artifact 4 — Recent Detections and Platform Breakdown
```

```text
Control ID: C-018
Control Name: Sophos threat detection records
Description: The console report records named threats, affected workstations and actions over the last 30 days, supporting discovery and investigation of malware and suspicious content; alert delivery and analyst response are not described.
Category: Technical
Function: Detective
Asset(s) Protected: Reported Sophos-protected workstations
Source: Artifact 4 — Recent Detections
```

```text
Control ID: C-019
Control Name: Sophos quarantine response
Description: Recorded quarantine actions isolate Adware.Generic on WS-RECEPT-01 and Trojan.GenericKD on WS-NURSE-3F-07 following detection, providing a corrective containment action without proving complete host cleanup or recovery.
Category: Technical
Function: Corrective
Asset(s) Protected: WS-RECEPT-01 and WS-NURSE-3F-07; quarantine capability evidenced on these hosts
Source: Artifact 4 — Recent Detections, Quarantined actions
```

```text
Control ID: C-020
Control Name: Endpoint signature-maintenance mechanism
Description: The status report identifies 341 devices with current signatures and 31 with outdated signatures, evidencing signature maintenance for part of the estate; the update schedule and deployment consistency are not supplied.
Category: Technical
Function: Preventive
Asset(s) Protected: Devices whose signature status is reported by Sophos
Source: Artifact 4 — Coverage, signature currency
```

```text
Control ID: C-021
Control Name: Endpoint protection health reporting
Description: The Sophos console identifies outdated signatures and 15 non-reporting devices, making protection gaps visible for follow-up; seven non-reporting devices may be lost or decommissioned and the totals require reconciliation.
Category: Technical
Function: Detective
Asset(s) Protected: Sophos-managed device inventory and endpoint protection coverage
Source: Artifact 4 — Deployment Summary and Notes
```

```text
Control ID: C-022
Control Name: Scheduled local backups and retained recovery points
Description: Veeam Nightly-Full is configured daily at 02:00 to NAS-01 with 14-day retention for the six explicitly listed servers; the corrective purpose is restoration after loss, although current job success and complete recovery are unverified and no offsite copy exists.
Category: Technical
Function: Corrective
Asset(s) Protected: ehr-srv-01, ehr-db-01, billing-srv-01, ad-dc-01, file-srv-01 and web-srv-01
Source: Artifact 5 — Schedule, What Is Backed Up and Offsite/Cloud Backup
```

```text
Control ID: C-023
Control Name: Backup-storage disk redundancy
Description: NAS-01 is a Synology DS1621+ with 24 TB RAID5, providing disk-failure tolerance for the local backup repository; redundancy is preventive for a single-disk failure-related interruption, not protection against room loss, deletion or ransomware.
Category: Technical
Function: Preventive
Asset(s) Protected: NAS-01 backup storage availability
Source: Artifact 5 — Destination, NAS-01 RAID5
```

```text
Control ID: C-024
Control Name: Partial recovery testing
Description: A documented partial restore of file-srv-01 eight months ago checked recoverability and exposed a six-hour single-server recovery time; classified as detective because testing identifies recovery weaknesses, with no full disaster-recovery test or recurring test schedule evidenced.
Category: Administrative
Function: Detective
Asset(s) Protected: file-srv-01 backup recovery capability
Source: Artifact 5 — Recovery Testing
```

```text
Control ID: C-025
Control Name: Main-entrance badge verification
Description: A uniformed guard verifies badges at Central main entrance Monday–Friday, 07:00–19:00, providing a staffed physical access check; the guard does not patrol floors or restricted areas and no night/weekend service is included.
Category: Physical
Function: Preventive
Asset(s) Protected: Central main-entrance access boundary
Source: Artifact 6 — Services Provided, hours, position and duties
```

```text
Control ID: C-026
Control Name: Uniformed entrance-guard presence
Description: The visible uniformed guard at Central main entrance can discourage opportunistic unauthorized entry during the contracted hours; this deterrent function is inferred from the evidenced visible presence, not evidence of successful deterrence or wider patrol coverage.
Category: Physical
Function: Deterrent
Asset(s) Protected: Central main entrance during contracted coverage
Source: Artifact 6 — one uniformed guard, position and hours
```

```text
Control ID: C-027
Control Name: Visitor registration process
Description: The guard registers visitors at the main-entrance sign-in desk during contracted hours, creating an administrative record that can support later investigation; completeness, retention and visitor escort procedures are not supplied.
Category: Administrative
Function: Detective
Asset(s) Protected: Central visitor accountability at the main entrance
Source: Artifact 6 — visitor sign-in desk and Visitor Registration duty
```

```text
Control ID: C-028
Control Name: Guard incident-reporting process
Description: The contract assigns incident reporting to the entrance guard, providing a human reporting channel for observed events during coverage; response procedures, escalation times and actual report records are absent.
Category: Administrative
Function: Detective
Asset(s) Protected: Central main-entrance security events
Source: Artifact 6 — Duties, Incident Reporting
```

```text
Control ID: C-029
Control Name: Central camera surveillance and recording
Description: Four analog cameras cover the main entrance (two), ER entrance (one) and parking garage entrance (one), recording to a standalone security-desk DVR for 30 days; monitoring is informal and IT areas and the administrative wing are not covered.
Category: Physical
Function: Detective
Asset(s) Protected: Central entrance areas specified in the camera inventory
Source: Artifact 6 — Camera System, Central; camera-monitoring exclusion
```

```text
Control ID: C-030
Control Name: Westside entrance camera recording
Description: One front-entrance camera records locally to an SD card with approximately 48 hours before overwrite, supporting short-term review of entrance events; it does not establish coverage of the server closet or active monitoring.
Category: Physical
Function: Detective
Asset(s) Protected: Westside Clinic front entrance
Source: Artifact 6 — Camera System, Westside Clinic
```

```text
Control ID: C-031
Control Name: HQ building-managed camera surveillance
Description: Building-managed cameras cover the HQ lobby and elevator, providing third-party physical surveillance; MedDefense has no footage access, and retention, monitoring and an evidence-request process are not documented.
Category: Physical
Function: Detective
Asset(s) Protected: HQ building lobby and elevator
Source: Artifact 6 — Camera System, Corporate HQ
```

```text
Control ID: C-032
Control Name: Annual security awareness training
Description: Mandatory annual CyberSafe Basics covers password hygiene, phishing recognition, tailgating, clean-desk behavior and reporting suspicious activity; last delivery was ten months ago, with reported completion of 94% at HQ, 71% at Central and 58% at Westside, and no PHI-specific or role-specific modules.
Category: Administrative
Function: Preventive
Asset(s) Protected: Staff handling of information and physical access across all three sites
Source: Artifact 7 — Security Awareness Training, completion and content
```

```text
Control ID: C-033
Control Name: Training completion tracking
Description: HR maintains a training log with site-level completion counts, enabling identification of participation gaps; James explicitly raised Westside completion with HR, but no completed enforcement action or improved completion is evidenced.
Category: Administrative
Function: Detective
Asset(s) Protected: Organization-wide security awareness program participation
Source: Artifact 7 — Training_Log.xlsx summary and James/HR correspondence
```

```text
Control ID: C-034
Control Name: Windows and Active Directory local event logging
Description: Windows servers record events accessible in Event Viewer and AD records critical events, providing local evidence for troubleshooting and investigation; collection is not centralized and security alerting is absent.
Category: Technical
Function: Detective
Asset(s) Protected: Windows servers and Active Directory services
Source: Artifact 8 — Windows server events and AD critical-event logs
```

```text
Control ID: C-035
Control Name: Linux local system logging
Description: Linux servers write standard syslog records under /var/log, retaining local evidence for investigation; no centralization, integrity protection or retention duration is provided, and specific ehr-srv-01 SSH verbosity is separately documented in C-011.
Category: Technical
Function: Detective
Asset(s) Protected: Linux servers
Source: Artifact 8 — Linux /var/log and standard syslog
```

```text
Control ID: C-036
Control Name: Apache access to retained web-service logs
Description: Apache logs on web-srv-01 and billing-srv-01 rotate weekly with four weeks retained via logrotate, preserving a limited local investigation window; the exact logged fields, routine review and protection against tampering are not supplied.
Category: Technical
Function: Detective
Asset(s) Protected: Apache services on web-srv-01 and billing-srv-01
Source: Artifact 8 — Apache logs and logrotate retention
```

```text
Control ID: C-037
Control Name: Vendor-managed EHR audit logging
Description: The EHR application maintains an audit log managed by its vendor, with exports available on request after 48 hours; this supports retrospective investigation but not demonstrated real-time detection, and event coverage and retention are unspecified.
Category: Technical
Function: Detective
Asset(s) Protected: EHR application activity and accountability
Source: Artifact 8 — EHR application audit log
```

```text
Control ID: C-038
Control Name: Reactive manual event-log review
Description: IT manually checks Windows and AD logs when something breaks, providing an existing human investigation practice; it is reactive and does not establish scheduled threat hunting, continuous monitoring or a formal incident-response procedure.
Category: Administrative
Function: Detective
Asset(s) Protected: Windows and AD service incidents investigated by IT
Source: Artifact 8 — manual checks when something breaks
```

## Control Summary Matrix

| Category | Preventive | Detective | Corrective | Compensating | Deterrent |
|---|---|---|---|---|---|
| **Technical** | C-001, C-002, C-003, C-005, C-006, C-007, C-008, C-009, C-010, C-013, C-014, C-015, C-017, C-020, C-023 | C-004, C-011, C-018, C-021, C-034, C-035, C-036, C-037 | C-019, C-022 |  |  |
| **Administrative** | C-012, C-016, C-032 | C-024, C-027, C-028, C-033, C-038 |  |  |  |
| **Physical** | C-025 | C-029, C-030, C-031 |  |  | C-026 |

Empty cells indicate no control evidenced in that category/function combination in these artifacts. They are potential review gaps, not proof that a control is absent throughout the organization or that every cell must be populated.

## Evidence limitations and potential gaps

- **Firewall scope:** The export is partial. VPN rules allow all services and outbound rule 4 permits all destinations/services. NAT is not counted as a substitute for egress filtering; no inspection profile, IDS/IPS, effective encrypted-tunnel configuration or fine-grained VPN restrictions are demonstrated. The DMZ interface name is configuration evidence, not validation of the full topology. Marcus's crypto-miner note is a reported observation, not a forensic finding verified by this inventory.
- **SSH and identity:** The hardened SSH extract applies only to ehr-srv-01. Other Linux servers reportedly allow passwords. UsePAM yes alone does not identify a specific additional PAM control; PermitEmptyPasswords no is included with authentication rather than counted twice. The SSH liveness settings must not be described as an unattended-user screen lock. MFA is recommended, not required or evidenced as deployed in this source package. Shared-account password-change compliance is unverified.
- **Sophos scope and inconsistent counts:** Coverage totals report 387 managed devices (341 current, 31 outdated, 15 not reporting), while the platform section lists 372 covered workstations plus 15 Windows servers explicitly NOT covered. These figures must be reconciled; 387 must not be presented as 387 protected endpoints. Linux servers and mobile devices are outside stated coverage, no MDM/EMM exists, and some non-reporting devices may be lost or decommissioned. Detection history demonstrates selected actions, not complete protection.
- **Backup coverage and recoverability:** The job says all VMs in the Central VMware cluster, but the packet supplies six included systems and explicit exclusions; confirm cluster membership and actual job scope. PACS, ad-dc-02, print-srv-01, ws-srv-01, medical-device configurations and O365 data are explicitly excluded. The statement that Microsoft handles O365 is not evidence of a separately configured recovery control. Backups are local, on the same network and in the same room; no offsite copy exists. A single historical partial restore does not demonstrate current backup success or full disaster recovery. RAID5 is not an offsite copy or a documented compensating control for missing backup isolation.
- **Physical coverage:** Guard service covers only Central's main entrance during specified weekday hours, with no patrols. Entrance visitor registration does not demonstrate a server-room visitor log. Camera scope and retention vary by site; no Central server-room, network-closet or administrative-wing camera coverage is listed. HQ footage is not accessible to MedDefense. Contracted camera monitoring is excluded, so informal viewing is not represented as a dedicated monitoring service. Badge verification does not prove the existence or configuration of electronic badge readers in these artifacts.
- **Training:** Completion remains incomplete, particularly at Westside; no phishing simulations, role-specific training or digital PHI-handling training are evidenced. Training about reporting suspicious activity does not by itself establish a formal reporting workflow or incident-response plan. HR's intention to add content in a future cycle is not a deployed control.
- **Logging:** Local logs and reactive review exist, but central collection, automated security alerting and log-integrity protection are explicitly absent. The EHR export delay limits timely investigation. Wazuh was researched but never installed and is excluded.
- **Matrix interpretation:** No expressly adopted compensating mechanism is documented. The empty Administrative/Corrective cell highlights the need to establish documented recovery and response procedures beyond the reported partial test. Empty Physical/Corrective and other cells warrant scope-based review; new controls must not be invented to fill the matrix. All categories contain evidenced controls, but matrix density does not measure security maturity.
