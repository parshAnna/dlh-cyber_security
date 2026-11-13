# MedDefense Health Systems — Comprehensive Security Assessment

**Emergency Board decision paper | Project 1x05 — Board Briefing | Task 8**
**Audience:** Dr. Patricia Morales (CEO), Dr. Angela Reeves (Board Chair), Robert Kim (CFO), Thomas Wright (Board), Maria Santos (General Counsel), James Chen (Deputy CISO), Sarah Park (IT Director)
**Baseline:** 1x00–1x04 assessments, September–November 2026 | **Emergency scenario:** Crimson Tide advisory, Tuesday 18:47, Board briefing the following morning 09:00
**Document status:** **PRELIMINARY BOARD ASSESSMENT — DECISION REQUIRED.** This synthesizes the MedDefense exercise evidence. It does not establish an actual compromise, completed production change, granted budget, HIPAA certification or formally accepted risk.

## 1. Executive Summary — Board decision in one page

**Are our patients safe?** MedDefense has routine safeguards and clinical staff who can execute manual contingencies, but **cannot currently demonstrate that its most important clinical and patient-data services would withstand the described attack**. A single FortiGate 100F supports the Central perimeter and site links; its confirmed **FortiOS 7.0.9** is within the affected range for **CVE-2023-27997**, a known-exploited SSL-VPN vulnerability. Whether that feature is actually enabled and Internet-reachable—and whether compromise has occurred—remains **unverified**. It would be inaccurate to tell the Board either “we are safe” or “we have been breached.”

**What is at stake?** The attack path intersects our weak VPN-to-server trust boundary, legacy Active Directory cryptography, overbroad EHR access, plaintext patient/database and backup storage, and recovery copies that share an attackable environment. A sustained incident could interrupt care in Central, Westside and HQ; expose patient records; impede imaging; and destroy our means of recovery. The earlier 31-finding vulnerability triage identified **7 Immediate Critical** and **20 Actionable Standard** items, but we have no post-change verification proving their closure. Our NIST CSF 2.0 profile rates **all six functions Partial**, and only **3 of 21 cryptographic inventory cells (14.3%)** are rated Adequate under the exercise's strict cell-count method.

**How urgent is the financial risk?** The 1x03 compound VPN/ransomware teaching model estimated **$2,864,400/year** ALE using a **$9,548,000** single-event loss and **0.30** annual event rate. The Crimson Tide stress scenario doubles the *assumed* annual rate to **0.60**, raising the modeled ALE to **$5,728,800/year** and `RISK-002` from **15/25 High** to **20/25 Critical**. Five reported hospital incidents in ten days are an urgent intelligence signal, **not** sufficient statistical data to estimate MedDefense's actual annual probability. Overlapping EHR and billing losses **must not be added** to this compound event.

**What must the Board authorize?** Within four hours, verify and safely restrict exposed SSL-VPN; protect at least one independent, usable backup; preserve evidence and activate named clinical/IT response leadership. At the emergency meeting, conditionally approve **$2,400/year** for legitimate Fortinet support entitlement plus a vendor-vetted, clinically tested patch route. Require Robert Kim to reconcile this against the **$120,000 six-month program cash cap** before any additional purchases. Confirm that the proposed **C1/C2/C3/C4/C6** portfolio (**$97,000 annualized; approximately $115,000 illustrative first-year cash**) is **not yet approved, purchased or deployed**. Authorize tightly scoped additional emergency expenditure only with invoices, a cap, clinical change authorization and subsequent Board review.

**Decision and accountability:** James Chen leads incident/risk decisions; Sarah Park is the sole production change coordinator with two IT staff tonight; Clinical/Biomedical leaders approve patient-impacting changes; Maria Santos and the DPO assess privacy/notification duties; Robert Kim controls expenditure; Dr. Morales/Board retain authority over material residual risk. **Do not mark the current Critical posture as accepted by default.**

## 2. Emergency Status — Crimson Tide, in plain language

The course scenario describes **five regional hospitals attacked in ten days, three nearby**, using a chain of vulnerable FortiGate access, internal movement, stolen directory privileges, patient-record exfiltration, backup destruction and ransomware. Hospital C, approximately 45 miles away, is reportedly in active containment. These campaign and geography details are **course-supplied scenario intelligence**, not independently authenticated public CISA case reporting. The underlying Fortinet CVE and vendor fixes are real. **MedDefense is within the scenario's operational blast radius**, but physical proximity alone does not demonstrate targeting or infection.

