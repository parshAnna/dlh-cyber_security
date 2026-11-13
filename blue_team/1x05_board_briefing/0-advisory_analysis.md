# MedDefense Health Systems — 1x05 Task 0: Crimson Tide Advisory Impact Assessment

- **Deliverable:** `0-advisory_analysis.md`
- **Project:** `1x05_board_briefing` — Emergency Board Briefing
- **Audience:** Dr. Patricia Morales (CEO), James Chen (Deputy CISO), Sarah Park (IT Director), Robert Kim (CFO), Dr. Angela Reeves (Board Chair), Thomas Wright (Board), Maria Santos (General Counsel)
- **Decision context:** Scenario time — Tuesday, 18:47; emergency Board session the following morning, 09:00
- **Assessment status:** **EMERGENCY / PRELIMINARY — scenario-based impact mapping, not confirmation of compromise.**

## Executive decision

**MedDefense is not able to demonstrate that it is protected against this attack chain.** The exercise establishes a FortiGate 100F running **FortiOS 7.0.9**, which falls within the vulnerable **7.0.0–7.0.11** range for **CVE-2023-27997**; network segmentation, organization-wide MFA, centralized monitoring, independent immutable backups and sensitive-data encryption remain proposals or incomplete controls. Whether SSL-VPN is actually enabled and internet-reachable, whether the appliance has already been compromised, and whether any Crimson Tide indicators are present **must be verified immediately**; proximity to affected hospitals establishes urgency, **not proof of attack**.

**Overall Exposure Score: 5/7 EXPOSED; 2/7 PARTIALLY PROTECTED; 0/7 PROTECTED.** The score measures plausible *attack-path exposure* against the documented baseline, **not** probability of exploitation, an attack already underway, or the effectiveness of funded-but-not-deployed measures.

**Source-verification limitation (material):** The course-provided signed S3 `cisa_advisory_crimson_tide.txt` link could not be retrieved in this assessment environment, so its **exact seven phase headings, full incident details, and any indicators of compromise (IOCs) have NOT been independently read or verified**. The seven phase names below are therefore **explicitly labeled analyst working names reconstructed from the scenario text**, not misrepresented as literal quotations from the missing advisory. Before issuing the final Board packet, James must obtain the supplied original and reconcile headings, chronology, IOCs, affected services and any different sequence. The question's Crimson Tide campaign, five hospitals in ten days, three nearby hospitals and Hospital C 45 miles away are treated as **exercise-provided claims**, not independently confirmed public CISA reporting. The real-world CVE and vendor patch data are independently supported by cited Fortinet/CERT sources. **Do not sign this provisional artifact off as a fully verified transcription of the seven-phase advisory.**

## 1. Scope, evidence rules and scoring

- **New scenario facts:** James verified FortiOS **7.0.9** on the **FortiGate 100F**; Sarah reports a candidate **7.0.14** image available but **not downloaded**, with the Fortinet support contract expired for three months and renewal priced at **$2,400/year**; the crisis window is 4 hours for the first priority, 72 hours for stabilization, and the next Board meeting is at 09:00. These are not equivalent to a completed configuration inspection or patch.
- **Vendor scope:** CVE-2023-27997 concerns the **SSL-VPN component**; FortiOS 7.0.0–7.0.11 are affected, with **7.0.12 or later** fixing this specific CVE. **An internet-reachable SSL-VPN listener is an exploitation prerequisite**; the scenario has not furnished an `ssl-vpn` enable/listener or exposure confirmation. The FortiGate's *site-to-site IPsec* links are a different feature and must not be disabled accidentally. FortiOS 7.0.14 may fix this particular CVE but is **also within the separately affected FortiOS 7.0.0–7.0.16 range for CVE-2024-55591** (an authentication-bypass issue fixed in 7.0.17); do **not** treat 7.0.14 as a fully secure upgrade target. Select an actually supported, vendor-approved 100F release after checking *all* current PSIRT notices and the official upgrade path. This is a separate CVE, not a claimed Crimson Tide campaign indicator. [E1–E3, E5–E6]
- **Risk logic:** `EXPOSED` = a credible attack-path prerequisite exists (or is strongly indicated), and no effective, **verified** blocking control is documented; `PARTIALLY PROTECTED` = some active security boundary exists, or the phase depends on important unverified prerequisites, but the weakness remains; `PROTECTED` = a tested preventive barrier would stop this phase. **Not evidenced** does not mean **no control exists**, but a proposed or merely budgeted control is not credited as deployed.
- **Trace format:** `F###` means 1x02 scan finding; `GAP-###` means 1x00 gap; `C1–C8` are the 1x03 proposed costed portfolio controls; `C-###` means a *baseline* control identifier from 1x00, not an authorization to treat it as effective.
- **Financial boundary:** 1x03 Task 8 selected **C1+C2+C3+C4+C6** provisionally: **$97,000 annualized** and **$115,000 illustrative first-year cash** against the **one $120,000 six-month program ceiling**, leaving only **$5,000 apparent headroom before unpriced obligations**. No Board approval, signed purchase order or successful production deployment is established; the $2,400 Fortinet renewal is an **additional emergency cost**, not included automatically in the selected control portfolio.
- **Patient-safety boundary:** Clinical leadership, Radiology and Biomedical Engineering must authorize changes to clinical routes, equipment or access. Fail closed *only where clinically safe*, use an approved continuity route for staff and avoid ransomware containment that itself disconnects essential care without coordination.

