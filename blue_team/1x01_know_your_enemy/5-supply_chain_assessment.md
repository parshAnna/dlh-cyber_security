# MedDefense Health Systems — Supply Chain Risk Assessment

Evidence: First Watch [onboarding summary](../1x00_first_watch/0-environment_summary.md), its contract extracts (D4), [Asset Registry](../1x00_first_watch/7-asset_registry.md), [Control Matrix](../1x00_first_watch/10-complete_control_matrix.md) and [Gap Analysis](../1x00_first_watch/12-gap_analysis.md), supplemented by the vendor-access facts supplied in this assignment. Risks below describe plausible consequences of compromise, not allegations that any named provider has been breached. Critical denotes potential direct clinical or widespread sensitive-data harm; High denotes substantial exposure whose extent depends on unresolved permissions or dependencies. Ratings are conditional judgments, not measured probabilities.

## 1. MedTech Solutions

```text
Vendor: MedTech Solutions
Service: EHR maintenance and software updates under a $145,000 annual contract; four-hour critical response SLA, not a four-hour restoration guarantee; hardware excluded.
Access Type: Application and direct server maintenance access (third-party maintenance access), as supplied by this task; the remote transport, account privileges and approval process are not documented.
Access Scope: ehr-srv-01 (A-036, 10.10.2.10) and its EHR application (A-111) are the evidenced maintenance target. The application depends on ehr-db-01 (A-037/A-112, 10.10.2.11), holding Restricted patient information. Vendor database privileges, export rights, root access and reach into other systems are not established.
Compromise Scenario: A supply chain attack using compromised vendor credentials or a malicious software update could change the EHR application or interrupt it. If the resulting application access includes usable database credentials, the attacker could read or alter patient records and pursue further reachable systems; broad connectivity alone does not grant those permissions.
Existing Controls: C-005 key-only SSH, C-006 disabled direct root login and C-007–C-011 SSH restrictions/logging protect ehr-srv-01 if that is the maintenance route; they do not authenticate a compromised vendor operator using a valid key. C-022 includes EHR backups but recovery copies share production exposure. C-037 audit exports are delayed. C-054/C-055 establish support/update obligations, not vendor access restrictions. No verified vendor-specific least privilege, privileged access management (PAM), session approval or multifactor authentication (MFA) is evidenced; C-002's broad VPN rules are relevant only if this access uses that path.
Risk Assessment: Critical — the demonstrated maintenance relationship reaches an application central to clinical decisions and sensitive information for over 50,000 patients; malicious application changes could impair treatment or confidentiality. GAP-006, GAP-011 and GAP-016 amplify concern, but organization-wide administrative reach remains unproven.
```

**Answer to James:** We can establish maintenance access to the EHR server, not an exact list of everything the provider can reach. Obtain the maintenance account permissions, connection path, application secrets access and allowed destinations before describing the effective boundary as verified.

## 2. Microsoft

```text
Vendor: Microsoft
Service: Organization-wide O365 E3 email, SharePoint and OneDrive; onboarding records list a $432,000 annual subscription. Identity management through Entra ID is conditional on actual deployment and configuration.
Access Type: Data and Application through cloud hosting and service administration; identity services only where configured. Provider hosting is distinct from unrestricted access by individual support employees.
Access Scope: A-115 covers organizational mailboxes, SharePoint content and OneDrive files, including Confidential business/HR material and Restricted patient information if uploaded. Tenant configuration, exact stored content, provider support access and identity integration are unknown. No direct route from this subscription to on-premises Active Directory or the EHR is established.
Compromise Scenario: A compromise affecting MedDefense's cloud service or its relevant privileged service-management path could expose stored content or interrupt email and document access. If cloud identity is actually integrated with other services, compromised identity administration could extend the effect; that dependency must be verified rather than assumed. Ordinary theft of a user's password is a separate customer-account compromise, not proof of a Microsoft breach.
Existing Controls: C-012/C-032 provide limited policy/training support; C-041 covers only James's unspecified personal account and cannot establish tenant-wide protection. C-022 explicitly excludes O365 backups. The matrix provides no verified tenant access restrictions, cloud audit review, vendor support approvals or independent restoration coverage. On-premises firewall rules do not establish provider-side isolation.
Risk Assessment: High — organization-wide communications and potentially sensitive documents are exposed to a shared service dependency, with weak recovery assurance under GAP-013. Escalate to Critical if clinical dependence, extensive Restricted content or identity integration that could disable care is confirmed.
```

## 3. Sophos

```text
Vendor: Sophos
Service: Endpoint protection, management and agent update/configuration delivery; onboarding records list an $18,000 annual contract.
Access Type: Application through the management/update channel and installed endpoint agents; Data to the extent agents and telemetry permissions allow. Exact service privileges and remote-action capabilities require configuration evidence.
Access Scope: A-117 represents the management platform and enrolled agents on protected workstations, including clinical and administrative devices. The task describes all managed endpoints, but the detailed report lists 372 covered Windows workstations and explicitly excludes Windows servers, Linux servers and mobile devices; 387 managed records and 15 non-reporting devices require reconciliation. Do not infer universal installation or direct agent access to EHR servers.
Compromise Scenario: In a software supply chain compromise, if an attacker controls a trusted update-delivery or management path capable of changing MedDefense agents, a malicious update or configuration could disable protection or execute unwanted actions where permissions allow. Compromised clinical workstations could then expose active patient sessions or provide a route toward servers, subject to those systems' access controls.
Existing Controls: C-017–C-021 document blocking, detection, quarantine, signature maintenance and health reporting, with stale or missing reports. They provide useful protection but are not independent assurance against compromise of their own trusted delivery mechanism. No staged update approval, independent agent-integrity check or verified limitation on vendor administrative actions is evidenced. C-003's perimeter denial does not isolate a compromised internal endpoint.
Risk Assessment: Critical — a trusted delivery path spanning clinical and administrative workstations creates potential simultaneous disruption and loss of the principal endpoint protection layer. The breadth is substantial even with server/mobile exclusions; exact execution privileges, customer scope and successful lateral movement remain conditional.
```