**First 72 hours:** **0–12 h:** confirm the SSL-VPN listener and external path; if exposed, isolate or restrict *that feature* only after a clinically approved alternative is tested; preserve FortiGate/AD/EHR/NAS logs; secure a last-known-good independent backup without indiscriminately stopping clinical backup jobs; freeze risky changes and privileged export/deletion. **12–36 h:** obtain Board/Finance decision on the $2,400 renewal and approved firmware, restrict unnecessary VPN-to-AD/EHR/NAS flows with negative and positive tests, validate an isolated restore and investigate Kerberos/privileged-account anomalies. **36–72 h:** stage a vendor-supported FortiOS upgrade through the official path, pilot carefully approved segmentation, plan service-account/AES Kerberos changes in a maintenance window and trial immutable encrypted offsite recovery. Every action needs a clinical rollback threshold; a purchase, download or plan alone is not protection.

**Seven-stage working exposure view:** (1) FortiGate exploit **Exposed if SSL-VPN reachable**; (2) foothold **Partially protected**; (3) lateral traversal **Exposed**; (4) Kerberoasting/domain privilege **Partially protected**; (5) EHR theft **Exposed**; (6) backup destruction **Exposed**; (7) ransomware/clinical disruption **Exposed**. **Working score: 5/7 Exposed, 2/7 Partially Protected; no proven protected phase.** The exact phase headings/order remain provisional because the full course-specific Crimson Tide text was unavailable to validate against the earlier Task 0; reconcile the source before public distribution. An exposure rating is **not evidence the phase occurred**.

## 3. Security Posture Overview — what MedDefense has (1x00)

### 3.1 Business-critical asset landscape

| Service/dependency | Concrete MedDefense assets and exposure | Business significance |
|---|---|---|
| Patient records and prescribing | `ehr-db-01` (A-037), `ehr-srv-01`, pharmacy application (A-093); EHR holds roughly 50,000 patient records | Restricted patient information, accurate treatment and medication decisions; prior EHR downtime forced paper records |
| Identity, network and site connectivity | FortiGate 100F (A-086), Central Cisco core switch (A-087), `ad-dc-01`/`ad-dc-02` (A-040/A-041), VMware, Westside and HQ VPNs | Shared authentication, routing and access across three sites; FortiGate high concentration of perimeter dependency |
| Imaging and care devices | `pacs-srv-01` (A-038), Windows XP MRI controller `WS-RAD-01`, BD Alaris pump fleet, Philips IntelliVue monitors | MRI transfer and imaging, medication delivery and bedside monitoring; vendor-approved changes essential |
| Recovery and business operations | `backup-srv-01` (A-044), `NAS-01` (A-045), `billing-srv-01` (A-039), patient portal `web-srv-01` | Available, trustworthy backups; revenue/claims continuity; patient-facing services |
| People, endpoints and unknown assets | Approximately 280 clinical workstations in the case notes; managed and unmanaged workstations; unregistered hosts **F028/F029** | Credential, export, malware and asset-ownership risk; incomplete discovery means inventory is not a verified whitelist |

**Five priority assets from 1x00:** (1) `ehr-db-01`; (2) pharmacy management system; (3) Central core switch; (4) infusion-pump fleet; (5) `pacs-srv-01`. Clinical priority can override a simple asset ranking, especially if an active infusion or urgent imaging workflow is threatened. The estate is **not proven physically flat at every hop**, but 1x00 shows a permissive `10.10.0.0/16` trust environment and FortiGate rule **C-002** allowing `ALL` services on important VPN-to-server routes, without verified least-privilege separation.

### 3.2 Controls: what exists versus what is only designed

**Evidenced baseline:** perimeter filtering **C-001/C-003**; permissive VPN rule **C-002**; local firewall and host logs; some managed endpoint antivirus; two AD controllers; RAID and approximately 14-day local backup copies; limited paper/website recovery procedures. These are partial controls, not independently tested guarantees of ransomware resistance. Missing or unproven protections include organization-wide MFA, protected server EDR, continuously staffed detection, independent immutable PACS/EHR recovery, controlled bulk exports and fully segmented medical networks.

**NIST CSF 2.0 Current → six-month Target (1x03 T1):**