## 2. MedDefense-specific mapping of the seven-phase attack chain

### Phase 1: FortiGate SSL-VPN exploitation — **analyst working phase name**

**Advisory Description:** The campaign gains external initial access by exploiting vulnerable FortiGate SSL-VPN software, including **CVE-2023-27997**.

**MedDefense Mapping:**
- **Target System:** **FortiGate 100F** (asset A-086; site VPN/perimeter gateway), **FortiOS 7.0.9** as confirmed by James.
- **Vulnerability Reference:** **New scenario CVE-2023-27997** (critical, pre-authentication SSL-VPN memory-corruption/RCE risk); historical 1x02 F014 concerns the **Westside Netgear router**, **not** the FortiGate, and must not be mislabeled a FortiGate scan result.
- **Gap Reference:** **GAP-015** — public-facing vulnerability remediation lacks verified ownership/closure; **GAP-016** — VPN/intersite trust boundaries inadequately restricted.
- **Crypto Weakness:** The attack is a **software vulnerability in SSL-VPN**, **not broken AES or SHA-256**. The previously reported site-to-site IPsec IKEv2/AES-256/SHA-256 configuration cannot defeat a flaw in a separate SSL-VPN listener; MFA is not sufficient against a pre-auth exploit. [E1–E3]
- **Current Protection:** Legacy perimeter rules **C-001/C-003** exist but are not evidence of a block on the SSL-VPN service; the 7.0.9 build is vulnerable. No current vendor patch, verified SSL-VPN shutdown or tested source restriction is documented; support renewal/download pending. Confirm public service binding and actual Internet reachability now.
- **Verdict:** **EXPOSED** — **conditional on SSL-VPN being reachable**, a credible and highly consequential prerequisite in the exercise. If SSL-VPN is proven disabled and inaccessible, reassess this phase immediately; do not assume site-to-site IPsec is the vulnerable service.
- **Recommended Break Point:** Incident commander authorizes emergency containment: verify SSL-VPN listener and external path, then **disable or isolate exposed SSL-VPN using a clinically approved alternative** pending a supported vendor-verified firmware change; preserve configs/logs first if compromise is suspected. Renew vendor support or obtain the approved image via legitimate procurement; check upgrade path, image signature, HA/rollback, maintenance safety and success from an external validation perspective.
- **Trace to 1x03 Control / Cost:** **C2 VPN/admin MFA $11,000/year** supports post-entry identity hardening but **does not fix this CVE**; **C1 network segmentation $30,000/year** reduces post-entry reach, not pre-auth code execution. **Emergency $2,400/year support renewal** is outside the budgeted C1/C2/C3/C4/C6 portfolio until Finance approves and reconciles the six-month cash plan.

### Phase 2: Foothold, credential access and persistence — **analyst working phase name**

**Advisory Description:** Following VPN compromise, the adversary seeks a durable internal foothold, captures reusable credentials and attempts to persist after the initial gateway session.

