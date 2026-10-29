# Task 5 — The Risk Equation

**Organization:** MedDefense Health Systems  
**Project:** 1x03 — Defense Blueprint  
**Deliverable:** `5-risk_equation.md`  
**Assessment date:** 29 October 2026  
**Status:** Scenario-based quantitative risk estimates; not audited financial forecasts.

## Methodology

This assessment uses the five scenarios supplied in DLH's `risk-scenarios.txt`, together with MedDefense's previous threat and vulnerability assessments.

- **Asset Value (AV):** The monetary value or clearly defined financial exposure associated with an asset.
- **Exposure Factor (EF):** The proportion of AV lost in one incident, expressed between 0 and 1.
- **Single Loss Expectancy (SLE):** `AV × EF`.
- **Annualized Rate of Occurrence (ARO):** Expected number of incidents per year.
- **Annualized Loss Expectancy (ALE):** `SLE × ARO`.

The scenario values are planning estimates. They must not be treated as verified incident frequencies or automatically added together when incidents have overlapping consequences.

## Scenario 1 — Ransomware on the Billing Server

**Asset:** `billing-srv-01`  
**Threat:** Ransomware causing prolonged billing disruption.  
**Threat evidence:** Findings 001 and 002 provide plausible entry and privilege-escalation paths. The scenario is related to KC1-style ransomware activity, although the billing server is not an explicitly documented KC1 step.

### Input Data

| Input | Value |
|---|---:|
| Annual billing transactions | $4,200,000 |
| Downtime | 18 days |
| Daily loss | $16,000 |
| Recovery cost | $85,000 |
| Assumed fine | $100,000 |
| Occurrence frequency | Once every 3–4 years |

### Calculations

**1. Asset Value (AV)**

Use a defined financial-exposure proxy:

AV = $4,200,000 + $85,000 + $100,000

**AV = $4,385,000**

This is not the physical replacement value of the server and does not imply that all annual transactions are permanently lost.

**2. Exposure Factor (EF)**

Downtime loss = 18 × $16,000 = $288,000

Total event loss = $288,000 + $85,000 + $100,000 = $473,000

EF = $473,000 / $4,385,000 = 0.10786773

**EF = 10.79%**

**3. Single Loss Expectancy (SLE)**

SLE = $4,385,000 × 0.10786773

**SLE = $473,000 per incident**

**4. Annualized Rate of Occurrence (ARO)**

Midpoint recurrence interval = (3 + 4) / 2 = 3.5 years

ARO = 1 / 3.5

**ARO = 0.285714 incidents/year**

Range: 0.25–0.333333 incidents/year.

**5. Annualized Loss Expectancy (ALE)**

ALE = $473,000 × (1 / 3.5)

**ALE = $135,143/year**

At the minimum and maximum estimated ARO, annualized loss ranges from $118,250 to approximately $157,667.

**6. Confidence: Medium**

The input costs and recurrence interval are explicitly supplied, but MedDefense's actual loss history is not verified.

**Most sensitive assumption:** Whether the $288,000 of billing disruption represents permanently lost revenue or payments collected after recovery.

If that amount is eventually recovered, SLE falls to $185,000 and ALE to approximately $52,857/year.

The assumed fine is also conditional.

**Recommended response:** Patch and isolate the billing service, validate backup restoration, and reassess actual downtime and residual occurrence frequency.

## Scenario 2 — Patient Data Breach via EHR

**Asset:** EHR application, EHR database and protected patient records.  
**Threat:** Unauthorized disclosure or exfiltration of patient information.  
**Threat evidence:** Finding 003 (broad PostgreSQL access), Finding 031 (exposed Tomcat AJP requiring CVE verification), GAP-017 and KC5 (vendor-channel compromise leading to EHR access).

### Input Data

| Input | Value |
|---|---:|
| Patient records | 50,000 |
| Cost per exposed record | $165 |
| Additional notification/monitoring | $25,000 |
| Estimated litigation | $200,000 |
| Two-year projected revenue loss | $600,000 |
| Frequency | Once every 3 years |

### Calculations

**1. Asset Value (AV)**

