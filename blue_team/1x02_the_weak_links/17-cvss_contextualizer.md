# Task 17 — The CVSS Contextualizer

**Project:** MedDefense Health Systems — Blue Team / 1x02 The Weak Links
**Deliverable:** `17-cvss_contextualizer.md`
**Assessment date:** 22 October 2026
**Method:** CVSS v3.1 Environmental metrics (NIST calculator / FIRST equations), combined with a distinct business-priority decision.

## Evidence, Scope, and Scoring Rules

The eight prioritized Actionable findings are **031, 003, 004, 010, 001, 008, 002, and 007**, in that order. T16 classifies the first seven as **Actionable Critical (AC)** and Finding 007 as the first **Actionable Standard (AS)** item. The selection and order were verified against `16-triage.md`.

Evidence sources: the [SecurePoint MedDefense vulnerability scan](https://s3.eu-west-3.amazonaws.com/hbtn.intranet/uploads/text/2026/3/3d9524922b7e610ce212603cb9f59167c5926948.txt); `4-exploit_hunt.md` (T4); `../1x00_first_watch/8-criticality_assessment.md` (CIA), `../1x00_first_watch/10-complete_control_matrix.md` (existing controls), and `../1x01_know_your_enemy/10-kill_chains.md` (KC1–KC5). Asset references are drawn from earlier MedDefense work. **Cross-check completed against the supplied 1x00 Task 8 criticality matrix, Task 10 complete control matrix, and 1x01 Task 10 kill chains.** CIA values are taken from the relevant asset *category* (G1–G7), not inferred as independently verified host-level ratings. In particular, the print server's category-wide High rating does not establish its individual impact. T4-specific scores and T16 order still require comparison with their original files.

**CVSS rules:** Base and Environmental scores are **not** a count of risk factors. CVSS v3.1 uses the documented Base vector plus Environmental requirements (`CR`, `IR`, `AR`) and defensible Modified Base overrides. We keep attack prerequisites unchanged and never increase `MAV` or remove `PR` just because a kill chain could provide access. All calculations use `E:X/RL:X/RC:X`, meaning unspecified Temporal metrics. T4 exploit scores and CISA KEV inform **business priority independently**, rather than being converted arbitrarily to CVSS points. Unless explicitly stated, compensating controls are not sufficiently demonstrated to override `MAV`, `MAC`, `MPR`, `MC`, `MI`, or `MA`.

**Interpretation of missing/contested CVEs:** Findings 003 and 007 are configuration exposures with **no published CVSS Base Score**; their numeric examples are plainly labeled **analyst-modeled scenarios**, not scores supplied by the scan or NVD. Findings 004 and 008 encompass unsupported products and multiple vulnerabilities; their calculations use **one named CVE as a representative**, not a fabricated CVSS score for the whole EOL condition. There are also material consistency problems in the scan: Tomcat 9.0.31 and Alaris firmware 12.1.2 are described as affected by CVEs for which vendors report those versions are fixed. An exposed connector or default credentials may still require remediation even if the version-based CVE association is false.

### Kill Chain Crosswalk (1x01 T10)

- **KC1:** VPN foothold → AD compromise → domain-wide ransomware (AD is a final/high-value objective).
- **KC2:** Unsafe pharmacy change → incorrect dosage integrity (none of the eight findings directly proves this chain).
- **KC3:** Radiology phishing → PACS extortion (legacy MRI/radiology connectivity increases the reachable attack surface).
- **KC4:** Privileged insider manipulation → BD Alaris infusion-pump integrity/availability impact.
- **KC5:** Compromised MedTech maintenance channel → EHR data access and exfiltration (EHR database is the final target).

---

## Finding 031 — CVE-2020-1938 / Ghostcat; EHR AJP Connector

**CVSS Base Score:** **9.8 Critical** in the scan and NVD; `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H` (correct NVD vector). **Validity caveat:** the scan reports Tomcat **9.0.31**, a version Apache lists as fixed. Manual confirmation establishes that port 8009/AJP is listening, but that alone does **not** prove that the patched build is vulnerable to Ghostcat. The scan also prints a vector ending `A:N` alongside 9.8, an internally inconsistent combination; the NVD `A:H` vector is used to reproduce the stated 9.8.

**Factor 1 — Asset Criticality (1x00):** Asset: `ehr-srv-01` (AJP application tier), with downstream `ehr-db-01` (A-037) and EHR data (A-112). **CIA Rating:** **C: Critical, I: Critical, A: Critical** (1x00 G1) because PHI, clinical record integrity, and continuity are essential; as documented in 1x00. **Impact:** strongly raises business priority.

**Factor 2 — Kill Chain Position (1x01):** **KC5** (EHR data is the final target), and potentially **KC1** as a post-compromise pivot. **Chain role:** exposed AJP is a possible additional access/credential-exposure route; it is **not asserted to be an explicitly documented step** in the original KC5. **Impact:** raises urgency through possible downstream EHR access.

**Factor 3 — Exploitability (T4):** **Exploitability Score: Not assessed in T4**, which scored five other CVEs. **CISA KEV: Yes** for CVE-2020-1938. **Impact:** public/known exploitation increases priority **if affected-version and trust-boundary conditions are confirmed**; KEV does not prove this particular deployment is vulnerable.

**Factor 4 — Compensating Controls (1x00):** **Existing Controls:** C-003 boundary filtering, C-037 delayed EHR audit review, C-043 weak paper fallback and C-055 contracted EHR software updates (patch status unverified); authentication at other tiers cannot be treated as protection for an unnecessarily reachable AJP port. **Impact:** no validated AJP allowlist or network segregation was demonstrated, so do **not** reduce CVSS.

**Environmental CVSS (recalculated):** `CR:H/IR:H/AR:H`; other metrics unchanged. **Full vector:** `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H/CR:H/IR:H/AR:H`. **Adjusted Score: 9.8 Critical (conditional on actual CVE applicability).**

**Final Priority: Critical — immediate verification and isolation.** The EHR and PHI are crown-jewel assets, reachable AJP is a credible trust-boundary concern, and KC5 makes unauthorized EHR access especially consequential. KEV status amplifies the need to validate the vulnerability; weak segmentation and delayed logs provide limited compensating assurance. **First establish Tomcat package/build and AJP exposure; then disable or strictly allowlist AJP and remediate any confirmed unsafe configuration.** Do not label an already-fixed Tomcat 9.0.31 instance exploitable without further evidence.

## Finding 003 — PostgreSQL Accepts Connections from `10.10.0.0/16`

**CVSS Base Score:** **N/A (no CVE; scan-rated Critical)**. The scan shows `listen_addresses='*'` and `pg_hba.conf: host all all 10.10.0.0/16 md5`; **MD5 authentication still applies** and the finding is **not** unauthenticated SQL access.

**Factor 1 — Asset Criticality (1x00):** Asset: `ehr-db-01` (A-037), EHR data (A-112). **CIA Rating:** **C: Critical, I: Critical, A: Critical** (1x00 G1); this is one of the five most critical assets. **Impact:** materially raises urgency of inappropriate lateral reachability.

**Factor 2 — Kill Chain Position (1x01):** **KC5** (EHR database is the final collection target), potentially **KC1** after ransomware lateral movement. **Chain role:** high-value final target; unnecessary network paths make compromise from a prior foothold easier. **Impact:** raises urgency.

**Factor 3 — Exploitability (T4):** **Exploitability Score: N/A—configuration finding absent from T4. CISA KEV: N/A (no CVE).** **Impact:** exploitation requires credentials, a separate weakness, or an authenticated application foothold; no public-CVE exploit score should be invented.

**Factor 4 — Compensating Controls (1x00):** **Existing Controls:** C-002 weak VPN scoping, C-003 perimeter firewall, C-051 weak password-based SSH protection and C-022 weak local backup; however, there is no internal firewall or PostgreSQL-specific allowlist separating workstations from this database; PostgreSQL MD5 authentication is a real remaining hurdle, **not** a substitute for segmentation. **Impact:** available controls are insufficient to reduce internal exposure.

**Environmental CVSS (analyst-modeled scenario only):** Assumption: an attacker already has a low-privilege database credential and can reach PostgreSQL from another internal host. A **hypothetical** v3.1 Base vector is `AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:L` = **8.3**, *not the scan/NVD Base*. Set `CR:H/IR:H/AR:M`, giving a **modeled adjusted score of 8.8 High**. Full illustrative vector: `CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:L/CR:H/IR:H/AR:M`. This scenario score must **not** be mistaken for an official score of an exposed port.

**Final Priority: Critical.** This is a documented, currently reachable path to a database containing protected patient information. Even with database authentication still enabled, a single compromised endpoint or stolen credential can attempt access across the flat network. The system is a KC5 final target and C-003 does not enforce the needed internal restriction. **Limit PostgreSQL 5432 and `pg_hba.conf` to the required EHR application source, use least-privilege credentials, and add database connection monitoring.**

## Finding 004 — Windows XP MRI Controller / CVE-2017-0144 (representative)

**CVSS Base Score:** **8.1 High** for CVE-2017-0144 **as printed in the scan**; the broader EOL finding has no single Base Score. CVE-2019-0708 (9.8) and CVE-2008-4250 (10.0 as reported in the scan) are also listed there. We preserve the scan's **8.1** representative metric, `AV:N/AC:H/PR:N/UI:N/S:U/C:H/I:H/A:H`; contemporary NVD enrichment may assign different metrics (for example, NVD reports 8.8 for CVE-2017-0144).

**Factor 1 — Asset Criticality (1x00):** Asset: MRI control workstation `WS-RAD-01` (A-016), supporting Siemens MRI (A-091), dependent on PACS (A-038). **CIA Rating:** **C: High, I: Critical, A: Critical** (1x00 G2), especially strong availability/safety implications; as documented in 1x00. **Impact:** raises clinical urgency far beyond a generic unsupported desktop.

**Factor 2 — Kill Chain Position (1x01):** **KC3**, which targets radiology/PACS; potentially **KC1** as a lateral-movement foothold. **Chain role:** adjacent radiology foothold/lateral movement enabler, **not** a proven first step in the KC3 document. **Impact:** increases risk of clinical imaging disruption or PACS extortion.

**Factor 3 — Exploitability (T4):** **Exploitability Score: 5/5** for CVE-2017-0144; T4 also gives **5/5** to CVE-2019-0708 and CVE-2008-4250. **CISA KEV: Yes** for all three per T4. **Impact:** strongly raises priority: mature public exploits, known exploitation, and no sustainable patch path for Windows XP.

**Factor 4 — Compensating Controls (1x00):** **Existing Controls:** C-003 firewall at perimeter; C-017–C-021 Sophos controls apply to some supported Windows endpoints, but **coverage or compatibility on this XP MRI controller is not established**. No dedicated medical-device VLAN is confirmed. **Impact:** minimal evidenced reduction; isolation is missing.

**Environmental CVSS (recalculated):** representative CVE-2017-0144 scan vector with `CR:M/IR:H/AR:H`. Full illustrative vector: `CVSS:3.1/AV:N/AC:H/PR:N/UI:N/S:U/C:H/I:H/A:H/CR:M/IR:H/AR:H`. **Adjusted Score: 8.1 High** on this specific old baseline; the metric ceiling means context does not necessarily increase the numeric result.

**Final Priority: Critical — significant uplift from representative CVSS High.** The machine is an unsupported clinical controller with at least three KEV-listed remote vulnerabilities and open SMB/RDP paths; the scan confirms lack of VLAN separation. Clinical availability and possible KC3 expansion justify immediate containment and vendor-coordinated modernization even though environmental scoring of a *single representative CVE* remains 8.1. **Block SMB/RDP from unrelated hosts, isolate behind allowlists, plan vendor-certified replacement.**

## Finding 010 — BD Alaris Pumps / CVE-2020-25165 (contested applicability)

**CVSS Base Score:** **7.5 High** in the scan; `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H`. **Major evidence conflict:** the scan names firmware **12.1.2** as affected, but BD's advisory lists **12.1.1 and later as remediated for the Alaris 8015 PC Unit**; affected Systems Manager versions must be checked separately. Thus, a vulnerable instance of this particular CVE has **not** been independently confirmed. **Separately**, the scan reports that **7/7 pumps accept `admin/admin`**, which is actionable regardless of this CVE.

**Factor 1 — Asset Criticality (1x00):** Asset: BD Alaris infusion-pump fleet (A-061–A-067). **CIA Rating:** **C: High, I: Critical, A: Critical** (1x00 G5) because medication delivery integrity and continuous availability matter acutely; per 1x00 matrix. **Impact:** raises urgency.

**Factor 2 — Kill Chain Position (1x01):** **KC4** (final clinical target of privileged manipulation); possible dependency in **KC5** vendor-update scenario but not an exact technical step. **Chain role:** final patient-care device target. **Impact:** raises urgency regardless of a disputed version fingerprint.

**Factor 3 — Exploitability (T4):** **Exploitability Score: N/A—not covered by T4. CISA KEV: No matching entry established for CVE-2020-25165**; absence is not a guarantee of safety. **Impact:** the report documents reachable management and default credentials, but the version-specific exploitability of CVE-2020-25165 needs validation with BD.

**Factor 4 — Compensating Controls (1x00):** **Existing Controls:** enterprise perimeter C-003 and C-025 provides broad entrance checks only; neither demonstrates dedicated pump VLAN isolation or unique management passwords. **Impact:** no validated sufficient protection; do not reduce the attack-vector metric.

**Environmental CVSS (conditional scenario):** If **an actually affected** device/version existed, set `CR:M/IR:H/AR:H`, especially availability requirement. Full conditional vector: `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H/CR:M/IR:H/AR:H`. **Adjusted Score: 9.3 Critical *for an affected version***, not a verified score for the currently recorded 12.1.2 devices.

**Final Priority: Critical for immediate pump access-control remediation; CVE status unconfirmed.** The medical criticality, KC4 direct target status, broad reachability, and **confirmed default credentials** justify urgent coordinated containment. However, raising CVE-2020-25165 itself to Critical as a confirmed unpatched condition would be unsound given BD's version advisory. **Rotate default credentials through approved clinical maintenance, restrict management to designated hosts and VLANs, verify the exact PC Unit and Systems Manager versions with BD, and maintain patient-care continuity during changes.**

## Finding 001 — CVE-2021-44790 / Apache mod_lua Buffer Overflow

**CVSS Base Score:** **9.8 Critical**; `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H`.

**Factor 1 — Asset Criticality (1x00):** Asset: `billing-srv-01` (A-039), billing application (A-123), financial records (A-113). **CIA Rating:** **C: High, I: High, A: High** (1x00 G3); per 1x00 matrix. **Impact:** financial records and revenue continuity increase urgency, although the host is not one of the five most-critical clinical assets.

**Factor 2 — Kill Chain Position (1x01):** **None explicitly named as an entry point** in KC1–KC5; it is a **plausible initial foothold feeding KC1-style ransomware lateral movement**. **Chain role:** network-facing remote execution → low-privilege web process, potentially followed by Finding 002. **Impact:** strongly raises priority as the first half of a verified two-vulnerability chain described in the scan.

**Factor 3 — Exploitability (T4):** **Exploitability Score: 4/5. CISA KEV: No** (T4; public verified Exploit-DB PoC). **Impact:** raises urgency despite no KEV listing.

**Factor 4 — Compensating Controls (1x00):** **Existing Controls:** C-003 boundary firewall, C-035/C-036 weak Linux/Apache logs, C-022 weak local backups and C-047/C-048 weak billing recovery/response; Sophos C-017–C-021 does not cover Linux servers. **Impact:** logs and backup aid detection/recovery but do not neutralize unauthenticated mod_lua memory corruption; no CVSS deduction.

**Environmental CVSS (recalculated):** `CR:H/IR:H/AR:M`; attack and impact metrics unchanged. Full vector: `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H/CR:H/IR:H/AR:M`. **Adjusted Score: 9.8 Critical.**

**Final Priority: Critical.** The confirmed loaded module and affected Apache version create a direct entry route to financial systems, while Finding 002 can turn that foothold into root access. T4's 4/5 exploitability and ineffective server EDR coverage amplify the urgency. Existing firewall/logging/backup controls do not remove exposure. **Patch Apache, verify mod_lua use, isolate the web service, and investigate the pre-existing miner for persistence.**

## Finding 008 — Windows Server 2012 R2 Print Server / CVE-2021-34527 (representative)

**CVSS Base Score:** **8.8 High** for PrintNightmare CVE-2021-34527, explicitly identified by the scan in the broader unsupported `print-srv-01` finding. Vector: `CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H`.

**Factor 1 — Asset Criticality (1x00):** Asset: `print-srv-01` (A-043). **CIA Rating:** **C: High, I: High, A: High** (1x00 G7 category; individual print service may be lower); per 1x00. **Impact:** print-service compromise is less directly safety-critical than MRI or infusion pumps, but lateral movement can raise its operational importance.

**Factor 2 — Kill Chain Position (1x01):** **KC1-compatible** Windows lateral-movement and privilege-escalation enabler; **not stated as a named step** in KC1. **Chain role:** internal pivot to SYSTEM on a shared service. **Impact:** raises urgency when domain access is possible.

**Factor 3 — Exploitability (T4):** **Exploitability Score: N/A—not scored in T4. CISA KEV: Yes** for CVE-2021-34527, corroborated by NVD/CISA; public PrintNightmare tooling exists. **Impact:** raises priority.

**Factor 4 — Compensating Controls (1x00):** **Existing Controls:** C-003 boundary firewall; C-017–C-021 Sophos on managed endpoints, but no verified coverage on this EOL print server or safe Print Spooler restrictions. **Impact:** insufficient proof of protection; no Environmental `MAV` reduction.

**Environmental CVSS (recalculated):** `CR:M/IR:H/AR:M`, maintaining known attack prerequisites. Full vector: `CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H/CR:M/IR:H/AR:M`. **Adjusted Score: 8.8 High.**

**Final Priority: High (urgent patch/retire, escalate to Critical if lateral domain access confirmed).** The KEV-listed service flaw and unsupported operating system are a credible path to SYSTEM, and the service is active. Existing enterprise protections have not been shown to block the path, but it is not a direct top-five patient-care asset and is not explicitly in an existing kill chain. **Apply supported replacement/mitigation, restrict spooler RPC, and isolate the server.**

## Finding 002 — CVE-2019-0211 / Apache Local Privilege Escalation

**CVSS Base Score:** **7.8 High**; `CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H`.

**Factor 1 — Asset Criticality (1x00):** Asset: `billing-srv-01` (A-039), billing records (A-113). **CIA Rating:** **C: High, I: High, A: High** (1x00 G3). **Impact:** increases urgency due to root control over revenue/billing data and potential adjacent assets.

**Factor 2 — Kill Chain Position (1x01):** **No literal instance** in KC1–KC5; a credible **post-foothold privilege escalation / lateral-movement enabler** for KC1-type ransomware progression. **Chain role:** after Finding 001 supplies code execution as a less-privileged Apache process, Finding 002 may elevate to root. **Impact:** significant priority increase over treating a local-only CVE in isolation.

**Factor 3 — Exploitability (T4):** **Exploitability Score: 5/5. CISA KEV: Yes**. Working public local exploit, but a local foothold remains a prerequisite. **Impact:** raises practical priority because the scan identifies a plausible prerequisite in Finding 001.

**Factor 4 — Compensating Controls (1x00):** **Existing Controls:** C-003 boundary firewall, C-035/C-036 local logs, C-022 backup; Linux servers lack evidenced Sophos agent protection. **Impact:** no control reliably stops local privilege escalation after application compromise.

**Environmental CVSS (recalculated):** `CR:H/IR:H/AR:M` only; **do not change `AV:L` to `AV:N`** or `PR:L` to `PR:N` merely because Finding 001 could create a foothold. Full vector: `CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H/CR:H/IR:H/AR:M`. **Adjusted Score: 7.8 High.**

**Final Priority: Critical — material *business-priority uplift*, not CVSS score inflation.** The KEV-listed exploit is a highly credible second stage behind the confirmed Apache remote code execution issue. Because the business context includes a real, reachable preceding vulnerability, root compromise and onward ransomware spread are plausible even though the intrinsic exploit remains local. Firewall, logs, and backups do not break that sequence. **Remediate Findings 001 and 002 together; do not defer 002 based only on its 7.8 Base Score.**

## Finding 007 — LDAP Signing Not Required on Domain Controller

**CVSS Base Score:** **N/A (no CVE; scan-rated High)**. The scan identifies unsigned LDAP and enabled SMBv1 on `ad-dc-01`; it does **not** prove a specific successful relay chain or privilege level.

**Factor 1 — Asset Criticality (1x00):** Asset: `ad-dc-01` (A-040), with AD redundancy on `ad-dc-02` (A-041). **CIA Rating:** **C: High, I: Critical, A: Critical** (1x00 G4), especially directory integrity and authentication availability; as documented in the 1x00 category matrix. **Impact:** sharply raises urgency.

**Factor 2 — Kill Chain Position (1x01):** **KC1** targets AD, whose compromise enables ransomware across the estate. **Chain role:** LDAP relay is a **plausible authentication abuse/lateral movement enabler**, not a proven occurrence or a verbatim KC1 step. **Impact:** raises priority because AD is a high-leverage objective.

**Factor 3 — Exploitability (T4):** **Exploitability Score: N/A—no CVE covered by T4. CISA KEV: N/A (no CVE).** **Impact:** relay attacks are a recognized abuse pattern, but exploitation requires conditions such as captured/relayed authentication and a suitable target; do not equate a misconfiguration with a KEV exploit.

**Factor 4 — Compensating Controls (1x00):** **Existing Controls:** C-034 weak directory-event logging, C-003 boundary firewall and C-050 secondary domain controller (availability only); no evidenced LDAP signing requirement, SMBv1 removal, or domain-controller source restriction. **Impact:** logging and boundary filtering do not adequately stop an internal relay attack.

**Environmental CVSS (analyst-modeled scenario only):** Hypothetical case: an adjacent attacker with a low-privilege position obtains a relay opportunity requiring user authentication. Illustrative **non-official Base** vector `AV:A/AC:H/PR:L/UI:R/S:U/C:H/I:H/A:L` = **6.4 Medium**; add `CR:H/IR:H/AR:H` to obtain **6.8 Medium**. Full illustrative vector: `CVSS:3.1/AV:A/AC:H/PR:L/UI:R/S:U/C:H/I:H/A:L/CR:H/IR:H/AR:H`. A different relay technique or assumptions would produce a different model; it is **not** an NVD score for Finding 007.

**Final Priority: Critical — contextual uplift from scan-rated High.** AD is central to KC1 and a domain-wide compromise could enable credential misuse, ransomware deployment, and organization-wide downtime. There is no confirmed internal restriction or mandatory LDAP signing to defeat the specific condition, and domain logging alone cannot prevent it. **Require LDAP signing (and channel binding where applicable), remove SMBv1, restrict domain-controller exposure, and audit insecure bind attempts before enforcement.**

---

## Priority Comparison Table

| Finding | CVSS Base (scan/NVD) | Environmental adjusted score | Final adjusted priority | Change direction vs Base/scan severity | Material difference / explanation |
|---|---|---|---|---|---|
| **031** Ghostcat / AJP | 9.8 Critical (CVE; applicability disputed) | **9.8 Critical, conditional** | **Critical** | Same; **validate first** | 9.0.31 is vendor-fixed, but AJP reachability demands review |
| **003** broad EHR DB access | N/A; scanner **Critical** | **8.8 High, modeled** (scenario Base 8.3) | **Critical** | Same vs scanner; numerical comparison N/A | No official CVSS; PHI and KC5 determine business urgency |
| **004** XP MRI / EternalBlue | 8.1 High (representative scan CVE) | **8.1 High** | **Critical** | **HIGHER business priority** | EOL, three KEV-listed CVEs, clinical dependency |
| **010** Alaris / CVE-2020-25165 | 7.5 High (CVE; likely fixed on 12.1.2) | **9.3 Critical if affected** | **Critical for default credentials; CVE unconfirmed** | **HIGHER conditional score/priority** | Life-critical availability; reported `admin/admin`; vendor version conflict |
| **001** Apache mod_lua | 9.8 Critical | **9.8 Critical** | **Critical** | Same | Network RCE plus Finding 002 chain |
| **008** EOL print / PrintNightmare | 8.8 High (representative CVE) | **8.8 High** | **High** | Same | KEV / active spooler, lower direct asset criticality |
| **002** Apache local privilege escalation | 7.8 High | **7.8 High** | **Critical** | **HIGHER business priority** | T4 5/5 + KEV + exploitable prerequisite in 001 |
| **007** unsigned LDAP | N/A; scanner **High** | **6.8 Medium, modeled** (scenario Base 6.4) | **Critical** | **HIGHER business priority** vs scan | AD centrality to KC1; numeric comparison N/A |

**Most significant changes:** Finding **010** changes *conditional numerical CVSS severity* (7.5 → 9.3), although the reported firmware is apparently already patched for the named CVE; therefore, **do not** deploy a CVE-specific emergency patch based on the calculated number alone. Findings **004, 002, and 007** rise from the scan/CVE's High-level treatment to **Critical operational priority** without artificial manipulation of technical CVSS prerequisites. For **003** and **007**, the official Base is N/A, so change-direction comparisons use the **scanner's qualitative severity**, not a nonexistent published Base score.

### Overall Synthesis

The environment's most consequential risk pattern is **reachable critical clinical and identity assets on an inadequately segmented internal network**, compounded by unsupported systems and exploitable chaining opportunities. CVSS v3.1 Environmental scoring captures CIA requirements but not the entire operational harm of medication disruption, a chained remote-to-root compromise, or AD-driven ransomware. The highest operational priorities are to constrain the EHR database and AJP exposure; isolate MRI/pump management; remediate the Apache RCE/LPE chain; harden domain authentication; and patch or replace the print server. **Version and applicability verification is a prerequisite** for attributing Ghostcat to Tomcat 9.0.31 or the Alaris session CVE to firmware 12.1.2, even when their associated configuration risks remain urgent.

## Reproduction and Reference Links

1. [NVD CVSS v3.1 calculator](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator) — paste each documented `CVSS:3.1/...` full vector or set Base and Environmental metrics manually.
2. [FIRST CVSS v3.1 specification and equations](https://www.first.org/cvss/v3.1/specification-document) — formal Environmental methodology, requirement weights, modified impact and rounding.
3. [MedDefense full vulnerability scan](https://s3.eu-west-3.amazonaws.com/hbtn.intranet/uploads/text/2026/3/3d9524922b7e610ce212603cb9f59167c5926948.txt) — finding IDs, services and scan-supplied scores.
4. [NVD CVE-2020-1938](https://nvd.nist.gov/vuln/detail/CVE-2020-1938) — 9.8 Base vector and affected Tomcat versions **earlier than 9.0.31**.
5. [BD Alaris 8015 / Systems Manager official bulletin](https://www.bd.com/en-us/about-bd/cybersecurity/bulletin/bd-alaris-8015-pc-unit-and-bd-alaris-systems-manager-network-s) — mitigation in software **12.1.1+** for specified PC Unit builds and separate Systems Manager considerations.
6. [NVD CVE-2021-34527](https://nvd.nist.gov/vuln/detail/CVE-2021-34527) — PrintNightmare 8.8 and KEV status.
7. [NVD CVE-2017-0144](https://nvd.nist.gov/vuln/detail/CVE-2017-0144) — NVD's current 8.8 metric differs from the **8.1 value printed in the MedDefense scan**.

**Evidence reconciliation:** The 1x00 CIA category ratings and control matrix, 1x01 T10 kill chains, T4 exploit scores, and T16 actionability/order have been compared with the supplied project documents. Category ratings must not be mistaken for independently validated per-host scores; the print server in particular may have lower standalone impact. The vendor/version applicability caveats remain unresolved and require actual deployment verification. CVSS modeled scenarios remain explicitly non-official.
