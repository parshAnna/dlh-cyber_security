# MedDefense Health Systems — Prioritized Threat Assessment

Prepared for: James Chen, Deputy CISO

Prepared by: Junior Security Analyst

Scope: Definitive Top 5 threat ranking based on the completed MedDefense actor, vector, surface, kill-chain, STRIDE, scenario and gap-correlation work. This is a planning assessment, not evidence that a named actor is currently targeting MedDefense.

## Decision Basis

Likelihood follows the qualitative next-12-month scale defined in the [Threat Actor Matrix](6-threat_actor_matrix.md). Sector figures come from the supplied [Threat Landscape Summary](0-threat_landscape_summary.md) and [Ransomware Assessment](2-ransomware_assessment.md); they describe selected historical reporting populations and are not MedDefense-specific probabilities. Impact follows the First Watch [Asset Criticality Assessment](../1x00_first_watch/8-criticality_assessment.md). Operational evidence comes from the [Kill Chains](10-kill_chains.md), [EHR STRIDE model](11-stride_ehr.md) and [Threat Scenarios](14-threat_scenarios.md). The [Gap–Threat Correlation](15-gap_threat_correlation.md) supplies cross-path leverage: GAP-016 and GAP-011 each appear in six of eight selected paths, and GAP-017 appears in four.

Overall Priority is a qualitative composite of likelihood, impact, observed local evidence and the number of credible routes—not a numeric multiplication. A conditional entry route is not treated as a confirmed vulnerability. Effort estimates mean **Quick Win: up to 2 weeks**, **Short-term: within one quarter**, and **Long-term: beyond one quarter**, subject to clinical change approval and vendor availability.

| Rank | Threat | Likelihood | Impact | Overall Priority | Key Gap |
|---:|---|---|---|---|---|
| 1 | Enterprise ransomware with theft, recovery destruction and encryption | High | Critical | **Critical** | GAP-016 |
| 2 | Unsafe privileged change corrupts medication information | High | Critical | **Critical** | GAP-002 |
| 3 | Automated compromise of billing becomes a persistent foothold | High | High | **High** | GAP-008 |
| 4 | Malicious insider exports EHR records through legitimate access | Medium | Critical | **High** | GAP-017 |
| 5 | Compromised MedTech identity reaches and alters the EHR | Low | Critical | **High — impact-driven** | GAP-011 |

## Rank 1 — Enterprise Ransomware and Double Extortion

```text
Rank: 1
Threat: A ransomware affiliate enters remotely, steals EHR data, reaches identity and recovery systems, then encrypts hospital services for double extortion.
Actor Type: Ransomware Groups (Organized Crime), including a BlackReef-style RaaS affiliate from T2/T6.
Primary Vector: VPN compromise — exploitation of a usable exposed edge flaw or brokered valid VPN access; spearphishing remains a close alternative.
Primary Target: EHR database ehr-db-01 A-037 / logical store A-112; AD and NAS-01 are enabling targets for deployment and recovery inhibition.
Likelihood: High — the supplied sector evidence assigns 25% of reported critical-infrastructure ransomware incidents to healthcare and describes public-facing exploitation, phishing and valid credentials as 38%, 31% and 22% of healthcare ransomware entry. Central's 350 beds match the dossier's attractive 100–500-bed profile; MedDefense already had a four-day ransomware-related claims outage, and the exercise reports three nearby hospital attacks in eight months. No current BlackReef targeting or vulnerable FortiGate build is established.
Impact: Critical — A-037/A-112 is First Watch's #1 Critical asset with Critical confidentiality, integrity and availability. EHR loss has already forced a nine-hour paper workflow, while theft and reachable recovery destruction can add privacy harm and prolonged clinical downtime that restoration alone cannot reverse.
Overall Priority: Critical — this combines the strongest actor/sector fit, a credible remote-access chain and simultaneous clinical, recovery and disclosure consequences.
Key Gap: GAP-016 — broad and unverified VPN, intersite and internal trust boundaries let one foothold discover and reach AD, EHR and recovery infrastructure.
Recommended Action: Short-term (6–12 weeks) — replace C-002's ALL-service VPN access with tested allowlists for named sources, destinations and protocols, beginning with separate AD, EHR and backup management paths and denying every unapproved east-west flow.
```

**Why rank first:** T6 already ranks ransomware first, T10 KC1 and T14 S1 provide complete operational paths, and T15 shows that closing GAP-016 can interrupt six of eight selected paths. Public-service exploitation remains conditional, but the actor's High likelihood and Critical multi-system consequence do not depend on proving one specific CVE.