Record exposure = 50,000 × $165 = $8,250,000

Additional costs = $25,000 + $200,000 + $600,000 = $825,000

AV = $8,250,000 + $825,000

**AV = $9,075,000**

This is a gross-additive financial exposure pool, not the replacement cost of the EHR system.

**Important:** The $165-per-record metric already includes some notification, legal and lost-business costs, so the additional $825,000 may partly double-count losses.

**2. Exposure Factor (EF)**

Assume an incident exposing all 50,000 records and incurring every stated cost.

**EF = 100% = 1.00**

This means 100% of the modeled financial-exposure pool, not that every EHR breach necessarily affects all patients.

**3. Single Loss Expectancy (SLE)**

SLE = $9,075,000 × 1.00

**SLE = $9,075,000**

**4. Annualized Rate of Occurrence (ARO)**

ARO = 1 / 3

**ARO = 0.333333 incidents/year**

The scenario also cites 1,247 sector breaches in 24 months across 6,000 hospitals, equivalent to about 0.104 reported incidents per hospital-year. Those events may have different severity and cannot independently verify a full-record breach frequency of 0.333333.

**5. Annualized Loss Expectancy (ALE)**

ALE = $9,075,000 × (1 / 3)

**ALE = $3,025,000/year**

**6. Confidence: Low**

The number of exposed records, actual occurrence rate and possible cost overlap have not been validated for MedDefense.

**Most sensitive assumption:** Whether all 50,000 records are exposed.

For example, a breach affecting 10,000 records, with the $825,000 extras unchanged, would have:

SLE = (10,000 × $165) + $825,000 = $2,475,000

ALE = $2,475,000 / 3 = $825,000/year.

**Alternative without potentially duplicative extras:**

SLE = 50,000 × $165 = $8,250,000

ALE = $8,250,000 / 3 = $2,750,000/year.

**Recommended response:** Restrict EHR database access, validate AJP configuration, monitor exports and implement least-privilege controls.

## Scenario 3 — Negligent Insider Disclosure

**Asset:** Patient data accessible through approximately 280 clinical workstations.  
**Threat:** Employee or contractor negligence resulting in unauthorized disclosure.  
**Threat evidence:** GAP-017 (bulk patient-record export controls), weaknesses in security awareness and individual accountability.

### Input Data

| Input | Value |
|---|---:|
| Investigation | $30,000 |
| Containment | $25,000 |
| Remediation | $40,000 |
| Reporting | $25,000 |
| Expected negligent incidents | 2–3 per year |
| Workforce | 2,000 employees |

### Calculations

**1. Asset Value (AV)**

Define AV as the modeled average-event consequence pool.

AV = $30,000 + $25,000 + $40,000 + $25,000

**AV = $120,000**

This is not the value of MedDefense's entire patient database.

**2. Exposure Factor (EF)**

A representative event consumes the defined average-event loss pool.

**EF = 100% = 1.00**

**3. Single Loss Expectancy (SLE)**

SLE = $120,000 × 1.00

**SLE = $120,000**

**4. Annualized Rate of Occurrence (ARO)**

ARO = (2 + 3) / 2

**ARO = 2.5 incidents/year**

The provided 60% negligence share must not be applied again because the supplied rate already concerns negligent incidents.

An ARO greater than 1 is valid when multiple incidents are expected each year.

**5. Annualized Loss Expectancy (ALE)**

ALE = $120,000 × 2.5

**ALE = $300,000/year**

Range: $240,000–$360,000/year.

**6. Confidence: Medium**

The incident cost components are itemized, but there is no verified MedDefense incident-history dataset.

**Most sensitive assumption:** True incident frequency and reporting completeness.

At an ARO of 0.5, ALE would fall to $60,000/year.

**Recommended response:** Introduce approved patient-data export restrictions, access accountability, targeted training and consistent incident reporting.

## Scenario 4 — BD Alaris Infusion-Pump Compromise

**Asset:** Seven BD Alaris infusion pumps.  
**Threat:** Unauthorized management access, disruption or manipulation affecting clinical care.  
**Threat evidence:** Finding 010 and KC4.

