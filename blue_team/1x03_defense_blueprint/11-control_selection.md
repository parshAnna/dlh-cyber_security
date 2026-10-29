# Task 11 — The Control Selection

- **Organization:** MedDefense Health Systems
- **Project:** 1x03 — Defense Blueprint
- **Deliverable:** `11-control_selection.md`
- **Assessment date:** 29 October 2026
- **Prepared for:** James Chen, Deputy CISO; Sarah Park, IT Director; Robert Kim, CFO; Clinical and Biomedical risk owners
- **Decision state:** Control selection and implementation plan only — **not authorization, deployment, verified effectiveness, or risk closure**.

## Decision Basis and Financial Guardrails

All ten entries **RISK-001–RISK-010** in [Task 10](10-risk_register.md) have **Treatment Decision: Mitigate**. Therefore this selection covers **all ten**; no accepted, avoided or transferred register entry is silently excluded. Control descriptions are tied to Task 10's actual risk evidence, risk owners, outcomes and clinical constraints, with [Task 3](3-gap_framework_bridge.md) supplying GAP-to-finding-to-threat traceability.

**Control IDs (unchanged from Task 7):** C1 network segmentation; C2 VPN/administrator MFA; C3 Wazuh SIEM; C4 immutable offsite backup; C5 full-estate Sophos EDR; C6 Westside firewall; C7 outsourced 24/7 SOC; C8 full dedicated medical-device isolation and monitoring. Task 8 selected **C1+C2+C3+C4+C6 conditionally**; C5 and full C8 were deferred, and C7's full contract rejected. The base-control annualized costs are **C1 $30,000; C2 $11,000; C3 $22,000; C4 $21,000; C6 $13,000**. **Total $97,000/year** is a *shared portfolio cost*, **not a per-risk charge**. Estimated first-year cash is **$115,000** owing to equipment purchases, against a $120,000 program cap; this leaves only **$5,000 cash headroom** before unpriced projects and other approved obligations. Finance must also reconcile the actual six-month, program-wide cash ceiling; annualized and six-month cash bases are not interchangeable.

**Mapping conventions:** CIS references give an exact **CIS Controls v8 Control and Safeguard ID**; NIST uses **CSF 2.0 Function.Category** identifiers (for example, `PR.AA`, *not* retired CSF 1.1 `PR.AC`). Mappings describe *alignment*, not an audit certification or proof that a safeguard is fully implemented. Each `Implementation Cost` cites the **full T7 control envelope once**; repeating it for several risks represents **shared allocation**, not duplicate spend. For non-T7 activities, `Not separately priced in T7 — quote/effort approval required` is deliberately **not** $0. There are no invented risk-specific savings.

**Quantification boundary:** T7 assigned a **sequential, conditional, non-double-credited** allocation to Task 6 risk scenarios: VPN/compound **R2:** C2 $310,000 → C1 $240,000 → C6 $35,000 → C3 $65,000; EHR **R1:** C3 $90,000; billing **R4:** C4 $45,000. These are **hypothetical marginal ALE-reduction scores**, not measured loss avoidance. R2 already includes EHR and billing consequences; **do not total these values into an enterprise-wide savings claim**. The pharmacy, MRI, PACS, Westside and print-server risks have **not quantified (NQ)** individual ALEs. Alaris R5 remains at its **$70,000/year** baseline planning proxy until clinical-safe controls are verified; the full C8's **$35,000/year hypothetical ARR** is *not funded*.

## Control Selection by Risk (10/10 Mitigate)

### RISK-001 — EHR Exfiltration and Patient-Data Breach

**Risk owner:** EHR Clinical Data Owner; Sarah Park implements; DPO reviews privacy. **Trace:** GAP-006/GAP-017; Finding 003 (broad authenticated PostgreSQL access), 031 (AJP reachability, Ghostcat applicability unverified); KC5 vendor-to-EHR. **Baseline ALE:** $3,025,000/year (T5/T6 R1, gross-additive full-breach model).

#### Selection R001-A — Limit EHR/Database Network Sources (C1 shared)
- **Risk:** RISK-001
- **Selected Control:** C1; zone EHR application/database separately and allow only validated application-to-PostgreSQL flows, including an explicit `pg_hba.conf` source allowlist; maintain authorized clinical traffic.
- **CIS Control Mapping:** **12 — Network Infrastructure Management, Safeguard 12.2** (secure architecture); **3 — Data Protection, Safeguard 3.12** (sensitive-data processing separation).
- **NIST CSF Mapping:** **PR.IR** (infrastructure resilience) and **PR.AA** (access restrictions).
- **Control Type:** Preventive.
- **Control Category:** Technical.
- **Implementation Cost:** **$30,000/year C1 shared T7** (annualized infrastructure $6,000; labor $18,000; maintenance $6,000); *no separate $30,000 charge for this risk*.
- **Expected Risk Reduction:** EHR-specific incremental ARR **not separately credited**; C1's **$240,000/year** is allocated solely to overlapping T6 R2 in T7. No invented additional EHR savings.
- **Dependencies:** Approved asset/flow inventory; EHR clinical-owner and vendor sign-off → C1 ACL staging → allow/deny PostgreSQL connection tests, clinical workflow tests and rollback.