| Function | Baseline | Conditional target | Closure evidence |
|---|---|---|---|
| GOVERN | Partial | Managed | Signed accountability, risk acceptance, emergency exception and spending decisions |
| IDENTIFY | Partial | Managed | Current asset/vendor inventory, clinical dependency mapping and owner attestations |
| PROTECT | Partial | Managed | MFA, service-scoped VPN/AD/DB rules and clinically validated restrictions |
| DETECT | Partial | Managed | Wazuh event sources, tested alerts, responsible responder and measured response time |
| RESPOND | Partial | Managed | Approved clinical incident runbooks, tabletop, evidence custody and escalation bridge |
| RECOVER | Partial | Managed | Independent immutable backup, RTO/RPO and isolated EHR/PACS/AD/billing restoration evidence |

**CIS v8 whole-Control baseline:** **0 Implemented, 15 Partial, 3 Not Implemented** (Controls 9, 16 and 18). These are exercise maturity classifications, **not** compliance percentages or certification. Proposed improvements do not change the current profile until verified in production.

### 3.3 Five recurring systemic gaps

1. **GAP-016** — broad internal/VPN reachability and insufficient enforced least-privilege zones.
2. **GAP-011** — shared identities, incomplete MFA and weak privileged/service-account accountability.
3. **GAP-006 / GAP-017** — overbroad EHR database sources and insufficient control of bulk PHI exports.
4. **GAP-007 / GAP-003** — backups share the production failure domain; PACS has no documented independent recovery copy.
5. **GAP-015 / GAP-012** — weak verified patch closure and incomplete asset ownership/discovery, now critical to FortiGate and shadow IT.

## 4. Threat Landscape — who threatens MedDefense (1x01)

| Prior threat ranking | Motivation and local evidence | Current status / practical route |
|---|---|---|
| **1 — Organized ransomware groups** | Financial double extortion; 1x01 KC1 predicted VPN → foothold → AD → ransomware; KC3 predicted radiology phishing → PACS extortion | **Elevated threat in exercise**: Crimson Tide adds named FortiGate CVE, RC4/DES Kerberoasting, plaintext EHR theft and deliberate backup destruction. **No MedDefense breach verified.** |
| **2 — Negligent insider / unsafe change** | Shared PACS identity, unmanaged patient copies and pharmacy dosage-change incident; errors need not be malicious to endanger patients | **Existing evidenced control weaknesses**, separate from attacker attribution; strengthen approval, least privilege, session privacy and two-person medication changes |
| **3 — Opportunistic/unskilled external attackers** | Internet scanning and vulnerable legacy services; billing mining/restart history shows a compromise pattern but not attribution to a specific actor | **Continuing exposure** through billing/web, remote administration and unmanaged systems; contain, investigate and patch independently of Crimson Tide |

**Model accuracy:** KC1 identified the correct principal entry-to-domain-to-ransomware structure, while the emerging threat demonstrates why technical details matter: pre-authentication remote code execution is **not blocked by MFA**, Kerberoasting merits AES/service-account hardening, and double extortion targets **data and recovery**, not just uptime. Other 1x01 chains remain relevant: KC2 unsafe pharmacy change, KC3 PACS, KC4 malicious insider/pump harm and KC5 compromised MedTech channel to EHR. No new intelligence removes those risks.

## 5. Vulnerability Status — where the cracks are (1x02)

**Original triage:** 31 scan findings → **7 Actionable Critical (24–48-hour queue), 20 Actionable Standard (7–30-day queue), 1 Informational and 3 False Positive**. The five priority entries below follow the documented original T16 order; they are **not** a claim that other issues have been fixed.

| Top five from T16 | MedDefense significance | Current evidence / disposition |
|---|---|---|
| **F031 — EHR Tomcat AJP / alleged Ghostcat** | AJP reachability and potential app configuration exposure near `ehr-db-01` | **Open pending revalidation**: T16 treated CVE-2020-1938 as actionable, but 1x02 T17 notes the reported **Tomcat 9.0.31** version was already fixed; confirm real build and connector restrictions before labeling the CVE exploitable |
| **F003 — Broad PostgreSQL access** | `ehr-db-01` reachable from `10.10.0.0/16` subject to credentials; source-scope plus optional TLS weaknesses | **Unverified remediation**; require narrow sources/roles, verified TLS, denied unauthorized paths and EHR workflow tests |
| **F004 — Unsupported XP MRI/SMB** | Exploitable legacy protocol conditions and radiology availability risk | **Open/isolating only by proposal**; validate approved MRI transfer, restrict management and SMB with Biomedical/vendor oversight |
| **F010 — BD Alaris management/default credentials** | Safety-critical treatment-device management | **Urgent control gap**; validate exact hardware/firmware applicability (T17 disputes the asserted CVE version), rotate approved defaults, limit admin path, monitor safely |
| **F001 — Billing Apache remote-execution risk** | Potential foothold on `billing-srv-01`, potentially linked to F002 privilege escalation | **Open pending patch/module and deployment proof**; investigate miner, harden server and retest exploit prerequisites |