The reported default management credentials warrant remediation. However, applicability of the specific firmware CVE must be verified with BD; the scanner's version-based claim is contested.

Model temporary disruption and patient-safety consequences separately.

### Scenario 4A — Temporary Denial of Service

**Given:** Seven pumps valued at $15,000 each, five days of downtime at $20,000/day, and an estimated event once every 10 years.

**1. Asset Value (AV)**

Hardware value = 7 × $15,000 = $105,000

Service disruption = 5 × $20,000 = $100,000

AV = $105,000 + $100,000

**AV = $205,000**

This is a potential exposure pool, not an assumption that quarantined devices must be replaced.

**2. Exposure Factor (EF)**

Assume only service disruption is realized.

EF = $100,000 / $205,000

**EF = 48.78%**

**3. Single Loss Expectancy (SLE)**

SLE = $205,000 × ($100,000 / $205,000)

**SLE = $100,000**

**4. Annualized Rate of Occurrence (ARO)**

ARO = 1 / 10

**ARO = 0.10**

**5. Annualized Loss Expectancy (ALE)**

ALE = $100,000 × 0.10

**ALE = $10,000/year**

**6. Confidence: Low**

**Most sensitive assumption:** Downtime and actual clinical fallback cost.

A one-day interruption at $20,000/day would yield an ALE of $2,000/year instead.

### Scenario 4B — Patient-Safety Incident

**Given:** Liability between $500,000 and $5,000,000; $150,000 investigation; $100,000 potential downtime; recurrence once every 50 years.

**1. Asset Value (AV)**

Define the maximum modeled exposure pool:

AV = $5,000,000 + $150,000 + $100,000

**AV = $5,250,000**

The physical pump fleet value is excluded because destruction of the equipment is not specified.

**2. Exposure Factor (EF)**

Illustrative midpoint liability:

($500,000 + $5,000,000) / 2 = $2,750,000

Midpoint event loss:

$2,750,000 + $150,000 + $100,000 = $3,000,000

EF = $3,000,000 / $5,250,000

**EF = 57.14%**

The liability midpoint is a teaching assumption, not a statistically established mean.

**3. Single Loss Expectancy (SLE)**

SLE = $5,250,000 × ($3,000,000 / $5,250,000)

**SLE = $3,000,000**

**4. Annualized Rate of Occurrence (ARO)**

ARO = 1 / 50

**ARO = 0.02**

**5. Annualized Loss Expectancy (ALE)**

ALE = $3,000,000 × 0.02

**ALE = $60,000/year**

Using the low and high liability endpoints produces approximately $15,000–$105,000/year.

**6. Confidence: Low**

**Most sensitive assumption:** Rare-event occurrence rate and liability severity.

If ARO doubles from 0.02 to 0.04, ALE becomes $120,000/year.

### Combined Scenario 4 Planning Estimate

Assuming DoS-only and patient-safety incidents are mutually exclusive event classes:

$10,000 + $60,000 = **$70,000/year**

This sum is conditional. If an event belongs to both categories, overlapping losses must be removed.

**Recommended response:** Replace default credentials through approved clinical procedures, restrict management interfaces, consult Biomedical Engineering and the vendor, and validate patient-care continuity. Patient safety cannot be reduced to ALE alone.

## Scenario 5 — FortiGate VPN to Full Network Compromise

**Asset:** FortiGate VPN, Active Directory, EHR, billing infrastructure and connected systems.  
**Threat:** External attacker gains VPN access and progresses to a compound ransomware/data-theft campaign.  
**Threat evidence:** KC1 (VPN → AD → ransomware), broad internal trust boundaries, and EHR/billing exposures.

No specific FortiGate CVE is assumed confirmed without firmware and configuration evidence.

### Input Data

The scenario combines the consequences of Scenarios 1 and 2 and specifies:

**ARO = 0.30 VPN compromise events/year**

The supplied 38% sector initial-access statistic is not itself a per-year compromise probability for MedDefense.

### Calculations

**1. Asset Value (AV)**

Use the combined scenario-defined financial-exposure pools.

AV = Scenario 1 AV + Scenario 2 AV