#### Selection R001-B — Detect Unusual EHR Access and Bulk Exports (C3 shared)
- **Risk:** RISK-001
- **Selected Control:** C3; onboard validated EHR/DB audit events to Wazuh, alert on anomalous bulk exports, and assign an accountable analyst for escalation.
- **CIS Control Mapping:** **8 — Audit Log Management, Safeguards 8.5 and 8.9** (detailed and centralized logs); **13 — Network Monitoring and Defense, Safeguard 13.1** (centralized security alerts).
- **NIST CSF Mapping:** **DE.CM**, **DE.AE**.
- **Control Type:** Detective.
- **Control Category:** Technical / Operational.
- **Implementation Cost:** **$22,000/year C3 shared T7** ($0 software, assuming existing capacity; labor $18,000; maintenance $4,000). Export role approval itself is **not separately priced in T7**.
- **Expected Risk Reduction:** T7 R1 C3 marginal **$90,000/year**, reducing modeled EHR ALE **$3,025,000 → $2,935,000/year** conditional on validated detection; not the larger T6 bundled improvement.
- **Dependencies:** Data-owner authorized export rules and sufficiently fresh log source → log onboarding/retention → Wazuh detection rule → analyst ownership and alert drill; do not label the service 24/7.

### RISK-002 — VPN Foothold and Domain-Wide Ransomware

**Risk owner:** James Chen, Deputy CISO; Sarah Park executes. **Trace:** GAP-011/GAP-016; Findings 007/018 (AD hardening support), 003 (downstream DB path), 014 (Westside router); KC1. **Baseline ALE:** $2,864,400/year T6 R2 (`q=1` classroom joint-campaign assumption).

#### Selection R002-A — Verified VPN and Administrator MFA (C2)
- **Risk:** RISK-002
- **Selected Control:** C2; enforce named individual VPN/admin identities, remote-network MFA, privileged-account MFA and controlled break-glass exceptions.
- **CIS Control Mapping:** **6 — Access Control Management, Safeguards 6.4 and 6.5** (remote-network and administrative MFA).
- **NIST CSF Mapping:** **PR.AA**.
- **Control Type:** Preventive.
- **Control Category:** Technical / Administrative.
- **Implementation Cost:** **$11,000/year C2 shared T7** ($0 incremental license *assumed*, labor $8,000; maintenance $3,000); any additional Entra/VPN licenses **must be quoted** because Office 365 E3 is not automatically Microsoft 365 E3.
- **Expected Risk Reduction:** T7 R2 sequential marginal **$310,000/year**; modeled R2 ALE **$2,864,400 → $2,554,400**.
- **Dependencies:** Identity inventory, exact SKU and FortiGate integration checks → supported MFA rollout → clinical/vendor emergency access test → measured enrollment and enforcement.

#### Selection R002-B — Segment VPN-to-AD and Cross-Zone Paths (C1 + C6)
- **Risk:** RISK-002
- **Selected Control:** C1 default-deny-by-exception segmentation and C6 centrally managed Westside firewall, with approved intersite and VPN-to-AD/EHR flows.
- **CIS Control Mapping:** **12 — Network Infrastructure Management, Safeguards 12.2 and 12.3** (secure architecture and secure network management).
- **NIST CSF Mapping:** **PR.IR** and **PR.AA**.
- **Control Type:** Preventive.
- **Control Category:** Technical.
- **Implementation Cost:** **C1 $30,000/year + C6 $13,000/year T7 shared**; C6 includes $5,000 annualized infrastructure/license, $6,000 labor and $2,000 maintenance. Same C1 is *not bought again* for RISK-001/003/004/006/010.
- **Expected Risk Reduction:** Sequential T7 R2 marginal **C1 $240,000 + C6 $35,000 = $275,000/year**, after C2; modeled R2 **$2,554,400 → $2,279,400/year**.
- **Dependencies:** C2 identity baseline and site/service flow inventory → C1 architecture and approved clinical ACLs → C6 Westside replacement → positive/negative site/VPN/AD tests and rollback.

#### Selection R002-C — Correlate VPN, AD and Firewall Alerts (C3)
- **Risk:** RISK-002
- **Selected Control:** C3 Wazuh collection and correlation of VPN authentication, privileged AD changes, suspicious lateral traffic and Westside firewall logs.
- **CIS Control Mapping:** **8 — Audit Log Management, Safeguard 8.9** (centralize logs); **13 — Network Monitoring and Defense, Safeguard 13.1** (centralize security event alerting).
- **NIST CSF Mapping:** **DE.CM**, **DE.AE**.
- **Control Type:** Detective.
- **Control Category:** Technical / Operational.
- **Implementation Cost:** **$22,000/year C3 shared T7**, no second charge.
- **Expected Risk Reduction:** T7 R2 final marginal **$65,000/year**, after C2/C1/C6; modeled R2 **$2,279,400 → $2,214,400/year**. Total R2 allocated reduction from C2/C1/C6/C3 = **$650,000/year**, *not a measured enterprise saving*.
- **Dependencies:** C2 identity and C1/C6 device logging configured → reliable timestamped source feeds → Wazuh rules and business-hours response owner → escalation test; a future outsourced SOC (C7) would depend on working telemetry but **is rejected as a $185,000 package**.

