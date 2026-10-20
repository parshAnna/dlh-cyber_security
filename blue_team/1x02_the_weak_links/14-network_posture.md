# MedDefense Health Systems — Network Posture Analysis

## Scope and Assessment Method

This analysis evaluates how MedDefense's flat internal network changes the effective risk of three CVEs affecting three different systems.

The selected vulnerabilities are:

| Finding | CVE | Host | CVSS Base Score |
|---|---|---|---:|
| 001 | CVE-2021-44790 | `billing-srv-01` — `10.10.2.15` | 9.8 |
| 008 | CVE-2021-34527 | `print-srv-01` — `10.10.2.31` | 8.8 |
| 004 | CVE-2017-0144 | `WS-RAD-01` / MRI controller — `10.10.1.70` | 8.1 |

The earlier MedDefense network assessment identified the Central environment as a broadly connected `10.10.0.0/16` network without effective segmentation between normal workstations, servers, clinical systems, and important infrastructure.

For this analysis, "Risk Amplification Factor" is qualitative rather than a fabricated numeric multiplier. The project does not provide a mathematical formula for calculating a network amplification value. The factor therefore describes how much the flat architecture increases attacker reachability and post-compromise blast radius.

A successful exploit does not automatically compromise every other MedDefense system. Instead, the flat network removes an important containment layer and allows the attacker to discover, reach, and attempt lateral movement toward many systems that would otherwise be separated by VLANs and firewall policy.

---

## 1. CVE-2021-44790 — Apache HTTP Server Buffer Overflow

**CVE:** CVE-2021-44790

**Finding:** 001

**Host:** `billing-srv-01 — 10.10.2.15`

**Asset Context:** Billing server A-039 and related billing application infrastructure.

**CVSS Base Score:** **9.8 — Critical**

The scan identifies Apache 2.4.29 with the affected `mod_lua` functionality on `billing-srv-01`. Successful exploitation can provide remote code execution on the billing server.

### Scenario A — Current Flat Network

**Who can reach this vulnerability:**

Systems with network access across MedDefense's broadly connected `10.10.0.0/16` environment can potentially reach services exposed by `billing-srv-01`, subject only to host-level service configuration and any controls that exist outside the flat internal architecture.

The flat environment includes normal user workstations, clinical endpoints, servers, Active Directory infrastructure, EHR systems, backup infrastructure, and medical-device networks that do not have strong security boundaries separating them.

The scan evidence does not establish that every host can access every port or that the Apache service is publicly Internet-accessible. The important point is that an attacker who obtains any internal foothold does not face a strong internal segmentation boundary before attempting to reach the billing server.

**What the attacker can reach AFTER exploitation:**

Successful remote code execution gives the attacker a foothold on `billing-srv-01`.

From this position, the attacker can enumerate and attempt to reach other services across the flat network, including:

- `ehr-db-01` and other EHR infrastructure;
- Active Directory domain controllers;
- `print-srv-01`;
- PACS and radiology systems;
- backup infrastructure such as `NAS-01`;
- workstations and clinical systems;
- medical-device management interfaces.

Finding 006 further increases the local value of the billing foothold because MySQL on the same server is broadly bound to the network.

The compromise can therefore change from a billing-server incident into a lateral-movement platform.

**Effective Risk:** **Critical.**

The intrinsic CVSS score is already Critical, but MedDefense's network architecture increases the environmental consequences. Instead of compromising one application server inside a contained billing segment, successful exploitation creates a foothold with broad visibility toward unrelated clinical and administrative systems.

### Scenario B — Hypothetical Segmented Network

**Who can reach this vulnerability:**

In a segmented design, `billing-srv-01` would reside in a dedicated billing or application VLAN.

Only systems with a legitimate operational need to communicate with the billing service would be allowed through firewall policy. General clinical workstations, medical-device VLANs, EHR infrastructure, and unrelated servers would not be able to initiate arbitrary connections to the billing segment.

**What the attacker can reach AFTER exploitation:**

The attacker would initially be contained within the billing VLAN.

They could compromise billing applications, local data, and other explicitly reachable systems in that zone, but access to:

- Active Directory administrative interfaces;
- EHR infrastructure;
- PACS;
- medical-device networks;
- backup management;
- unrelated server VLANs

would require a permitted firewall path, stolen privileged credentials, or exploitation of an additional controlled boundary.

The vulnerability would therefore remain serious, but the blast radius would be substantially smaller.

**Effective Risk:** **High to Critical within the billing segment, but substantially reduced at the enterprise level.**

### Risk Amplification Factor

**Very High.**

The flat network transforms a Critical vulnerability on one billing server into a potential enterprise-wide foothold.

Segmentation would not remove CVE-2021-44790 or eliminate the need to patch Apache, but it would prevent one successful exploit from automatically creating broad east-west reachability across unrelated clinical and infrastructure systems.