## Rank 2 — Negligent Clinical Change Causes Medication Integrity Failure

```text
Rank: 2
Threat: An authorized administrator deploys an inadequately reviewed pharmacy change that silently corrupts medication-dosage information across all three sites.
Actor Type: Insider (Negligent) from T6; “actor” here means harmful authorized action without malicious intent.
Primary Vector: Legitimate privileged maintenance access abused unintentionally through an untested script, weak approval and missing validated rollback.
Primary Target: Pharmacy management system A-093.
Likelihood: High — the supplied dossier reports roughly 35% of healthcare breaches involving insiders with negligence the larger 60% share, while MedDefense documents shared sessions, shadow storage, plaintext administrative credentials and incomplete training. More importantly, Incident C already demonstrates the exact local failure mode: a script presented incorrect dosage values for six hours before manual discovery.
Impact: Critical — A-093 is First Watch's #2 Critical asset and serves medication information at all three sites. Incorrect values can influence treatment even while the application appears available, making integrity loss and the resulting loss of trusted availability direct patient-safety concerns.
Overall Priority: Critical — High local recurrence plausibility plus direct clinical-integrity consequence places this above technically sophisticated but less likely targeted attacks.
Key Gap: GAP-002 — pharmacy dosage changes lack systematic validation and tested service recovery.
Recommended Action: Short-term (4–8 weeks) — institute one mandatory pharmacy production-change gate requiring peer approval, representative test results, automated comparison to an approved dosage source and a demonstrated rollback before deployment.
```

**Why rank second:** T6 ranks negligent insiders second, and T10 KC2 shows that no malware or stolen account is necessary. The existing C-044 manual comparison deserves credit, but it detected the prior error only after unsafe data had been available for six hours.

## Rank 3 — Opportunistic Billing Compromise Becomes a Foothold

```text
Rank: 3
Threat: Automated exploitation or credential abuse compromises billing-srv-01 for mining or resale, leaving a persistent internal foothold from which a stronger actor can enumerate critical systems.
Actor Type: Unskilled/Opportunistic Attacker from T6.
Primary Vector: Automated testing of a known flaw or reusable credential against a reachable service; the actual billing-miner entry route and Internet exposure remain unverified.
Primary Target: billing-srv-01 A-039, Billing MySQL A-113 and billing application A-123.
Likelihood: High — T0 describes Internet-wide scanning and credential stuffing, and T1 reports a similar mining pattern across more than 300 organizations. MedDefense has direct evidence of a mining-configured process and recurring performance symptoms on billing-srv-01, so exposure is not based only on sector analogy; attribution, exploitability and initial access remain unknown.
Impact: High — First Watch rates Billing G3 High across confidentiality, integrity and availability. A prior incident stopped claims processing for four days and current mining affects performance; Critical escalation is possible through the flat network, but no confirmed EHR pivot or patient-care interruption is claimed.
Overall Priority: High — confirmed local compromise indicators and High exposure likelihood outweigh the target's lower intrinsic criticality relative to EHR or pharmacy.
Key Gap: GAP-008 — mining activity is treated as a capacity problem rather than a compromise requiring containment, eradication and root-cause analysis.
Recommended Action: Quick Win (up to 2 weeks) — place billing-srv-01 into formal incident containment, preserve forensic evidence, rebuild it from known-good media, rotate its application/service credentials and return it only with documented billing flows allowed.
```

**Why rank third:** T6 places opportunistic attackers third because automated campaigns do not need to select MedDefense deliberately, and the miner supplies the strongest current local compromise evidence. The ranking does not assume Apache 2.4.29 was the entry point or that the operator was low-skilled.

## Rank 4 — Malicious Insider Exfiltrates Patient Records

