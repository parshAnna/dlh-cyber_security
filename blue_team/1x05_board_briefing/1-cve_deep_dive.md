# MedDefense Health Systems — Task 1: The CVE Deep Dive

**Project:** 1x05 — Emergency Board Briefing  
**Deliverable:** `1-cve_deep_dive.md`  
**Research date:** 12 November 2026  
**Incident frame:** Fictional Crimson Tide emergency scenario; analysis requested immediately after the exercise advisory  
**Prepared for:** James Chen (Deputy CISO), Sarah Park (IT Director), Dr. Patricia Morales (CEO), Robert Kim (CFO), Board and General Counsel  
**Status:** Urgent intelligence-led assessment. **No live FortiGate exploitation, authenticated appliance check, or SearchSploit command has been executed by the author.**

## Executive decision — patch or safely eliminate SSL-VPN exposure now

**CVE-2023-27997** is a **critical, remotely exploitable, pre-authentication heap-based buffer overflow** in Fortinet FortiOS/FortiProxy **SSL-VPN**. NVD's CVSS v3.1 **Base Score is 9.8 Critical**; **CISA KEV: YES** (added **13 June 2023**); MedDefense's **FortiGate 100F on FortiOS 7.0.9** is in the affected range. The appropriate **Exploitability Score is 5/5** using 1x02 Task 4's KEV/working-public-exploit rubric. [S1–S5]

**MedDefense Environmental CVSS v3.1 = 9.8 Critical, equal to the 9.8 base—not 10.0.** `CR:H/IR:H/AR:H` reflects three-site clinical dependence, but v3.1's modified impact is already capped. The single perimeter, all-site VPN dependency, inadequate segmentation, active exploitation and blocked procurement route make the **business priority Emergency / Immediate**, irrespective of the unchanged numeric result. [S12]

**Four-hour action:** Under James's incident authority, Sarah must confirm whether the FortiGate **SSL-VPN listener is enabled and Internet-reachable**; if so, urgently disable or isolate that specific listener through an approved clinical continuity/failover plan, preserve relevant logs/configuration, and arrange a **current vendor-approved, verified image and upgrade path**. Site-to-site **IPsec** is a separate service; do **not** indiscriminately shut down all three clinic connections. Compromise is **not confirmed** merely because the firmware is vulnerable. [S3–S5]

## Part 1 — NVD research and affected-system assessment

### 1.1 Identification and full technical description

