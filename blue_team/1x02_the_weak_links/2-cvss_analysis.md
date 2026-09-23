# MedDefense Health Systems — CVSS v3.1 Deconstruction

**Assessment date:** 2026-09-23 UTC

**Scoring standard:** [FIRST Common Vulnerability Scoring System v3.1](https://www.first.org/cvss/v3.1/specification-document)

**Calculator:** [NIST NVD CVSS v3.1 Calculator](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator)

## Method and Interpretation

This assessment evaluates **CVSS v3.1 Base metrics** only. A Base score describes the intrinsic technical severity of a vulnerability under the conditions encoded in its vector; it is not a probability of exploitation or a complete MedDefense risk rating. Environmental context such as asset criticality, existing controls and business impact must be added separately during prioritization.

CVSS v3.1 uses the following qualitative bands: None (`0.0`), Low (`0.1–3.9`), Medium (`4.0–6.9`), High (`7.0–8.9`) and Critical (`9.0–10.0`). The calculations below were entered into the NIST calculator and independently checked against the FIRST v3.1 equations and mandatory “Roundup” rule.

## Exercise 1 — Deconstruction

### Source Finding and Baseline

- **Scan reference:** Finding 001, CVE-2021-44790, on `billing-srv-01`
- **Vector:** `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H`
- **NIST result:** **9.8 — Critical**
- **Calculator verification:** [Open the baseline vector in the NIST calculator](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator?vector=AV%3AN%2FAC%3AL%2FPR%3AN%2FUI%3AN%2FS%3AU%2FC%3AH%2FI%3AH%2FA%3AH&version=3.1)

The “all else equal” scores in the table change only the named metric. They illustrate the formula; a metric must always be selected from the real exploitation conditions, not chosen merely to raise or lower a score.

| Component | Selected value and meaning | Other possible values and score effect | Why it fits CVE-2021-44790 at MedDefense |
|---|---|---|---|
| **AV:N — Attack Vector: Network** | The vulnerable component can be reached remotely across a network. Network has weight `0.85` and represents the least attacker proximity. | **Adjacent (A)** requires access to a shared or otherwise limited network and would produce `8.8`; **Local (L)** requires local-system access and would produce `8.4`; **Physical (P)** requires physical interaction and would produce `6.8`. Greater required proximity lowers exploitability. | The report describes an unauthenticated crafted HTTP request to Apache on TCP/80; the attacker does not first need an account or local session on `billing-srv-01`. |
| **AC:L — Attack Complexity: Low** | Exploitation does not depend on significant conditions outside the attacker's control. Low has weight `0.77`. | **High (H)** means exploitation requires specific conditions, preparation or a successful race and would lower this vector to `8.1`. | The reported path is delivery of a crafted multipart request to the loaded `mod_lua` parser, with no race or uncommon deployment condition identified beyond the vulnerable module being present. |
| **PR:N — Privileges Required: None** | The attacker needs no prior authorization in the vulnerable system. For unchanged scope, None has weight `0.85`. | **Low (L)** requires basic authorized capability and would produce `8.8`; **High (H)** requires significant administrative control and would produce `7.2`. PR weights differ when Scope is Changed. | Finding 001 expressly states that remote code execution may occur without authentication. |
| **UI:N — User Interaction: None** | No person other than the attacker must take an action. None has weight `0.85`. | **Required (R)** means another user must perform an action, such as opening a file or visiting content, and would lower this vector to `8.8`. | Apache processes the attacker's request directly; no billing employee must click, approve or open anything. |
| **S:U — Scope: Unchanged** | The vulnerable component and the impacted resources are governed by the same security authority. | **Changed (C)** applies only when exploitation crosses into a different security authority. With every other value held constant, it would produce `10.0` because the Changed-scope impact formula and multiplier apply. | The initial result is code execution and compromise within the security authority of the vulnerable Apache host. Finding 002 could then provide a separate privilege-escalation step, but that distinct vulnerability does not make Finding 001's own Scope Changed. |
| **C:H — Confidentiality Impact: High** | Exploitation can cause total loss of confidentiality in the affected scope. High has weight `0.56`. | **Low (L)** means limited disclosure and would produce `9.4`; **None (N)** means no confidentiality loss and would produce `9.1`, if only C changed. | Arbitrary code in the web-service context can expose application secrets and billing information accessible to that process; the scanner therefore assigns complete potential confidentiality impact. |
| **I:H — Integrity Impact: High** | Exploitation can cause total loss of integrity in the affected scope. High has weight `0.56`. | **Low (L)** means limited modification and would produce `9.4`; **None (N)** means no integrity loss and would produce `9.1`, if only I changed. | Remote code execution can alter application data, content or executable state available to the compromised service. |
| **A:H — Availability Impact: High** | Exploitation can cause total loss of availability in the affected scope. High has weight `0.56`. | **Low (L)** means reduced or intermittent service and would produce `9.4`; **None (N)** means no availability loss and would produce `9.1`, if only A changed. | Memory corruption or attacker-controlled code can crash or deliberately stop the Apache-hosted billing service. |

### Required Attack-Vector Change: Network to Local

Changing only `AV:N` to `AV:L` produces:

`CVSS:3.1/AV:L/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H`

**Calculated result:** **8.4 — High**

**Calculator verification:** [Open the modified vector in the NIST calculator](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator?vector=AV%3AL%2FAC%3AL%2FPR%3AN%2FUI%3AN%2FS%3AU%2FC%3AH%2FI%3AH%2FA%3AH&version=3.1)

The CIA Impact subscore remains approximately `5.87` because the potential consequences did not change. Only the Attack Vector weight falls, from Network's `0.85` to Local's `0.55`, reducing the Exploitability subscore from approximately `3.89` to `2.52`. The v3.1 formula and Roundup rule therefore move the Base score from `9.8` to `8.4`: the hypothetical flaw remains highly damaging, but the attacker must first obtain local access.

## Exercise 2 — Construction

### Metric Selection

| Stated characteristic | CVSS metric | Reasoning |
|---|---|---|
| Exploitable only from the local network, not the Internet | `AV:A` | **Adjacent** is correct for an attack delivered over a restricted shared or logically adjacent network. `AV:L` would mean that the attacker must already have local read/write/execute capability on the vulnerable host itself. |
| Exploitation is complex and requires specific conditions | `AC:H` | Success depends on conditions beyond ordinary attacker control. |
| Attacker needs low-level privileges | `PR:L` | A basic authorized account or limited privilege is required before exploitation. |
| No user interaction is needed | `UI:N` | No separate victim action is part of the path. |
| Only the targeted system is affected | `S:U` | The vulnerable and impacted components remain under the same security authority. |
| Confidentiality is compromised completely | `C:H` | All protected information in the affected scope may be disclosed. |
| No integrity impact | `I:N` | The exploit does not enable unauthorized modification. |
| No availability impact | `A:N` | The exploit does not interrupt the service or resource. |

**Constructed vector:** `CVSS:3.1/AV:A/AC:H/PR:L/UI:N/S:U/C:H/I:N/A:N`

**NIST-calculated Base score:** **4.8 — Medium**

**Calculator verification:** [Open the constructed vector in the NIST calculator](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator?vector=AV%3AA%2FAC%3AH%2FPR%3AL%2FUI%3AN%2FS%3AU%2FC%3AH%2FI%3AN%2FA%3AN&version=3.1)

The complete confidentiality loss gives an Impact subscore of approximately `3.60`, but adjacent-only reachability, high complexity and the low-privilege prerequisite reduce the Exploitability subscore to approximately `1.18`. With no integrity or availability effect, the resulting Base score is `4.8`.

## Exercise 3 — Comparison

### Evidence Constraint and Selection

The supplied scan report contains **no finding with an explicitly stated CVSS Base score between 5.0 and 7.0**. Its explicit numeric values are `7.5`, `7.8`, `8.1`, `8.8`, `9.8` and `10.0`; the remaining findings show `N/A` or no CVSS field. Inventing a scanner-issued score would misrepresent the evidence.

To complete the intended comparison transparently, this exercise uses:

1. **Finding 001 — Apache `mod_lua` buffer overflow:** report-supplied vector and score, `9.8`.
2. **Finding 017 — Tomcat default error-page information disclosure:** an **analyst-derived** Base vector of `5.3`, based only on the report's stated behavior. This vector supports the scoring exercise; it does not replace SecurePoint's `N/A (Scanner rated: Medium)` result.

Finding 017 exposes Tomcat 9.0.31 and internal stack-trace/path information over TCP/8080. The disclosure can be requested remotely, with no authentication, user action or special condition stated; it reveals useful but limited information and does not itself modify or stop the service. Those facts support:

`CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N`

**Calculated result for Finding 017:** **5.3 — Medium**

**Calculator verification:** [Open the analyst-derived Finding 017 vector](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator?vector=AV%3AN%2FAC%3AL%2FPR%3AN%2FUI%3AN%2FS%3AU%2FC%3AL%2FI%3AN%2FA%3AN&version=3.1)

### Side-by-Side Metric Comparison

| Metric | Finding 001: `mod_lua` RCE | Finding 017: error-page disclosure | Effect on the difference |
|---|---|---|---|
| Attack Vector | `AV:N` | `AV:N` | None; both are network reachable. |
| Attack Complexity | `AC:L` | `AC:L` | None; no special condition is encoded. |
| Privileges Required | `PR:N` | `PR:N` | None; neither path requires prior authorization. |
| User Interaction | `UI:N` | `UI:N` | None; neither needs a victim action. |
| Scope | `S:U` | `S:U` | None; both remain within the affected service's security authority. |
| Confidentiality | `C:H` | `C:L` | Finding 001 can expose all data available in the affected scope; Finding 017 discloses limited version, stack-trace and path information. |
| Integrity | `I:H` | `I:N` | Finding 001 permits arbitrary alteration; Finding 017 does not itself modify data or code. |
| Availability | `A:H` | `A:N` | Finding 001 can crash or disable the service; Finding 017 does not itself interrupt it. |
| **Base score** | **9.8 — Critical** | **5.3 — Medium** | **4.5-point difference** |

The exploitability metrics are identical, so both vectors have an Exploitability subscore of approximately `3.89`. The entire score difference comes from the **Impact metrics**: the Impact subscore falls from approximately `5.87` for `C:H/I:H/A:H` to `1.41` for `C:L/I:N/A:N`. Integrity and Availability have the largest individual changes because each moves from High (`0.56`) to None (`0`), while Confidentiality moves from High (`0.56`) to Low (`0.22`). Collectively, the CIA metrics—not network reachability—explain why one remotely accessible issue is Critical and the other is Medium.

## Conclusions

- A score is reproducible only when every metric is tied to an explicit exploitation or impact fact.
- “Local network” and “local access” are not interchangeable: the former normally maps to `AV:A`, while the latter maps to `AV:L`.
- Finding 001 remains severe after a hypothetical proximity restriction because its confidentiality, integrity and availability impacts all remain High.
- Equal exploitability does not imply equal severity; the comparison demonstrates how sharply CIA impact can change the result.
- CVSS Base severity must be combined with MedDefense-specific exposure, asset criticality, controls and threat evidence before remediation priority is assigned.

## Sources

- [FIRST — CVSS v3.1 Specification Document](https://www.first.org/cvss/v3.1/specification-document)
- [FIRST — CVSS v3.1 User Guide](https://www.first.org/cvss/v3.1/user-guide)
- [NIST NVD — CVSS v3.1 Calculator](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator)
- [NIST NVD — Vulnerability Metrics](https://nvd.nist.gov/vuln-metrics/cvss)
- [NIST NVD — CVE-2021-44790](https://nvd.nist.gov/vuln/detail/CVE-2021-44790)
- [SecurePoint Consulting — MedDefense Vulnerability Scan Report](https://s3.eu-west-3.amazonaws.com/hbtn.intranet/uploads/text/2026/3/3d9524922b7e610ce212603cb9f59167c5926948.txt)