```text
Rank: 4
Threat: A workforce member uses legitimate EHR permissions and the built-in export function to collect patient records gradually and remove them through unmanaged storage.
Actor Type: Insider (Malicious) from T6, using T3's deliberate unauthorized-record-access profile and T14 S2's paced exfiltration path.
Primary Vector: Legitimate EHR account abuse followed by built-in export and removable-media transfer; no exploit or privilege escalation is required.
Primary Target: EHR database ehr-db-01 A-037 / logical store A-112 through EHR application A-111.
Likelihood: Medium — the supplied dossier reports roughly 35% of healthcare breaches involving insiders and a 60/40 negligent/malicious split. T3 documents deliberate patient-record snooping at MedDefense, but organized bulk theft is modeled rather than observed; valid access, delayed C-037 audit export and no demonstrated volume alert keep the path credible.
Impact: Critical — the EHR database is the #1 Critical asset and contains Restricted clinical information. Disclosure can affect patient privacy, regulatory response and trust, and unlike availability loss it cannot be undone by restoring a backup.
Overall Priority: High — lower likelihood than opportunistic exposure is offset by direct access to the highest-value data and an exfiltration path that can resemble normal work.
Key Gap: GAP-017 — bulk export lacks documented authorization, cumulative-volume limits and timely detection; it is the only gap used by all three T14 scenarios.
Recommended Action: Short-term (4–8 weeks) — configure one EHR export-control workflow that requires secondary approval above a clinically agreed threshold and alerts on cumulative per-user record volume across sessions using near-real-time A-119 events.
```

**Why rank fourth:** T14 S2 shows a complete no-exploit route from authorized access to USB removal, and T15 raises GAP-017 to Critical. It remains below Rank 3 because T6 rates malicious-insider likelihood Medium and no bulk-theft event is established locally.

## Rank 5 — Compromised Vendor Access Alters the EHR

```text
Rank: 5
Threat: A capable external actor compromises a MedTech maintenance identity, enters through the trusted support channel and modifies EHR code or uses application-held access to collect records.
Actor Type: Nation-State APT from T6, operating through a compromised MedTech Solutions account or service environment.
Primary Vector: Compromised vendor maintenance identity and authorized third-party access pathway to ehr-srv-01; direct vendor database/root privilege is not assumed.
Primary Target: EHR application A-111 on ehr-srv-01 A-036, with the EHR database A-037/A-112 as the ultimate intelligence target.
Likelihood: Low — T6 finds no institutional research program, trial repository or strategic partnership that would make MedDefense an obvious state target. The MedTech maintenance relationship is real, however, and its transport, individual identity, MFA, approval window and effective privilege are undocumented, creating a credible conditional route.
Impact: Critical — the EHR database is First Watch's #1 Critical asset, and T11 identifies application tampering as the greatest EHR STRIDE risk because false clinical information may appear trustworthy. Covert collection, record alteration or containment-driven outage can affect confidentiality, integrity and availability for the clinical record service.
Overall Priority: High — impact-driven: targeted likelihood is Low, but a trusted path to silent clinical-integrity failure warrants Top 5 treatment because ordinary perimeter controls may not distinguish it from support activity.
Key Gap: GAP-011 — named vendor identity, strong MFA, lifecycle control and time-limited individual accountability are not demonstrated.
Recommended Action: Short-term (6–12 weeks) — route every MedTech maintenance session through a ticket-linked privileged-access gateway using named accounts, phishing-resistant MFA, time-limited approval and recorded sessions, with access closed automatically when the window expires.
```

**Why rank fifth:** T10 KC5 and T14 S3 establish a conditional but complete trusted-channel route. Nation-State APT remains below the higher-likelihood local threats; future research/pharmaceutical partnerships or confirmed vendor compromise would trigger immediate reassessment.

## Ranking Boundary

Hacktivism remains outside the Top 5 because T6 assesses targeted likelihood as Low, no current MedDefense controversy is documented and its most supported objectives—public defacement or DDoS—have less direct reach into the Critical clinical assets than the five threats above. The prior political homepage defacement still warrants portal monitoring and remediation; it is not sufficient to displace a threat with High likelihood or direct EHR/pharmacy impact.

## Strategic Recommendation

If MedDefense can fund only two initiatives next quarter, fund **(1) Least-Privilege Access Containment** to close GAP-016 and GAP-011 by replacing broad VPN/intersite rules with approved-flow allowlists and placing administrator/vendor access behind named, phishing-resistant-MFA, time-limited sessions, because those two gaps each appear in six of eight modeled paths and interrupt ransomware, insider and supplier movement near the beginning; and **(2) Clinical Data-Loss and Recovery Resilience** to close GAP-017 and reduce GAP-007 by adding near-real-time EHR export/behavior alerts plus an access-isolated immutable recovery copy with a full EHR restoration test, because it limits all three T14 data-theft scenarios and removes ransomware's strongest leverage after prevention fails. These two programs provide the broadest cross-threat reduction; the pharmacy production gate and billing incident containment remain concrete Rank 2/3 actions that should begin through existing operational authority rather than wait for a larger platform purchase.