### RISK-003 — PACS Imaging Outage or Extortion

**Risk owner:** Radiology Department Head. **Trace:** GAP-003/GAP-007; Finding 024 (DICOM encryption gap) and 004 (adjacent MRI foothold); 1x00 C-022 documents the absence of PACS backup; KC3. **Baseline ALE:** NQ, not zero.

#### Selection R003-A — Protected, Recoverable PACS Copy (C4, conditional scope)
- **Risk:** RISK-003
- **Selected Control:** C4 isolated, immutable PACS images, metadata and configuration backups with a clinically timed **full PACS restore**; use fast-enough recovery storage alongside archival Glacier when required by RTO.
- **CIS Control Mapping:** **11 — Data Recovery, Safeguards 11.2, 11.4 and 11.5** (backups, isolated copy, tested recovery).
- **NIST CSF Mapping:** **RC.RP**, **PR.DS**.
- **Control Type:** Corrective.
- **Control Category:** Technical / Operational.
- **Implementation Cost:** **$21,000/year C4 shared T7** ($12,000 cloud capacity/requests, $6,000 labor, $3,000 maintenance), **conditional on PACS capacity, retrieval and full-restore requirements fitting the quoted scope**. PACS expansion or rapid tier may cost more; **not approved merely by citing the C4 envelope**.
- **Expected Risk Reduction:** **NQ for PACS**; Task 7 credits C4's $45,000/year solely to billing R4, **not** a second PACS benefit. Conditional T10 target score **15 → 12**, only after clinical restore validation.
- **Dependencies:** Radiology-approved image inventory/RTO/RPO and DICOM workflows → storage sizing and clinical retrieval tier → C4 replication/immutability → full PACS recovery drill and sign-off.

### RISK-004 — BD Alaris Infusion-Pump Management Compromise

**Risk owner:** Biomedical Engineering Manager with patient-safety lead. **Trace:** GAP-001/GAP-016; Finding 010 default management credentials / accessible interfaces, firmware CVE contested; KC4. **Baseline ALE:** $70,000/year under distinct DoS-only and patient-safety event classes.

#### Selection R004-A — Vendor-Approved Management Boundary (C1 limited scope)
- **Risk:** RISK-004
- **Selected Control:** C1 restricted pump-management source/destination/port rules and clinician-approved normal treatment/maintenance paths; **not** the deferred full C8 dedicated isolation design.
- **CIS Control Mapping:** **12 — Network Infrastructure Management, Safeguard 12.2** (secure architecture).
- **NIST CSF Mapping:** **PR.IR**, **PR.AA**.
- **Control Type:** Preventive / Compensating.
- **Control Category:** Technical / Operational.
- **Implementation Cost:** **$30,000/year C1 shared T7**; no device-specific incremental equipment is presumed within this envelope.
- **Expected Risk Reduction:** Pump-specific dollar reduction **not separately quantified or credited** by Task 7 for C1. **R5 $70,000/year proxy retained pending evidence**. Full C8 ($44,000/year, hypothetical $35,000 ARR) **deferred**, not selected as funded.
- **Dependencies:** Biomedical and BD firmware/credential advisory → documented approved clinical communication flows → safe C1 zoning → passive benign access test and fallback verification; do not scan or isolate active infusion devices unsupervised.

#### Selection R004-B — Remove Default Pump Management Credentials (mandatory gap action)
- **Risk:** RISK-004
- **Selected Control:** Change documented `admin/admin` defaults to vendor-supported unique managed credentials; restrict privileged users and preserve an emergency support procedure.
- **CIS Control Mapping:** **4 — Secure Configuration, Safeguard 4.7** (manage default accounts); **5 — Account Management, Safeguard 5.2** (unique passwords).
- **NIST CSF Mapping:** **PR.AA**, **PR.PS**.
- **Control Type:** Preventive / Compensating.
- **Control Category:** Technical / Administrative.
- **Implementation Cost:** **Not separately priced in T7** (part of the safety minimum, *not* a claim that C8 or C1 funds all vendor labor); Biomedical/BD must quote/approve effort and Finance must reconcile it.
- **Expected Risk Reduction:** Safety-critical exposure reduced if verified, but **no defensible standalone ALE reduction**; T10 current R5 and inherent severity remain unchanged for governance pending measured results.
- **Dependencies:** BD/Biomedical change authorization and compatibility check → secure credential escrow and access ownership → supervised rotation → validated support/fallback without touching live infusions.