---

## 2. CVE-2021-34527 — PrintNightmare

**CVE:** CVE-2021-34527

**Finding:** 008

**Host:** `print-srv-01 — 10.10.2.31`

**Asset Context:** Legacy Windows print server A-043.

**CVSS Base Score:** **8.8 — High**

The scan identifies an active Windows Print Spooler on the legacy `print-srv-01`. CVE-2021-34527 can allow a network attacker with the required low-level access to execute code with SYSTEM privileges.

### Scenario A — Current Flat Network

**Who can reach this vulnerability:**

The print server exposes Windows services within MedDefense's broadly connected internal environment.

Because workstation and server populations are not strongly segmented, a compromised internal endpoint has a much larger opportunity to interact with the print server than it would in a least-privilege segmented architecture.

This is especially important for a print service because many ordinary endpoints may legitimately communicate with it, making the server a natural convergence point between user systems and infrastructure.

**What the attacker can reach AFTER exploitation:**

Successful PrintNightmare exploitation can provide SYSTEM-level control of `print-srv-01`.

From a privileged position on the print server, an attacker can attempt to:

- harvest credentials or authentication material;
- discover Active Directory systems;
- reach other Windows hosts;
- enumerate SMB and administrative services;
- interact with the EHR and billing server networks;
- probe backup infrastructure;
- locate PACS and clinical systems;
- move toward domain infrastructure.

The flat network does not guarantee successful lateral movement, but it removes many network-level restrictions that would otherwise prevent the print server from initiating communication with unrelated security zones.

**Effective Risk:** **Critical in MedDefense's environment.**

Although the scan CVSS Base score is 8.8 High, successful SYSTEM-level compromise of a shared infrastructure server inside a flat healthcare network gives the attacker a strong lateral-movement platform.

The environmental risk is therefore higher than the base score alone suggests.

### Scenario B — Hypothetical Segmented Network

**Who can reach this vulnerability:**

In a segmented environment, the print server would reside in a dedicated infrastructure or print-services VLAN.

Client VLANs would be permitted to access only the specific printing protocols required for operation.

Administrative interfaces and unnecessary SMB/RPC traffic would be restricted to approved management systems.

Clinical-device VLANs, database servers, backup management networks, and domain-controller management interfaces would not accept arbitrary traffic from the print-server zone.

**What the attacker can reach AFTER exploitation:**

An attacker controlling `print-srv-01` would still control the print service and could affect local printing operations.

However, lateral movement would be constrained by inter-VLAN firewall policy.

Access to the EHR, PACS, medical devices, backup infrastructure, or domain-controller administrative services would require a separately authorized network path or another successful pivot.

**Effective Risk:** **High.**

The vulnerability remains serious because SYSTEM-level execution on a production server is significant, but the compromise would be more likely to remain a print-services incident rather than immediately becoming an enterprise-wide lateral-movement opportunity.

### Risk Amplification Factor

**Very High.**

The flat network increases both the number of systems that can interact with the vulnerable print service and the number of systems the attacker can target after compromise.

Segmentation changes the attack from:

`endpoint → vulnerable print server → broad internal network`

to a more restricted model:

`authorized endpoint → print server VLAN → firewall-controlled destinations`

This significantly reduces blast radius even though the underlying CVE still exists.

---

## 3. CVE-2017-0144 — EternalBlue / MS17-010

**CVE:** CVE-2017-0144

**Finding:** 004

**Host:** `WS-RAD-01 — 10.10.1.70`

**System Role:** Windows XP Embedded MRI controller associated with the Siemens MAGNETOM imaging environment.

**CVSS Base Score:** **8.1 — High**

The scan identifies SMB port `445/tcp` as open on this legacy medical-device workstation and associates the system with CVE-2017-0144.

The earlier technical-vector analysis also records ports `135`, `139`, and `445` on this system and places it on the general workstation network rather than in an isolated medical-device security zone.

### Scenario A — Current Flat Network

**Who can reach this vulnerability:**

Systems across the broadly connected internal environment may be able to reach the MRI controller's SMB service because the device is located on the general workstation network without a dedicated isolation boundary.

A compromised nurse workstation, reception workstation, administrative endpoint, or other internal system therefore has a potential network path toward the vulnerable medical-device controller.

This is particularly concerning because EternalBlue is remotely exploitable over SMB and has mature public exploitation tooling.

**What the attacker can reach AFTER exploitation:**

Successful exploitation gives the attacker control of a system directly associated with a clinical imaging workflow.

From the compromised MRI controller, the attacker can attempt to discover or communicate with:

- PACS infrastructure;
- radiology workstations;
- ordinary workstations;
- Windows servers;
- Active Directory services;
- EHR-related systems;
- other reachable medical devices.

