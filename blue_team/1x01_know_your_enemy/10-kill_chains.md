# MedDefense Health Systems — Critical Kill Chains

Prepared for: James Chen, Deputy CISO

Prepared by: Junior Security Analyst

Scope: Five critical paths selected from the [T9 Vector-to-Asset Matrix](9-vector_asset_matrix.md); no live testing, exploitation or actor attribution performed.

## Selection Basis

The chains combine T9 connectivity with asset criticality, T6 actor likelihood and the severity of the final business consequence. They are scenarios, not claims that an attack is in progress. A successful network connection does not itself grant authorization, and conditional supplier, credential and exploit paths remain explicitly conditional. For the negligent-insider chain, “kill chain” describes a sequence of control failures rather than malicious intent.

| Chain | T9 Intersection | Why It Is Included |
|---|---|---|
| 1 | VPN Exploit → Active Directory | VPN is T9's most versatile external technical vector, AD is tied as a most-connected asset, and T6 ranks ransomware first. |
| 2 | Insider — Negligent → Pharmacy Management System | T6 ranks negligence second, and a prior untested change already produced incorrect dosage values across three sites. |
| 3 | Phishing / Spear Phishing → PACS | Phishing is a credible ransomware entry path, while PACS has six vector paths and no documented recovery copy. |
| 4 | Insider — Malicious → BD Alaris Infusion-Pump Fleet | Both the actor vector and the pump fleet connect to all seven opposite dimensions in T9, with potential patient-safety consequences. |
| 5 | Supply Chain Compromise → EHR DB | A compromised MedTech maintenance identity or update has the clearest trusted third-party route toward the highest-ranked asset and Restricted patient data. |

## Kill Chain #1: VPN Foothold to Domain-Wide Ransomware

```yaml
Threat Actor: Ransomware Groups (Organized Crime) — T6 profile with High likelihood, Medium–High capability and financial double-extortion motivation
Target Asset: Active Directory on ad-dc-01 and ad-dc-02 — A-040/A-041
Expected Impact: Enterprise authentication and administration disruption that can extend into clinical outages and extortion — Confidentiality, Integrity and Availability

Step 1 - Initial Access:
  Vector: VPN Exploit
  Surface: External
  Detail: An affiliate exploits a usable flaw in the exposed VPN service and obtains an internal session; the scenario does not assert that the current FortiGate version is vulnerable.

Step 2 - Establish Foothold:
  Action: The affiliate uses the VPN session to reach a Windows host, obtains a reusable credential and installs a persistence mechanism before the gateway session ends.
  MedDefense Weakness: C-002 permits ALL services toward the Central server subnet, organization-wide MFA is not evidenced and Sophos C-017–C-021 excludes Windows servers.

Step 3 - Lateral Movement / Escalation:
  Action: The affiliate enumerates AD on ports 88, 389 and 445, captures or abuses a privileged identity and reaches domain-administration functions.
  MedDefense Weakness: The flat network and weak trust boundaries under GAP-016 provide broad discovery paths, while C-034/C-038 supply only local and reactive event review.

Step 4 - Objective Execution:
  Action: The affiliate changes privileged accounts or Group Policy and uses domain control to deploy ransomware to reachable systems and interfere with recovery access.
  Data/System Affected: AD accounts, groups, Group Policy, domain-joined endpoints and any reachable clinical or recovery systems controlled through those identities.

Step 5 - Impact:
  Business Impact: Staff can lose authentication and access to clinical workflows while recovery and investigation costs increase and stolen credentials or data support extortion.
  CIA Pillars: Confidentiality is affected by credential and data exposure, Integrity by unauthorized directory and policy changes, and Availability by domain and downstream service disruption.

Gaps Exploited:
  - GAP-015 — Public-facing vulnerability remediation lacks verified ownership and closure
  - GAP-011 — Shared identities and limited MFA weaken clinical accountability
  - GAP-016 — Public-service and intersite trust boundaries lack verified least-privilege enforcement
  - GAP-007 — Production and recovery copies share a failure domain

Break Points:
  - Step 1 — Verified VPN firmware and vulnerability closure under GAP-015, paired with organization-wide MFA, could prevent or sharply limit initial access; C-041 currently covers only James's unspecified personal account.
  - Step 2 — Replace C-002's ALL-service permission with approved destination and protocol rules, and extend managed EDR to servers, to contain a VPN session before persistence.
  - Step 3 — Tier privileged administration, isolate domain controllers and send C-034 events to centrally monitored alerts for credential theft and privilege changes.
  - Step 4 — Require protected administrative workstations and approval for high-risk GPO changes, while testing isolated AD recovery beyond C-022/C-050's limited backup and redundancy evidence.
```