**New item outside the 31:** FortiGate **CVE-2023-27997**, **FortiOS 7.0.9**, is a real affected-version match, with reachable SSL-VPN configuration unknown; assign separate `RISK-NEW-001` and emergency owner. Adjacent high-relevance findings are **F007 LDAP signing, F018 RC4/DES Kerberos, F015 NAS DSM access, F027 silent Sophos agents**, and **F024 plaintext DICOM**. The historic **F014** concerns a *Westside Netgear router*, **not** the FortiGate CVE.

**Remediation progress:** Analysis, designs, runbooks, simulated labs and the Task 6 **personal Fedora** OpenSSL/SHA-256/SearchSploit/Lynis checks are documented; **no verified production patch, restriction, site-wide MFA, backup restore or monitoring deployment has been supplied**. Consequently the Board cannot credit any of the 27 actionable scan items as *validated closed* from the evidence at hand. The three False Positive classifications are triage dispositions, **not remediations**. Closure requires a change ticket, before/after configuration, negative security and positive clinical tests, rollback readiness and independent sign-off.

## 6. Risk Quantification — likelihood, loss and spending (1x03 + 1x05)

### 6.1 Updated top five ALE exposures

| Modeled loss event | SLE / calculation basis | Baseline ARO | Updated ARO | Current planning ALE/year | Confidence / accounting boundary |
|---|---:|---:|---:|---:|---|
| **RISK-002 — compound VPN → AD ransomware + record/billing loss** | **$9,548,000** | **0.30** | **0.60 scenario** | **$5,728,800** (was $2,864,400) | **Low**; 0.60 is an emergency stress assumption, not an inferred 5-in-10-day hospital attack rate; overlaps EHR/billing below |
| **RISK-001 — full EHR breach** | $9,075,000 | 1/3 | **Unchanged** | **$3,025,000** | Low; gross-additive 50,000-record case may contain overlapping cost categories |
| **RISK-007 — negligent insider disclosure** | $120,000 | 2.50 | **Unchanged** | **$300,000** | Scenario estimate; may coexist with ransomware but not inferred from Crimson Tide |
| **RISK-008 — billing ransomware** | $473,000 | 2/7 | **Unchanged** | **$135,143** | Separate billing scenario; can overlap a compound campaign |
| **RISK-004 — Alaris availability/safety events** | $100,000 at 0.10 plus $3,000,000 at 0.02 | Two distinct rates | **Unchanged** | **$70,000** | Two nonoverlapping pump-event classes within this example; unrelated to CT frequency |

**Equation / change:** `ALE = SLE × ARO`; `9,548,000 × 0.30 = $2,864,400/year`; `9,548,000 × 0.60 = $5,728,800/year` (**+100%**). The assumption of an entire compound loss after each counted event (`q=1`) is intentionally severe and should be replaced with observed access and progression evidence. **Do not sum these five rows into a MedDefense enterprise ALE.** PACS/pharmacy and several other clinical losses are **NQ (not quantified), not zero**.

**Risk Register change:** `RISK-002` is now **Likelihood 4/5 × Impact 5/5 = 20/25 Critical**, conditional on the stress case; treatment remains **Mitigate — Emergency**. New `RISK-NEW-001` records the FortiGate initial-access vulnerability as **20/25 provisional** with **standalone ALE = NQ**; the $5,728,800 compound ALE is a **shared scenario**, not a second charge. The 1x03 governance trigger for a relevant newly exploited/KEV-listed vulnerability requires **immediate out-of-cycle review**. No evidence establishes signed acceptance.

### 6.2 Budget and ROI: promised benefits are not achieved benefits