**MedDefense Mapping:**
- **Target System:** FortiGate remote-access plane and the **Central server subnet `10.10.2.0/24`**, including **`ad-dc-01`/`ad-dc-02`** and domain-joined Windows endpoints or servers reachable from VPN paths.
- **Vulnerability Reference:** **F007** (LDAP signing not required) and **F027** (reported incomplete Sophos/server coverage) are **supporting** conditions; neither is a scan finding proving a persistent implant or stolen password. The new CVE provides the conditional entry path.
- **Gap Reference:** **GAP-011** — shared identities/limited MFA; **GAP-016** — broadly trusted access from VPN; **GAP-015** — incomplete remediation assurance.
- **Crypto Weakness:** Weak or reused identity secrets and poor protection of cached credentials make subsequent lateral access easier; T14 target-state KMS and named identities have **not** been verified operational.
- **Current Protection:** Some endpoint Sophos deployment and local logs exist; Windows server coverage, centralized alerting and organization-wide remote/privileged MFA are incomplete or unverified. **C-041** indicates MFA for James's unspecified personal account only, not complete VPN coverage; existing perimeter/authentication still impose some constraints.
- **Verdict:** **PARTIALLY PROTECTED** — credentials and an authorized host/technique are still needed for a durable foothold, and some endpoint controls exist, but the internal access and monitoring posture is too weak to declare this phase blocked.
- **Recommended Break Point:** Review gateway/admin sessions, newly created accounts and changes, off-hours logins, privilege escalation, unexpected processes and persistence; isolate suspicious hosts by approved EDR/network workflows; revoke compromised tokens and replace high-risk named admin credentials **after preserving evidence**, not by an untargeted organization-wide reset.
- **Trace to 1x03 Control / Cost:** **C2 MFA $11,000/year**, **C3 Wazuh SIEM $22,000/year** and **C1 segmentation $30,000/year** are **proposed**. **C5 full-estate Sophos EDR $41,000/year** was deferred; do not credit it as delivered. Immediate forensic collection/incident-response labor and contracted expertise are **unpriced**.

### Phase 3: Flat-network discovery and lateral movement — **analyst working phase name**

**Advisory Description:** The intruder enumerates reachable internal hosts and traverses unrestricted routes toward identity services, patient applications, storage and recovery systems.

**MedDefense Mapping:**
- **Target System:** **`10.10.0.0/16`**; **`ad-dc-01` (`10.10.2.20`)**, `ad-dc-02`; **`ehr-db-01` (`10.10.2.11`)**; `billing-srv-01` (`10.10.2.15`); `NAS-01` (`10.10.2.41`); potentially `pacs-srv-01` and legacy `WS-RAD-01`.
- **Vulnerability Reference:** **F003** (PostgreSQL reachable from broad internal address range), **F006** (MySQL bound to `0.0.0.0`), **F015** (NAS DSM management broadly reachable), **F004** (legacy MRI Windows XP), **F014** (Westside perimeter weaknesses). Reachability is not, by itself, proof of successful logon or code execution.
- **Gap Reference:** **GAP-016** (broad VPN/DMZ/internal boundaries), **GAP-006** (database access restrictions), **GAP-012** (unknown internal devices/ownership); see also 1x03 proposed zoning.
- **Crypto Weakness:** PostgreSQL TLS is optional and the billing app-to-MySQL path is plaintext in the T0 exercise. **IPsec encrypting a tunnel does not restrict where its authorized endpoint can route after decryption**.
- **Current Protection:** The historical **C-002** FortiGate rule allows **ALL services** toward the Central server subnet. Some firewalls/ACLs may exist, but the project has **no verified default-deny interzone enforcement**, and the 1x03 C1 design was not deployed.
- **Verdict:** **EXPOSED** — multiple independently documented overly broad service paths exist.
- **Recommended Break Point:** Apply approved emergency source/destination deny rules on **VPN-to-AD/DB/NAS management paths**, preserve essential EHR, DICOM, HL7 and clinical flows, and stage permanent default-deny zoning. Audit before and after; reject nonapproved paths and verify legitimate appointments, laboratory, imaging, pharmacy and billing service paths.
- **Trace to 1x03 Control / Cost:** **C1 segmentation $30,000/year** is the principal portfolio control; **C6 Westside firewall $13,000/year** is site-specific and **does not replace Central segmentation**. Both remain proposed until tested and approved.

### Phase 4: Domain privilege escalation through Kerberoasting — **analyst working phase name**

**Advisory Description:** The attacker requests Kerberos service tickets associated with service accounts and attempts to crack recoverable password-derived secrets offline to gain broader privileges.