## Kill Chain #2: Unsafe Pharmacy Change to Dosage Integrity Failure

```yaml
Threat Actor: Insider (Negligent) — T6 profile with High likelihood, Low–Medium capability and convenience or workload-reduction motivation
Target Asset: Pharmacy management system — A-093
Expected Impact: Incorrect medication-dosage information across three sites and delayed clinical work — Integrity and Availability

Step 1 - Initial Access:
  Vector: Insider (Negligent)
  Surface: Human
  Detail: An authorized administrator uses legitimate maintenance access to prepare a database change intended to accelerate routine pharmacy work.

Step 2 - Establish Foothold:
  Action: The administrator retains sufficient change capability and prepares or reuses a script without independent technical review, staging or a verified rollback plan.
  MedDefense Weakness: GAP-022 records incomplete organization-wide change approval and rollback evidence, so authorized access can introduce an unsafe change without a reliable gate.

Step 3 - Lateral Movement / Escalation:
  Action: The script is applied to the shared pharmacy dataset and propagates incorrect values to users of the service across Central, Westside and HQ workflows.
  MedDefense Weakness: The application's hosting and dependencies are unmapped, and GAP-002 records no systematic dosage validation or validated service recovery process.

Step 4 - Objective Execution:
  Action: The untested statement overwrites medication-dosage values, leaving the application available but presenting unsafe information until someone detects the discrepancy.
  Data/System Affected: Medication dosage records in the pharmacy management system A-093 serving all three sites.

Step 5 - Impact:
  Business Impact: Clinicians or pharmacists can receive incorrect dosage guidance, creating patient-safety risk, manual verification work, care delay and reputational or regulatory consequences.
  CIA Pillars: Integrity is the primary loss because values are wrong, while Availability is affected when the system cannot be safely trusted during validation and restoration.

Gaps Exploited:
  - GAP-002 — Pharmacy dosage changes lack validated recovery and systematic checking
  - GAP-022 — Organization-wide change approval and rollback evidence is incomplete

Break Points:
  - Step 1 — Delegate only the minimum pharmacy maintenance permissions and require an individually attributable change identity before production access is granted.
  - Step 2 — A peer-reviewed change ticket, representative test environment, pre-change backup and tested rollback decision could stop an unsafe script before execution under GAP-022.
  - Step 3 — Database constraints, a limited canary rollout and automated comparison against an approved dosage source could prevent one script from affecting all sites.
  - Step 4 — Formalize and accelerate C-044's pharmacist comparison, then restore from a validated known-good copy, rather than relying on the prior six-hour manual discovery.
```

## Kill Chain #3: Radiology Phish to PACS Extortion

