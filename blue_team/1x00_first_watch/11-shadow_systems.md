# MedDefense Health Systems — Shadow Systems Assessment

Prepared for: James Chen, Deputy CISO  
Prepared by: Junior Security Analyst  
Scope: Task 11 — assessment of Mike Torres's three reported shadow systems; no device access, migration or shutdown performed.

Sources: **T11** = the supplied helpdesk account; [Task 7 Asset Registry](7-asset_registry.md), including prior scan identities; [Task 9 Data Map](9-data_map.md); [Task 10 Complete Control Matrix](10-complete_control_matrix.md). Control IDs retain their Task 10 meanings. Data contents, ownership, configuration and backup state have not been inspected. Lack of organizational control coverage does not prove that a personal provider or device has no built-in safeguards.

## 1. Dr. Patel's Personal NAS

### Risk Assessment

**Sensitive data or access:** Mike reports research data stored on a personally purchased NAS connected to a Cardiology office wall port. It could include patient-linked measurements, images or research working files, but no dataset or consent/access documentation has been inspected. Patient-identifiable health information would be **Restricted** under Task 9; non-public research intellectual property would normally merit at least **Confidential** handling, subject to content review. “Research data” does not itself prove a formal clinical-trial program or establish a connection to the institution's EHR.

**Official controls that do not demonstrably cover it:** C-022 backs up six named servers, not this NAS; C-023 protects the official NAS-01's disks and cannot be transferred to this device by analogy. C-017–C-021 cover reported Sophos endpoints, not an unmanaged NAS; C-013–C-015 Windows password policy is not evidenced on it. C-034–C-038 local/application logging does not establish collection of NAS events, and C-056's scan has not identified its address. C-003 may protect perimeter-crossing traffic, but does not establish isolation from the flat internal network; C-039 server-room access does not cover Dr. Patel's office.

**Worst-case scenario:** If the NAS contains identifiable patient data, an attacker could steal it (Confidentiality), alter research files relied on by staff (Integrity), or encrypt/delete the only copy (Availability). A compromised NAS might also be used to attempt access to other reachable systems, but network reachability does not establish credentials or successful lateral movement. Research results influencing care would add a safety consequence, which must be verified rather than assumed. Priority is provisionally High, escalating if Restricted data and absent recovery are confirmed.

### Recommended Response — Migrate

Move the data to an approved, IT-owned repository whose access, capacity, performance and recovery are verified for the actual dataset. This addresses the stated reason for the bypass—the shared drive's poor performance—rather than directing the clinician back to an unusable service. The existing file-srv-01 is a candidate because it is within C-022 scope, not an automatically suitable destination; bandwidth, quota, segregation, encryption and restore capability need validation.

First establish ownership and lawful data-handling responsibilities, inventory/classify the files, and preserve available access records or other evidence of suspected misuse. Copy securely, validate file integrity and access permissions, test retrieval/recovery, and have Dr. Patel confirm the working dataset before disabling use of the personal NAS. Coordinate sanitization or return of the personal device only after retention and evidence obligations are resolved; do not erase the only copy or remove the device from clinical use without checking dependencies. Migration is proposed, so its registry status remains Shadow IT until governance and transition are complete.

## 2. Marketing Google Drive Linked to Personal Gmail

### Risk Assessment

**Sensitive data or access:** The drive contains media files and press communications. Approved published material can be **Public**, while embargoed announcements, drafts, contact lists and non-public business plans may be **Confidential**; patient-identifiable photographs or case stories would require **Restricted** review if present. Marketing's subject matter alone does not establish that every file is harmless or that a consent record exists. Sharing links and collaborator identities may expose additional information.

**Official controls that do not demonstrably cover it:** C-013–C-015 AD password policy and C-016 departure handling are not established for the personal Gmail identity. C-041 is MFA on James's account, not this one. C-022 does not cover the personal Google Drive, and C-034–C-038 do not establish organizational access to its cloud audit records. C-017–C-021 may protect some accessing workstations but not the cloud account, sharing rules or independent data recovery. C-032 training is a broad partial safeguard, not technical enforcement of external sharing.

**Worst-case scenario:** Account takeover or overbroad sharing could expose embargoed communications or identifiable patient media (Confidentiality), alter approved messages (Integrity), or remove files/account access when the employee leaves (Availability). An attacker could use the account to impersonate Marketing and damage public trust. Provider recovery/versioning, if available, is not a substitute for demonstrated organization-owned access and recovery; no actual disclosure is alleged.

### Recommended Response — Migrate

Move the business content to an organization-owned collaboration workspace, with MedDefense's existing O365/SharePoint service a candidate destination after validation. Give Marketing a practical controlled sharing process, named business ownership, group-based permissions and supported strong authentication. The existing O365 subscription provides a governed identity/service starting point, but its backup exclusion in the artifacts means suitable retention, audit access and recovery must be established before calling the destination fully protected.

Inventory owners, collaborators and links; separate published material from confidential drafts and any Restricted content; and preserve records relevant to an incident or retention requirement. Validate transferred files and permissions with Marketing, update approved external links, and then revoke obsolete business sharing. Separate personal files from organizational material and coordinate removal of company data without deleting the person's entire Gmail account. No automatic transfer of security from the user's workstation to the cloud service is assumed.

## 3. Unmaintained Raspberry Pi Network Monitor