| Field | Verified assessment |
|---|---|
| CVE identifier | **CVE-2023-27997** (often called **XORtigate**) |
| Vendor / component | **Fortinet FortiOS and FortiProxy SSL-VPN**; relevant MedDefense asset: **FortiGate 100F (A-086)** |
| Published | **13 June 2023** (NVD publication date) |
| **NVD CVSS v3.1 Base Score** | **9.8 / 10 — Critical** |
| **NVD Base Vector** | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H` |
| NVD Base sub-scores | Exploitability **3.9**; Impact **5.9** (CVSS sub-scores, **not** 1x02's 1–5 rating) |
| **CWE** | **CWE-122: Heap-based Buffer Overflow**; CWE-787 (Out-of-bounds Write) is a related broader description in some enrichment records |
| Attack preconditions | **SSL-VPN service accessible** over network; **no login or user interaction required** for the vulnerable request path |
| Worst-case consequence | Specially crafted unauthenticated requests can corrupt the SSL-VPN process heap and potentially permit **arbitrary remote code/command execution**, jeopardizing gateway confidentiality, integrity and availability |
| Exploitation / fix | **CISA KEV: YES; official Fortinet fixes are available**; a protected perimeter image is not proof an attacker is absent |

**Full description (paraphrased from NVD/Fortinet):** A memory-safety error in the SSL-VPN request handler can permit an attacker with network reachability to submit maliciously formed requests that overflow an allocated heap buffer. Because this handling takes place before user authentication, the attacker does not need valid VPN credentials or to bypass MFA; successful exploitation may allow execution of arbitrary code/commands on the gateway. The resulting control can expose private configuration, facilitate a foothold into trusted networks, and disrupt a critical clinical perimeter service. The advisory establishes *possible* outcomes, not a verified exploitation of this particular FortiGate. [S1–S5]

**CVSS vector interpretation:** `AV:N` = network, `AC:L` = low complexity, `PR:N` = no prior privileges, `UI:N` = no victim interaction, `S:U` = unchanged security authority scope, and `C:H/I:H/A:H` = high potential losses of confidentiality, integrity and availability. **Strong IPsec AES-256 or VPN MFA does not patch an unrelated pre-authentication SSL-VPN memory-corruption bug.** [S1–S5]

**Scoring source nuance:** NVD's **9.8 is the required Base Score**. Some Fortinet/CNA displays show **9.2** on a *longer vector that includes Temporal modifiers* (`E:F/RL:X/RC:R`); **do not confuse that value with the NVD Base Score**. Use one consistent v3.1 base vector when calculating MedDefense's environmental result. [S1, S2]

### 1.2 Affected products, vulnerable versions and fixed releases

| Product family | Vulnerable versions | First branch-level fix for CVE-2023-27997 |
|---|---|---|
| **FortiOS 7.2** | **7.2.0–7.2.4** | **7.2.5** |
| **FortiOS 7.0** | **7.0.0–7.0.11** | **7.0.12** |
| FortiOS 6.4 | 6.4.0–6.4.12 | 6.4.13 |
| FortiOS 6.2 | 6.2.0–6.2.13 | 6.2.14 |
| FortiOS 6.0 | 6.0.0–6.0.16 | 6.0.17 |
| FortiProxy 7.2 | 7.2.0–7.2.3 | 7.2.4 |
| FortiProxy 7.0 | 7.0.0–7.0.9 | 7.0.10 |
| FortiProxy 2.0 | 2.0.0–2.0.12 | 2.0.13 |
| FortiProxy 1.2 / 1.1 | 1.2.x and 1.1.x in the advisory's affected ranges | Confirm vendor-supported upgrade/migration for these older branches |

*The table lists this particular CVE's historical fix boundaries, **not** versions recommended for a new 2026 production installation. Verify the current PSIRT notices, actual model support and official multi-hop upgrade path before approving an image.* [S2–S5]

**MedDefense comparison:** Scenario-confirmed **FortiOS 7.0.9** is within **7.0.0–7.0.11**, so the installed build **contains the affected code**. Exposure to **remote exploitation is conditional on the SSL-VPN interface being activated and reachable**; the provided record confirms site-to-site IPsec but does **not** establish SSL-VPN status, public listener/port, protective ACLs, or an actual intrusion. Treat this unknown as a **four-hour verification and containment priority**, not as a reason to defer. [1x05 T0; S3–S5]

**Critical candidate-image caveat:** Sarah reports **FortiOS 7.0.14** as an available-but-not-downloaded update and a **$2,400/year** expired-support renewal. Version 7.0.14 fixes **CVE-2023-27997**, but is **also affected by the separate CVE-2024-55591 (FortiOS 7.0.0–7.0.16; fixed in 7.0.17)**. Consequently **do not certify 7.0.14 as safe or make it the default 2026 target**: have Fortinet verify a current, supported FortiGate 100F release, upgrade path, other applicable PSIRT fixes and signed image. Renewal cost needs CFO/CEO authorization without assuming it is already in C1–C6. [S9, S10]

### 1.3 Vendor advisory and patch references

- [S1] **NVD CVE-2023-27997**: <https://nvd.nist.gov/vuln/detail/CVE-2023-27997> — Base score/vector, vulnerability summary, CWE, CPE/affected products, references.
- [S2] **Fortinet PSIRT FG-IR-23-097**: <https://www.fortiguard.com/psirt/FG-IR-23-097> — primary vendor advisory, affected versions and remediation.
- [S3] **Fortinet technical analysis, June 2023**: <https://www.fortinet.com/blog/psirt-blogs/analysis-of-cve-2023-27997-and-clarifications-on-volt-typhoon-campaign> — SSL-VPN pre-auth implications, requirement to patch, disabled-SSL-VPN conditional mitigation.
- [S4] **CERT-EU advisory 2023-038**: <https://cert.europa.eu/publications/security-advisories/2023-038/> — vulnerable/fixed versions and MFA limitation.
- [S5] **Canadian Centre for Cyber Security**: <https://www.cyber.gc.ca/en/alerts-advisories/vulnerability-impacting-fortigatefortios-cve-2023-27997> — affected/fixed branch references; temporarily disable exposed SSL-VPN if unable to patch.

## Part 2 — Exploit availability: SearchSploit, Exploit-DB and CISA KEV

### 2.1 SearchSploit / Exploit-DB evidence rules

This document records **public research and a reproducible review procedure**. The author's environment has **no installed SearchSploit executable and no access to the user's Fedora terminal**, so the following are **commands for Sarah/the student to run, NOT fabricated captured outputs**:

```bash
searchsploit --cve 2023-27997 --id
searchsploit 'FortiGate SSL-VPN' --id
```

Review any returned **title, CVE mapping, EDB-ID, author, publication date and `EDB Verified` field** against the *actual* corresponding Exploit-DB page. A local database could be stale or index a detection script rather than an exploit. Save the real terminal output to evidence; **do not invent an EDB entry or claim a command was executed when it was not**.

| Exploit evidence question | Finding on 12 Nov 2026 | Confidence / limits |
|---|---|---|
| **Public exploit / PoC available?** | **Yes** — public third-party GitHub research/PoC repositories and defensive verification tooling document exploitability; the Bishop Fox research describes a demonstrable pre-auth RCE issue. | Public *availability* does not establish that any arbitrary PoC works against FortiOS 7.0.9 or that it was run against MedDefense. [S6, S7] |
| **Verified Exploit-DB entry?** | **No correctly mapped EDB-ID independently verified in this research**; result from an up-to-date local `searchsploit` is **pending**. | A non-verified EDB hit is not required to score 5 where KEV confirms exploitation. |
| **Important false lead** | Some third-party lists claim **EDB-51832** for this CVE; the **actual Exploit-DB 51832 page is a Saflok KDF local hardware exploit, CVE: N/A**, not FortiOS. | **Never cite EDB-51832 as a FortiGate exploit.** [S8] |
| **CISA KEV?** | **YES — added 2023-06-13**, agency due date **2023-07-04**, required action to apply vendor updates; KEV metadata indicates known ransomware campaign use. | KEV means demonstrated exploitation of the CVE, **not verified Crimson Tide attribution nor compromise of MedDefense**. [S11] |
| **Exploitability Score (1–5)** | **5/5 — confirmed exploitation in the wild, with public research/PoCs.** | **Same 1x02 T4 rubric** used for known-exploited CVEs (KEV + public exploit => 5; verified public PoC but not KEV => 4). Distinct from CVSS `Exploitability Subscore 3.9`. |

**Public evidence examples (do not run against production):** [S6] Bishop Fox's **CVE-2023-27997-check** describes a safer timing-based vulnerability assessment and the underlying exploitable pre-auth behavior; [S7] independent public PoC repositories exist, but their quality and target coverage vary. A detection method that submits many requests still needs maintenance approval because it could affect a healthcare perimeter. No offensive exploit payload, listener, or live-target test is authorized by this document.

**CISA KEV interpretation:** Entry on 13 June 2023 establishes that exploitation has been observed. Its **2023-07-04 due date is the U.S. federal KEV timetable**, not a newly issued hospital deadline. The **fictional Crimson Tide emergency** creates MedDefense's separate operational urgency; the particular campaign's attribution and IOCs require reconciliation with the course advisory. [S11]

### 2.2 Immediate exploit-response implications

- **No authentication prerequisite:** MFA and password resets cannot by themselves block initial exploitation of an exposed SSL-VPN listener.
- **Exploit chain:** Gateway compromise is a potential entry to **KC1** (VPN → AD → ransomware), where **GAP-016** weak separation and **GAP-011** identity weaknesses increase lateral-movement risk.
- **Secondary consequences:** The same compromised gateway could create access relevant to **KC2** pharmacy integrity and **KC3** radiology/PACS extortion, **but those original 1x01 chains do not name FortiGate exploitation as a literal step**; record the association as conditional path expansion, not fact.
- **Encryption is not containment:** Site-to-site IPsec cryptography does not constrain what an authorized/compromised gateway can route; unencrypted EHR and NAS copies (1x04 T0/T15) raise potential downstream data/recovery impact.

## Part 3 — NIST CVSS v3.1 environmental contextualization

### 3.1 Preserve technical exploit prerequisites

**Base vector:** `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H`  
**Base score (NVD): 9.8 Critical.**

| MedDefense factor | Environmental decision | Evidence and boundary |
|---|---|---|
| **Only FortiGate perimeter; no redundancy** | **AR:H** (Availability Requirement: High) | Loss of the only gateway can interrupt clinical and Internet connectivity; no verified HA/failover exists. This is an organizational consequence **not a new technical attack vector**. |
| **All three sites use gateway VPN** | **IR:H** (Integrity Requirement: High), **AR:H** | Hostile routing/firewall-policy changes can disrupt or redirect clinical flows; ensure site-to-site IPsec remains distinct from SSL-VPN. |
| **Reachability toward EHR, identity and clinical assets** | **CR:H** (Confidentiality Requirement: High), **IR:H** | Highly sensitive patient records and cross-site clinical operations; **GAP-016**, **GAP-006**, **GAP-017**; original **KC1** direct, **KC2/KC3** conditional expansions. |
| **Support expired; $2,400 renewal; 7.0.14 not downloaded** | **Emergency business priority and remediation blocker**; **not a CVSS CR/IR/AR value** | Vendor entitlement affects time to fix and procurement, **not** exploit attack complexity, scope or intrinsic severity; leave Temporal modifiers undefined in the primary comparison. |
| **No effective, verified isolation documented** | **MAV/MAC/MPR/MUI/MS/MC/MI/MA left `X`** | Do not invent a tested WAF, ACL, changed security scope or different privilege requirement. A firmware *version* alone cannot verify the listener is reachable. |

**Selected environmental metrics:** `CR:H/IR:H/AR:H`. All Modified Base metrics are **Not Defined**, meaning inherit the original NVD values; Temporal modifiers are **Not Defined** for like-for-like Base-versus-Environmental comparison.

**Complete Environmental Vector:**

```text
CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H/CR:H/IR:H/AR:H
```

**Calculator input:** Open [NIST CVSS v3.1 calculator](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator), enter the eight Base metric values, then set `CR = High`, `IR = High`, `AR = High` under Environmental; leave all other metrics unchanged/not defined. This procedure is reproducible using the [FIRST v3.1 specification](https://www.first.org/cvss/v3-1/specification-document). [S12]

### 3.2 Exact v3.1 calculation and honest comparison

Using FIRST CVSS v3.1 constants and the Scope-Unchanged formula:

```text
Modified C/I/A impact each = 0.56 (High)
High requirement multiplier = 1.5
MISS = min[1 - (1 - 0.56*1.5)^3, 0.915] = 0.915
Modified Impact = 6.42 * 0.915 = 5.8743
Modified Exploitability = 8.22 * 0.85 * 0.77 * 0.85 * 0.85 = 3.8870
Environmental score = Roundup(5.8743 + 3.8870) = 9.8
```

| Score | Value | Difference | Interpretation |
|---|---:|---:|---|
| NVD CVSS **Base** | **9.8 Critical** | — | Inherent remote pre-auth technical severity |
| MedDefense CVSS **Environmental** | **9.8 Critical** | **0.0: Equal, neither higher nor lower** | CR/IR/AR high, but impact subscore hits the v3.1 0.915 ceiling |
| **1x02 T4 Exploitability** | **5/5** | Separate ordinal scale | CISA KEV and published PoC evidence |
| **Operational treatment** | **EMERGENCY / Immediate** | Not a CVSS number | Three-site single failure domain + known exploitation + patch access delay |

**Why not 10.0?** In CVSS v3.1 the environmental **Modified Impact Sub-Score is capped at `0.915`**, preventing unlimited amplification when baseline `C:H/I:H/A:H` already scores near maximum. **Do not arbitrarily add points for hospital importance, the $2,400 bill, three sites, or kill chain count**. Also do not change `S:U` to `S:C` solely because the compromise affects many separate organizational assets: CVSS Scope concerns a **security authority** boundary. [S12]

**Temporal nuance (not used in the official 9.8 comparison):** The public exploit evidence and available official fix could support separate Temporal choices such as `E:H/RL:O/RC:C`; including `RL:O` applies a numerical multiplier reflecting an available *vendor fix* even when MedDefense has **not installed it**. This is an entirely different metric-group calculation; do **not** present the resulting lower Temporal-adjusted value as proof that the current hospital is safer. The primary requested Environmental Score above keeps `E:X/RL:X/RC:X` consistent with 1x02 T17 methodology.

### 3.3 Business and risk crosswalk

| Attack dependency | Case-study evidence | Existing vs proposed control | Proposed cost / risk linkage |
|---|---|---|---|
| Initial gateway RCE | **New CVE-2023-27997**; FortiOS 7.0.9; **GAP-015** | C-001/C-003 perimeter filters do **not prove** SSL-VPN blocked; vendor image and listener disablement are emergency controls, not existing completed fixes. | **$2,400/year support renewal** is **additional** and requires approval; no misleading claim that C2 MFA fixes pre-auth RCE. |
| VPN-to-AD lateral paths / KC1 | **GAP-016**, **GAP-011**; supporting 1x02 **F007/F018** | **C1 segmentation and C2 MFA** in proposed 1x03 plan; neither credited as deployed. | **C1 $30,000/year; C2 $11,000/year**; **RISK-002 $2,864,400/y teaching ALE**, with compound scenario assumptions. |
| Detect foothold and privilege misuse | Partial endpoint coverage **F027**, local firewall logs, AD event review | Proposed **C3 Wazuh monitoring**, plus incident forensic preservation. | **C3 $22,000/year**; staff/forensics emergency costs **unpriced**. |
| EHR exfiltration | **F003**, **GAP-006/017**, unencrypted `ehr-db-01` | Proposed segmentation/export controls and T13/T14 EHR encryption; no claimed implemented record protection. | **RISK-001 $3,025,000/y teaching ALE**, overlaps RISK-002; **do not add** the two. |
| NAS loss / PACS downtime | **F015**, **GAP-007/003**, plaintext **NAS-01** and no verified isolated restore | Proposed **C4 immutable offsite backup** with independently controlled keys and restore tests. | **C4 $21,000/year**; **RISK-003 ALE NQ**, billing **RISK-008 $135,143/y** is a separate non-additive reference. |

**Budget boundary:** The provisional C1+C2+C3+C4+C6 portfolio was **$97,000 annualized**, **$115,000 illustrative first-year cash**, within a **single $120,000 six-month ceiling** only before unpriced obligations; do not declare these controls funded-and-deployed. The emergency **$2,400/year** support renewal is outside the prior scope until CFO Robert Kim reconciles cash and the CEO authorizes a commitment. Neither the ALE numbers nor the CVSS score are an HSM, firmware or response **ROI**. [MedDefense 1x03 T8/T10]

## Decision record and next 72-hour evidence gates

| Horizon | Decision or verification | Owner | Evidence / acceptance criterion |
|---|---|---|---|
| **0–4 hours** | Verify FortiOS 7.0.9 build, actual SSL-VPN enablement/listener/public reachability; authorize clinically safe temporary SSL-VPN shutdown or restriction if exposed. Preserve appliance/auth logs and config before high-impact change if compromise suspected. | **Sarah Park** executes; **James Chen** incident authority; Clinical duty officer approves continuity. | Signed incident/change ticket; observed listener before/after from an authorized vantage point; no unplanned loss of **site-to-site IPsec** or essential clinical routes. |
| **0–4 hours** | Request legitimate vendor entitlement / approved signed firmware, review entire Fortinet PSIRT list (including **CVE-2024-55591**) and upgrade/rollback path; verify the image supports FortiGate 100F. | Sarah; **Robert Kim** verifies emergency **$2,400/year**; CEO approves spending as required. | Version-specific vendor advisory/upgrade path, purchase authorization, protected configuration backup, approved change window. |
| **4–24 hours** | Investigate suspected gateway compromise, unexpected VPN/admin sessions, configuration changes, AD/Kerberos abuse and EHR/NAS accesses; preserve evidence under chain of custody. | James / Security Analyst / Sarah / DPO as indicated. | Time-correlated logs, confirmed vs unconfirmed IOCs, incident severity, clinical/Legal escalation record. |
| **24–72 hours** | Patch to **currently supported vendor-approved** FortiOS after staging; test gateway policies, IPsec peers, clinical app reachability and rollback; restrict lateral access and verify offsite backup restorability. | Sarah / Network team / Clinical/Biomedical / James. | Recorded new firmware version and hash/signature, successful three-site IPsec and portal tests, approved negative access tests, independent recoverable backups. |
| **Board follow-up** | State the actual attack-status determination, residual gaps, cost, authority and risk acceptance; update 1x05 T0 findings/score if listener exposure proves absent. | James → Board / Maria Santos / Robert Kim. | Evidence ledger and formal go/no-go acceptance, not merely a completed document. |

**Safety and evidence discipline:** Do not run destructive payloads or a live remote exploit against a clinical perimeter without explicit authorization; this report provides **version/configuration/KEV-based assessment, not exploit instructions**. Do not equate a network-reachable **IPsec** tunnel with the vulnerable **SSL-VPN** listener. Avoid service interruption by coordinating alternate clinician access and emergency workflows with Clinical Leadership and Biomedical Engineering.

## Evidence and reference index

**Public primary/reference sources (accessed 12 November 2026):**

- **[S6]** [Bishop Fox, CVE-2023-27997-check](https://github.com/BishopFox/CVE-2023-27997-check) — public research-backed vulnerability verification project, not a documented MedDefense run.
- **[S7]** [Rapid7 Metasploit framework issue #18163](https://github.com/rapid7/metasploit-framework/issues/18163) — public exploit-development discussion and referenced third-party PoC; an issue is **not** a confirmed Metasploit exploit module.
- **[S8]** [Exploit-DB entry 51832](https://www.exploit-db.com/exploits/51832) — **Saflok KDF**, showing the incorrect FortiGate/EDB attribution; [OffSec SearchSploit Manual](https://www.exploit-db.com/searchsploit) for search procedure.
- **[S9]** [NVD CVE-2024-55591](https://nvd.nist.gov/vuln/detail/CVE-2024-55591) — distinct vulnerability affecting FortiOS 7.0.0–7.0.16, including candidate 7.0.14.
- **[S10]** [Fortinet, upgrade to FortiOS 7.0.17 to resolve CVE-2024-55591](https://community.fortinet.com/fortigate-3/technical-tip-upgrade-to-fortios-7-0-17-to-resolve-vulnerability-cve-2024-55591-195231) — historical specific fix, not blanket approval for 2026 version selection.
- **[S11]** [CISA Known Exploited Vulnerabilities Catalog](https://www.cisa.gov/known-exploited-vulnerabilities-catalog?search_api_fulltext=CVE-2023-27997) — CVE-2023-27997 added 2023-06-13, action to apply vendor updates, U.S. federal due date 2023-07-04.
- **[S12]** [FIRST CVSS v3.1 official specification](https://www.first.org/cvss/v3-1/specification-document) and [NIST v3.1 calculator](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator) — official Environmental scoring constants and methodology.

**Project-internal sources (relative to `blue_team/1x05_board_briefing`):**

- [1x05 Task 0 — Crimson Tide advisory analysis](0-advisory_analysis.md): seven-phase scenario map, new FortiGate version, SSL-VPN uncertainty, $2,400 support issue and 5/7 conditional exposure score. The original course-specific Crimson Tide advisory text **was not independently retrieved**; campaign claims are scenario inputs, not independently authenticated CISA campaign evidence.
- [1x00 Gap Analysis](../1x00_first_watch/12-gap_analysis.md), [Control Matrix](../1x00_first_watch/10-complete_control_matrix.md): GAP-015/016/011/006/017/007/003, existing C-001/002/003/004/022/023/041.
- [1x01 Kill Chains](../1x01_know_your_enemy/10-kill_chains.md): KC1 VPN→AD→ransomware, KC2 pharmacy-change integrity, KC3 radiology→PACS extortion. Only KC1 explicitly starts with VPN compromise; KC2/KC3 are *conditional downstream consequences* of broader access, not literal FortiGate exploitation stages.
- [1x02 T4 — Exploit Hunt](../1x02_the_weak_links/4-exploit_hunt.md): **5/5** for KEV-listed exploited CVEs and **4/5** for a verified public PoC without KEV; [1x02 T17 — CVSS Contextualizer](../1x02_the_weak_links/17-cvss_contextualizer.md) for environmental-metric methodology.
- [1x03 Governance](../1x03_defense_blueprint/4-governance_architecture.md), [Budget](../1x03_defense_blueprint/8-budget_allocation.md), [Risk Register](../1x03_defense_blueprint/10-risk_register.md): decision owners, C1/C2/C3/C4 costs and EHR/VPN overlap caution.
- [1x04 T0](../1x04_crypto_foundation/0-crypto_inventory.md), [T13](../1x04_crypto_foundation/13-encryption_levels.md), [T14](../1x04_crypto_foundation/14-key_management.md), [T15](../1x04_crypto_foundation/15-crypto_posture_audit.md): database, NAS and VPN controls/baseline versus recommendations.

**Provenance boundary:** All CVE/KEV/vendor fixed-version assertions are sourced to published advisories. FortiOS 7.0.9, FortiGate 100F, single-perimeter/no-HA, $2,400 support renewal, 800 portal patient interactions and Crimson Tide location/attack narrative are **user-supplied exercise facts**, not results of appliance access. The CVSS calculation is reproducible; local SearchSploit output, actual SSL-VPN reachability, authenticated inventory, firmware patching and Board approvals remain **not observed**. All remediation requires appropriate authority and clinical service protections.