| 1x03 Task 7/8 proposed control | Annualized estimate | Decision / actual status | Primary operational effect |
|---|---:|---|---|
| **C2 — VPN/privileged MFA** | $11,000 | Selected **conditionally; not verified funded/deployed** | Reduces stolen-credential abuse; **does not block FortiGate pre-auth exploit** |
| **C1 — network segmentation** | $30,000 | Selected conditionally; **not deployed** | Restricts VPN-to-AD/EHR/NAS paths after entry |
| **C3 — Wazuh SIEM** | $22,000 | Selected conditionally; **not deployed** | Improves incident detection and response, **not direct entry prevention** |
| **C4 — immutable offsite recovery** | $21,000 | Selected conditionally; **not deployed** | Preserves an independent restore option; does not stop local deletion or data theft by itself |
| **C6 — Westside firewall** | $13,000 | Selected conditionally; **not deployed** | Creates a controlled Westside trust boundary |
| **Selected portfolio** | **$97,000/year** | **Proposal only** | Illustrative year-one cash **$115,000**, not proven six-month cap affordability |

**Deferred/not selected:** C5 full Sophos estate upgrade **$41,000/year** (marginal in original T7); C8 full medical-device isolation **$44,000/year** (not justified financially in its independent pump-risk case, but clinically necessary minimums remain); C7 24/7 outsourced SOC **$185,000/year** (not justified at original modeled marginal benefit). The Task 7/8 **$785,000/year** is a sum of hypothetical **marginal allocation scores** for investment comparison, **not observed annual savings, a validated portfolio ROI, or a figure to add to scenario ALE reductions**. No funded production deployment permits a verified “ROI of implemented controls” calculation. Existing perimeter/AV/log/RAID controls have **no measured attributable ARR** in the case material.

**Emergency Fortinet economics:** The separate renewal is **$2,400/year**. For the compound SLE, break-even requires an effective **full-campaign ARO decrease greater than $2,400 / $9,548,000 = 0.0002514 events/year**, before labor/clinical disruption costs. Illustrative **1% relative** reduction of the stress ARO (`0.600 → 0.594`) gives `$57,288/year` gross modeled reduction, `$54,888/year` net and approximately **2,287% conditional ROI**; **renewal alone, without a verified safe patch/containment, has no evidenced risk reduction**. Obtain quote, entitlement, signed image and full upgrade/rollback cost; reprice any change to the shared six-month cash plan. The provisional **$115,000 + $2,400 = $117,400** first-year illustration leaves **$2,600** against $120,000 on that simplistic basis, **not an assurance of spare six-month funds**.

## 7. Cryptographic Posture — patient-data protection and legal readiness (1x04)

**Inventory coverage:** Task 0 assessed **7 data categories × 3 states = 21 cells**: **3 Adequate (14.29%), 3 Weak (14.29%) and 15 Absent (71.43%)**. This 14.3% figure is a strict **unweighted adequate-cell ratio**, **not** the percentage of encrypted bytes or a statutory-compliance score. Two of the Absent VPN cells are **N/A placeholders**, and some other Absent cells reflect missing evidence rather than proven plaintext. Task 15's **16/16 (100%)** remediation-path coverage refers to **documented proposed treatment of applicable gaps**, **not deployed cryptography**.

**Critical weaknesses exploited or relevant to Crimson Tide:**

| Finding | Documented baseline and threat relevance | Accelerated safe response |
|---|---|---|
| **CRYPTO-011 / F018** — AD Kerberos | RC4/DES supported alongside AES; service tickets may facilitate offline cracking/Kerberoasting if prerequisites hold | Read-only ticket/service-account audit now; stronger identities/AES and phased legacy disablement in tested AD maintenance windows |
| **CRYPTO-001** — EHR at rest | PostgreSQL 14 `ehr-db-01` on plaintext ext4; copied raw files/snapshots could reveal PHI | Narrow access and inspect exports now; stage **LUKS2 AES-256-XTS volume protection** plus selective application-layer AES-GCM with **independent key custody**; do not rush destructive database migration |
| **CRYPTO-013 / F015** — NAS backups | `NAS-01` plaintext, reachable DSM management; susceptible to theft/deletion after privileged compromise | Preserve offline/isolated recoverable copy first; plan supported NAS volume/folder encryption and **client-side encrypted immutable offsite copies**, keys not held solely on NAS |
| **CRYPTO-002** — EHR DB transport | PostgreSQL TLS enabled but both `hostssl` and `hostnossl` paths permitted; live negotiation unknown | Inventory clients; require validated `sslmode=verify-full`, restricted `pg_hba.conf` and documented positive/negative tests |
| **CRYPTO-019 / CRYPTO-008** — portal/DICOM | Legacy patient portal TLS 1.0; DICOM without TLS; not established as the CT entry vector | Renew live portal certificate and remove TLS 1.0 safely; vendor-approve DICOM TLS/gateway without interrupting imaging |

