# Task 14 — The Segmentation Architecture

**Organization:** MedDefense Health Systems
**Project:** 1x03 — Defense Blueprint
**Prepared for:** James Chen, Deputy CISO; Sarah Park, IT Director
**Assessment date:** 29 October 2026
**Status:** Proposed architecture — not deployed

## Executive Design Summary

MedDefense currently operates an effectively flat internal network. The existing 10.10.0.0/16 environment includes Central network groups 10.10.1.0/24, 10.10.2.0/24 and 10.10.3.0/24 without demonstrated effective interzone firewall enforcement. Existing FortiGate policy C-002 permits overly broad VPN-to-server traffic, increasing lateral-movement exposure (GAP-016).

The proposed solution creates separate, routed VLANs for critical servers, Active Directory, EHR databases, clinical workstations, medical devices, imaging, administration, visitors, non-clinical IoT, public applications and backups.

**Design principles:**
- Deny interzone traffic by default.
- Permit only documented clinical and business dependencies.
- Route interzone traffic through an enforcing firewall.
- Require individually authorized administrative and vendor access.
- Separate patient-care networks from guest and non-clinical devices.
- Protect backup management from ransomware.
- Test clinical workflows before activating restrictive rules.

All 10.20.x.x addresses below are proposed, not existing MedDefense addresses. They require IPAM, routing, DHCP, static-address and VPN-overlap validation.

A VLAN alone does not enforce security. Intra-VLAN communication also requires host firewalls, private VLANs, port isolation or additional subzones.

## Part 1 — Zone Definition

### 1.1 VLAN and Address Plan

| Zone | VLAN | Proposed IP Range | Purpose and Systems |
|---|---:|---|---|
| Z-SRV — Server Zone | 110 | 10.20.10.0/24 | EHR application server, billing server, file server, approved pharmacy applications |
| Z-ID — Identity Zone | 111 | 10.20.11.0/24 | Active Directory controllers ad-dc-01 and ad-dc-02, AD-integrated DNS |
| Z-DATA — Database Zone | 112 | 10.20.12.0/24 | ehr-db-01, protected EHR database and approved database services |
| Z-CLIN — Clinical Workstations | 120 | 10.20.20.0/23 | Nurse stations, physician workstations, approved Radiology clients |
| Z-MED — Medical Devices | 130 | 10.20.30.0/24 | BD Alaris infusion pumps, Philips IntelliVue monitoring devices and approved gateways |
| Z-IMG — Imaging and PACS | 131 | 10.20.31.0/24 | pacs-srv-01, MRI controller WS-RAD-01, Siemens MRI and imaging dependencies |
| Z-MGMT — Management Zone | 140 | 10.20.40.0/24 | Hardened administrator workstations, biomedical jump host, Wazuh and network-management tools |
| Z-GUEST — Guest Wi-Fi | 150 | 10.20.50.0/24 | Visitor and patient personal devices |
| Z-IOT — Non-clinical IoT | 151 | 10.20.51.0/24 | Smart displays, building-management devices and approved non-medical IoT |
| Z-DMZ — Public Services | 160 | 10.20.60.0/24 | Patient portal, public website and approved reverse proxy |
| Z-BACKUP — Recovery Zone | 170 | 10.20.70.0/24 | Synology NAS, backup/restore proxies and protected recovery administration |
| Z-VPN — Remote Access | Logical | 10.20.61.0/24 | MFA-authenticated remote users and approved vendor sessions |

The five mandatory zone families are Server, Clinical Workstation, Medical Device, Management and Guest/IoT. Additional zones reduce exposure to AD, EHR records and recovery systems.

### 1.2 Allowed Outbound and Inbound Connections

#### Zone 1 — Server Zone (VLAN 110)

**Systems:** ehr-srv-01, billing-srv-01, file-srv-01 and approved business application hosts.

**Allowed outbound:** Named EHR application server to PostgreSQL TCP/5432; approved domain authentication and DNS to Z-ID; authorized backup traffic to Z-BACKUP; approved security logs to Z-MGMT.