**MedDefense Mapping:**
- **Target System:** Active Directory controllers **`ad-dc-01` / `ad-dc-02`** (A-040/A-041), domain service accounts and SPNs used by administrative and potentially clinical applications.
- **Vulnerability Reference:** **F018** (Kerberos **RC4/DES enabled**) and **F007** (LDAP signing not required; a related domain-integrity weakness, **not direct proof of Kerberoasting**).
- **Gap Reference:** **GAP-011** (shared identities, limited MFA/identity accountability), **GAP-016** (AD reachable across overly broad segments).
- **Crypto Weakness:** T0/T6 explicitly report **RC4 and DES configurations** while Kerberos AES-128/AES-256 are also available; a requested RC4-HMAC service ticket can become a fast offline password-guessing target if weak service account credentials and a usable SPN exist. **MD4/NT hash, HMAC-MD5 and MD5 collision are different concepts**; this attack is **not** an MD5 collision attack.
- **Current Protection:** Kerberos authentication and AES ticket options exist, and the attacker generally needs an appropriate domain identity/SPN and a weak recoverable service-account password. **Actual RC4 tickets, exploitable SPN accounts, tickets stolen and cracked passwords have not been evidenced**; no organization-wide safe legacy-etype removal is verified.
- **Verdict:** **PARTIALLY PROTECTED** — a confirmed permissive cryptographic setting leaves a credible path, but SPN/ticket/password prerequisites are unverified; **do not claim success from configuration alone**.
- **Recommended Break Point:** Audit event **4769** ticket encryption types, SPNs and service-account privilege; use long randomly generated service secrets/gMSA where compatible, restrict service privileges and move to **AES Kerberos** after vendor-safe testing. Enforce LDAP integrity/channel protection separately; alert on anomalous ticket volume and lateral authentication. Preserve clinical compatibility before blocking RC4/DES.
- **Trace to 1x03 Control / Cost:** **C2 named-admin MFA $11,000/year** helps protect privileged identities but **does not prevent offline Kerberoasting**; **C3 SIEM $22,000/year** helps detect suspicious ticket patterns; **C1 segmentation $30,000/year** reduces AD reachability. **SPN/gMSA/RC4/DES transition has no separately approved price in T8**; estimate labor/vendor tests as a change request.

### Phase 5: Patient-database access, copying and exfiltration — **analyst working phase name**

**Advisory Description:** With sufficient access, adversaries obtain patient records from internal databases and move copies outside the hospital for double extortion.

**MedDefense Mapping:**
- **Target System:** **`ehr-db-01` PostgreSQL 14** (A-037), the EHR data store (A-112; **50,000 patient records in the 1x03 scenario**) and **`ehr-srv-01`** as a potential authorized query or export route; `billing-srv-01` is a distinct related data target.
- **Vulnerability Reference:** **F003** (PostgreSQL connections allowed from broad `10.10.0.0/16` source range, **authentication still required**); T0 **confirmed plaintext ext4 data at rest**; 1x04 **CRYPTO-001/002**; no proof of actual exfiltration.
- **Gap Reference:** **GAP-006** (excessive DB network access), **GAP-017** (bulk patient export controls), **GAP-016** (unrestricted trust boundaries).
- **Crypto Weakness:** EHR database files are **unencrypted at rest** and `hostssl`/`hostnossl` permit unprotected PostgreSQL transport. **Important qualification: encrypting storage alone does NOT prevent a compromised authorized application or SQL session from querying and exfiltrating plaintext**. Application-side sensitive-field controls, restricted queries and telemetry are needed as well.
- **Current Protection:** PostgreSQL authentication and EHR application roles remain genuine barriers; however broad source acceptance, reported lack of disk encryption, weak export control and approximately **48-hour EHR audit-export delay** leave no demonstrated prevention of the full scenario.
- **Verdict:** **EXPOSED** — a realistic post-compromise EHR path exists, **conditional on stolen valid credentials, app compromise or another proven data-access route**.
- **Recommended Break Point:** Restrict PostgreSQL to approved EHR application sources, require TLS with hostname/CA verification, limit bulk export grants, alert on anomalous reads/egress, and preserve query logs. Plan tested **LUKS2/AES-XTS volume encryption** and selective application-side **AES-256-GCM** for especially sensitive fields with KMS-held KEKs, but do **not** claim encryption at rest neutralizes every live SQL exfiltration path.
- **Trace to 1x03 Control / Cost:** **C1 $30,000/year** (segmentation) and **C3 $22,000/year** (Wazuh EHR monitoring) are portfolio items. **EHR volume/record encryption and application export hardening are not separately costed** in the $97,000 program; obtain a scoped estimate. **RISK-001 baseline ALE $3,025,000/year** is a high-uncertainty **full-breach classroom estimate**, not a savings claim from this control.

### Phase 6: Recovery suppression and backup destruction — **analyst working phase name**

**Advisory Description:** After gaining sufficiently privileged access, attackers attempt to delete, encrypt or corrupt reachable backups so restoration becomes unreliable.