## 4. Siemens

```text
Vendor: Siemens
Service: MRI scanner manufacture and periodic maintenance of the legacy controller and device firmware, as stated in this task. No maintenance price or response commitment is supplied.
Access Type: Application/device maintenance; Physical access is a plausible onsite method, while remote Network maintenance is possible but not documented. Neither transport nor unrestricted physical access is assumed confirmed.
Access Scope: Siemens MAGNETOM scanner A-091 and controller WS-RAD-01 A-016 (10.10.1.70); the controller must transfer studies to PACS A-038 (10.10.2.12). Required communication does not establish vendor PACS login rights or authority to administer other hospital systems.
Compromise Scenario: A compromised maintenance laptop, authorized maintenance identity or accepted firmware package could interfere with the scanner/controller. The shared workstation network could then offer opportunities to reach other systems, while disrupted imaging would affect approximately 45 MRI studies per day; further compromise would still require usable access or vulnerabilities.
Existing Controls: C-003 provides perimeter filtering, not a dedicated MRI boundary; no device-specific access monitoring or recovery is established. C-022 excludes medical-device configuration backups. Task 6's proposed isolation and controlled maintenance measures are not deployed controls. Generic access protections elsewhere in the hospital do not prove supervision of MRI servicing.
Risk Assessment: Critical — manipulation or loss of clinically necessary imaging can directly affect patient care, while GAP-005 leaves the legacy controller insufficiently separated from ordinary workstations. The certified OS cannot be patched, upgraded, replaced or disconnected under the earlier scenario; controls must preserve required imaging functions.
```

**Source reconciliation:** The earlier legacy scenario describes an unnamed acquired manufacturer, while onboarding and this task name Siemens; no Siemens acquisition history is inferred. Verify model, serial number, controller edition and responsible servicing entity. Periodic device firmware maintenance in this task does not prove current firmware or permission to patch the constrained Windows XP Embedded operating system.

## 5. Greenfield Building Management

```text
Vendor: Greenfield Building Management
Service: HQ building network and internet connectivity within the lease; MedDefense uses a VLAN, meaning a logically separated portion of shared equipment.
Access Type: Network infrastructure management and Physical control of building infrastructure. The exact contractual access to MedDefense offices or devices is not supplied.
Access Scope: A-110 supports HQ connectivity, including the MedDefense segment labeled 10.10.20.0/24 and its intersite connection. Network equipment models, VLAN rules, management privileges and VPN termination are unresolved. Managing the network does not automatically allow reading encrypted email, patient records or VPN traffic.
Compromise Scenario: An attacker controlling relevant landlord network administration could change forwarding or separation rules, interrupt HQ connectivity or attempt to redirect or observe traffic. If tenant boundaries or VPN termination are weak, this could create a route toward MedDefense systems; decryption or access beyond that route requires additional conditions.
Existing Controls: The documented tenant VLAN provides logical network segmentation, but effective tenant isolation and access control list (ACL) enforcement are unverified. C-002/C-004 provide some MedDefense VPN scoping and logs, with broad allowed services; their protection depends on the actual connection path. C-031 building cameras are not accessible to MedDefense and do not constrain network administration. No verified provider-management restrictions, tenant assurance review or notification obligations are documented.
Risk Assessment: High — a shared infrastructure compromise could disrupt HQ operations and expose reachable services without timely tenant visibility, matching GAP-021 and GAP-016. Critical clinical access or plaintext patient-data exposure through this provider is not established, so it should not be asserted as inevitable.
```

## Supply Chain Risk Summary

**MedTech Solutions is the highest-priority single-vendor compromise in this assessment** because the supplied direct EHR maintenance access creates the clearest path to altering the application clinicians trust for patient histories, prescriptions and results; data corruption could cause unsafe decisions even while the service appears functional. Sophos also has potentially extensive impact across endpoints, but its server exclusions and unresolved delivery privileges make a direct EHR-compromise path less certain; this ranking favors evidenced clinical reach rather than claiming a measurable worst-case maximum. **The first cross-vendor control should be an Administrative Preventive third-party access management policy enforcing least privilege:** record each provider's permitted systems, data, accounts and maintenance/update channels, authorize only the minimum required scope, require time-limited access where applicable, and revoke access when the need ends. Apply that single governance control differently to each relationship—maintenance permissions for MedTech/Siemens, tenant/provider roles for Microsoft, management and update authority for Sophos, and network administration boundaries for Greenfield—rather than assuming one remote-access gateway covers them all. It establishes the access boundary James currently cannot verify, while further technical enforcement, independent monitoring and recovery remain necessary to address supplier platform compromise.