AV = $4,385,000 + $9,075,000

**AV = $13,460,000**

This is a combined financial exposure proxy, not the physical replacement cost of the whole network.

**2. Exposure Factor (EF)**

Combined single-event loss:

Scenario 1 SLE + Scenario 2 SLE

$473,000 + $9,075,000 = $9,548,000

EF = $9,548,000 / $13,460,000

**EF = 70.94%**

This assumes both full EHR exfiltration and billing ransomware follow the same VPN compromise.

**3. Single Loss Expectancy (SLE)**

SLE = $13,460,000 × ($9,548,000 / $13,460,000)

**SLE = $9,548,000**

**4. Annualized Rate of Occurrence (ARO)**

Scenario-provided VPN compromise frequency:

**ARO = 0.30 events/year**

This is not proof that every VPN compromise develops into a complete network attack.

**5. Annualized Loss Expectancy (ALE)**

For the task's full-chain teaching assumption:

ALE = $9,548,000 × 0.30

**ALE = $2,864,400/year**

A more realistic conditional model introduces:

q = Probability of full combined campaign given a VPN compromise.

Then:

ALE = $2,864,400 × q

Illustrative outcomes:

| Conditional progression q | Adjusted ALE |
|---|---:|
| 25% | $716,100 |
| 50% | $1,432,200 |
| 100% | $2,864,400 |

These progression probabilities are hypothetical, not measured.

**6. Confidence: Low**

**Most sensitive assumption:** Probability that an initial VPN compromise leads to both billing ransomware and full EHR disclosure.

If that progression probability is substantially below 100%, the full-campaign ALE falls accordingly.

**Recommended response:** Verify VPN configuration and MFA, patch validated weaknesses, segment the network and test whether a VPN foothold can actually reach AD, EHR and backup assets.

**Double-counting warning:** Scenario 5 reuses the losses from Scenarios 1 and 2. Its ALE must not be added to their ALEs as though it represented an independent risk.

## Consolidated Scorecard

| Scenario | AV | EF | SLE | ARO | ALE/year | Confidence |
|---|---:|---:|---:|---:|---:|---|
| 1. Billing ransomware | $4,385,000 | 10.79% | $473,000 | 0.285714 | **$135,143** | Medium |
| 2. Full EHR breach | $9,075,000 | 100% | $9,075,000 | 0.333333 | **$3,025,000** | Low |
| 3. Negligent insider | $120,000 | 100% | $120,000 | 2.5 | **$300,000** | Medium |
| 4A. Pump DoS | $205,000 | 48.78% | $100,000 | 0.10 | **$10,000** | Low |
| 4B. Pump safety incident | $5,250,000 | 57.14% | $3,000,000 | 0.02 | **$60,000** | Low |
| 4. Combined conditional | — | — | Separate classes | — | **$70,000** | Low |
| 5. VPN compound campaign | $13,460,000 | 70.94% | $9,548,000 | 0.30 | **$2,864,400** | Low |

## Validation and Budget Implications

These ALEs are decision-support estimates, not verified financial losses.

Before approving security investments, MedDefense should:

1. Validate real billing disruption and recovery costs with Finance.
2. Verify realistic EHR breach size and eliminate duplicated legal and notification costs.
3. Establish a historical baseline for negligent insider events.
4. Validate infusion-pump clinical risk through Biomedical Engineering and vendor-approved procedures.
5. Test VPN compromise pathways, MFA enforcement and segmentation.
6. Measure residual risk before and after each proposed security control.

The **$120,000 budget ceiling** applies to the entire six-month Defense Blueprint.

Any future cost-benefit proposal should use:

**Annual Risk Reduction = ALE before control − ALE after control**

A control is not assumed implemented merely because it has been recommended. Clinical safety and legal obligations remain mandatory regardless of the modeled ALE.

## Evidence References

- DLH: `risk-scenarios.txt`, Scenarios 1–5.
- 1x01: `10-kill_chains.md`.
- 1x02: `17-cvss_contextualizer.md`.
- 1x03: `3-gap_framework_bridge.md`.
- 1x03: `4-governance_architecture.md`.