**MedDefense Mapping:**
- **Target System:** Synology **`NAS-01` (`10.10.2.41`, A-045)**; **`backup-srv-01` (A-044)**, backup software/agents and any accessible EHR, billing, AD and PACS recovery objects.
- **Vulnerability Reference:** **F015** (network-wide DSM management exposure on 5000/5001); T0 reports **plaintext NAS backups**; no evidence that backup deletion has actually occurred.
- **Gap Reference:** **GAP-007** — production and recovery copies share a failure domain; **GAP-016** — weak access segregation; PACS independent recovery also depends on **GAP-003**.
- **Crypto Weakness:** NAS backups are unencrypted and the optional Synology AES shared-folder protection is reported disabled. Encryption alone **does not stop deletion**; immutability, offline/offsite custody, identity separation and tested restore are essential. Keys must be **NOT on NAS-01** in reusable plaintext form.
- **Current Protection:** **C-022** local ~14-day backup copies and **C-023 RAID-5** provide limited routine recovery/media-failure protection; **no demonstrated independent immutable offsite backup, segregated admin identity or successful full clinical restore**. RAID-5 is not a defense against malicious deletion.
- **Verdict:** **EXPOSED** — one reachable recovery domain remains a shared failure point, even though destructive access needs usable privileges.
- **Recommended Break Point:** Immediately verify the last known good backup and integrity, restrict DSM/admin/backup deletion rights and isolate independent copies under two-person custody. Stand up an **immutable/offline encrypted offsite copy**, with separate backup encryption KEK/DEKs, separate recovery credentials and an **isolated restore test** before declaring it resilient. Do not disable scheduled clinical backups until alternative preservation is available.
- **Trace to 1x03 Control / Cost:** **C4 immutable offsite backup $21,000/year**, **C1 segmentation $30,000/year**; external key management/encryption implementation is **not automatically included** in C4's approved scope. **RISK-003 PACS outage ALE is NQ** and **RISK-008 billing ransomware $135,143/year** is a separate teaching estimate; do not add it to the overlapping VPN campaign estimate.

### Phase 7: Ransomware deployment and patient-care disruption — **analyst working phase name**

**Advisory Description:** The attackers deploy ransomware across reachable systems and exploit the loss of data, identity and recovery services to disrupt treatment and extort payment.

**MedDefense Mapping:**
- **Target System:** **`ad-dc-01` / `ad-dc-02`**, **`billing-srv-01`**, **`ehr-srv-01` / `ehr-db-01`**, **`pacs-srv-01`** and reachable hospital workstations; patient-care fallout includes Radiology, pharmacy and clinical scheduling, **not proof all are already infected**.
- **Vulnerability Reference:** **F001/F002** (billing Apache exploitable entry/privilege chain), **F004** (end-of-life MRI controller), **F027** (incomplete endpoint/server EDR monitoring) are **additional attack surfaces**, not evidence Crimson Tide used them; **F015** weak recovery management and **new CVE-2023-27997** establish relevant chain conditions.
- **Gap Reference:** **GAP-016** (lateral reachability), **GAP-007** (shared backup domain), **GAP-003** (PACS recovery), **GAP-011** (identity control).
- **Crypto Weakness:** Encryption at rest can reduce offline disclosure but **will not prevent ransomware from encrypting/deleting files accessible to a compromised privileged account**. IPsec traffic encryption likewise does not constrain internal privileges.
- **Current Protection:** Partial Sophos on existing endpoints, local backups, directory redundancy and clinical workflows provide **some** defenses; no evidence exists of comprehensive Windows-server EDR, deployed C1/C3/C4 or tested isolated EHR/PACS recovery. Clinical disruption potential is severe but actual infection is **unconfirmed**.
- **Verdict:** **EXPOSED** — existing partial measures do not establish a reliably tested chain break or independent recovery capability.
- **Recommended Break Point:** If hostile activity is found, declare a security incident, isolate confirmed affected systems while preserving evidence and **clinical life-safety workflows**, disable malicious administrative paths, preserve unaffected backups, and activate approved downtime/diversion plans. Prioritize protected AD and EHR services, then PACS/billing recovery from validated clean sources; do not reconnect restored hosts to the compromised trust domain.
- **Trace to 1x03 Control / Cost:** **C1 $30,000/year**, **C3 $22,000/year**, **C4 $21,000/year** in the *proposed* portfolio; **C5 full Sophos EDR $41,000/year** deferred. Treat recovery/emergency-response contracts, substitute clinical services and patient-diversion costs as **unpriced** and seek emergency approval.

## 3. Seven-phase scorecard and decisive dependencies

| Phase | Analyst working name (verify against supplied advisory) | Primary MedDefense asset | Evidence link | Verdict |
|---:|---|---|---|---|
| 1 | FortiGate SSL-VPN exploitation | FortiGate 100F, 7.0.9 | CVE-2023-27997; GAP-015/016 | **EXPOSED*** |
| 2 | Foothold and persistence | Central endpoints/servers | F007/F027; GAP-011/016 | **PARTIALLY PROTECTED** |
| 3 | Reconnaissance and lateral movement | AD/EHR/MySQL/NAS | F003/F006/F015; GAP-016 | **EXPOSED** |
| 4 | Kerberoasting and domain privilege | `ad-dc-01` / `ad-dc-02` | F018/F007; GAP-011 | **PARTIALLY PROTECTED** |
| 5 | Patient-record exfiltration | `ehr-db-01` | F003; CRYPTO-001/002; GAP-006/017 | **EXPOSED** |
| 6 | Backup destruction | `NAS-01`, `backup-srv-01` | F015; GAP-007 | **EXPOSED** |
| 7 | Ransomware and clinical disruption | AD/EHR/PACS/billing | F001/002/004/027; GAP-003/007/016 | **EXPOSED** |
| **Total** | | | | **5/7 EXPOSED; 2/7 PARTIAL; 0/7 PROTECTED** |