**Key limitation:** disk encryption only protects appropriately locked storage and backups. An intruder with domain-admin or EHR application/SQL credentials may still retrieve live plaintext, **especially when unlock/decryption keys reside on the same compromised server**. Separately administer KMS, application authorization, export audit and recovery escrow; protect patient workflows before changing storage. Encryption does not provide immutability, stop ransomware file writes or repair a vulnerable SSL-VPN implementation.

**HIPAA Security Rule — exercise assumption, no compliance declaration:** The exercise treats MedDefense as a HIPAA covered entity. `45 CFR §164.312(a)(2)(iv)` **encryption/decryption at rest** and `§164.312(e)(2)(ii)` **transmission encryption** are **Addressable** specifications requiring a documented reasonable-and-appropriate assessment, implementation or justified alternative—not a free opt-out. `§164.312(e)(1)` transmission-security safeguards and `§164.312(d)` person/entity authentication are **Required standards**; unique identity, audit and integrity safeguards also matter. The observed plaintext EHR/NAS/DICOM paths and incomplete identity records create **significant readiness gaps**, but the exercise is **not a completed legal compliance audit or regulatory violation finding**. DPO/Legal must document applicability, ePHI data map, decisions, compensating measures, vendor terms, restore evidence and any GDPR or other jurisdictional obligations.

## 8. Recommendations — ordered by clinical and security consequence

### 8.1 First 72 hours: specific intercepts, owners and money

| Deadline | Decisive action and acceptable proof | Advisory phase / trace | Owner / cash gate |
|---|---|---|---|
| **0–4 h** | Inspect actual SSL-VPN enablement and WAN reachability, preserve config/telemetry; if exposed, restrict safely and prove site-to-site IPsec/clinical continuity | **P1**; new CVE-2023-27997; GAP-015/016; C1/C2 **not patch substitutes** | **Sarah + IT-A**, James authorization; **no purchase tonight** |
| **0–12 h** | Make an independently recoverable copy; verify backup inventory, encryption/key access, and no avoidable backup-job interruption | **P6/P7**; F015, GAP-007/003, CRYPTO-013; target **C4 $21k/year** | **IT-B**, Sarah/clinical owner; existing resources only |
| **0–12 h** | Preserve FortiGate, AD Kerberos, EHR export, NAS and endpoint logs; alert on new privileged accounts, unusual service tickets, bulk export, backup deletion | **P1–P7**; F007/F018/F027; GAP-011; target **C3 $22k/year** | **Analyst + James**, IT read-only exports; manual until SIEM works |
| **12–36 h** | Authorize official Fortinet entitlement and vendor-reviewed release; stage signed image, backup config, three-site change/rollback; tighten only tested VPN-to-AD/DB access | **P1–P5**; F003, GAP-016; C1/C2; extra **$2,400/year** entitlement | **Board/CFO** approve spend; **Sarah + IT-A** perform changes |
| **12–72 h** | Isolated restore rehearsal; piloted least-privilege segmentation and AES Kerberos/service-account migration only after test; protected offsite replica if feasible | **P3/P4/P6/P7**; F018/F015, GAP-011/007/016, C1/C4 | **IT-B + clinical/Biomedical/vendor**; quotes and change window required |

**Operational red lines:** Do not disable essential intersite IPsec while changing SSL-VPN; do not physically disconnect the **only** usable backup without protecting continuity; do not switch off RC4/DES across all AD accounts in an emergency without compatibility testing; do not run invasive scans against pumps/MRI or reformat a live database volume. James owns the command bridge; Sarah staggers network and system change windows across **two** available IT staff, with the analyst collecting evidence rather than being counted as a third implementer.

### 8.2 Accelerated 30-day roadmap