**Allowed inbound:** Clinical workstations to approved EHR and billing application HTTPS TCP/443; named Z-MGMT administrator hosts for necessary management; approved reverse-proxy application traffic where verified.

**Denied:** Direct general VPN/guest access, unrestricted database access, unnecessary SMB/RDP between servers, and direct public Internet administration.

**Reason:** Limits ransomware movement from compromised user or VPN sessions.

#### Zone 2 — Identity Zone (VLAN 111)

**Systems:** ad-dc-01 (A-040), ad-dc-02 (A-041), DNS and domain services.

**Allowed outbound:** Domain-controller replication, authorized log delivery and protected backups.

**Allowed inbound:** Domain-joined systems using required DNS, Kerberos, LDAP, SMB/SYSVOL and validated RPC services; privileged administration only from the management jump host.

**Denied:** Guest/IoT access, unrestricted remote VPN access and arbitrary workstation administration.

**Reason:** Protects Active Directory, the primary objective of KC1. Required Windows dynamic RPC ports must be inventoried and narrowly scoped rather than blindly blocked.

#### Zone 3 — Protected Database Zone (VLAN 112)

**Systems:** ehr-db-01 (A-037), Restricted EHR data (A-112), and specifically approved database hosts.

**Allowed outbound:** Approved backups, audit forwarding and essential time synchronization.

**Allowed inbound:** Only named EHR application-host addresses using PostgreSQL TCP/5432; named DBA management through a protected jump host.

**Denied:** Direct clinical-workstation, VPN, guest, IoT and vendor access to database services.

**Reason:** Addresses Finding 003, where PostgreSQL currently accepts connection attempts from the entire internal 10.10.0.0/16 range. Database authentication remains required; network restriction adds defense in depth.

#### Zone 4 — Clinical Workstation Zone (VLAN 120)

**Systems:** Nurse stations, physician workstations, clinical laptops and approved Radiology clients.

**Allowed outbound:** Approved EHR/pharmacy applications over HTTPS, authorized PACS viewing, necessary AD services, approved DNS/NTP, managed software updates and security telemetry.

**Allowed inbound:** Established application responses and authenticated IT support from Z-MGMT.

**Denied:** Direct PostgreSQL administration, general pump management, backup administration, and unapproved lateral SMB/RDP.

**Reason:** Limits damage after a compromised user endpoint or phishing incident.

#### Zone 5 — Medical Device Zone (VLAN 130)

**Systems:** BD Alaris pumps (A-061–A-067), Philips IntelliVue monitors and approved medical-device gateways.

**Allowed outbound:** Only verified clinical telemetry, monitoring interfaces, and vendor-approved dependencies.

**Allowed inbound:** Approved biomedical jump host, necessary clinical monitoring endpoints and verified vendor-maintenance flows.

**Denied:** Guest, ordinary VPN, general office workstation and unnecessary Internet access.

**Reason:** Reduces unauthorized pump-management reachability, supporting RISK-004 and KC4.

**Safety condition:** Biomedical engineering, BD and clinical staff must approve all changes. Never run disruptive scans or make untested ACL changes to devices used in active treatment. Device-specific management and monitoring may require further microsegmentation.

#### Zone 6 — Imaging and PACS Zone (VLAN 131)

**Systems:** pacs-srv-01 (A-038), WS-RAD-01 (A-016), Siemens MRI (A-091).

**Allowed outbound:** Authorized DICOM transfers, verified clinical viewing/archiving, audit logs and protected recovery traffic.

**Allowed inbound:** Approved modality IPs using observed DICOM TCP/4242 or TCP/11112; authorized viewer HTTPS; management by approved Radiology/IT jump hosts.

**Denied:** General workstation SMB TCP/445, RDP TCP/3389, arbitrary vendor connections and unnecessary Internet access.

**Reason:** Contains the unsupported Windows XP MRI controller and reduces KC3 lateral movement into PACS.

**Safety condition:** Obtain Siemens/Radiology approval and confirm DICOM and emergency support traffic before cutover. DICOM encryption remains a separate requirement (Finding 024).

#### Zone 7 — Management Zone (VLAN 140)

**Systems:** Privileged IT workstations, hardened jump hosts, security-log collectors and approved biomedical support hosts.

