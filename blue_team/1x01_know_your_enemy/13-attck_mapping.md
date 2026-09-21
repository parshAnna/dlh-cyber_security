# MedDefense Health Systems — MITRE ATT&CK Mapping

Prepared for: James Chen, Deputy CISO

Prepared by: Junior Security Analyst

Scope: Step-by-step mapping of both narratives in the supplied [ATT&CK scenario file](https://s3.eu-west-3.amazonaws.com/hbtn.intranet/uploads/text/2026/3/40c37113122d59624e9a28d12024c7c531b9280e.txt), using the 14 Enterprise tactics specified by the assignment and technique names and IDs verified against the official [MITRE ATT&CK Enterprise knowledge base](https://attack.mitre.org/techniques/).

## Mapping Method

The supplied file contains **nine** numbered steps in Scenario Alpha and **eight** in Scenario Beta, so all 17 are mapped. Where one narrative step contains several ATT&CK behaviors, the **Tactic** and **Technique** fields identify the dominant behavior and the **Alternatives** field records other defensible mappings rather than silently assigning several primary tactics. MedDefense factors come from the First Watch asset, control and gap artifacts and from facts stated directly in these two scenarios; a listening port or flat path is not treated as successful authorization by itself.

## Scenario Alpha — Operation Flatline

### Step 1: Fortinet appliance target list acquired

- **Tactic:** Reconnaissance
- **Technique:** [Gather Victim Network Information: Network Security Appliances (T1590.006)](https://attack.mitre.org/techniques/T1590/006/)
- **Alternatives:** [Active Scanning: Scanning IP Blocks (T1595.001)](https://attack.mitre.org/techniques/T1595/001/) describes how the broker built the list; Vulnerability Scanning (T1595.002) would apply only if the scan tested versions or flaws rather than merely identifying interfaces.
- **MedDefense Factor:** MedDefense depends on FortiGate 100F A-086 for perimeter and VPN services, its firmware is unknown, and GAP-015 records incomplete public-facing remediation evidence; much of this pre-compromise reconnaissance occurs outside C-004's limited boundary visibility.

### Step 2: Fortinet-themed email delivers the reverse shell

- **Tactic:** Initial Access
- **Technique:** [Phishing: Spearphishing Link (T1566.002)](https://attack.mitre.org/techniques/T1566/002/)
- **Alternatives:** [User Execution: Malicious Link (T1204.001)](https://attack.mitre.org/techniques/T1204/001/) covers Sarah following the portal link, [User Execution: Malicious File (T1204.002)](https://attack.mitre.org/techniques/T1204/002/) covers opening the downloaded document, and [PowerShell (T1059.001)](https://attack.mitre.org/techniques/T1059/001/) covers payload execution.
- **MedDefense Factor:** The Fortinet support pretext is relevant to Sarah Park's IT role, WS-HQ-01 A-081 is a Windows 11 workstation with a trusted site-to-site path to Central, and C-032 training is incomplete and not role-specific; C-017–C-021 can protect covered workstations but the scenario establishes successful execution.

### Step 3: Scheduled task preserves the reverse-shell foothold

- **Tactic:** Persistence
- **Technique:** [Scheduled Task/Job: Scheduled Task (T1053.005)](https://attack.mitre.org/techniques/T1053/005/)
- **Alternatives:** The scheduled task also performs Execution; [Application Layer Protocol: Web Protocols (T1071.001)](https://attack.mitre.org/techniques/T1071/001/) would describe Command and Control only if the reverse shell uses HTTP or HTTPS, which the narrative does not specify.
- **MedDefense Factor:** The backdoor runs every 30 minutes under a Windows Update disguise, while C-034/C-038 provide local, reactive Windows event review rather than a demonstrated central alert for newly created scheduled tasks.

### Step 4: Internal hosts, domain groups and routes are enumerated

- **Tactic:** Discovery
- **Technique:** [Remote System Discovery (T1018)](https://attack.mitre.org/techniques/T1018/)
- **Alternatives:** [Permission Groups Discovery: Domain Groups (T1069.002)](https://attack.mitre.org/techniques/T1069/002/) maps `net group "Domain Admins" /domain`, while System Network Configuration Discovery (T1016) maps `arp -a` and local network information.
- **MedDefense Factor:** HQ connects to Central through A-110, C-002 permits ALL services toward the Central server subnet, and the reported flat `10.10.0.0/16` environment exposes AD, EHR, billing and backup addresses to broad discovery under GAP-016.

### Step 5: Mimikatz extracts the `svc_backup` NTLM hash

- **Tactic:** Credential Access
- **Technique:** [OS Credential Dumping: LSASS Memory (T1003.001)](https://attack.mitre.org/techniques/T1003/001/)
- **Alternatives:** OS Credential Dumping: Cached Domain Credentials (T1003.005) would be an alternative only if the material came from cached domain-logon storage rather than the memory-resident session described.
- **MedDefense Factor:** Sarah has local administrator rights and a domain-admin backup identity was used on her ordinary workstation, collapsing administrative tiers; C-013–C-015 govern passwords and lockout but do not prevent privileged credential residue, and C-034 review is reactive.

### Step 6: Pass-the-hash obtains Domain Admin access

- **Tactic:** Lateral Movement
- **Technique:** [Use Alternate Authentication Material: Pass the Hash (T1550.002)](https://attack.mitre.org/techniques/T1550/002/)
- **Alternatives:** Remote Services would describe the underlying connection if its protocol were supplied, and the subsequent computer-object query is additional Discovery rather than the principal movement action.
- **MedDefense Factor:** The captured `svc_backup` hash carries Domain Admin privilege, ad-dc-01 A-040 is reachable across the broad internal path, and C-050's second controller supports availability but does not stop misuse of a valid privileged identity; C-034 lacks demonstrated real-time alerting.

### Step 7: EHR and file data are compressed and sent to cloud storage

- **Tactic:** Exfiltration
- **Technique:** [Exfiltration Over Web Service: Exfiltration to Cloud Storage (T1567.002)](https://attack.mitre.org/techniques/T1567/002/)
- **Alternatives:** [Data from Information Repositories: Databases (T1213.006)](https://attack.mitre.org/techniques/T1213/006/) maps `pg_dump`, and [Archive Collected Data: Archive via Utility (T1560.001)](https://attack.mitre.org/techniques/T1560/001/) maps compression before Rclone transfers the archive.
- **MedDefense Factor:** `ehr-db-01` A-037/A-112 exposes PostgreSQL 5432 broadly under GAP-006, patient bulk-export safeguards are incomplete under GAP-017, and HTTPS cloud egress can blend with permitted traffic while C-037's EHR audit export is delayed.

### Step 8: NAS backups and Windows shadow copies are deleted

- **Tactic:** Impact
- **Technique:** [Inhibit System Recovery (T1490)](https://attack.mitre.org/techniques/T1490/)
- **Alternatives:** Data Destruction (T1485) is a broader alternative for deleted stored data, but T1490 is more specific because both NAS backups and Volume Shadow Copies are targeted to prevent restoration.
- **MedDefense Factor:** NAS-01 A-045 exposes management on 5001 and shares network and physical failure domains with production; C-022/C-023 provide local backups and RAID, but neither prevents logical deletion with compromised administrative access, matching GAP-007.

### Step 9: GPO and SSH distribute ransomware

- **Tactic:** Impact
- **Technique:** [Data Encrypted for Impact (T1486)](https://attack.mitre.org/techniques/T1486/)
- **Alternatives:** [Domain or Tenant Policy Modification: Group Policy Modification (T1484.001)](https://attack.mitre.org/techniques/T1484/001/) maps deployment through AD, while [Remote Services: SSH (T1021.004)](https://attack.mitre.org/techniques/T1021/004/) maps separate access to Linux servers.
- **MedDefense Factor:** Domain Admin control can reach domain-joined Windows systems through GPO, C-051 permits password SSH on Linux hosts such as `billing-srv-01`, and endpoint protection excludes Windows and Linux servers. C-005 reports key-only SSH on `ehr-srv-01`, so the narrative's separate EHR SSH access would require a usable key or configuration drift rather than a password alone.

## Scenario Beta — The Quiet Departure

### Step 1: An authorized employee decides to misuse existing access

- **Tactic:** Initial Access
- **Technique:** [Valid Accounts: Domain Accounts (T1078.002)](https://attack.mitre.org/techniques/T1078/002/)
- **Alternatives:** The parent Valid Accounts technique T1078 is safer if the billing and EHR identities are not AD-backed; the narrative establishes legitimate accounts but does not document the applications' authentication architecture.
- **MedDefense Factor:** Maria already has billing access and read-only EHR access for verification work, so no exploit is needed; GAP-011 records weak identity governance and C-037 supplies delayed application auditing rather than timely purpose-of-access detection.

### Step 2: Accessible billing and EHR information is surveyed

- **Tactic:** Discovery
- **Technique:** [File and Directory Discovery (T1083)](https://attack.mitre.org/techniques/T1083/)
- **Alternatives:** ATT&CK has no exact application-record discovery sub-technique; [Data from Information Repositories: Databases (T1213.006)](https://attack.mitre.org/techniques/T1213/006/) becomes the stronger Collection mapping once Maria begins retrieving records in Step 3.
- **MedDefense Factor:** Maria's normal roles expose billing identity, insurance, diagnosis and amount fields plus read-only histories and prescriptions, and the narrative states that the EHR neither limits records viewed per session nor alerts on abnormal volume.

### Step 3: Built-in EHR export collects patient CSV files

- **Tactic:** Collection
- **Technique:** [Data from Information Repositories: Databases (T1213.006)](https://attack.mitre.org/techniques/T1213/006/)
- **Alternatives:** [Automated Collection (T1119)](https://attack.mitre.org/techniques/T1119/) would apply if the repeated exports were scripted or automatically gathered; the narrative describes paced use of a built-in export function instead.
- **MedDefense Factor:** Every read-authorized user can export without additional approval, GAP-017 records missing bulk-export authorization and detection, and C-037 logs the activity but is not proactively reviewed.

### Step 4: Patient CSV files leave on a personal USB drive

- **Tactic:** Exfiltration
- **Technique:** [Exfiltration Over Physical Medium: Exfiltration over USB (T1052.001)](https://attack.mitre.org/techniques/T1052/001/)
- **Alternatives:** None is more specific because the removable USB medium and transfer action are explicit.
- **MedDefense Factor:** The scenario confirms no USB-restriction GPO and normalizes personal USB use; C-017–C-021 provide malware protection on covered workstations but not data-loss prevention, aligning with GAP-020.

### Step 5: Local CSV files are deleted to hide the activity

- **Tactic:** Defense Evasion
- **Technique:** [Indicator Removal: File Deletion (T1070.004)](https://attack.mitre.org/techniques/T1070/004/)
- **Alternatives:** Clear Windows Event Logs (T1070.001) does not apply because Maria deletes exported files and empties the recycle bin but does not clear event logs or the EHR audit trail.
- **MedDefense Factor:** Local deletion removes the obvious workstation copies, while C-037's separate EHR audit remains vendor-managed, delayed by up to 48 hours and never proactively reviewed in the narrative, so the evasion is incomplete but likely to delay discovery.

### Step 6: Billing database credentials are copied from a configuration file

- **Tactic:** Credential Access
- **Technique:** [Unsecured Credentials: Credentials In Files (T1552.001)](https://attack.mitre.org/techniques/T1552/001/)
- **Alternatives:** Data from Local System (T1005) describes copying a local file generally, but T1552.001 is more specific because the file contains reusable database credentials.
- **MedDefense Factor:** The billing application stores a database secret on Maria's workstation, `billing-srv-01` A-039/A-113 exposes MySQL 3306 broadly, and no evidenced credential vaulting or secret-scanning control removes the reusable material.

### Step 7: Delayed offboarding leaves the account persistent

- **Tactic:** Persistence
- **Technique:** [Valid Accounts: Domain Accounts (T1078.002)](https://attack.mitre.org/techniques/T1078/002/)
- **Alternatives:** The parent Valid Accounts technique T1078 applies if the VPN identity is maintained outside Active Directory; Account Manipulation does not apply because Maria does not change the account herself.
- **MedDefense Factor:** The termination ticket waits five business days with no offboarding SLA or HR-linked automation; C-002/C-004 govern VPN traffic and logs but do not revoke identities, extending the GAP-011 identity-governance concern.

### Step 8: The still-active VPN account enables remote database extraction

- **Tactic:** Initial Access
- **Technique:** [External Remote Services (T1133)](https://attack.mitre.org/techniques/T1133/)
- **Alternatives:** Valid Accounts: Domain Accounts (T1078.002) maps use of the still-active credential, while Data from Information Repositories: Databases (T1213.006) maps the subsequent collection of 400 billing records.
- **MedDefense Factor:** Maria can still enter through the VPN three days after departure, C-002 permits broad VPN services toward the Central server subnet, MySQL 3306 is reachable, and C-004 provides only local logs without demonstrated proactive off-hours or post-termination alerting.

## ATT&CK Coverage Assessment

The primary mappings shared by both attacks are **Initial Access, Persistence, Credential Access, Discovery and Exfiltration**; Collection also occurs in both narratives, although Alpha Step 7 is classified primarily as Exfiltration because Rclone sends the prepared data to cloud storage. This overlap shows that MedDefense urgently needs detection at the reusable identity-and-data choke points rather than only at final Impact: alert on phishing execution and unusual remote logins, scheduled-task creation, privileged credential access and pass-the-hash behavior, broad internal enumeration, abnormal EHR/database export volume, cloud-transfer tools and removable-media writes. Today, C-004/C-034/C-038 are local or reactive, C-037 can delay EHR audit access by 48 hours and the scenario confirms absent USB enforcement and delayed offboarding, so an external ransomware affiliate and a legitimate insider can traverse different entry paths while exploiting the same visibility gaps before encryption or data loss is recognized.
