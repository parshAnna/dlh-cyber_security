# Task 10 — The MedDefense Risk Register

- **Organization:** MedDefense Health Systems
- **Project:** 1x03 — Defense Blueprint
- **Deliverable:** `10-risk_register.md`
- **Register version:** 1.0 — proposed baseline, 29 October 2026
- **Prepared for:** James Chen (Deputy CISO), Robert Kim (CFO), Sarah Park (IT Director), clinical risk owners and the Board
- **Purpose:** A living register of ten prioritized risk events; proposed controls have **not** been represented as deployed or verified.
- **Scope of authority:** The Task 8 five-control **$97,000 annualized / $115,000 estimated first-year cash** portfolio is a **proposal**, not approval to spend. The actual six-month program shares a **$120,000 overall cash ceiling**, which must be reconciled before purchase orders.

## Scoring Method and Interpretation

**Inherent risk** is rated before proposed mitigations; **target residual risk** is the score anticipated *only after* the specified controls pass acceptance testing. It is not current risk. The consistent qualitative score is **Likelihood (1–5) × Impact (1–5)**, yielding **1–25**. Different combinations can share a score; patient safety, legal duties and clinical urgency may override purely numerical priority.

| Likelihood | Definition | Annual rate guide, where a scenario ARO is available |
|---:|---|---|
| **1 — Rare** | Exceptional event | <0.02 events/year |
| **2 — Unlikely** | Infrequent but credible | 0.02 to <0.10 events/year |
| **3 — Possible** | Plausible recurrent threat | 0.10 to <0.50 events/year |
| **4 — Likely** | Occurs regularly | 0.50 to <2.00 events/year |
| **5 — Frequent** | Multiple events per year | >=2.00 events/year |

When there is no measured ARO, Likelihood is an **explicit analyst judgment**, not a fabricated probability. ARO is scenario-provided and often uncertain; category labels are deliberately coarse, so a modeled ALE may decrease without crossing a 1–5 Likelihood boundary.

| Impact | Definition / primary decision criterion |
|---:|---|
| **1 — Negligible** | Minimal service disruption; roughly <$10,000 loss, no patient impact |
| **2 — Minor** | Local, recoverable operational loss; roughly $10,000 to <$100,000 |
| **3 — Moderate** | Material localized business loss; roughly $100,000 to <$500,000 |
| **4 — Major** | Prolonged enterprise service disruption, reportable sensitive-data event or roughly $500,000 to <$2 million |
| **5 — Severe/Catastrophic** | Potential severe patient harm, prolonged critical clinical outage or >=$2 million modeled loss |

Use the **higher defensible clinical/regulatory or financial category**, not an arbitrary sum of impacts. **Rating bands:** 1–4 Low; 5–9 Moderate; 10–15 High; 16–25 Critical. A 15-point clinical risk can need immediate action even though 20-point compliance exposure ranks higher arithmetically.

**Evidence / finance controls:** T5/T6 calculate ALE only for five distinct teaching scenarios: R1 EHR **$3,025,000**, R2 VPN/compound **$2,864,400**, R3 negligent insider **$300,000**, R4 billing **$135,143**, R5 Alaris **$70,000** per year. The joint VPN scenario **reuses EHR and billing consequences**, so never sum these as an enterprise total or add the T6 bundled after-control benefits to T7's marginal benefits. For other risks, **NQ = not quantified, not zero**. Finding 010's firmware/CVE match and Finding 031's Ghostcat/version match remain unverified; network/credential misconfigurations can be actionable independently. Where a direct numbered vulnerability finding does not exist (pharmacy), state the absence rather than invent one.

## Risk Register — Executive Summary