### RISK-005 — Unsafe Pharmacy Dosage Change

**Risk owner:** Chief Pharmacist / Pharmacy Department Head; IT change owner supports. **Trace:** GAP-002/GAP-022; 1x00 Incident C and C-044 (no direct numbered 1x02 Finding); KC2 negligence/integrity scenario. **Baseline ALE:** NQ, not zero.

#### Selection R005-A — Two-Person Dosage Change Gate and Validation
- **Risk:** RISK-005
- **Selected Control:** Named pharmacist peer authorization, staging of medication-change scripts, automated dose-range/reference checks and signed change tickets before promotion to production.
- **CIS Control Mapping:** **16 — Application Software Security, Safeguard 16.1** (secure development/change process); **4 — Secure Configuration, Safeguard 4.1** (configuration change process).
- **NIST CSF Mapping:** **PR.PS**, **GV.PO**.
- **Control Type:** Preventive.
- **Control Category:** Administrative / Operational.
- **Implementation Cost:** **Not separately priced in T7**; pharmacist peer-review, test data and developer/change-control labor require scoped effort and funding approval. **C3's $22,000/year** already covers only a shared monitoring service, not this change gate.
- **Expected Risk Reduction:** **NQ**; T10 target score **15 → 10** conditional on successful invalid-dose rejection and signed process, not achieved by merely logging changes.
- **Dependencies:** Chief Pharmacist defines approved dosage reference/ranges → IT establishes staging and independent authorization → negative-dose test → authorized release and documented emergency rollback.

#### Selection R005-B — Independently Validated Pharmacy Rollback
- **Risk:** RISK-005
- **Selected Control:** Pre-change application-consistent recovery point, tested dose-table rollback and reconciliation at all three sites; send validation failures and unauthorized changes to C3 where source logs exist.
- **CIS Control Mapping:** **11 — Data Recovery, Safeguards 11.1 and 11.5** (recovery process and restore test); **8 — Audit Log Management, Safeguard 8.2** (collect logs).
- **NIST CSF Mapping:** **RC.RP**, **DE.CM**.
- **Control Type:** Corrective / Detective.
- **Control Category:** Operational / Technical.
- **Implementation Cost:** **Not separately priced in T7** for pharmacy-specific rollback; C3 **$22,000/year shared** if its existing ingest capacity can be used. Do not assume C4's billing/PACS design automatically backs up pharmacy data.
- **Expected Risk Reduction:** NQ; targets containment of erroneous patient-dose values, but clinical integrity benefit is **not monetized**.
- **Dependencies:** R005-A signed controls and schema/data reconciliation specification → rollback point and test environment → supervised failure/restore drill → C3 alert integration; independent clinical sign-off required.

### RISK-006 — Unsupported Windows XP MRI Controller

**Risk owner:** Radiology Department Head with Biomedical / Siemens. **Trace:** GAP-016; Finding 004 (XP SP3, SMB/RDP and legacy exposures); KC3-adjacent MRI-to-PACS foothold. **Baseline ALE:** NQ.

#### Selection R006-A — Clinically Approved MRI Controller Allowlist (C1)
- **Risk:** RISK-006
- **Selected Control:** C1 isolate `WS-RAD-01` from user and guest networks; permit only Siemens-approved MRI/PACS management and DICOM traffic; block unrelated SMB/RDP.
- **CIS Control Mapping:** **12 — Network Infrastructure Management, Safeguard 12.2** (least-privilege segmentation); **4 — Secure Configuration, Safeguard 4.5** (end-user firewall *where supported*, not required on XP).
- **NIST CSF Mapping:** **PR.IR**, **PR.PS**.
- **Control Type:** Preventive / Compensating.
- **Control Category:** Technical / Operational.
- **Implementation Cost:** **$30,000/year C1 shared T7**, not per-MRI; vendor-managed hardware refresh is **not costed in T7**.
- **Expected Risk Reduction:** **NQ** MRI-specific; conditional T10 qualitative score **15 → 10** after verified isolation, without asserting a separate dollar benefit already counted in R2.
- **Dependencies:** Written Siemens/Radiology/biomedical flow approval → C1 zone design → nonintrusive connectivity check → imaging and emergency-maintenance tests → documented supported replacement plan.

### RISK-007 — Negligent Insider Patient-Information Disclosure

**Risk owner:** Data Protection Officer, HR and clinical department leads. **Trace:** GAP-017/GAP-011; Finding 023 unrestricted USB, supporting; insider scenario S2 is intentional and thus only adjacent. **Baseline ALE:** $300,000/year (T5/T6 R3).