**Allowed outbound:** Named management destinations and ports, approved log review, updates and maintenance.

**Allowed inbound:** Authenticated, role-authorized administrators through a controlled MFA gateway; approved audit/log feeds.

**Denied:** General clinical, guest, IoT and unrestricted VPN access.

**Reason:** Separates privileged administration from ordinary user workstations and helps protect KC1/KC4 targets.

#### Zone 8 — Guest and Non-clinical IoT Zones (VLANs 150/151)

**Systems:** Personal phones, visitor laptops, building controllers and non-clinical devices.

**Allowed outbound:** Guest Internet access through NAT; tightly scoped update/management services for approved IoT.

**Allowed inbound:** Guest DHCP/captive portal services and authorized facilities administration for specific IoT devices only.

**Denied:** All direct access to EHR, AD, clinical workstations, PACS, MRI, medical devices, internal databases and backups.

**Reason:** Removes low-trust devices as convenient internal attack starting points.

#### Zone 9 — DMZ (VLAN 160)

**Systems:** Patient portal, web-srv-01 and approved public reverse proxies.

**Allowed outbound:** Only documented application-to-backend APIs and approved security services.

**Allowed inbound:** Public HTTPS TCP/443 and HTTP TCP/80 only when required for redirect; restricted management from Z-MGMT.

**Denied:** Direct database administration, AD management, medical-device management and broad internal network discovery.

**Reason:** Prevents compromise of a public-facing web application from automatically becoming unrestricted internal access.

#### Zone 10 — Backup Zone (VLAN 170)

**Systems:** Synology NAS, dedicated recovery proxies and backup-management components.

**Allowed outbound:** Authenticated protected/offsite replication and required monitoring.

**Allowed inbound:** Backup traffic from individually enrolled critical systems; administration only from dedicated backup operators in Z-MGMT.

**Denied:** General VPN, clinical-user, guest, IoT and unnecessary server-to-NAS administration.

**Reason:** Protects recovery access during ransomware. The offsite immutable backup from C4 remains a separate security/failure domain.

### 1.3 Text Network Architecture Diagram

```text
                         INTERNET
                            |
                    FortiGate 100F
                            |
               +------------+-----------+
               |                        |
        PUBLIC DMZ                  MFA VPN POOL
        VLAN 160                     Z-VPN
               |                        |
               +------------+-----------+
                            |
                  INTERZONE FIREWALL
                DEFAULT DENY + LOGGING
                            |
       +--------------------+---------------------+
       |                    |                     |
 SERVER FAMILY          USER FAMILY           MEDICAL FAMILY
       |                    |                     |
   Z-SRV 110           Z-CLIN 120             Z-MED 130
   Z-ID  111           Z-GUEST 150            Z-IMG 131
   Z-DATA 112          Z-IOT 151                  |
       |                                          |
       +--------------------+---------------------+
                            |
                       Z-MGMT 140
                  Authorized jump hosts
                            |
                       Z-BACKUP 170
                  Protected recovery copies

 Every interzone flow must cross an enforcing policy.
 Same-zone clinical and device flows need host/switch ACLs
 when different trust levels share a VLAN.
```

## Part 2 — Firewall Rules

### 2.1 Firewall Policy

All interzone traffic must traverse an enforcing firewall or equivalent L3 ACL. Apply **least privilege**, **stateful inspection**, **logging** and **default deny**. Use named source/destination host objects rather than trusting an entire VLAN. The ten critical rules below are a design baseline, not a complete production ruleset.

### 2.2 Ten Critical Rules