### Risk Assessment

**Sensitive data or access:** The Pi reportedly served as a network monitor, but its exact function is unknown. Depending on configuration, it could hold network topology, addresses, inventory, administrator keys, monitoring tokens or packet captures; captures may contain patient data or credentials only if such traffic was actually visible and collected. Privileged secrets and identifiable clinical payloads would be **Restricted**, with operational monitoring information generally **Confidential**. Do not infer that a device on a switched network automatically sees all traffic, or that the phrase “monitor” proves port mirroring or IDS operation.

**Official controls that do not demonstrably cover it:** C-005–C-011 apply only to ehr-srv-01, not this Pi. C-017–C-021 do not establish Raspberry Pi/Linux coverage under the purchased Sophos tier; C-022 excludes any unlisted host, and C-035's broad Linux-logging description does not prove this unmanaged device is configured or reviewed. C-004/C-037 do not turn it into a centrally managed detector. C-056 exposes unknown hosts but has not linked an IP to this hardware. Marcus's possible request is not evidence of formal approval, a support owner or an operating monitoring process.

**Worst-case scenario:** Compromise could disclose collected traffic or secrets (Confidentiality), falsify monitoring output to hide activity (Integrity), or remove the visibility staff depend on if the tool has an undocumented operational role (Availability). The Pi could also become a foothold from which an attacker attempts to reach internal systems. The account does not establish that monitoring ever functioned, that the Pi is infected or that its removal is harmless.

### Recommended Response — Decommission

The reported tool has no current custodian or demonstrated monitored service, so leaving an unvalidated device indefinitely connected is not justified by its presumed security purpose. Before removal, identify its hardware and address, consult IT and James about the original request, record services/configuration and check whether any active workflow depends on it. Preserve relevant logs or captures through approved handling, classify and retain them as required, revoke any associated keys/tokens, then disconnect through a coordinated change and sanitize or repurpose the device after evidence/retention needs are resolved.

If review establishes an essential monitoring function, arrange a governed replacement before removing the Pi, or revisit the decision as Legitimize and Secure with a named owner, supported configuration and testable operational value. That is a conditional review trigger, not permission to count the current Pi as an effective detective control. Decommissioning an unvalidated monitor does not close MedDefense's broader monitoring gap; that still requires an approved detection and response service.

## Asset Registry Update and Reconciliation

The [Asset Registry](7-asset_registry.md) now contains the following additional records. All are **Shadow IT** as requested; status does not change until the recommended action is implemented and verified.

| Asset ID | Name | Type | Location | Owner (Dept) | OS/Platform | Critical Services | Network Segment | Status | Notes |
|---|---|---|---|---|---|---|---|---|---|
| A-124 | Dr. Patel personal NAS | Data Store | Central, Cardiology office | Dr. Patel / Cardiology, reported user; formal IT owner absent | Personal NAS; vendor/OS unknown | Reported research-file storage; clinical dependence unverified | Office wall connection; IP/VLAN unknown | Shadow IT | T11; contents/classification pending; migrate after verified secure destination and data validation; do not equate with NAS-01 or either unknown scan host. |
| A-125 | Marketing personal-account Google Drive | Application | External cloud; data region unknown | Marketing; personal Gmail account owner unspecified | Google Drive linked to personal Gmail | Media collaboration and press communications | Internet/cloud; no internal IP established | Shadow IT | T11; validate sharing, ownership and data sensitivity; migrate to organization-owned workspace with verified access and recovery. |
| A-126 | Former intern Raspberry Pi monitor | Endpoint | Central, second floor; exact placement unknown | IT/security purpose alleged; current custodian absent | Raspberry Pi; OS/services unknown | Alleged network monitoring; effectiveness/dependencies unverified | Internal connection; IP/VLAN unknown | Shadow IT | T11; preserve evidence and validate dependencies before decommissioning; identity may overlap an unknown scan record, but no match is confirmed. |

These additions produce **126 registry records, not 126 verified unique physical assets**. A-124 or A-126 might overlap an earlier unidentified record, particularly Central's A-047, but neither an IP match nor a hardware match is provided. The Westside unknown A-080 remains unresolved and must not be assigned to a device reported at Central without contrary evidence. Older status text “Shadow IT (unmanaged)” in Task 7 has the same governance meaning; the three new entries use the requested exact label.

The new description of Dr. Patel's research data qualifies earlier statements about MedDefense having no formal research programs: individual research files and an institution-level clinical-trial program are different claims. Confirm the data's purpose, subject identity, partners and authorization before revising threat likelihood or asserting a formal research program. Existing 123-record totals in earlier reports reflect their preparation date and require refresh in a subsequent consolidated revision, not silent reinterpretation.

## Shadow IT Policy Recommendation

Adopt one mandatory, service-backed **IT approval and registration policy for every device and cloud service used to store, process or access MedDefense information**, including personally purchased equipment and personal-account services. Make the policy practical through a short request process with a named owner, published response target, data classification and minimum access/recovery requirements before onboarding, plus a documented escalation route when approved services fail clinical or business needs. Require renewal of ownership when staff leave and reconciliation of approved records with discovery results; existing unregistered systems should enter a coordinated review that protects data and continuity rather than encouraging concealment. This policy addresses the common cause across all three cases: departments bypassing governance to meet a perceived need without an accountable long-term support and security owner.