```yaml
Threat Actor: Ransomware Groups (Organized Crime) — T6 profile with High likelihood, Medium–High capability and financial double-extortion motivation
Target Asset: PACS imaging server pacs-srv-01 — A-038
Expected Impact: Exposure or encryption of diagnostic images with delayed imaging-dependent care — Confidentiality, Integrity and Availability

Step 1 - Initial Access:
  Vector: Phishing / Spear Phishing
  Surface: Human
  Detail: A vendor-themed message convinces a Radiology user to disclose credentials or execute a payload on a workstation used in the PACS workflow.

Step 2 - Establish Foothold:
  Action: The affiliate maintains access on the compromised workstation, captures the shared PACS session or credential and attempts to evade ordinary endpoint response.
  MedDefense Weakness: C-052 uses a shared Radiology login, GAP-011 weakens individual accountability and GAP-014 records incomplete and non-role-specific training.

Step 3 - Lateral Movement / Escalation:
  Action: The affiliate discovers pacs-srv-01 and uses the flat network plus reachable ports 445, 4242 or 11112 to attempt authenticated access to imaging services.
  MedDefense Weakness: GAP-016 leaves internal paths insufficiently restricted, and Sophos workstation coverage does not establish protection for the Windows PACS server.

Step 4 - Objective Execution:
  Action: With sufficient PACS permission, the affiliate copies imaging data and encrypts or deletes accessible studies to create disclosure and restoration pressure.
  Data/System Affected: Diagnostic images and patient-linked imaging metadata on pacs-srv-01 A-038 and dependent modality workflows.

Step 5 - Impact:
  Business Impact: Imaging availability can be interrupted, approximately 45 daily MRI studies can be delayed, patient information can be exposed and extortion pressure increases because PACS lacks a documented recovery copy.
  CIA Pillars: Confidentiality is affected by image theft, Integrity by altered or deleted studies, and Availability by PACS encryption and diagnostic workflow interruption.

Gaps Exploited:
  - GAP-014 — Security training does not reach clinical staff consistently
  - GAP-011 — Shared identities and limited MFA weaken clinical accountability
  - GAP-016 — Public-service and intersite trust boundaries lack verified least-privilege enforcement
  - GAP-003 — PACS imaging has no documented recovery copy

Break Points:
  - Step 1 — Complete C-032/C-033 with Radiology-specific phishing exercises and add centrally managed email authentication and attachment or link protection to reduce successful delivery and execution.
  - Step 2 — C-017–C-021 can block, detect or quarantine malware on covered workstations; rapid alert handling and individual MFA-backed PACS sessions should replace C-052's shared login.
  - Step 3 — Permit only validated modality and Radiology-management flows to PACS and block general workstation access to unnecessary PACS and SMB services.
  - Step 4 — Add an isolated PACS recovery copy and routinely test image-service restoration to close GAP-003 before encryption becomes an unrecoverable clinical outage.
```

## Kill Chain #4: Privileged Insider Manipulation of Infusion Pumps

```yaml
Threat Actor: Insider (Malicious) — T6 profile with Medium likelihood, Low–Medium capability and possible financial, revenge or deliberate-harm motivation
Target Asset: BD Alaris infusion-pump fleet — A-061 through A-067 plus aggregate fleet entries
Expected Impact: Unauthorized pump configuration or service disruption with direct patient-safety consequences — Integrity and Availability

Step 1 - Initial Access:
  Vector: Insider (Malicious)
  Surface: Human
  Detail: A biomedical, clinical or IT insider uses a legitimate role or retained credential to access a workstation or interface involved in pump administration.

Step 2 - Establish Foothold:
  Action: The insider preserves access through a reusable management credential or an unattended administrative session that is not individually attributable.
  MedDefense Weakness: GAP-018 records the medical-device credential baseline as unverified, while GAP-011 records shared-identity and MFA limitations; unchanged factory defaults are not assumed.

Step 3 - Lateral Movement / Escalation:
  Action: The insider enumerates pump web interfaces on ports 80/443 across the flat medical-device network and reaches additional fleet members from the authorized endpoint.
  MedDefense Weakness: GAP-016 provides no verified least-privilege segmentation between general management origins and medical-device destinations.

Step 4 - Objective Execution:
  Action: Where the obtained role permits it, the insider changes device configuration, disrupts connectivity or sends an unauthorized fleet-management action.
  Data/System Affected: BD Alaris firmware and management configuration, network dosage-update functions and the availability of affected pumps; direct alteration of an active infusion is not asserted as proven capability.

Step 5 - Impact:
  Business Impact: Biomedical and clinical teams may need to remove devices from service, verify settings and shift to manual or replacement workflows, with potential treatment delay and patient-safety consequences.
  CIA Pillars: Integrity is affected by unauthorized configuration or dosage-update changes, and Availability by pump isolation, reset or loss of trusted operation; Confidentiality is secondary and data scope is unverified.

Gaps Exploited:
  - GAP-018 — Medical-device management credential baseline is unverified
  - GAP-011 — Shared identities and limited MFA weaken clinical accountability
  - GAP-016 — Public-service and intersite trust boundaries lack verified least-privilege enforcement
  - GAP-001 — Infusion pumps lack device-specific detection and recovery

Break Points:
  - Step 1 — Assign individual role-based biomedical accounts, remove stale access and require MFA or an equivalent vendor-supported strong control for pump administration.
  - Step 2 — Validate and rotate device-management credentials, prohibit shared or factory-default use and record privileged sessions to close GAP-018 without disrupting clinical operation.
  - Step 3 — Place the pump fleet behind allowlisted medical-device controls that accept management only from approved stations and protocols.
  - Step 4 — Alert on fleet configuration changes, require dual authorization for high-risk actions and maintain tested device-safe configuration recovery under GAP-001.
```