```text
R01: Z-VPN authorized admins -> Z-MGMT jump gateway
     TCP/443 HTTPS : ALLOW
     Prevents unrestricted VPN access to internal servers.

R02: Z-CLIN approved workstations -> Z-SRV EHR application
     TCP/443 HTTPS : ALLOW
     Preserves authorized clinical access without exposing databases.

R03: Z-SRV named EHR application -> Z-DATA ehr-db-01
     TCP/5432 PostgreSQL : ALLOW
     Restricts Finding 003's broad database reachability.

R04: Z-CLIN/Z-SRV authorized domain members -> Z-ID AD controllers
     TCP/UDP 53,88,389,464; TCP/445; validated AD RPC : ALLOW
     Preserves required domain authentication for approved systems.
     Require LDAP signing and verified Windows service dependencies.

R05: Z-IMG approved MRI/modalities -> Z-IMG PACS
     TCP/4242,11112 DICOM : ALLOW
     Preserves authorized imaging traffic.
     Same-VLAN flow requires host ACL or switch microsegmentation.

R06: Z-CLIN authorized Radiology clients -> Z-IMG PACS viewer
     TCP/443 HTTPS : ALLOW
     Permits viewing while excluding unnecessary PACS administration.

R07: Z-MGMT approved Biomedical jump host -> Z-MED pump management
     TCP/443 or vendor-validated port : ALLOW
     Restricts device management to approved sources.

R08: Enrolled critical backup agents -> Z-BACKUP receiver
     TCP/443 or validated backup-agent service : ALLOW
     Preserves backups without general NAS administrative access.

R09: Z-GUEST/Z-IOT -> ALL internal protected zones
     ANY/ANY : DENY
     DENY #1: Blocks visitor and non-clinical IoT lateral movement.

R10: Unauthorized Z-VPN/Z-CLIN/Z-GUEST/Z-IOT sources
     -> Z-DATA/Z-MED/Z-IMG/Z-BACKUP management endpoints
     TCP/22,3389,445,5432,8009 and other unapproved ports : DENY
     DENY #2: Blocks direct SSH, RDP, SMB, PostgreSQL, AJP and
     protected-device administration outside explicit allowlists.

DEFAULT: Any remaining unauthorized interzone flow
         ANY/ANY : DENY + LOG
```

**Rule order:** R01–R08 are narrow, approved exceptions; R09–R10 deny other matching traffic. Default deny applies to remaining interzone flows. Source identity and destination service restrictions must be enforced independently; merely being in an allowed VLAN is insufficient.

**Clinical exception:** AD dynamic RPC, DICOM, HL7, pharmacy, PACS and biomedical vendor dependencies require a validated service matrix. Never deploy these example rules without testing the necessary clinical communication paths.

### 2.3 Enforcement and Monitoring

- Remove FortiGate C-002's broad VPN-to-server `ALL` service authorization after validating replacement flows.
- Log allowed privileged administration and all critical interzone denies.
- Review denied connections for blocked attacks and broken legitimate workflows.
- Do not assume VLAN separation can filter two hosts in the same VLAN; use host firewalls, switch ACLs or finer subzones.
- Confirm approved connectivity and rollback with Biomedical, Radiology, Pharmacy and IT.

## Part 3 — Kill Chain Impact

### 3.1 Kill Chain #1: VPN to Active Directory Ransomware

**Reference:** 1x01 KC1, RISK-002.

**Step 1 — Initial Access:** A ransomware affiliate exploits or misuses a VPN service to obtain an internal session. Segmentation does not necessarily prevent VPN exploitation, but places the session in restricted Z-VPN rather than a flat trusted network. C2 MFA and gateway patching remain essential.

**Step 2 — Establish Foothold:** The attacker attempts to reach Windows servers and steal credentials. R01 and R10 restrict VPN traffic to an approved jump gateway and deny unauthorized administrative access. **Primary break point:** direct VPN-to-server access is disrupted.

**Step 3 — Lateral Movement and Escalation:** The attacker enumerates AD using Kerberos, LDAP and SMB and attempts privileged access. AD is separately protected in Z-ID, with only necessary domain services permitted. Unauthorized administrative paths are blocked. **Primary break point:** unrestricted lateral movement is strongly constrained, although approved domain members retain essential AD traffic.

**Step 4 — Ransomware Deployment:** The attacker modifies GPO or privileged accounts to distribute ransomware. Segmented medical, imaging, database and recovery networks reduce possible propagation paths. However, a fully compromised domain-admin account might still abuse legitimate management flows. **Partial break point**, not guaranteed prevention.