\* **Phase 1 is conditional on Internet-reachable SSL-VPN**: this configuration detail has not yet been produced. A documented shutdown or proof of inaccessibility changes the verdict; a vulnerable software version alone does not establish an exploitable listening service. For phases 5–7, the score means a viable *conditional chain after prior access*, not that credentials were stolen, data extracted, backups deleted or files encrypted.

### Why the existing controls do not make this safe

| Control/evidence | Current status from MedDefense studies | What this means for Crimson Tide |
|---|---|---|
| FortiGate 100F FortiOS 7.0.9 | **New scenario-confirmed; unpatched**, support renewal required to obtain preferred candidate image | Potential **pre-auth SSL-VPN** entry remains until actual listener restriction or verified patch |
| Site-to-site IPsec AES-256, IKEv2, SHA-256, DH14 | T0: **reported configuration**; endpoint implementation unverified | Strong tunnel cryptography does **not** fix SSL-VPN RCE or post-decryption lateral access |
| C-002 FortiGate broad VPN rule | 1x00 existing permissive rule | Facilitates unrestricted reach to Central server networks |
| PostgreSQL authentication | Present; SSL available but optional | Requires valid access but not adequate containment or confidentiality of copied offline DB files |
| Kerberos AES options | Present alongside DES/RC4 | Some crypto assurance, **not verified RC4 rejection** or service-account safety |
| Local backup C-022, RAID-5 C-023 | Baseline present | Partial recovery against routine failure, **not** independent anti-deletion capability |
| Sophos endpoint coverage | Baseline partial; server coverage incomplete | Partial prevention only, inadequate to claim enterprise ransomware protection |
| C1/C2/C3/C4/C6 | **Selected in 1x03 budget, proposed only** | No unverified improvement is credited in verdicts |

## 4. Immediate four-hour decision path (the requested critical recommendation)

**Critical Finding — exactly one sentence:** **Within the next four hours, Sarah Park, under James Chen's emergency authorization and clinical continuity controls, must verify whether FortiGate 100F SSL-VPN is Internet-reachable and immediately remove that vulnerable exposure (disable/isolate SSL-VPN if present) while initiating compromise triage and expedited acquisition of a vendor-approved fixed firmware image.**

**Execution order from emergency declaration, not proof actions have occurred:**

1. **0–30 minutes — command and preserve:** James opens a SEV-1 precautionary incident/heightened-threat record, names Sarah technical lead and Security Analyst evidence lead, and notifies CEO, clinical duty officer, DPO/Legal and network/backup custodians. Capture read-only firmware, SSL-VPN enable/binding, firewall rules, current sessions, HA state, configuration backup, device/remote log availability, log time/retention and traffic/administrative anomalies **before potentially destructive operations**; if the appliance is suspected compromised, preserve evidence with specialist assistance.
2. **0–60 minutes — reduce exploitable perimeter:** Confirm whether SSL-VPN is enabled and reachable externally. On a vulnerable *reachable* listener, use the **approved continuity option** to disable/isolate SSL-VPN or impose a vendor-supported narrow compensating block, without disabling unrelated critical site-to-site IPsec. Validate permitted clinical remote access, ambulance/referral coordination and cross-site patient workflows; record the change and backout.
3. **0–120 minutes — legitimate image and vendor escalation:** Sarah contacts Fortinet/vendor/procurement about the expired support contract; Robert Kim documents approval request for **$2,400/year** and confirms budget impacts. Verify signed firmware, model compatibility, supported upgrade path, current PSIRT issues (not only CVE-2023-27997), maintenance/HA rollback and evidence of pre-upgrade compromise. **Do not download from unofficial mirrors or assume 7.0.14 fixes every current vulnerability.**
4. **0–240 minutes — downstream containment and threat hunt:** Review gateway auth/admin sessions and possible compromise indicators; inspect KDC 4769 service-ticket trends, recent admin account changes, unusual database queries/exports, NAS delete attempts, abnormal EHR egress and backup integrity. Temporarily narrow **C-002 VPN-to-server access** with clinical-approved allowlists, protect NAS administration and verified recovery copies, and escalate to full incident response if any credible intrusion evidence appears.