#### Selection R007-A — Restrict Patient Exports and Removable Media
- **Risk:** RISK-007
- **Selected Control:** Data-owner-authorized EHR bulk-export permissions, documented exceptions, targeted removable-media restrictions/DLP and export event records, without blocking necessary clinical workflows.
- **CIS Control Mapping:** **3 — Data Protection, Safeguards 3.3 and 3.13** (data ACLs, DLP); **3.14** (log sensitive-data access).
- **NIST CSF Mapping:** **PR.DS**, **PR.AA**.
- **Control Type:** Preventive / Detective.
- **Control Category:** Technical / Administrative.
- **Implementation Cost:** **Not separately priced in T7**; DLP licenses, exception workflow and endpoint compatibility need a quote; **do not mistake C5 Sophos EDR ($41,000, deferred) for a funded DLP capability**.
- **Expected Risk Reduction:** **No T7/T8 ARR attributed to R3**. T10 continues to show **$300,000/year** before approved export/DLP funding. T6's **$150,000/year after-control** is an *illustrative bundled scenario*, not realized or budgeted here.
- **Dependencies:** DPO/clinical data classification and user entitlements → approved export/USB exception design → supported endpoint pilot → monitored enforcement with incident ownership.

#### Selection R007-B — Role-Based Patient-Data Handling Training
- **Risk:** RISK-007
- **Selected Control:** Privacy-focused onboarding/refresher training, realistic mishandling exercises and accountable disclosure/escalation procedures for patient-data handlers.
- **CIS Control Mapping:** **14 — Security Awareness and Skills Training, Safeguard 14.1** (awareness program).
- **NIST CSF Mapping:** **PR.AT**.
- **Control Type:** Preventive.
- **Control Category:** Administrative / Operational.
- **Implementation Cost:** **Not separately priced in T7**; HR/DPO delivery and clinical backfill effort must be approved and included in the whole-program cash plan.
- **Expected Risk Reduction:** **Not quantified as a standalone control**; track incident frequency relative to Task 6's 2.5/year baseline rather than claiming a training-effect percentage.
- **Dependencies:** DPO-approved policy and specific common error patterns → workforce scheduling → training and incident-reporting test → quarterly metric review.

### RISK-008 — Billing-Server Ransomware and Outage

**Risk owner:** Robert Kim, CFO; Sarah Park implements. **Trace:** GAP-007/GAP-016; Findings 001 (Apache `mod_lua` RCE), 002 (Apache LPE), 015 (backup NAS); KC1-compatible but billing server is not a literal KC1 hop. **Baseline ALE:** $135,143/year (T5/T6 R4).

#### Selection R008-A — Offsite Immutable Billing Recovery (C4)
- **Risk:** RISK-008
- **Selected Control:** C4 protected isolated backup with independent credentials, app-consistent billing restoration, retention and measured RTO; use accessible tier for time-critical recovery, not Glacier archive alone.
- **CIS Control Mapping:** **11 — Data Recovery, Safeguards 11.3, 11.4 and 11.5** (protect, isolate, test recovery data).
- **NIST CSF Mapping:** **RC.RP**, **PR.DS**.
- **Control Type:** Corrective.
- **Control Category:** Technical / Operational.
- **Implementation Cost:** **$21,000/year C4 shared T7** ($12,000 cloud + $6,000 labor + $3,000 maintenance), not charged again for RISK-003 PACS.
- **Expected Risk Reduction:** T7 R4 **$45,000/year**, SLE modeled **$473,000 → $315,500** at ARO 1/3.5; residual ALE **$135,142.86 → $90,142.86/year**; dependent on actual restore times.
- **Dependencies:** Scoped billing backup inventory and keys → separated C4 destination → automated replication → full data-plus-application recovery drill → CFO/IT acceptance of measured RTO.

#### Selection R008-B — Remediate Apache RCE/LPE Chain
- **Risk:** RISK-008
- **Selected Control:** Verify affected Apache build/modules, disable unnecessary `mod_lua`, patch/remediate both Findings 001 and 002 and restrict reachable application services through C1.
- **CIS Control Mapping:** **7 — Continuous Vulnerability Management, Safeguard 7.7** (remediate vulnerabilities); **4 — Secure Configuration, Safeguard 4.8** (disable unnecessary services).
- **NIST CSF Mapping:** **PR.PS**, **PR.IR**.
- **Control Type:** Preventive / Corrective.
- **Control Category:** Technical / Operational.
- **Implementation Cost:** **Not separately priced in T7** for patching/lifecycle effort; C1 already has a **$30,000/year shared envelope**, but is **not** evidence that patch labor is funded.
- **Expected Risk Reduction:** **No additional ARR credited** beyond the C4 R4 $45,000 estimate and C1's R2 allocation; patch validation should trigger a revised risk model, not automatic savings stacking.
- **Dependencies:** Actual version/module validation → change window and fallback → vendor-supported patch/module disable → post-change scan and access testing.

### RISK-009 — Westside Perimeter and Unmanaged Services

**Risk owner:** Sarah Park, IT Director; Westside Clinic Site Manager coordinates continuity. **Trace:** GAP-016; Findings 014 (consumer router) and 029 (undocumented Grafana host); KC1-compatible site pivot. **Baseline ALE:** NQ separately; downstream consequence already modeled in R2.