| Window | Workstream | Measurable exit gate |
|---|---|---|
| **Days 1–7** | Supported FortiGate upgrade and compromise review; credential rotation when indicated; emergency ACLs; preserve EHR/NAS/PACS recovery copies; restore inactive Sophos agents | External SSL-VPN reachability and patched release evidenced; zero unintended cross-site failures; independent restore succeeds; named security alerts reach an on-call owner |
| **Days 8–14** | Formal C1 VPN/AD/data segmentation pilot; test C2 MFA on privileged/vendor accounts; audit Kerberos and high-risk service identities; scope EHR source/export rules | Approved/denied flow tests, service-ticket baseline and clinical workflow acceptance; no blanket claim of all-site completion |
| **Days 15–21** | Enroll critical FortiGate/AD/EHR/NAS events into C3 monitoring pilot; implement C4 immutable offsite proof; test PACS and billing recovery with independent keys | Detection alert drill, locked offsite copy, denied deletion test and timed isolated restore |
| **Days 22–30** | Progress EHR disk/key and PostgreSQL TLS pilots; remediate Apache/billing; vendor-gated MRI/pump controls; confirm portal TLS and DICOM plans | Change/rollback evidence, positive/negative tests, DPO/Clinical acceptance; update 31-finding queue and Risk Register with verified results |

**Prioritize change safety over arbitrary deadlines.** A missed or unverified milestone remains open with an accountable owner and interim restriction; it is not presented as a success to meet the Board calendar.

### 8.3 Year 1 strategic priorities

Build a repeatable **NIST CSF 2.0 Govern/Identify/Protect/Detect/Respond/Recover** program, using CIS Controls v8 for technical acceptance and ISO 27001-aligned governance records without implying certification. Replace the single-perimeter dependency with **tested FortiGate support and recovery/HA design**; complete C1/C6 least-privilege segmentation, C2 identity and vendor account hardening, C3 detection staffing and playbooks, and C4 verified EHR/PACS/AD/billing recovery; then extend endpoint/server protection (C5 in scoped releases), biomedical device isolation (C8 with vendor safety), vulnerability/patch SLAs, key management, staff phishing/privacy training, clinical dosage-change approvals, routine exercises and independent assurance. Revisit C7's managed SOC scope only after pricing incremental benefit beyond the actual C3 operation.

**Funding rule:** Maintain a single reconciled **six-month cash forecast** and a distinct annualized cost view. The emergency $2,400 is a **request**, not proof of a committed invoice. Robert Kim should first evaluate reprioritization, then request a **capped extraordinary authorization** if safe containment, official patching or recoverability cannot fit the approved $120,000 cash ceiling. Disburse against quoted deliverables and independent clinical/security acceptance; report unpriced key-management, IR retainer, PACS recovery and vendor work as **unpriced**, not free.

## 9. Residual Risk Disclosure — what remains, who may accept it

**Even if every selected control is fully implemented and tested, MedDefense is not risk-free.** A patched gateway may have been compromised *before* patching; other entry points and vulnerable versions remain; approved EHR queries can export plaintext despite disk encryption; a compromised authorized account may traverse permitted clinical flows; Wazuh can detect but not automatically prevent intrusion; immutable backup preserves recovery without preventing confidentiality loss or temporary downtime; MRI and infusion hardware may require enduring vendor-managed exceptions. The 1x05 Kill Chain Overlay identified **two plausible decisive *stage objectives* constrained out of seven**, not a guaranteed two-phase prevention rate; strict zero-bypass prevention is not established.

**Current acceptance status: NONE evidenced.** Proposed temporary exceptions, if patient safety makes immediate change impractical, must include specific asset and flow, risk owner, compensating restriction, clinical/DPO advice, monitoring KRI, expiry/revisit date, and **CEO-authorized material risk acceptance with Board oversight**. No silence, procurement delay, incomplete detection or undocumented “legacy necessity” counts as approval. Cases that could cause imminent patient harm require escalation, not casual acceptance. Retain `RISK-002` and linked `RISK-NEW-001` as **Critical** until containment, patch and independent tests justify rescore; review upon any new KEV/incident, KRI breach, failed backup restore or firmware/asset change, independent of the monthly/quarterly calendar.

**Next module — from assessment to operational defense:** endpoint and server hardening (service-account hygiene, EDR, Linux/Windows baselines and audit), infrastructure defense (routing/segmentation, identity plane, cloud and backup segregation), continuous validation and clinical-safe incident response. Evidence of operation—not report length—is the exit condition.