**If compromise is confirmed:** Immediate incident containment and independent forensic triage outrank routine firmware installation; patching alone cannot remove persistence on a previously compromised device. Counsel evaluates reportability based on evidence, not mere exposure or geographic proximity. **A paid firmware entitlement is a procurement obstacle, not a security control.**

## 5. Quantified exposure and emergency investment trace

The existing 1x03 teaching **RISK-002** model assigns a conditional **$2,864,400/year ALE** to a full VPN-to-billing/EHR attack chain and **RISK-001** assigns **$3,025,000/year ALE** to a full EHR breach. Their consequences **overlap** and the underlying event probabilities/record loss estimates have low confidence; **do not sum them**, use them as a real-time predicted loss, or claim they will be fully avoided by a $2,400 contract renewal. The four-hour action is warranted by known vulnerable version plus severe, potentially irrecoverable clinical consequences even without a new measured Crimson Tide ARO.

| Decision or control | Baseline/proposed cost | Immediate action | Evidence for accountable approval |
|---|---:|---|---|
| **Fortinet support entitlement** | **$2,400/year** — NEW scenario item; outside 1x03 C1–C8 cost ledger | Seek expedited CFO/CEO authorization and approved fixed image/download pathway | Contract/license, support SLA, vendor-approved firmware, signature and device/HA upgrade test |
| **C1 Network segmentation** | **$30,000/year** modeled 1x03 cost | Immediate bounded VPN/AD/NAS rules if safe; full zoning later | Change ticket; denied unauthorized flow and successful clinical workflows |
| **C2 VPN/admin MFA** | **$11,000/year** modeled | Protect credentials and trusted admin paths; **not a CVE-2023-27997 patch** | 100% named privileged sign-ins with MFA coverage; logs |
| **C3 Wazuh SIEM** | **$22,000/year** modeled | Centralize available logs, urgent hunt and exception alerting; no claim already deployed | Time-synchronized retained audit events and test alerts |
| **C4 Immutable offsite backup** | **$21,000/year** modeled | Preserve independent clean copy and test isolated restore | Unmodifiable copy, separate key/admin domain, successful EHR/AD/PACS restore |
| **C6 Westside firewall** | **$13,000/year** modeled | Review Westside policy after protecting Central; cannot fix FortiGate SSL-VPN | Vendor compatibility, tested site segmentation |
| **C5 Sophos full-estate EDR** | **$41,000/year** modeled, **deferred** | Escalate targeted Windows server coverage as emergency unpriced scope; obtain approval | Agent reports and successful benign detection test |

**Budget reconciliation:** `$30,000 + $11,000 + $22,000 + $21,000 + $13,000 = $97,000/year` is **annualized cost**, not the six-month purchase plan. The project reports **$115,000 illustrative first-year cash** against **$120,000 single six-month cash ceiling**, leaving `$5,000` nominally before unpriced tasks; adding the hypothetical `$2,400` contract gives **$117,400**, leaving `$2,600` **only in a like-for-like simplified first-year estimate**. **These are not a reconciled six-month spend forecast**; labor, forensic retainers, service disruption, upgrade compatibility and other obligations may exceed the apparent headroom. Finance/CEO authorization is required; do not silently repurpose C4 backup money to pay for the firmware.

## 6. Questions that must be answered before the 09:00 Board meeting

| Question | Evidence required | Accountable owner |
|---|---|---|
| Is SSL-VPN actually enabled and public-facing on FortiGate 100F? | Read-only interface/SSL-VPN configuration, outside listener test, approved network diagram | Sarah Park |
| Has FortiGate or a domain identity already been compromised? | Appliance config/session/auth changes, retained firewall logs, KDC and endpoint anomaly review, forensic triage | James Chen / Security Analyst |
| Has EHR data been copied, and how much? | Database logs/authorized export trails, network egress, account mapping, DPO/clinical scope review | EHR owner / Security / DPO |
| Are NAS/PACS backups still recoverable? | Protected independent backup manifest, integrity/hash evidence, controlled isolated restore | Sarah / Backup team / Radiology |
| What paid/alternative safe patch path is available? | Vendor contract, firmware entitlement, security release, upgrade/rollback plan and total cost | Sarah / Robert Kim |
| What can be reported as confirmed vs uncertain? | A Board evidence ledger separating facts, scenario claims, untested hypotheses, blocked access and actual incidents | James / Maria Santos |
| What clinical disruption is tolerable if SSL-VPN is isolated? | Approved cross-site and remote-clinician continuity plan, Clinical duty officer sign-off | Dr. Morales / Clinical leadership |

**Board-answer sentence:** **“Our assessment has identified a vulnerable FortiGate version and several credible downstream routes to patient data and recovery systems; we have not verified an intrusion or proven that these routes are blocked, so we are urgently containing external exposure, checking for compromise, protecting recovery copies and seeking authority for a verified firmware upgrade.”**

