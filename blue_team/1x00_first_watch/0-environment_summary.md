# MedDefense Health Systems — Structured Environment Summary

Prepared for: James Chen, Deputy CISO (acting security lead)  
Prepared by: Junior Security Analyst  
Scope: Task 0 — documentary review of the onboarding packet; no live-system validation.

Evidence reference: [MedDefense Internal Documentation Package](https://s3.eu-west-3.amazonaws.com/hbtn.intranet/uploads/text/2026/3/f313f31b0157a0d741006a77b1aff5d54bf3a4c8.txt). References below identify its six documents: **D1** HR guide; **D2** partial asset list; **D3** Marcus Webb's notes; **D4** service contracts; **D5** draft network diagram; **D6** organization chart. The packet uses relative dates and does not establish a reliable assessment date. Documented information is not necessarily current or independently verified. Inferences are explicitly labeled.

## 1. Organization Overview

| Site | Location and premises | Function and departments | Approximate staff |
|---|---|---|---:|
| MedDefense Central Hospital | Downtown; six floors plus basement containing mechanical/server room; underground staff garage and visitor surface parking | 350-bed acute care hospital: Emergency, Surgery, Cardiology, Radiology, Oncology, Pediatrics, Maternity, Pharmacy, Laboratory and Administration | 1,400 |
| Westside Clinic | Suburban; 12 minutes from Central; two-story medical office complex with parking shared with retail premises | Outpatient primary care, X-ray and ultrasound imaging (no MRI), blood work, minor procedures and physical therapy; local server closet and some shared Central IT services | 180 |
| Corporate HQ | Greenfield Business Park; 15 minutes from Central; leased third-floor offices in a five-story commercial building | Finance, HR, Legal, Marketing, Executive Leadership and IT; cloud services and VPN access to Central | 220 |

D1 reports approximately 2,000 employees organization-wide, whereas site estimates total 1,800. This discrepancy remains unresolved.

**Security-relevant reporting and responsibilities (D6):**

- CEO Dr. Patricia Morales oversees CFO Robert Kim, COO Angela Torres, General Counsel David Park and the vacant CISO position. Clinical directors report through the COO.
- James Chen is Deputy CISO and acts as security lead. Although formally reporting to the vacant CISO position, he reports directly to the CEO in practice. The new security analyst replaces Marcus Webb and reports to James.
- Sarah Park, IT Director, and James are peers. James controls security policy but has no authority over IT operations. This separation can complicate implementation and requires clear ownership of security actions.
- IT is based at HQ. D6 lists three system administrators, two network technicians, one database administrator, two helpdesk analysts (including lead Mike Torres), two desktop support technicians and one vacant intern position. Including Sarah, this is 12 positions but apparently 11 filled positions, which needs reconciliation with the stated 12 IT staff in D1.
- Finance holds the contract summary; Legal asserts HIPAA compliance without supporting evidence in the packet (D3–D4). Clinical directors are relevant stakeholders for patient-care dependencies, although asset ownership is not assigned.

## 2. IT Infrastructure Identified

### Servers and storage

Locations and operating systems below are recorded in D2 unless stated otherwise; they have not been independently verified.

| Name/type | Function | Site | Available technical details and evidence |
|---|---|---|---|
| ehr-srv-01 | Electronic health record (EHR) application | Central | Ubuntu 20.04 LTS; D3 says SSH migration reached this server, but completion and effective configuration are unclear |
| ehr-db-01 | EHR database | Central | Ubuntu 20.04 LTS; PostgreSQL; D3 reports database access from the entire 10.10.0.0/16 range |
| pacs-srv-01 | Picture archiving and communication system (PACS) imaging | Central | Windows Server 2016 |
| billing-srv-01 | Billing and claims processing | Central | Ubuntu 18.04 LTS; recurring performance problems treated with restarts; D3 reports a January ransomware incident and four days of improvised response, without specifying the year or proving current compromise |
| ad-dc-01 | Primary domain controller | Central | Windows Server 2019 |
| ad-dc-02 | Secondary domain controller | Central | Windows Server 2019 |
| file-srv-01 | Department file shares | Central | Windows Server 2016 |
| print-srv-01 | Print services | Central | Windows Server 2012 R2; explicitly UNVERIFIED, meaning not physically confirmed in over a year; D3 flags end of support in October 2023 |
| backup-srv-01 | Backup processing | Central | Ubuntu 22.04 LTS; Veeam agent; D3 reports nightly backups to a local NAS |
| Local NAS | Backup destination | Central | Same server room, rack and network as the backup infrastructure; model, capacity and protection configuration unspecified (D3, D5) |
| web-srv-01 | Public website and patient portal | Central | Ubuntu 20.04 LTS; drawn in a DMZ in D5, but the diagram also states no VLANs and a single network; effective separation unconfirmed |
| ws-srv-01 | Local file services and scheduling | Westside | Windows Server 2016 |
| Possible additional server | Unknown | Westside | Mentioned by Mike Torres to Marcus; existence, function and specifications unconfirmed |

D2 states that HQ has no on-premises servers. This does not establish whether other undocumented assets or hosted systems exist.

### Network and communications infrastructure

| Name/type | Function | Site | Available technical details and evidence |
|---|---|---|---|
| Cisco core switch | Core connectivity | Central | Model unknown (D2) |
| Cisco access switches | Floor-level connectivity | Central | Two per floor reported; exact total unclear because floor coverage is unspecified and D5 depicts only floors 1–4 (D1–D2, D5) |
| Fortinet FortiGate 100F | Internet perimeter and intersite VPN termination | Central | One device; Fortinet support contract; D5 connects both remote sites to this firewall |
| Internal network | Connects servers, workstations and medical devices | Central | D3 reports a flat broadcast domain, 10.10.0.0/16; D5 states no VLANs configured; DMZ depiction requires clarification |
| Ubiquiti UniFi access points | Wireless connectivity | Central | 12 APs; guest SSID exists but its isolation is unverified (D2–D3) |
| UniFi controller | Wireless management | Hosting location unknown | Controller referenced by D4; deployment, host and configuration unspecified |
| Unmanaged switch | Local connectivity | Westside | One; brand unknown (D2) |
| Netgear Nighthawk consumer router | ISP access and VPN to Central | Westside | D3 identifies the router and reports no firewall at the site; D5 labels the tunnel IPSec; router filtering capabilities and actual rules are not documented |
| Wireless infrastructure | Possible local Wi-Fi | Westside | D2 marks Wi-Fi information unknown; presence, devices and configuration require confirmation |
| Building-managed network and internet | HQ connectivity | HQ | Dedicated MedDefense VLAN on landlord-managed infrastructure; equipment and tenant separation details absent (D2, D4) |
| HQ site-to-site VPN | Access to Central | HQ–Central | D3 says it appears properly configured but ACLs were not audited; endpoint equipment at HQ unspecified |
| IP nurse call system and phone system | Clinical calls and communications | Site coverage unspecified | Nurse call system explicitly integrates with the phone system; models, quantities and hosting unspecified (D2) |

### Endpoints, medical devices and supporting systems

| Name/type | Function | Site | Available technical details and evidence |
|---|---|---|---|
| Approximately 320 Windows 10 workstations | Staff computing | Central | D2 estimates; approximately eight-month-old AD report |
| Approximately 60 thin clients | Clinical access terminals | Central clinical areas | OS, backend platform and management unspecified |
| Approximately 45 Windows 10 workstations | Clinic staff computing | Westside | D2 estimates |
| Approximately 120 Windows 10/11 workstations | Administrative computing | HQ | OS distribution unspecified |
| Approximately 30 remote-capable laptops | Mobile/remote work | HQ inventory | OS and remote-access method unspecified; overlap with workstation count unclear |
| Approximately 25 physician iPads | Rounds | Site allocation unspecified | Management status unclear; OS versions and application access unspecified |
| PACS workstation | Radiology access to imaging | Radiology; site not explicit in D3 | Shared account reported; whether included in workstation estimates is unknown; credential value intentionally omitted |
| Approximately 80 Philips IntelliVue patient monitors | Connected patient monitoring | Central | D2 locates monitors across Central; D3 reports shared network with other assets |
| Approximately 120 BD Alaris infusion pumps | Infusion delivery with network dosage updates | Central indicated by D3 network discussion | Device software and precise allocation unspecified; shared network reported |
| One Siemens MAGNETOM MRI scanner | MRI imaging | Central, Radiology | Windows XP reported; separate referenced file not supplied (D2) |
| One GE Revolution CT scanner | CT imaging | Central | OS unknown (D2) |
| X-ray and ultrasound equipment | Diagnostic imaging | Westside | Implied by D1 services; count, models and network connectivity unconfirmed |
| HID Global badge/access system | Door access control | Site coverage unspecified | Some doors integrated with AD (D2); Central server-room access reportedly uses the generic staff badge (D3) |
| Security cameras | Physical surveillance | Central garage and ER entrance | D3 reports cameras at these locations and none in the server-room corridor; recording platform and connectivity unspecified |
| UPS | Short-duration power continuity | Central context in D3 | Approximately 20 minutes reported; model, load and protected equipment unspecified |
| Printers | Printing | Site allocation unspecified | Implied by print server; count, models and connectivity unconfirmed |

### Software, cloud services and operational support

- **Microsoft O365 E3:** organization-wide subscription; $432,000 annually, September renewal. Tenant configuration, enabled services and data locations are not provided. Other departmental cloud services are suspected but unidentified (D3–D4).
- **Sophos endpoint protection:** $18,000 annually, January renewal; installed coverage and update status not established (D3–D4).
- **Veeam backup software:** $8,500 annually, March renewal; nightly local-NAS workflow reported, but scope and recovery capability unverified (D3–D4).
- **Fortinet support:** $4,200 annually, June renewal; contract does not establish enabled security features or current configuration (D4).
- **UniFi controller:** listed as free, with no renewal date (D4).
- **ServiceDesk ticketing system and AD reporting:** sources of the partial asset inventory; hosting and product details for ServiceDesk unspecified (D2).
- **Shared drive S:\Security\Notes:** location of Marcus's observations; hosting is not explicitly tied to file-srv-01 (D3).
- **MedTech Solutions EHR maintenance:** $145,000 annually, July renewal; covers software updates, excludes hardware; critical response SLA four hours and standard response SLA 24 hours. Response time is not a restoration guarantee (D4).
- **Greenfield Building Management:** provides HQ network/internet within the lease; operational and security responsibilities unspecified (D4).
- **ClearView Security:** $96,000 annually, December renewal; one Central main-entrance guard, Monday–Friday 07:00–19:00. No night/weekend coverage and no guard at Westside or HQ (D4).

## 3. Data and Services

The service-to-data mappings below are inferred from documented functions where actual datasets are not listed. Record counts, formal classifications, retention periods and encryption status are not supplied.

| Data type | Associated service/infrastructure | Users and operational dependency |
|---|---|---|
| Patient health records and clinical information, expected to include protected health information (inferred) | EHR application and PostgreSQL database | Clinical personnel depend on record access for care; MedTech provides software support. Specific department workflows and Westside access are unconfirmed |
| Diagnostic images and associated patient information (inferred) | PACS, MRI and CT; Westside imaging services | Radiology and treating clinicians depend on imaging availability and accuracy; exact modality-to-PACS connections are undocumented |
| Billing, claims and associated patient/payment information (inferred) | billing-srv-01 | Billing/Finance personnel depend on claims processing for revenue collection; external payer connections and actual stored fields are unknown |
| Appointment and local clinic files | ws-srv-01 | Westside scheduling and clinic personnel; exact user groups and central dependencies unspecified |
| Departmental business records, potentially including personnel, financial and legal information (inferred) | Department shares and O365; precise storage allocation unknown | HR, Finance, Legal, Marketing, Administration and leadership; actual data locations are unconfirmed |
| Public website content and patient-facing portal information | web-srv-01 | Public visitors and portal users; portal data fields, authentication and EHR integration unspecified |
| Account identities, authentication information and access permissions | AD domain controllers and some badge-controlled doors | Staff access to connected resources and selected physical doors; full AD dependency map absent |
| Patient-monitoring information and dosage-update data | Connected monitors and infusion pumps | Clinical teams rely on monitoring and appropriate infusion operation; remote/network failure effects are undocumented |
| Nurse calls and telephone communications | Integrated IP nurse call and phone systems | Patients and care teams; hosting and service continuity dependencies unknown |
| Backup copies of source data | Veeam, backup-srv-01 and local NAS | IT recovery activities; backup coverage and restore reliability not established |
| Security documentation, support records and possible physical-security records | Shared notes, ServiceDesk, cameras and badge system | IT/security and relevant facilities personnel; camera retention and access-event logging are not documented |

**Cross-service dependencies:** D5 shows Central as the connection point for both remote sites. HQ explicitly uses Central infrastructure over VPN; Westside shares some Central IT services. Network connectivity, authentication, power and backup recovery therefore require consideration alongside individual applications. Central's reported flat network connects clinical devices and general computing assets, but the packet is insufficient to establish all access paths. Co-location of backups with production infrastructure creates a shared exposure; it does not establish that every backup would necessarily be lost.

**Data states:** Active applications process data in use; server/database/cloud storage and backup copies represent data at rest; VPN links and network-connected services carry data in transit. These are functional mappings, not evidence of encryption. The packet names Westside IPSec connectivity but does not document comprehensive protections for any of the three states.

## 4. Known Unknowns

The following gaps require document requests and confirmation with accountable staff. Proposed contacts are validation contacts, not verified asset owners.

| ID | Missing, incomplete or contradictory information | Why clarification matters / proposed follow-up |
|---|---|---|
| KU-01 | Site headcounts total 1,800 versus approximately 2,000 organization-wide | HR should reconcile scope and dates before staffing-based coverage or licensing calculations |
| KU-02 | Twelve IT staff stated, but D6 appears to show 12 positions including one vacancy | Sarah/HR should confirm actual staffing and available operational capacity |
| KU-03 | Packet has no absolute compilation date; notes and AD export use relative dates; January incident year absent | James/Sarah should establish evidence dates so historical observations are not treated as current facts |
| KU-04 | Partial inventory; print-srv-01 unverified; possible second Westside server; no complete endpoint count | IT/Mike should reconcile asset records, laptop overlap, site allocation and unknown equipment before claiming completeness |
| KU-05 | Most assets lack owners, exact room/rack placement, IPs, versions, support status and lifecycle records | IT should supply authoritative inventory and maintenance records for later assessment; OS labels alone do not prove patch or support status |
| KU-06 | D5 shows four floors while D1 describes six plus basement; two access switches per floor does not establish total coverage | Network staff should provide a current topology and switch/AP inventory |
| KU-07 | DMZ label for web-srv-01 conflicts with the broad statements that everything shares one network and no VLANs exist | Network staff should confirm interfaces, subnets and firewall boundaries; neither isolation nor its absence is proven by the diagram alone |
| KU-08 | Guest Wi-Fi isolation unverified; Westside wireless unknown; HQ wireless not described | Network staff/building management should document wireless access boundaries and management responsibilities |
| KU-09 | Westside reportedly has no firewall, but consumer-router filtering is undocumented; VPN/ACL details incomplete at both remote sites | Obtain router/firewall configuration records and VPN scope; HQ's apparently sound configuration is an unaudited opinion |
| KU-10 | Current billing-srv-01 condition and January incident scope, cause, recovery and closure evidence absent | James/Sarah should supply incident records and subsequent investigations; poor performance alone does not prove active malware |
| KU-11 | Backup scope, retention, access separation, immutability, encryption and restore-test results absent; offsite budget denied | IT should confirm current recovery arrangements. A denied proposal does not establish that no later alternative exists |
| KU-12 | Broad EHR database reachability reported without current rules, database permissions or authentication evidence | DBA/network staff should clarify effective access paths and privileges; network reachability is not equivalent to authorized data access |
| KU-13 | MFA reportedly absent except James's personal account; policy scope and current settings unknown; SSH note both says password authentication remains on all Linux servers and mentions migration of ehr-srv-01 | IT should establish effective per-system authentication and whether the EHR migration completed |
| KU-14 | Radiology shared account reported; full shared/privileged account inventory and remediation status absent | IT/clinical leadership should confirm identity ownership and accountability without circulating the disclosed password |
| KU-15 | Sophos contract exists, but endpoint coverage, health, update state and security monitoring are unknown | IT should supply deployment and monitoring evidence; purchasing protection does not demonstrate effective operation |
| KU-16 | MRI's separate file missing; CT OS, device firmware, maintenance arrangements and permitted updates unknown | Biomedical engineering/IT should provide device records and vendor constraints before future remediation planning |
| KU-17 | Cloud inventory incomplete; O365 configuration, departmental services, vendor access and data residency unknown | IT and department leads should reconcile cloud services, external access and contractual responsibilities |
| KU-18 | No comprehensive data inventory, flow map, classification, record volume, retention or encryption evidence | Data-owning departments should identify sensitive data and its handling at rest, in transit and in use |
| KU-19 | Server-room generic badge access and unlocked Westside closet reported; current access lists, logs and corrective action unknown | IT/facilities should verify current physical controls, camera coverage and landlord responsibilities |
| KU-20 | D3 reports no formal incident response, business continuity or disaster recovery plans; no recovery objectives, tested downtime procedures or complete power/resilience details | James/IT/clinical leadership should confirm current documentation and dependencies; approximately 20 minutes of UPS runtime is not a recovery plan |
| KU-21 | Legal asserts HIPAA compliance, while D3 states no formal Security Rule assessment and no evidence | Legal/James should provide assessment scope and supporting records; neither compliance nor a definitive legal violation can be concluded from this packet |
| KU-22 | Formal vulnerability assessment and threat analysis unfinished; current patch records and full control inventory absent | James/IT should provide existing evidence for subsequent tasks; this summary does not claim a validated vulnerability or risk rating |
| KU-23 | Asset/service ownership, vendor responsibility boundaries and restoration commitments incomplete; EHR contract gives response times only | James/Sarah and Finance should clarify accountability, contracts and service dependencies before prioritizing treatments |

These gaps limit confidence in the environment description. This summary provides a documented starting point for the subsequent asset, control and risk assessments; it does not certify the environment's security posture.