## Kill Chain #5: Compromised MedTech Channel to EHR Records

```yaml
Threat Actor: Nation-State APT — T6 profile with Low MedDefense-specific likelihood, High capability and espionage motivation
Target Asset: EHR database ehr-db-01 and logical store — A-037/A-112
Expected Impact: Stealthy patient-record collection or manipulation affecting clinical decisions in an organization handling information for more than 50,000 patients — Confidentiality and Integrity, with possible Availability impact

Step 1 - Initial Access:
  Vector: Supply Chain Compromise
  Surface: External
  Detail: An APT compromises a MedTech maintenance identity, service system or accepted software update and uses the trusted relationship to reach ehr-srv-01.

Step 2 - Establish Foothold:
  Action: The actor places a persistent application component or reuses valid vendor access while blending activity with legitimate EHR maintenance.
  MedDefense Weakness: C-054/C-055 establish support and software-update obligations but do not evidence vendor-specific MFA, time-limited access, session approval, update integrity validation or independent monitoring.

Step 3 - Lateral Movement / Escalation:
  Action: The actor obtains application-held database credentials or an authorized connection and follows the EHR dependency from ehr-srv-01 to PostgreSQL on ehr-db-01.
  MedDefense Weakness: GAP-006 records database access broader than the documented application need, and GAP-016 leaves the effective third-party and internal trust boundary unverified.

Step 4 - Objective Execution:
  Action: The actor queries and exports patient records or makes subtle changes intended to remain unnoticed within ordinary application activity.
  Data/System Affected: Restricted EHR medical records and lab information in PostgreSQL on ehr-db-01 A-037/A-112; actual vendor database privileges remain to be validated.

Step 5 - Impact:
  Business Impact: MedDefense can face patient privacy harm, unsafe clinical decisions from corrupted records, investigation and notification costs, loss of trust and service interruption if the database must be isolated.
  CIA Pillars: Confidentiality is affected by covert collection, Integrity by record manipulation, and Availability if containment or destructive action interrupts the EHR.

Gaps Exploited:
  - GAP-011 — Shared identities and limited MFA weaken clinical accountability
  - GAP-016 — Public-service and intersite trust boundaries lack verified least-privilege enforcement
  - GAP-006 — EHR database access is broader than the documented application need
  - GAP-017 — Patient-record bulk export lacks documented authorization and detection safeguards

Break Points:
  - Step 1 — Pair C-054/C-055 with named vendor identities, phishing-resistant MFA, time-bound approval, source restrictions and cryptographic update validation before maintenance reaches production.
  - Step 2 — Application allowlisting, file-integrity monitoring and independent review of vendor sessions could expose persistence that valid SSH or maintenance credentials would otherwise conceal.
  - Step 3 — Restrict PostgreSQL 5432 to the validated EHR service path, use a least-privilege application identity and alert on new source systems or privilege changes to close GAP-006.
  - Step 4 — Replace C-037's 48-hour export delay with timely EHR audit review, bulk-query thresholds and authorized-export approval so collection or anomalous modification is interrupted before completion.
```

## Cross-Chain Defensive Priority

The earliest reusable intervention is identity and boundary control: individual MFA-backed access, time-limited vendor and administrator privileges, restrictive VPN and east-west rules, and centrally reviewed authentication events can interrupt all five scenarios before objective execution. The second reusable intervention is recoverability and integrity assurance: reviewed changes, independent clinical-data validation and isolated tested recovery reduce the impact when prevention fails. Existing perimeter denial, endpoint protection, logging, redundancy and backups remain useful, but their documented scope does not cover every server, device, supplier session or clinical recovery requirement represented in these chains.