## 7. Evidence index and reconciliation checklist

**Internal MedDefense evidence (relative links from `1x05_board_briefing`):**

1. [1x00 Gap Analysis](../1x00_first_watch/12-gap_analysis.md) — **GAP-015** public-facing patch closure; **GAP-016** broad intersite trust boundaries; **GAP-011** identity; **GAP-006** DB access; **GAP-017** bulk exports; **GAP-007** backup failure domain; **GAP-003** PACS recovery; **GAP-012** asset ownership.
2. [1x00 Complete Control Matrix](../1x00_first_watch/10-complete_control_matrix.md) — **C-002** FortiGate ALL services, **C-022/C-023** local backup/RAID, **C-041** narrowly reported MFA; controls are not equivalent to approved C1–C8 target program.
3. [1x01 Kill Chains](../1x01_know_your_enemy/10-kill_chains.md) — **KC1 VPN → AD → ransomware**, **KC5 supplier → EHR**; working hypotheses before this new scenario, not observed incidents.
4. [1x02 Vulnerability Triage](../1x02_the_weak_links/16-triage.md) — F001/002/003/004/006/007/014/015/018/027; **CVE-2023-27997 is a NEW advisory/scenario finding**, not invented as a historical scan finding.
5. [1x03 Governance Architecture](../1x03_defense_blueprint/4-governance_architecture.md) — executive authority, Sarah IT changes, James response, DPO/clinical gates.
6. [1x03 Risk Equation](../1x03_defense_blueprint/5-risk_equation.md), [ALE Workshop](../1x03_defense_blueprint/6-ale_workshop.md), [Risk Register](../1x03_defense_blueprint/10-risk_register.md), [Budget Allocation](../1x03_defense_blueprint/8-budget_allocation.md) — RISK-001/002/003/008, overlap constraints and funding status.
7. [1x04 Crypto Inventory](../1x04_crypto_foundation/0-crypto_inventory.md), [Algorithm Landscape](../1x04_crypto_foundation/6-algorithm_landscape.md), [Encryption Levels](../1x04_crypto_foundation/13-encryption_levels.md), [Key Management](../1x04_crypto_foundation/14-key_management.md), [Crypto Posture Audit](../1x04_crypto_foundation/15-crypto_posture_audit.md) — plaintext EHR/NAS, optional DB TLS, RC4/DES and proposed key custody.
8. **Missing course-source reconciliation:** Retrieve **`cisa_advisory_crimson_tide.txt`** from the course-provided link, record its issue time, issuing authority, title/version, **exact seven phase names and order**, impacted hospitals, sector statistics, TLP, IOCs and mitigations. Replace the **analyst working names** above only after comparing with the actual text and update verdicts if prerequisites differ. **Do not invent attacker IP addresses, malware hashes or victim names beyond the scenario.**

**Independent public technical corroboration (NOT proof of the Crimson Tide campaign):**

- **[E1] CERT-EU, Security Advisory 2023-038:** https://cert.europa.eu/publications/security-advisories/2023-038/ — FortiOS **7.0.0–7.0.11** affected by **CVE-2023-27997**, fixed in **7.0.12+**, pre-authentication SSL-VPN RCE potential.
- **[E2] Fortinet, analysis of CVE-2023-27997:** https://www.fortinet.com/blog/psirt-blogs/analysis-of-cve-2023-27997-and-clarifications-on-volt-typhoon-campaign — official Fortinet vulnerability technical context.
- **[E3] Fortinet FortiOS 7.0.12 release notes:** https://docs.fortinet.com/document/fortigate/7.0.12/fortios-release-notes/289806/resolved-issues — version-specific closure of this CVE.
- **[E4] CISA / MS-ISAC Ransomware Guide:** https://www.cisa.gov/sites/default/files/publications/CISA_MS-ISAC_Ransomware%20Guide_S508C.pdf — independent/offline backups, network segregation, verified restoration and incident handling.

- **[E5] NVD CVE-2024-55591:** https://nvd.nist.gov/vuln/detail/CVE-2024-55591 — separate authentication bypass affecting FortiOS 7.0.0–7.0.16.
- **[E6] Fortinet FortiOS 7.0.17 release notes:** https://docs.fortinet.com/document/fortigate/7.0.17/fortios-release-notes/289806 — addresses CVE-2024-55591, but is not assumed to be the latest supported build.

**Final status:** **Ready for internal incident review as a preliminary impact analysis; NOT ready for final unqualified Board sign-off until the source advisory and live FortiGate SSL-VPN exposure are verified.** No MedDefense production change, intrusive scan or attack was performed to prepare this report.