#### Selection R009-A — Centrally Managed Westside Firewall (C6)
- **Risk:** RISK-009
- **Selected Control:** C6 replace the consumer router with supported, centrally managed security firewall; implement explicit intersite policies, protected management and forwarding of events to C3.
- **CIS Control Mapping:** **12 — Network Infrastructure Management, Safeguards 12.1, 12.2 and 12.3** (supported infrastructure, segmentation, secure management).
- **NIST CSF Mapping:** **PR.IR**, **DE.CM**.
- **Control Type:** Preventive / Detective.
- **Control Category:** Technical.
- **Implementation Cost:** **$13,000/year C6 shared T7** ($5,000 annualized appliance/subscription, $6,000 labor, $2,000 maintenance). Annualized equipment includes a $9,000 purchase paid in year one, reflected in T8 cash check.
- **Expected Risk Reduction:** Westside-specific ALE **NQ**; C6's **$35,000/year marginal ARR already credited to overlapping R2**, not counted a second time here. Target qualitative T10 score **12 → 8**, pending testing.
- **Dependencies:** Westside asset/connection inventory → C1 intersite architecture → C6 replacement and approved failover → permitted clinical traffic plus denied unexpected paths → C3 log intake.

#### Selection R009-B — Reconcile and Restrict Undocumented Grafana
- **Risk:** RISK-009
- **Selected Control:** Locate owner of `10.10.10.200`, check version and advisory applicability, close unnecessary exposure, patch or retire unsupported Grafana safely.
- **CIS Control Mapping:** **1 — Inventory and Control of Enterprise Assets, Safeguards 1.1 and 1.2** (inventory and unauthorized-asset disposition); **7 — Continuous Vulnerability Management, Safeguard 7.7**.
- **NIST CSF Mapping:** **ID.AM**, **PR.PS**.
- **Control Type:** Preventive / Corrective.
- **Control Category:** Administrative / Technical.
- **Implementation Cost:** **Not separately priced in T7**; inspection/patching effort to be sized, not assumed covered by C6 firewall purchase.
- **Expected Risk Reduction:** **NQ** distinct Westside benefit; don't attribute the R2 C6 savings twice.
- **Dependencies:** Inventory and owner confirmation → approved service-impact assessment → patch/retire/allowlist → C6/C3 follow-up visibility.

### RISK-010 — Unsupported Print-Server Privilege Escalation

**Risk owner:** Sarah Park, IT Director / print-service owner. **Trace:** Finding 008 (Windows Server 2012 R2, PrintNightmare/spooler), GAP-016; plausible KC1-related pivot, not named as a step. **Baseline ALE:** NQ separately.

#### Selection R010-A — Restrict Print-Service Lateral Reachability (C1)
- **Risk:** RISK-010
- **Selected Control:** C1 deny nonapproved print RPC/SMB flows to `print-srv-01`, restrict authorized client networks and validate ongoing printing.
- **CIS Control Mapping:** **12 — Network Infrastructure Management, Safeguard 12.2**; **4 — Secure Configuration, Safeguard 4.4** (server firewall where supported).
- **NIST CSF Mapping:** **PR.IR**, **PR.PS**.
- **Control Type:** Preventive / Compensating.
- **Control Category:** Technical.
- **Implementation Cost:** **$30,000/year C1 shared T7**, no per-server increment assumed.
- **Expected Risk Reduction:** **NQ** direct print risk; T10 conditional score **12 → 8** after measured isolation. R2 C1's $240,000 ARR must not be counted again.
- **Dependencies:** Print dependency/client inventory → C1 network policy → print-flow tests and safe Print Spooler restrictions → test unauthorized access denial.

#### Selection R010-B — Disable/Replace Unsupported Print Spooler
- **Risk:** RISK-010
- **Selected Control:** Disable nonessential spooler functions, apply mitigations/patches where supported, and retire or migrate `print-srv-01` to supported print services.
- **CIS Control Mapping:** **2 — Inventory and Control of Software Assets, Safeguard 2.2** (supported software); **7 — Continuous Vulnerability Management, Safeguard 7.7** (remediate detected vulnerabilities).
- **NIST CSF Mapping:** **PR.PS**, **ID.AM**.
- **Control Type:** Corrective / Preventive.
- **Control Category:** Operational / Technical.
- **Implementation Cost:** **Not separately priced in T7**; OS migration, printer compatibility and licensing need a Finance-approved quote; **C5 EDR deferred** cannot substitute for replacing an EOL server.
- **Expected Risk Reduction:** **NQ** independent ALE; T10 target **12 → 8** conditional on network isolation, and further improvement requires supported replacement plus rescoring.
- **Dependencies:** Application/print-service owner inventory → supported platform selection and quote → test migration/fallback → retire EOL service with documented verification.

## Cross-Risk Control Coverage and Funding Matrix