**Step 5 — Operational Impact:** Restricted movement may limit the outage and protect recovery systems, but shared AD dependencies can still interrupt hospital operations. Immutable backups (C4), protected AD recovery and clinical continuity plans remain necessary.

### 3.2 Estimated Effect on Five Kill Chains

| Kill Chain | Effect of Segmentation | Disrupted? |
|---|---|---|
| KC1 — VPN -> AD ransomware | Strongly constrains steps 2–3 and reduces propagation at step 4 | Yes |
| KC2 — Negligent pharmacy change | Authorized incorrect dosage changes still pass application permissions | No |
| KC3 — Radiology phishing -> PACS | Blocks unnecessary workstation-to-PACS SMB/RDP and lateral paths | Yes |
| KC4 — Malicious insider -> Alaris | Limits pump management to approved biomedical origins, but authorized misuse remains possible | Yes, partial |
| KC5 — Compromised vendor -> EHR | Limits direct database and management access; compromised authorized EHR app remains a risk | Yes, partial |

**Percentage:** 4 of 5 selected kill chains have at least one materially constrained step: `4 / 5 × 100 = 80%`.

This is a **qualitative architecture estimate**. It does not mean attacks, ALE, incident probability or losses decrease by 80%. KC1 and KC3 have stronger network-stage disruption; KC4 and KC5 remain partly exposed. KC2 requires pharmacist approval, dosage validation and tested rollback rather than segmentation alone.

### 3.3 Financial Alignment

This design corresponds to **C1 Network Segmentation** in Task 7:

- Annualized cost: **$30,000**
- Annualized infrastructure: **$6,000**
- Labor: **$18,000**
- Maintenance: **$6,000**
- Modeled marginal reduction in the R2 VPN/ransomware scenario: **$240,000/year**, conditional on the C2 MFA sequence.

These are planning estimates, not confirmed savings. The complete segmentation deployment must be priced and reconciled against the Task 8 primary portfolio of **$97,000 annualized**, **$115,000 estimated first-year cash**, and the overall six-month program ceiling.

### 3.4 Implementation and Verification

1. **Discover:** Sarah Park and Network IT confirm all current IPs, VLAN capability, site-to-site routes, DNS, DHCP, host dependencies and approved ports.
2. **Approve:** James Chen obtains documented clinical, Biomedical, Radiology and vendor acceptance of traffic matrices and rollback plans.
3. **Pilot:** Apply guest isolation and low-risk rules first; record successful allow/deny tests.
4. **Migrate:** Stage Server, Identity, Database and Management zones with application, authentication and backup validation.
5. **Protect clinical flows:** Validate imaging, pump monitoring, emergency support, pharmacy and PACS traffic without disrupting patient treatment.
6. **Cut over:** Replace broad FortiGate permissions with the approved scoped rule set.
7. **Verify:** Confirm authorized EHR HTTPS and PostgreSQL connections work; unauthorized direct database/AD management and guest-to-clinical paths fail; PACS DICOM, AD logon and critical backup/restore succeed.
8. **Review:** Record firewall-deny logs, test evidence and new residual-risk decisions in Task 10 Risk Register.

**Rollback trigger:** Any interruption to patient monitoring, infusion, imaging, pharmacy dispensing, critical authentication or necessary backup/restore requires immediate clinical escalation and rollback of the affected change.

**Approval:** James Chen (security oversight), Sarah Park (implementation), Biomedical and clinical owners (patient safety), Robert Kim/Board (financial authority).

## References

- [1x00 Asset Registry](../1x00_first_watch/7-asset_registry.md)
- [1x00 Gap Analysis](../1x00_first_watch/12-gap_analysis.md)
- [1x01 Kill Chains](../1x01_know_your_enemy/10-kill_chains.md)
- [1x02 Triage](../1x02_the_weak_links/16-triage.md)
- [Task 7 Cost-Benefit Analysis](7-cost_benefit_analysis.md)
- [Task 8 Budget Allocation](8-budget_allocation.md)
- [Task 10 Risk Register](10-risk_register.md)
- [Task 11 Control Selection](11-control_selection.md)

**Status:** Proposed design only. No network changes, verified savings or completed clinical acceptance are claimed.