| ID | Risk event | Category | Inherent L×I | Inherent band | Baseline ALE/yr | Treatment | Target residual L×I | Accountable owner | Next review |
|---|---|---|---:|---|---:|---|---:|---|---|
| **[RISK-001](#risk-001)** | EHR exfiltration and patient-data breach | Compliance | **3×5=15** | High | $3,025,000/year | Mitigate | 15 (conditional) | EHR Clinical Data Owner | 06 November 2026 |
| **[RISK-002](#risk-002)** | VPN foothold and domain-wide ransomware | Operational | **3×5=15** | High | $2,864,400/year | Mitigate | 15 (conditional) | James Chen, Deputy CISO | 06 November 2026 |
| **[RISK-003](#risk-003)** | PACS imaging outage or extortion without tested recovery | Operational | **3×5=15** | High | NQ | Mitigate | 12 (conditional) | Radiology Department Head | 06 November 2026 |
| **[RISK-004](#risk-004)** | BD Alaris management compromise and infusion interruption | Operational | **3×5=15** | High | $70,000/year | Mitigate | 15 (conditional) | Biomedical Engineering Manager | 06 November 2026 |
| **[RISK-005](#risk-005)** | Unsafe pharmacy update changes medication dosage | Operational | **3×5=15** | High | NQ | Mitigate | 10 (conditional) | Pharmacy Department Head / Chief Pharmacist | 06 November 2026 |
| **[RISK-006](#risk-006)** | Unsupported MRI controller exploited as clinical foothold | Operational | **3×5=15** | High | NQ | Mitigate | 10 (conditional) | Radiology Department Head, jointly coordinating implementation | 06 November 2026 |
| **[RISK-007](#risk-007)** | Negligent insider patient-information disclosure | Compliance | **5×4=20** | Critical | $300,000/year | Mitigate | 20 (conditional) | Data Protection Officer | 06 November 2026 |
| **[RISK-008](#risk-008)** | Billing-server ransomware and prolonged revenue outage | Financial | **3×4=12** | High | $135,143/year | Mitigate | 9 (conditional) | Robert Kim, CFO | 06 November 2026 |
| **[RISK-009](#risk-009)** | Westside weak perimeter and unmanaged site services | Operational | **3×4=12** | High | NQ | Mitigate | 8 (conditional) | Sarah Park, IT Director, | 30 November 2026 |
| **[RISK-010](#risk-010)** | Legacy print-server compromise enables internal pivot | Operational | **3×4=12** | High | NQ | Mitigate | 8 (conditional) | Sarah Park, IT Director | 30 November 2026 |

**Read this table as a set of distinct risk entries, not as a portfolio loss sum.** Detailed records below contain all 17 required fields, source traceability, scoring rationale, detection thresholds and validation actions. A "target residual" score is a conditional projection; current residual exposure remains at inherent levels unless control evidence proves otherwise.

## Detailed Risk Entries

### RISK-001 — EHR exfiltration and patient-data breach

- **Risk ID:** **RISK-001**
- **Risk Description:** A compromised supplier identity or authenticated internal foothold could extract protected patient records from the EHR, creating large notification, liability and operational losses.
- **Risk Category:** Compliance
- **Threat Source:** Compromised MedTech maintenance supplier / nation-state APT (1x01 KC5); insider S2 is a separate pathway.
- **Vulnerability:** Finding 003 (direct: overbroad PostgreSQL source range with MD5 authentication still required); Finding 031 (AJP reachability, CVE applicability unverified); Finding 023 (adjacent only).
- **Affected Asset(s):** `ehr-db-01` (A-037), EHR data (A-112), `ehr-srv-01` (application tier; registry ID to confirm).
- **Likelihood:** **3/5** — Task 5 models a full breach at 1/3 event/year (~0.333); this lies in the 0.1 to <0.5 band, but is unvalidated.
- **Impact:** **5/5** — Modeled full-event loss is $9,075,000, with potential GDPR and patient-trust consequences.
- **Inherent Risk Score:** **3 × 5 = 15/25 (High)**.
- **ALE:** **$3,025,000/year** (T5/T6 R1 gross-additive full-breach case; may double-count certain costs).
- **Risk Owner:** EHR Clinical Data Owner (accountable role; named individual to be appointed), supported by Sarah Park, IT Director and DPO.
- **Treatment Decision:** **Mitigate**
- **Treatment Justification:** Sensitive patient information and the large conditional loss justify access restriction and prompt detection instead of reliance on insurance or risk acceptance.
- **Planned Control(s):** **C1** segmentation (T7); **C3** Wazuh EHR/database event monitoring (funded in T8); export-role approvals and query limits are additional non-T7 actions requiring a scoped owner and funding.
- **Residual Risk:** **Target L3 × I5 = 15 (High), not yet achieved.** T7 assigns C3 only a $90,000 marginal benefit to R1, giving **$2,935,000/year** modeled residual R1 ALE; other C1 benefits are not added again to this event because T7 attributes them to the overlapping R2 chain.
- **KRI:** Any unapproved bulk patient export, or EHR security-audit review delay >24 hours (current evidence suggests ~48-hour delay); threshold: **1 event or 1 delay breach**.
- **Review Date:** **06 November 2026**
- **1x00 Gap Trace:** GAP-006, GAP-017, GAP-016.
- **Validation / Next Action:** Obtain data-owner authorization matrix, source-allowlist and EHR workflow test, EHR alert test and legal/privacy verification of nonoverlapping loss costs.
- **Prioritization Note:** Critical clinical/data priority despite a 15-point matrix score.

### RISK-002 — VPN foothold and domain-wide ransomware

- **Risk ID:** **RISK-002**
- **Risk Description:** An attacker using VPN credentials or another initial foothold could traverse weak internal trust boundaries, compromise Active Directory and disrupt multiple MedDefense services.
- **Risk Category:** Operational
- **Threat Source:** Ransomware affiliates / external intruders (1x01 KC1), with a separate possible EHR/record-theft consequence.
- **Vulnerability:** Findings 007 and 018 (supporting AD LDAP-signing and Kerberos weaknesses), 003 (downstream DB source scope), 014 (Westside site-router issue); no specific FortiGate CVE confirmed.
- **Affected Asset(s):** FortiGate VPN gateway (registry ID to verify), `ad-dc-01` (A-040), `ad-dc-02` (A-041), `ehr-db-01` (A-037), `billing-srv-01` (A-039).
- **Likelihood:** **3/5** — Task 5 supplies VPN compromise rate ARO=0.30/year, but the chance of progression into the full campaign is unknown.
- **Impact:** **5/5** — Modeled joint campaign SLE $9,548,000, with loss of identity and clinical-business availability.
- **Inherent Risk Score:** **3 × 5 = 15/25 (High)**.
- **ALE:** **$2,864,400/year** (T5/T6 R2, deliberately conservative full-chain assumption q=1).
- **Risk Owner:** James Chen, Deputy CISO (enterprise cyber risk); Sarah Park, IT Director, leads technical treatment.
- **Treatment Decision:** **Mitigate**
- **Treatment Justification:** MFA and least-privilege boundaries cost far less than the potential ransomware disruption, conditional on validated control efficacy.
- **Planned Control(s):** **C2** VPN/admin MFA; **C1** segmentation; **C6** Westside firewall; **C3** Wazuh monitoring (all selected in T8).
- **Residual Risk:** **Target L3 × I5 = 15 (High), not yet achieved.** T7 sequential benefit ledger credits $310,000 + $240,000 + $35,000 + $65,000 = $650,000 to R2, yielding **$2,214,400/year** modeled residual R2 ALE; the coarse likelihood band stays L3.
- **KRI:** VPN privileged-account MFA coverage <100%, any unauthorized VPN-to-AD/EHR path, or an unexplained privileged sign-in; threshold: **any occurrence**.
- **Review Date:** **06 November 2026**
- **1x00 Gap Trace:** GAP-016, GAP-011, GAP-007.
- **Validation / Next Action:** Verify identity licensing, named privileged accounts, allowed/denied network flows, AD logging and escalation ownership; recalibrate unknown full-chain progression probability q.
- **Prioritization Note:** Critical operational priority; compound risk overlaps RISK-001 and RISK-008.

### RISK-003 — PACS imaging outage or extortion without tested recovery

- **Risk ID:** **RISK-003**
- **Risk Description:** Radiology compromise or ransomware could make PACS images unavailable or expose patient studies while the organization lacks a proven independent PACS recovery copy.
- **Risk Category:** Operational
- **Threat Source:** Ransomware affiliate moving from radiology access to imaging extortion (1x01 KC3).
- **Vulnerability:** Finding 024 (unencrypted patient-linked DICOM, adjacent confidentiality issue); Finding 004 (XP MRI controller, adjacent foothold); **backup absence comes from 1x00 C-022, not a direct 1x02 finding**.
- **Affected Asset(s):** PACS (A-038), Siemens MRI (A-091), radiology MRI-control `WS-RAD-01` (A-016), imaging studies (registry data-ID to verify).
- **Likelihood:** **3/5** — Analyst qualitative estimate of a plausible ransomware chain; no event-specific PACS ARO was supplied.
- **Impact:** **5/5** — Radiology imaging unavailability can impair time-critical diagnosis and prolong clinical downtime.
- **Inherent Risk Score:** **3 × 5 = 15/25 (High)**.
- **ALE:** **Not quantified (NQ).** T5/T6 provide no separate PACS outage SLE/ARO; do not substitute the billing ALE or report $0.
- **Risk Owner:** Radiology Department Head (clinical risk owner), supported by Sarah Park and the PACS service owner.
- **Treatment Decision:** **Mitigate**
- **Treatment Justification:** Unrecoverable or unavailable diagnostic imaging is a clinical continuity risk that cannot be accepted just because a distinct ALE is missing.
- **Planned Control(s):** **C4** immutable offsite backup replication (PACS coverage/fast-tier retrieval must be included and validated); **C1** approved radiology segmentation; **C3** PACS alerting where safe (selected in T8).
- **Residual Risk:** **Target L3 × I4 = 12 (High)** *only after* successful application-consistent PACS backup and full clinical restoration test; otherwise **L3 × I5 = 15 (High)** remains. Residual ALE **NQ**; T7 assigns C4 benefit to billing only, not PACS.
- **KRI:** No independently recoverable PACS copy, or >1 day since most recent verified PACS backup; threshold: **any breach**, followed by immediate clinical escalation.
- **Review Date:** **06 November 2026**
- **1x00 Gap Trace:** GAP-003, GAP-007, GAP-016.
- **Validation / Next Action:** Obtain Radiology-approved RTO/RPO, independent image+metadata recovery copy, DICOM workflow tests and documented restoration time.
- **Prioritization Note:** Patient-care priority independent of the missing quantitative ALE.

### RISK-004 — BD Alaris management compromise and infusion interruption

- **Risk ID:** **RISK-004**
- **Risk Description:** Abuse of broadly reachable infusion-pump management credentials could interrupt device availability or jeopardize treatment configuration and patient safety.
- **Risk Category:** Operational
- **Threat Source:** Malicious or misusing biomedical/clinical/IT insider (1x01 KC4); opportunistic intruder is an additional plausible actor.
- **Vulnerability:** Finding 010 (reported 7/7 default `admin/admin` credentials and management reachability); **CVE-2020-25165 applicability for version 12.1.2 is disputed**.
- **Affected Asset(s):** Seven BD Alaris infusion pumps (A-061 through A-067), pump-management services (registry ID to verify).
- **Likelihood:** **3/5** — T5 uses two assumed nonoverlapping event rates, DoS 0.10/year and safety event 0.02/year; their combined event-class rate 0.12/year is in band L3.
- **Impact:** **5/5** — Although monetary ALE is moderate, credible medication-delivery disruption or severe patient injury warrants maximum impact.
- **Inherent Risk Score:** **3 × 5 = 15/25 (High)**.
- **ALE:** **$70,000/year** (T5/T6 R5: $10,000 DoS-only plus $60,000 patient-safety-event, if event classes are nonoverlapping).
- **Risk Owner:** Biomedical Engineering Manager with Clinical Patient-Safety Lead; James Chen escalates cyber aspects.
- **Treatment Decision:** **Mitigate**
- **Treatment Justification:** Patient-safety duties require vendor-approved management hardening even when full isolation C8 fails a financial-only test.
- **Planned Control(s):** **C1** approved medical-device management zoning (selected T8); **C8** full isolation/dedicated monitoring **deferred**, not treated as deployed; immediate vendor-approved credential change, access allowlist, passive alerts and safe fallback are mandatory actions outside full C8.
- **Residual Risk:** **Current/projected until verified: L3 × I5 = 15 (High), $70,000/year proxy unchanged.** If C8 were later fully delivered, T7 assumes $35,000/year residual, but **that unfunded benefit is NOT credited** to the current portfolio.
- **KRI:** Any pump retaining default management credentials, unauthorized management session, or failed clinically supervised fallback; threshold: **one device/event**.
- **Review Date:** **06 November 2026**
- **1x00 Gap Trace:** GAP-001, GAP-016.
- **Validation / Next Action:** Validate firmware and advisory with BD, rotate supported credentials, inspect safe access paths and perform biomedical-approved monitoring/recovery drill without touching active infusions.
- **Prioritization Note:** Patient safety override: immediate clinical escalation despite C8 deferral.

### RISK-005 — Unsafe pharmacy update changes medication dosage

- **Risk ID:** **RISK-005**
- **Risk Description:** An inadequately reviewed pharmacy production change could alter dosage values, evade timely validation and expose patients to incorrect medication.
- **Risk Category:** Operational
- **Threat Source:** Negligent authorized pharmacy/IT insider (1x01 KC2; a process/integrity failure, not necessarily a malicious attack).
- **Vulnerability:** **No direct numbered Finding in 1x02.** The evidence is 1x00 pharmacy Incident C (~six hours undetected), C-044, GAP-002 and GAP-022; Finding 023 is only an adjacent endpoint-policy issue, not proof of a pharmacy application flaw.
- **Affected Asset(s):** Pharmacy dispensing / dose-management application and medication records (1x00 asset-registry names/IDs require confirmation before assignment).
- **Likelihood:** **3/5** — Qualitative possible rating based on a documented historic incorrect-update incident; no validated annual occurrence rate.
- **Impact:** **5/5** — Wrong medication dosing can directly threaten patient safety and has a severe clinical consequence independent of monetized ALE.
- **Inherent Risk Score:** **3 × 5 = 15/25 (High)**.
- **ALE:** **Not quantified (NQ).** No pharmacy-specific SLE or ARO in T5/T6; a fabricated ALE would mislead clinical governance.
- **Risk Owner:** Pharmacy Department Head / Chief Pharmacist (clinical process owner), with application-change owner in IT.
- **Treatment Decision:** **Mitigate**
- **Treatment Justification:** The reported production integrity failure demands dual authorization, validation and recoverable rollback rather than financial-only risk acceptance.
- **Planned Control(s):** **C3** Wazuh alerting for approved change logs, where supported (T7 selected); **C1** application-zone restrictions; crucial peer approval, staged dose checks, signed change ticket and rollback are **additional operational controls not separately priced in T7**.
- **Residual Risk:** **Target L2 × I5 = 10 (High)** only if independent pharmacist review, automated dose-bound checks and tested rollback operate; absent that evidence, **L3 × I5 = 15 (High)** remains. Residual ALE **NQ**.
- **KRI:** Any production pharmacy dosage update without independent pharmacist sign-off, or any failed dose-range validation; threshold: **1 exception**.
- **Review Date:** **06 November 2026**
- **1x00 Gap Trace:** GAP-002, GAP-022.
- **Validation / Next Action:** Name a clinical change approver, stage and cross-check dosing changes across the three sites, test restoration and record exception escalation.
- **Prioritization Note:** Immediate clinical integrity priority even though no 1x02 Finding ID or ALE exists.

### RISK-006 — Unsupported MRI controller exploited as clinical foothold

- **Risk ID:** **RISK-006**
- **Risk Description:** An attacker exploiting the unsupported Windows XP MRI controller over reachable legacy management protocols could disrupt radiology operations and pivot toward PACS.
- **Risk Category:** Operational
- **Threat Source:** Ransomware affiliates / opportunistic external or internal intruders; adjacent to 1x01 KC3 and potentially KC1.
- **Vulnerability:** Finding 004 (EOL Windows XP SP3, SMB/RDP exposure and multiple historical remotely exploitable vulnerabilities); applicability and actual path validation required for specific exploits.
- **Affected Asset(s):** MRI controller `WS-RAD-01` (A-016), Siemens MRI (A-091), PACS (A-038).
- **Likelihood:** **3/5** — Qualitative possible event from reachable EOL device; no MRI-specific yearly event rate supplied.
- **Impact:** **5/5** — MRI interruption can delay diagnosis and the asset is a plausible stepping stone toward image-system disruption.
- **Inherent Risk Score:** **3 × 5 = 15/25 (High)**.
- **ALE:** **Not quantified (NQ).** Neither MRI downtime SLE nor compromise frequency is established in T5/T6.
- **Risk Owner:** Radiology Department Head, jointly coordinating implementation with Biomedical Engineering Manager.
- **Treatment Decision:** **Mitigate**
- **Treatment Justification:** Vendor-approved isolation can reduce a known critical legacy exposure without destabilizing certified imaging software.
- **Planned Control(s):** **C1** least-privilege radiology segmentation; **C3** passive/adjacent network alerts; **C4** PACS recovery support (selected T8); replacement/upgrade requires a separate vendor lifecycle decision.
- **Residual Risk:** **Target L2 × I5 = 10 (High)** after verified isolation and permitted DICOM/workflow testing; otherwise **L3 × I5 = 15 (High)**. ALE **NQ**.
- **KRI:** Any unauthorized SMB/RDP reachability to `WS-RAD-01` from a nonapproved network segment; threshold: **1 validated route**.
- **Review Date:** **06 November 2026**
- **1x00 Gap Trace:** GAP-016; legacy clinical-platform containment gaps documented in 1x00..
- **Validation / Next Action:** Approve allowlisted source/port matrix with Siemens and Radiology, block unrelated SMB/RDP, test imaging connectivity, plan lifecycle retirement.
- **Prioritization Note:** Critical medical-technology legacy risk.

### RISK-007 — Negligent insider patient-information disclosure

- **Risk ID:** **RISK-007**
- **Risk Description:** A staff member or contractor could accidentally disclose patient information through unrestricted removable storage, excessive exports or improper data handling.
- **Risk Category:** Compliance
- **Threat Source:** Negligent employee or contractor (1x01 insider context S2 is adjacent but models *intentional* export, not this exact accidental scenario).
- **Vulnerability:** Finding 023 (unrestricted clinical-workstation USB: supporting pathway); **no 1x02 finding establishes a particular negligent event**.
- **Affected Asset(s):** Clinical workstation fleet and EHR records (A-112); individual workstation registry IDs require cross-check.
- **Likelihood:** **5/5** — Task 5 supplies 2–3 negligent incidents/year; midpoint ARO=2.5 meets L5 (>=2/year). Do not multiply by the scenario 60% negligence share again.
- **Impact:** **4/5** — A $120,000 representative event may trigger sensitive patient-data notification and regulatory/reputational exposure even below the I4 monetary threshold.
- **Inherent Risk Score:** **5 × 4 = 20/25 (Critical)**.
- **ALE:** **$300,000/year** (T5/T6 R3: $120,000 SLE × 2.5/year).
- **Risk Owner:** Data Protection Officer (DPO; role) with HR and relevant Clinical Department Heads.
- **Treatment Decision:** **Mitigate**
- **Treatment Justification:** Repeated reportable patient-data errors require attributable export access and practical staff controls rather than solely purchasing perimeter technologies.
- **Planned Control(s):** **C3** selected SIEM can help monitor export activity, but **T7/T8 assign no direct quantified ARR for R3**; named export approvals, USB/DLP policy and staff training require a separate funded/owned action (not automatically C5 EDR).
- **Residual Risk:** **L5 × I4 = 20 (Critical)** until export and training controls are funded and demonstrated; **$300,000/year** remains the conservative R3 proxy in the T8 portfolio, not the T6 hypothetical $150,000 after an unfunded bundle.
- **KRI:** Any unauthorized patient export to removable media, or >0 privacy incident without an identified owner and containment ticket; threshold: **1 incident**.
- **Review Date:** **06 November 2026**
- **1x00 Gap Trace:** GAP-017, GAP-011.
- **Validation / Next Action:** Prioritize DPO-approved export restrictions, exception logging, clinical training and incident reporting metrics; present the unallocated treatment need to Finance.
- **Prioritization Note:** Highest numeric inherent score due to repeat frequency; risk not solved by the funded five controls alone.

### RISK-008 — Billing-server ransomware and prolonged revenue outage

- **Risk ID:** **RISK-008**
- **Risk Description:** Remote exploitation of the billing web stack could lead to server takeover, encrypted billing operations and substantial recovery costs.
- **Risk Category:** Financial
- **Threat Source:** Ransomware affiliate / financially motivated attacker (KC1-compatible parallel entry path, not a named KC1 hop).
- **Vulnerability:** Finding 001 (Apache mod_lua RCE), Finding 002 (Apache local privilege escalation after foothold), Finding 015 (adjacent exposed backup-NAS management).
- **Affected Asset(s):** `billing-srv-01` (A-039), billing records (A-113) and shared backup infrastructure (NAS registry ID to verify).
- **Likelihood:** **3/5** — Task 5 uses 1/3.5 ~ 0.2857 events/year, inside the L3 frequency band.
- **Impact:** **4/5** — The modeled $473,000 event includes 18 days of billing disruption and recovery/conditional legal expenses, qualifying as prolonged material business outage.
- **Inherent Risk Score:** **3 × 4 = 12/25 (High)**.
- **ALE:** **$135,143/year** (T5/T6 R4, rounded from $473,000/3.5).
- **Risk Owner:** Robert Kim, CFO (revenue continuity risk owner), with Sarah Park responsible for technical recovery.
- **Treatment Decision:** **Mitigate**
- **Treatment Justification:** Tested protected backups and patching reduce potential revenue interruption more predictably than accepting the known RCE/LPE chain.
- **Planned Control(s):** **C4** offsite immutable backup replication; **C1** segmentation and **C3** alerting (selected T8), plus Apache patch/remediation required outside these separately costed controls.
- **Residual Risk:** **Target L3 × I3 = 9 (Moderate)** assuming verified shorter restoration from C4; T7 allocates $45,000 marginal R4 reduction and **$90,143/year** modeled residual (rounded). If restore tests fail, retain **L3 × I4 = 12 (High)**.
- **KRI:** Any overdue validated critical Apache remediation beyond 7 calendar days or any full-billing restore missing its approved RTO; threshold: **one violation**.
- **Review Date:** **06 November 2026**
- **1x00 Gap Trace:** GAP-007, GAP-016.
- **Validation / Next Action:** Confirm vulnerable Apache modules/versions, fix or disable unsafe exposure, isolate backup admin access and prove application-plus-data restoration.
- **Prioritization Note:** Finance-owned material disruption, with $100,000 penalty component explicitly conditional.

### RISK-009 — Westside weak perimeter and unmanaged site services

- **Risk ID:** **RISK-009**
- **Risk Description:** An attacker could exploit Westside Clinic’s inadequate perimeter equipment or an unapproved internal service to establish a foothold and traverse trusted intersite connections.
- **Risk Category:** Operational
- **Threat Source:** Opportunistic financially motivated external attacker or ransomware affiliate, compatible with the broader KC1 lateral-movement model.
- **Vulnerability:** Finding 014 (consumer-grade Netgear router at Westside), Finding 029 (undocumented Grafana 8.2.0 host, associated path-traversal exposure); neither proves a successful cross-site compromise.
- **Affected Asset(s):** Westside Clinic site router and unknown Grafana host (`10.10.10.200`); exact registry IDs not evidenced and must be reconciled with 1x00.
- **Likelihood:** **3/5** — Qualitative possible site compromise; no Westside-specific ARO is available.
- **Impact:** **4/5** — A weak perimeter may compromise multiple site services and enable larger, already separately modeled domain impact.
- **Inherent Risk Score:** **3 × 4 = 12/25 (High)**.
- **ALE:** **Not quantified (NQ) separately.** Potential downstream VPN/domain losses already sit in T5/T6 R2; do not charge those dollars twice.
- **Risk Owner:** Sarah Park, IT Director, with Westside Clinic Site Manager for service continuity.
- **Treatment Decision:** **Mitigate**
- **Treatment Justification:** A supported centrally managed site firewall and validated asset ownership close a concrete entry-path control gap.
- **Planned Control(s):** **C6** centrally managed Westside firewall; **C1** intersite segmentation; **C3** site telemetry (all selected T8); restrict or retire undocumented Grafana after ownership review.
- **Residual Risk:** **Target L2 × I4 = 8 (Moderate)** upon validated firewall changeover, denied disallowed intersite paths and Grafana disposition; otherwise **L3 × I4 = 12 (High)**. ALE **NQ**; C6 $35,000 marginal benefit is already attributed to R2, not added again.
- **KRI:** Any unapproved intersite allow-all rule, unknown external-facing site service, or failure of firewall alert intake; threshold: **one observed condition**.
- **Review Date:** **30 November 2026**
- **1x00 Gap Trace:** GAP-016; undocumented-device inventory gap.
- **Validation / Next Action:** Replace consumer router safely, test medical and business traffic, investigate Grafana ownership and track WAN configuration backups.
- **Prioritization Note:** Priority extends beyond replacing hardware: asset ownership and cross-site policy validation required.

### RISK-010 — Legacy print-server compromise enables internal pivot

- **Risk ID:** **RISK-010**
- **Risk Description:** A PrintNightmare-class flaw on the unsupported print server could grant elevated access and support lateral movement toward higher-value MedDefense systems.
- **Risk Category:** Operational
- **Threat Source:** Opportunistic intruder or ransomware affiliate using Windows service exploitation as a KC1-compatible pivot (not explicitly a KC1 step).
- **Vulnerability:** Finding 008 (Windows Server 2012 R2 EOL, exposed spooler and CVE-2021-34527 PrintNightmare-family exposure).
- **Affected Asset(s):** `print-srv-01` (A-043), domain authentication and adjacent workstations (individual IDs to verify).
- **Likelihood:** **3/5** — Analyst possible estimate based on known-service exposure and unsupported OS; no verified annual exploit rate.
- **Impact:** **4/5** — SYSTEM-level server compromise and a plausible AD-adjacent pivot can materially disrupt internal operations.
- **Inherent Risk Score:** **3 × 4 = 12/25 (High)**.
- **ALE:** **Not quantified (NQ).** No print-server-specific SLE or ARO in T5/T6; domain consequences may overlap R2.
- **Risk Owner:** Sarah Park, IT Director (IT Infrastructure / Print Service Owner).
- **Treatment Decision:** **Mitigate**
- **Treatment Justification:** Restricting spooler access and replacing unsupported infrastructure prevents an avoidable internal pivot without inventing a separate ALE.
- **Planned Control(s):** **C1** restrict Windows print-service network paths; **C3** server log alerts, both selected T8; disable unnecessary spooler features and procure supported replacement as a separate lifecycle decision.
- **Residual Risk:** **Target L2 × I4 = 8 (Moderate)** after verified spooler restriction and isolation; otherwise **L3 × I4 = 12 (High)**, with ALE **NQ**. Replacement remains necessary to eliminate EOL exposure.
- **KRI:** Printer spooler RPC reachable from any nonapproved subnet, or unsupported host still in production after signed retirement deadline; threshold: **one finding**.
- **Review Date:** **30 November 2026**
- **1x00 Gap Trace:** GAP-016; legacy system lifecycle and patch/segmentation weaknesses.
- **Validation / Next Action:** Validate Print Spooler requirements, restrict/disable where safe, deploy signed firewall rules and agree an EOL replacement date.
- **Prioritization Note:** High internal-pivot priority; not a new independent dollar claim on R2.

## Operating State, Treatment Tracking and Evidence Gates

- **Status (all ten at creation):** `Open — assessed / treatment proposed`; do **not** report `Mitigated` or `Accepted` before deployment evidence and a signed decision. Treatment selection in Task 8 is provisional: C1/C2/C3/C4/C6 are selected subject to cash, licensing, vendor and clinical gates; C5 and full C8 were deferred, and C7's full 24/7 contract rejected.
- **Ownership workflow:** Each owner must confirm the asset registry ID, service dependency, control implementer, dated remediation/exception ticket and residual risk decision. Where named people are absent from source documents, this register uses the accountable *role* rather than inventing a person.
- **Evidence-driven closure:** Change tickets, MFA and network negative/positive tests, database allowlist evidence, version/firmware confirmation, alert exercise, restore results and clinical sign-off must be linked in the operational issue tracker before lowering a risk score. The analyst should log `last reviewed`, `last evidence date`, decision/exception ID and `next action due` in the maintained system; the Markdown baseline is a published snapshot.
- **Time-base consistency:** T7/T8 dollars are annualized decision scores, while actual six-month program cash is capped at $120,000 overall. Expected ALE and risk-control economics are assumptions, not actual realized losses or confirmed savings. Do not apply separate portfolio claims to the same VPN-to-EHR/billing event.
- **Prioritization override:** Patient safety risks RISK-003/004/005/006 require Clinical/Biomedical sign-off; EHR and insider privacy risks require DPO involvement. The fact that a full C8 purchase was deferred does not permit continued default pump credentials or unreviewed dose changes.

## Source Index

- [1x00 Asset Registry](../1x00_first_watch/7-asset_registry.md), [1x00 Gap Analysis](../1x00_first_watch/12-gap_analysis.md), [1x00 Control Matrix](../1x00_first_watch/10-complete_control_matrix.md).
- [1x01 Kill Chains](../1x01_know_your_enemy/10-kill_chains.md), including KC1 VPN/ransomware, KC2 pharmacy integrity, KC3 radiology/PACS, KC4 Alaris, KC5 vendor-to-EHR.
- [1x02 Triage](../1x02_the_weak_links/16-triage.md) and [1x02 CVSS Contextualizer](../1x02_the_weak_links/17-cvss_contextualizer.md); version-related CVE allegations are explicitly conditional.
- [1x03 Task 3 — Gap-to-Framework Bridge](3-gap_framework_bridge.md), [Task 4 — Governance Architecture](4-governance_architecture.md), [Task 5 — Risk Equation](5-risk_equation.md), [Task 6 — ALE Workshop](6-ale_workshop.md), [Task 7 — Cost-Benefit Analysis](7-cost_benefit_analysis.md), and [Task 8 — Budget Game](8-budget_allocation.md).

## Risk Register Governance Note

**James Chen, Deputy CISO, is accountable for the register and risk escalation; the Security Analyst maintains the operational entries, evidence links, KRI history and change log, while each named risk owner confirms treatment and residual-risk decisions.** The Security/IT/Clinical risk committee reviews the register **monthly** (with the first scheduled November review shown above), and James submits a consolidated dashboard to the Board **quarterly**. Any newly exploited or KEV-listed relevant vulnerability, significant incident, asset or vendor/firmware change, failed recovery test, patient-safety near miss, overdue high-risk treatment or **breach of a stated KRI threshold** triggers an immediate out-of-cycle review: open a ticket, notify the risk owner and relevant IT/DPO/Biomedical lead, validate the signal, rescore inherent/residual exposure, assign containment and an accountable deadline, and escalate Critical/high patient-safety risks to the CEO/Board without waiting for the next meeting. Financial or clinical risk acceptance requires documented authority, rationale, expiry date and a scheduled recheck; an unresolved KRI is never silently marked closed.