| Control | T7 annualized cost | Task 8 decision | Selected risk IDs (shared, non-additive) | T7 ARR attribution | Release conditions |
|---|---:|---|---|---|---|
| **C2 — MFA** | **$11,000** | Select, conditional | 002 | **R2 $310,000** | Licensing and enforcement verified |
| **C1 — Network segmentation** | **$30,000** | Select, conditional | 001, 002, 004, 006, 008, 009, 010 | **R2 $240,000** | Signed clinical paths, staged ACL tests |
| **C3 — Wazuh SIEM** | **$22,000** | Select, conditional | 001, 002, 005 (logs), 009 (logs), and 003/006/007/008 where appropriate | **R2 $65,000 + R1 $90,000** | Analyst time, source capacity, log freshness; not 24/7 SOC |
| **C4 — Immutable offsite recovery** | **$21,000** | Select, conditional | 003, 008 | **R4 $45,000** | PACS scope & retrieval speed quote; real restore tests |
| **C6 — Westside firewall** | **$13,000** | Select, conditional | 002, 009 | **R2 $35,000** | Supported device, clinical traffic and failover tests |
| **C5 — Full Sophos EDR** | $41,000 | **Defer** | Not selected | R2/R1/R4 hypothetical $43,000 only if newly funded | Restore existing broken sensor reporting first |
| **C8 — Full dedicated medical-device isolation** | $44,000 | **Defer full scope** | Not selected (004 only has C1 baseline zone and mandatory safe hardening) | Hypothetical R5 $35,000 if actually funded | BD/Biomedical supervision; clinical safety override |
| **C7 — 24/7 outsourced SOC** | $185,000 | **Reject contract** | Not selected | Hypothetical $80,000 incremental only if later funded | No inference that C3 supplies around-the-clock staffing |

**Not-yet-funded implementation actions:** Pharmacy two-person approval, dosage checks, rollback and reconciliation (RISK-005); EHR/insider export policy and DLP/education (RISK-001/007); unique pump-management credentials (RISK-004); supported MRI and print lifecycle replacement (RISK-006/010); Grafana remediation and Apache patch work (RISK-009/008). These are **selected risk-treatment requirements, not separately funded T7 line items**. Each needs an effort/quote, identified owner, and Board/Finance/clinical decision before procurement. Some policy steps may use existing capacity but **no zero-dollar capacity has been established**.

### Budget Reconciliation (once, not per risk)

| Funded candidate | Annualized T7 amount | First-year incremental equipment cash versus annualization |
|---|---:|---:|
| C2 MFA | $11,000 | $0 (license entitlement may change) |
| C1 Segmentation | $30,000 | +$12,000 (buy $18,000 equipment vs $6,000 annualized) |
| C3 Wazuh | $22,000 | $0 (reuse of compute/storage assumed) |
| C4 Backup | $21,000 | $0 (cloud use assumptions require quote) |
| C6 Westside firewall | $13,000 | +$6,000 (buy $9,000 appliance vs $3,000 annualized) |
| **Total** | **$97,000/year** | **+$18,000** |

**Estimated year-one cash for these five alone:** **$97,000 + $18,000 = $115,000**, leaving **$5,000 below $120,000**, before the extra clinical/privacy/remediation actions above. **Do not claim the whole six-month program is funded or all ten risk treatments are affordable**; approve procurement in gates and re-scope the portfolio if necessary. Do not add the five T6 bundled risk-reduction figures, the five T7 ARR amounts, or R2+R1+R4 dollar losses as independent enterprise savings.

## Control Dependency Map (implementation order)

```text
LEVEL 0 — AUTHORIZE & INVENTORY (not a deployment claim)
  Board/Finance release gates + James Chen / Sarah Park ownership
  |-- Confirm 1x00 asset/role/vendor inventories, priority clinical flows
  |-- Validate T7 costs, Office 365 E3 license entitlements, RTO/RPO
  |-- Biomedical/Siemens/BD + Pharmacy + Radiology + DPO approvals
  |
  +--> LEVEL 1 — BASELINE AND LOW-RISK PREVENTION
       |-- C2 MFA: identity inventory -> VPN/admin policy -> exceptions
       |-- C1 architecture: approved routes -> test-zone ACL templates
       |-- C4 backup plan: scope -> isolate credentials -> copy sizing
       |-- Pharmacy peer approval/dose rules (UNPRICED, safety required)
       |-- BD unique credential change (UNPRICED, vendor approved)
       |-- EHR export entitlements / DPO sign-off (UNPRICED)
       |
       +--> LEVEL 2 — DEPLOY AND CLINICALLY VALIDATE
            |-- C1 production segmentation (after test flows)
            |     |--> C6 Westside firewall (depends on C1 intersite design)
            |     |--> MRI safe allowlist (depends on Siemens validation)
            |     +--> Pump C1 management boundary (after BD validation)
            |           +--> C8 FULL device isolation (DEFERRED; NOT funded)
            |-- C4 isolated data copies -> app-consistent restore exercises
            |     +--> PACS restore (after Radiology RTO/RPO and sizing)
            |-- Pharmacy signed update -> staged checks -> rollback drill
            |-- C2 enabled accounts + C1/C6 log configuration
            |     +--> C3 Wazuh ingest + correlation + analyst response
            |           +--> C7 full 24/7 managed SOC (REJECTED; NOT funded)
            |-- C3 available EHR/export logs -> detect bulk data access
            |
            +--> LEVEL 3 — ACCEPTANCE AND RISK REASSESSMENT
                 Positive/negative reachability; verified MFA coverage;
                 approved DICOM and pump clinical workflows; backup restore;
                 alert tests; KRI thresholds; risk owner sign-off
                 Recalculate residual likelihood/ALE ONLY after evidence.
```