**Board disclosure sentence:** *“We know where the highest-consequence weaknesses are, have an accountable emergency containment plan and can justify specific near-term spending; we cannot yet certify resilience or absence of compromise, and we request explicit authority to close the entry point and preserve patient-care recovery.”*

---

## Evidence and decision-source index

**Original work — links relative to `blue_team/1x05_board_briefing`:**

- **1x00 — environment, asset criticality, controls and gaps:** [Asset Registry](../1x00_first_watch/7-asset_registry.md), [Criticality Assessment](../1x00_first_watch/8-criticality_assessment.md), [Control Matrix](../1x00_first_watch/10-complete_control_matrix.md), [Gap Analysis](../1x00_first_watch/12-gap_analysis.md).
- **1x01 — actor ranking and scenarios:** [Threat Actor Matrix](../1x01_know_your_enemy/6-threat_actor_matrix.md), [Threat Priority](../1x01_know_your_enemy/16-threat_priority.md), [Five Kill Chains](../1x01_know_your_enemy/10-kill_chains.md).
- **1x02 — 31-finding context and validation:** [Triage](../1x02_the_weak_links/16-triage.md), [CVSS Contextualizer](../1x02_the_weak_links/17-cvss_contextualizer.md), [Validation Plan](../1x02_the_weak_links/23-validation_plan.md).
- **1x03 — risk, maturity and budget:** [NIST CSF Map](../1x03_defense_blueprint/1-nist_csf_mapping.md), [ALE Workshop](../1x03_defense_blueprint/6-ale_workshop.md), [Cost-Benefit](../1x03_defense_blueprint/7-cost_benefit_analysis.md), [Budget](../1x03_defense_blueprint/8-budget_allocation.md), [Risk Register](../1x03_defense_blueprint/10-risk_register.md), [Security Strategy](../1x03_defense_blueprint/17-security_strategy.md).
- **1x04 — cryptography and exercise HIPAA assessment:** [Crypto Inventory](../1x04_crypto_foundation/0-crypto_inventory.md), [Encryption Levels](../1x04_crypto_foundation/13-encryption_levels.md), [Crypto Audit](../1x04_crypto_foundation/15-crypto_posture_audit.md), [HIPAA Checkpoint](../1x04_crypto_foundation/19-hipaa_checkpoint.md), [Implementation Playbook](../1x04_crypto_foundation/22-implementation_playbook.md).
- **1x05 — emergency response:** [Advisory Assessment](0-advisory_analysis.md), [CVE Deep Dive](1-cve_deep_dive.md), [Kill Chain Overlay](2-kill_chain_overlay.md), [72-Hour Plan](3-emergency_plan.md), [Crypto Emergency](4-crypto_emergency.md), [ALE Update](5-ale_update.md), [Technical Proof — local Fedora only](6-technical_proof.md), [Risk Register Update](7-risk_register_update.md).

**Independent technical authorities (confirm CVE/standards only; not verification of the fictional campaign):** [CERT-EU 2023-038 on CVE-2023-27997](https://cert.europa.eu/publications/security-advisories/2023-038/); [Fortinet FortiOS 7.0.12 resolved CVE](https://docs.fortinet.com/document/fortigate/7.0.12/fortios-release-notes/289806/resolved-issues); [CERT-EU 2025-003 on CVE-2024-55591 and FortiOS 7.0.0–7.0.16](https://cert.europa.eu/publications/security-advisories/2025-003/pdf); [Fortinet FortiOS 7.0.17 resolved issues](https://docs.fortinet.com/document/fortigate/7.0.17/fortios-release-notes/289806); [NIST CSF 2.0](https://doi.org/10.6028/NIST.CSWP.29); [HIPAA 45 CFR §164.312](https://www.law.cornell.edu/cfr/text/45/164.312); [HHS explanation of Addressable encryption](https://www.hhs.gov/hipaa/for-professionals/faq/is-the-use-of-encryption-mandatory-in-the-security-rule/index.html).

**Evidence limitations and immediate reconciliation:** Confirm the **original course-supplied Crimson Tide advisory's exact seven headings/IOCs**, FortiGate public SSL-VPN state, installed versions and configuration on the clinical estate, production changes since the old assessment, purchase orders, actual current backups/keys, validated cost estimates, clinical downtime tolerances and the competent legal jurisdiction. Refresh scores and close findings only on dated, signed, independently testable evidence.