The attacker may also disrupt the MRI workflow directly.

Because the controller participates in clinical imaging, compromise can affect not only confidentiality but also availability of patient-care services.

The 1x01 Radiology kill chain already demonstrates why movement from a radiology endpoint toward PACS is particularly important: PACS compromise can interrupt imaging availability and increase ransomware/extortion impact.

**Effective Risk:** **Critical.**

The base vulnerability is High, but MedDefense's architecture places an unsupported medical-device workstation with remotely exploitable SMB exposure inside a broadly reachable network.

The combination of legacy software, clinical importance, remote exploitability, and lack of segmentation raises the real-world environmental risk beyond the CVSS Base score alone.

### Scenario B — Hypothetical Segmented Network

**Who can reach this vulnerability:**

The MRI controller would be placed in a dedicated medical-imaging VLAN.

Firewall policy would allow only the minimum required communication between:

- the MRI controller;
- approved radiology management systems;
- PACS;
- specifically required support services.

General office workstations, reception endpoints, billing systems, unrelated servers, and other medical-device groups would not be permitted to initiate SMB connections to the controller.

**What the attacker can reach AFTER exploitation:**

If EternalBlue were still successfully exploited, the attacker would initially control the MRI controller and systems explicitly reachable inside the imaging zone.

The attacker could still threaten the MRI workflow and possibly PACS if required clinical flows permit communication between them.

However, movement toward:

- domain controllers;
- billing systems;
- backup management;
- unrelated workstations;
- EHR databases;
- other medical-device VLANs

would require crossing a firewall-controlled boundary or exploiting another permitted path.

**Effective Risk:** **High.**

The vulnerability would still require urgent remediation or compensating controls because the legacy MRI controller remains clinically important. However, segmentation would greatly reduce the probability that compromise of one medical device becomes an organization-wide incident.

### Risk Amplification Factor

**Very High.**

This CVE illustrates the strongest architectural amplification in the set.

In the current environment, a remotely exploitable vulnerability on a legacy clinical device can become both:

1. a patient-care availability problem; and
2. a lateral-movement foothold into unrelated infrastructure.

A dedicated medical-device VLAN would not make EternalBlue safe, but it would reduce the number of systems able to attack the controller and drastically limit the number of destinations available after compromise.

---

## Comparative Segmentation Impact

| CVE | Host | Base Severity | Effective Risk — Flat | Effective Risk — Segmented | Amplification |
|---|---|---|---|---|---|
| CVE-2021-44790 | `billing-srv-01` | Critical 9.8 | **Critical / Enterprise-wide pivot potential** | **High–Critical / Billing-zone impact** | **Very High** |
| CVE-2021-34527 | `print-srv-01` | High 8.8 | **Critical / Privileged lateral-movement platform** | **High / Print-services zone impact** | **Very High** |
| CVE-2017-0144 | `WS-RAD-01` | High 8.1 | **Critical / Clinical plus lateral-movement risk** | **High / Imaging-zone impact** | **Very High** |

---

## Network Posture Summary

MedDefense's flat `10.10.0.0/16` architecture acts as a risk multiplier across the entire vulnerability scan because it increases both **pre-exploitation reachability** and **post-exploitation blast radius**. A vulnerability that should belong to one business or clinical security zone can instead become a stepping stone toward unrelated assets such as Active Directory, the EHR, PACS, backup infrastructure, user workstations, and medical devices. Patching individual CVEs remains essential, particularly remotely exploitable and weaponized vulnerabilities, but patching removes only one attack path at a time. Effective segmentation changes the security properties of many findings simultaneously: it limits which systems can reach vulnerable services, constrains lateral movement after compromise, separates clinical and administrative trust zones, and forces attackers to cross monitored firewall boundaries before expanding their access. For that reason, segmentation can provide a broader reduction in aggregate organizational risk than remediation of any single CVE. It does not replace vulnerability management; instead, it prevents one missed, delayed, unsupported, or newly disclosed vulnerability from turning a single-host compromise into an enterprise-wide incident.

## References

- [1x00 Asset Registry](../1x00_first_watch/7-asset_registry.md)
- [1x00 Gap Analysis](../1x00_first_watch/12-gap_analysis.md)
- [1x01 Threat Actor Matrix](../1x01_know_your_enemy/6-threat_actor_matrix.md)
- [1x01 Kill Chains](../1x01_know_your_enemy/10-kill_chains.md)
- [1x02 First Impressions](0-first_impressions.md)
- [1x02 CVE Ecosystem Research](1-cve_ecosystem.md)
- [1x02 Exploit Hunt](4-exploit_hunt.md)
- [1x02 Misconfiguration Analysis](6-misconfiguration_analysis.md)
- MedDefense Vulnerability Scan Report — supplied project scan artifact