**Dependency interpretation:** Wazuh (C3) can be installed and configured in parallel with C1/C2/C6, but **full cross-control detection coverage requires those controls' log sources and test events**; a future SOC relies on effective alerting and an incident-response handoff. **C1 zone policy and vendor approval precede full C8 medical-device isolation**; neither generic VLAN tagging nor unapproved changes to active pumps qualify. Backup recovery is evaluated by restored clinical services, not merely successful cloud object uploads. Pharmacy dual review is a direct patient-safety gate irrespective of SIEM funding.

## Evidence, Acceptance and Review

| Risk grouping | Concrete evidence required before lowering T10 risk score | Risk owner / key approver |
|---|---|---|
| 001 EHR | Denied unauthorized TCP/5432, allowed EHR transaction, bulk-export alert with response ticket | EHR Clinical Data Owner; DPO; Sarah Park |
| 002 VPN/domain | MFA for all privileged/VPN users or approved emergency exception, blocked unauthorized paths, AD alerts | James Chen; Sarah Park |
| 003 PACS | Verified immutable image/metadata copy and end-to-end PACS/DICOM restore meeting clinical RTO/RPO | Radiology Head; IT Ops |
| 004 Alaris | Vendor-approved changed defaults, authorized management sources, supervised fallback and benign alert | Biomedical Manager; BD; Patient-Safety Lead |
| 005 Pharmacy | Peer-approved staged change, failed invalid-dose test, successful full three-site rollback | Chief Pharmacist; IT change owner |
| 006 MRI | Blocked unauthorized SMB/RDP while Siemens-approved MRI/PACS workflows remain operational | Radiology Head; Biomedical; Siemens |
| 007 Insider | Export permission matrix, denied unauthorized USB/data export test, staff training and incident measures | DPO; HR; clinical leads |
| 008 Billing | Verified Apache patch/module mitigation, isolated recovery copy and timed billing restore | Robert Kim; Sarah Park |
| 009 Westside | Supported firewall installed, service inventory reconciled, denied unsafe intersite path and live log | Sarah Park; Westside Site Manager |
| 010 Print | Restricted spooler RPC, working authorized printing, signed EOL retirement plan | Sarah Park; Print Service Owner |

At the **monthly** register committee and when a T10 **KRI threshold** is breached, the Security Analyst must update the action ticket and evidence links; James Chen and the risk owner decide whether to rescore, escalate, or request an approved time-bound exception. **Approval of a proposed control is not acceptance of residual risk.** Patient-safety and legal requirements override a favorable annual-cost ratio or an unfunded C8 business case; any excess beyond the full-program cash ceiling returns to Finance/Board for a revised allocation.

## Framework and Project Sources

- **CIS:** [Official CIS Controls v8 Navigator](https://www.cisecurity.org/controls/cis-controls-navigator/v8), individual Controls/Safeguards 1, 2, 3, 4, 5, 6, 7, 8, 11, 12, 13, 14 and 16.
- **NIST:** [NIST Cybersecurity Framework 2.0 (CSWP 29)](https://doi.org/10.6028/NIST.CSWP.29), Appendix A Functions and Categories. `PR.AA` is the CSF 2.0 access-control category.
- **Task 10 — [Risk Register](10-risk_register.md):** All ten Mitigate decisions, owners, KRI gates, baseline and conditional residual scores.
- **Task 7 — [Cost-Benefit Analysis](7-cost_benefit_analysis.md):** Control costs, supported scope, incremental ARR sequence, and no-duplicate-credit rules.
- **Task 8 — [Budget Game](8-budget_allocation.md):** Conditional C1/C2/C3/C4/C6 portfolio, cash-versus-annualized reconciliation and deferred/rejected controls.
- **Task 6 — [ALE Workshop](6-ale_workshop.md):** Original scenario ALE values, evidence caveats and clinical impacts.
- **Task 3 — [Gap-to-Framework Bridge](3-gap_framework_bridge.md):** GAP/Finding/Kill-chain links; disputed Finding 010 and 031 CVE applicability remains explicit.

**Audit conclusion:** Every `Mitigate` entry has at least one exact safeguard-mapped proposed treatment, an assigned implementation or approval dependency, a cost **source or explicit cost gap**, and a risk-specific reduction target or an honest NQ. **Only the five shared T8 controls are tentatively selected inside the modeled envelope**, and none is represented as already deployed.
