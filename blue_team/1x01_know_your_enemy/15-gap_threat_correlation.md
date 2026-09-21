# MedDefense Health Systems — Gap–Threat Correlation

Prepared for: James Chen, Deputy CISO

Prepared by: Junior Security Analyst

Scope: Threat-informed reassessment of all 23 gaps in the final First Watch [Gap Analysis](../1x00_first_watch/12-gap_analysis.md), including the Task 13 additions and later predecessor-review additions already incorporated there.

## Method and Interpretation

This assessment cross-references the six actor types in the [Threat Actor Matrix](6-threat_actor_matrix.md), the five selected [Kill Chains](10-kill_chains.md) and the three integrated [Threat Scenarios](14-threat_scenarios.md). Supporting exposure logic comes from the [Attack Surface Map](7-attack_surface_map.md) and [Technical Vector Assessment](8-technical_vectors.md). “Threat Actors” identifies actors with a plausible way to use the gap; it does not assert current targeting or successful exploitation.

Path frequency counts only a gap's explicit appearance in a T10 or T14 **Gaps Exploited** list, once per distinct path. The five kill chains contain 18 such references and the three scenarios contain 13, for 31 total path-to-gap connections. A zero means none of these eight deliberately selected paths depends explicitly on the gap—not that the gap is safe or unreachable. Original impact, evidence quality and existing controls remain part of the decision, so frequency informs risk rather than replacing judgment.

Updated levels use the existing Critical/High/Medium/Low scale. An upgrade requires materially stronger threat relevance, repeated path dependence or a newly demonstrated combination of high likelihood and severe impact. A downgrade requires both weak/conditional threat evidence and low path dependence; it does not close the gap. “Same” preserves the original level.

### Path Key

| ID | T10 kill chain or T14 scenario |
|---|---|
| KC1 | VPN Foothold to Domain-Wide Ransomware |
| KC2 | Unsafe Pharmacy Change to Dosage Integrity Failure |
| KC3 | Radiology Phish to PACS Extortion |
| KC4 | Privileged Insider Manipulation of Infusion Pumps |
| KC5 | Compromised MedTech Channel to EHR Records |
| S1 | Vendor Patch Lure to Hospital-Wide Extortion |
| S2 | The Quiet Export Before Departure |
| S3 | Trusted MedTech Update, Hidden EHR Collection |

## Full Gap Correlation

### GAP-001 — Infusion pumps lack device-specific detection and recovery

```text
Gap ID: GAP-001
Gap Description: The BD Alaris fleet lacks evidenced device-specific monitoring, safe isolation and tested configuration recovery.
Original Risk Level: Critical
Threat Actors: Insider (Malicious); Ransomware Groups (Organized Crime); Unskilled/Opportunistic Attacker after an internal foothold.
Kill Chains: KC4 — Privileged Insider Manipulation of Infusion Pumps.
Scenarios: None of the three T14 scenarios explicitly depends on this gap.
Updated Risk Level: Critical — Same
Justification: KC4 converts the gap into a direct integrity-and-availability path against bedside devices, while T8 shows reachable pump interfaces that an external foothold could discover. The absence of device-specific detection and recovery on a patient-safety asset already justified Critical; one explicit chain strengthens urgency without requiring an upgrade beyond Critical.
```

### GAP-002 — Pharmacy dosage changes lack validated recovery and systematic checking

```text
Gap ID: GAP-002
Gap Description: Pharmacy changes lack systematic dosage validation, independently reviewed deployment and tested service rollback.
Original Risk Level: Critical
Threat Actors: Insider (Negligent); Insider (Malicious).
Kill Chains: KC2 — Unsafe Pharmacy Change to Dosage Integrity Failure.
Scenarios: None of the three T14 scenarios explicitly depends on this gap.
Updated Risk Level: Critical — Same
Justification: KC2 demonstrates that legitimate administrative access and an unsafe change can corrupt dosage values without an external exploit. The prior six-hour error and potential patient-safety consequences keep this Critical even though C-044 provides partial manual detection.
```

### GAP-003 — PACS imaging has no documented recovery copy

```text
Gap ID: GAP-003
Gap Description: PACS is excluded from the documented backup scope and has no evidenced alternative recovery copy or tested restoration.
Original Risk Level: Critical
Threat Actors: Ransomware Groups (Organized Crime); Insider (Malicious).
Kill Chains: KC3 — Radiology Phish to PACS Extortion.
Scenarios: None of the three T14 scenarios explicitly depends on this gap.
Updated Risk Level: Critical — Same
Justification: KC3 shows how the highest-priority T6 actor can turn a Radiology phish into image theft and an unrecoverable imaging outage. The direct extortion value of absent recovery reinforces the existing Critical rating for a Top 5 clinical asset.
```

### GAP-004 — Central core-switch configuration and failover protection are unverified

```text
Gap ID: GAP-004
Gap Description: Core-switch monitoring, configuration backup, ownership and redundant failover are not evidenced.
Original Risk Level: Critical
Threat Actors: Insider (Malicious); Ransomware Groups (Organized Crime); Nation-State APT.
Kill Chains: None of the five selected T10 chains explicitly uses this gap.
Scenarios: None of the three T14 scenarios explicitly depends on this gap.
Updated Risk Level: Critical — Same
Justification: The eight paths emphasize hosts, identities and clinical applications rather than a direct core-management attack, but their lateral movement and service access all depend on network availability. Because A-087 is a Top 5 shared dependency with no core-specific detective or corrective evidence, scenario selection is not a sound reason to reduce the original Critical level.
```

### GAP-005 — Legacy MRI controller remains on the general workstation network

```text
Gap ID: GAP-005
Gap Description: An unpatchable Windows XP MRI controller exposes SMB/RPC services on the general workstation network without evidenced compensating isolation, monitoring or recovery.
Original Risk Level: Critical
Threat Actors: Ransomware Groups (Organized Crime); Unskilled/Opportunistic Attacker.
Kill Chains: None of the five selected T10 chains explicitly uses this gap.
Scenarios: None of the three T14 scenarios explicitly depends on this gap.
Updated Risk Level: Critical — Same
Justification: T8 identifies ransomware as the actor most likely to exploit unsupported systems after a foothold, and T7 confirms the controller's flat-network exposure and PACS dependency. Its absence from the selected paths reflects scenario scope, not reduced likelihood of legacy-host exploitation or reduced impact on approximately 45 daily MRI studies.
```

### GAP-006 — EHR database access is broader than the documented application need

```text
Gap ID: GAP-006
Gap Description: PostgreSQL 5432 and database access paths are broader than the validated EHR application relationship requires, with incomplete account/source review.
Original Risk Level: High
Threat Actors: Ransomware Groups (Organized Crime); Nation-State APT; Insider (Malicious); Unskilled/Opportunistic Attacker after a foothold.
Kill Chains: KC5 — Compromised MedTech Channel to EHR Records.
Scenarios: S1 — ransomware extortion; S3 — compromised MedTech update.
Updated Risk Level: Critical — Upgraded from High
Justification: Three independent paths use GAP-006 to move from a workstation, privileged identity or trusted vendor host toward MedDefense's #1 critical asset. T6 actors pursue the database for extortion, espionage and theft, while T11 shows both disclosure and privilege-escalation consequences. Existing local logs and backups remain credited, but they do not contain a successful database session or reverse disclosure.
```

### GAP-007 — Production and recovery copies share a failure domain

```text
Gap ID: GAP-007
Gap Description: Production and local recovery infrastructure share network and physical exposure, and full clinical restoration is not demonstrated.
Original Risk Level: High
Threat Actors: Ransomware Groups (Organized Crime); Insider (Malicious).
Kill Chains: KC1 — VPN Foothold to Domain-Wide Ransomware.
Scenarios: S1 — ransomware extortion.
Updated Risk Level: Critical — Upgraded from High
Justification: The highest-ranked T6 actor explicitly targets recovery, and both KC1 and S1 depend on reachable backups to maximize enterprise-wide extortion impact. C-022/C-023 still provide real local protection and are not relabeled absent; the upgrade reflects the likelihood that one privileged ransomware event can defeat both production and the only demonstrated recovery domain.
```

### GAP-008 — Billing mining activity is treated as a capacity problem

```text
Gap ID: GAP-008
Gap Description: Confirmed mining-configured activity on billing-srv-01 has been restarted around rather than investigated, contained and eradicated as a compromise.
Original Risk Level: High
Threat Actors: Unskilled/Opportunistic Attacker; Ransomware Groups (Organized Crime) acquiring or reusing the foothold.
Kill Chains: None of the five selected T10 chains explicitly uses this gap.
Scenarios: None of the three T14 scenarios explicitly depends on this gap.
Updated Risk Level: High — Same
Justification: T6 ranks opportunistic exposure third and T8 identifies this actor as the most likely vulnerable-software exploiter. The absence from the eight critical paths reflects their focus on higher-impact end targets; direct local compromise evidence and possible resale or pivot value prevent a downgrade, while the unproven entry route and unconfirmed clinical reach do not justify Critical.
```

### GAP-009 — Patient portal object-level authorization lacks closure evidence

```text
Gap ID: GAP-009
Gap Description: A prior cross-patient object-authorization failure has no supplied remediation and retest evidence.
Original Risk Level: High
Threat Actors: Hacktivist; Unskilled/Opportunistic Attacker; Ransomware Groups (Organized Crime) if the portal yields a usable foothold.
Kill Chains: None of the five selected T10 chains explicitly uses this gap.
Scenarios: None of the three T14 scenarios explicitly depends on this gap.
Updated Risk Level: High — Same
Justification: T6 identifies the portal as the Hacktivist's likely target, and opportunistic actors can test predictable object references at scale. No selected path relies on this authorization defect, but the prior disclosure evidence, Internet-facing surface and Restricted lab information sustain High; code execution or an internal pivot is not assumed.
```

### GAP-010 — Generic server-room access exposes critical hosted systems

```text
Gap ID: GAP-010
Gap Description: Overbroad badge access, a generic room credential and incomplete room monitoring expose co-located critical servers and recovery systems.
Original Risk Level: High
Threat Actors: Insider (Malicious); Unskilled/Opportunistic Attacker with obtained physical access.
Kill Chains: None of the five selected T10 chains explicitly uses this gap.
Scenarios: None of the three T14 scenarios explicitly depends on this gap.
Updated Risk Level: High — Same
Justification: The modeled paths are cyber-led, so they do not measure this physical route well. A malicious insider needs little technical sophistication to exploit legitimate or overbroad access, and the room contains several critical systems; partial entrance controls and the absence of a modeled physical chain keep the risk High rather than Critical.
```

### GAP-011 — Shared identities and limited MFA weaken clinical accountability

```text
Gap ID: GAP-011
Gap Description: Shared accounts, incomplete lifecycle assurance and limited MFA weaken individual attribution and permit reuse of privileged, clinical or vendor identities.
Original Risk Level: High
Threat Actors: Ransomware Groups (Organized Crime); Nation-State APT; Insider (Malicious); Insider (Negligent); Unskilled/Opportunistic Attacker using stolen credentials.
Kill Chains: KC1, KC3, KC4 and KC5.
Scenarios: S1 and S3.
Updated Risk Level: Critical — Upgraded from High
Justification: GAP-011 appears in six of eight paths—the joint-highest frequency—and supports VPN/domain takeover, PACS abuse, pump administration and trusted-vendor intrusion. It is reusable by four distinct intentional actor types while negligence sustains shared access. Because closing it can break several chains at or near initial access, its threat-informed priority is Critical.
```

### GAP-012 — Undocumented internal devices lack ownership and access review

```text
Gap ID: GAP-012
Gap Description: Unknown and shadow devices lack reliable ownership, managed-device admission, continuous inventory and retirement review.
Original Risk Level: High
Threat Actors: Unskilled/Opportunistic Attacker; Ransomware Groups (Organized Crime); Insider (Negligent); Insider (Malicious).
Kill Chains: None of the five selected T10 chains explicitly uses this gap.
Scenarios: None of the three T14 scenarios explicitly depends on this gap.
Updated Risk Level: High — Same
Justification: T6 directly links opportunistic exposure to unmanaged-device oversight, while T8 shows that shadow endpoints can introduce malware or storage inside broad network paths. No selected path requires an unknown device, so there is insufficient new evidence for Critical; persistent ownership and control uncertainty prevents a downgrade.
```

### GAP-013 — Departmental cloud and file data lack validated recovery scope

```text
Gap ID: GAP-013
Gap Description: O365, Westside and departmental/HR recovery responsibilities and restoration coverage are incomplete or unverified.
Original Risk Level: High
Threat Actors: Ransomware Groups (Organized Crime); Insider (Malicious); Insider (Negligent).
Kill Chains: None of the five selected T10 chains explicitly uses this gap.
Scenarios: None of the three T14 scenarios explicitly depends on this gap.
Updated Risk Level: High — Same
Justification: Ransomware and deliberate or accidental deletion can affect cloud and file data even though the selected paths concentrate on clinical EHR/PACS recovery. Existing file-server backup provides partial protection, but excluded or unmapped repositories retain significant operational and confidentiality exposure, supporting High without new evidence for Critical.
```

### GAP-014 — Security training does not reach clinical staff consistently

```text
Gap ID: GAP-014
Gap Description: Training is incomplete and lacks role-specific phishing, patient-data and clinical-workflow content, despite tracked completion.
Original Risk Level: Medium
Threat Actors: Ransomware Groups (Organized Crime); Nation-State APT; Unskilled/Opportunistic Attacker; Insider (Negligent).
Kill Chains: KC3 — Radiology Phish to PACS Extortion.
Scenarios: S1 — vendor-patch lure to hospital-wide extortion.
Updated Risk Level: High — Upgraded from Medium
Justification: T10 and T14 independently use the same human weakness as the first control failure in PACS and enterprise ransomware paths, and T6 ranks ransomware first. Existing C-032/C-033 delivery and tracking still reduce risk, so the gap does not become Critical; the new linkage from incomplete role preparation to two severe attack chains makes Medium too low.
```

### GAP-015 — Public-facing vulnerability remediation lacks verified ownership and closure

```text
Gap ID: GAP-015
Gap Description: Public-service version, advisory ownership, remediation deadlines and closure evidence are incomplete.
Original Risk Level: High
Threat Actors: Ransomware Groups (Organized Crime); Hacktivist; Unskilled/Opportunistic Attacker; Nation-State APT.
Kill Chains: KC1 — VPN Foothold to Domain-Wide Ransomware.
Scenarios: None; S1 deliberately uses phishing rather than an assumed FortiGate exploit.
Updated Risk Level: High — Same
Justification: KC1 and T6 show how a usable public-service flaw could give ransomware immediate internal access, while several actor types can scan exposed services. The actual FortiGate/web versions, external listeners and exploitability remain unverified, so one conditional chain raises operational urgency but does not support a Critical finding.
```

### GAP-016 — Public-service and intersite trust boundaries lack verified least-privilege enforcement

```text
Gap ID: GAP-016
Gap Description: DMZ, VPN, internal and third-party flows are broad or unverified rather than constrained to approved sources, destinations and services.
Original Risk Level: High
Threat Actors: Ransomware Groups (Organized Crime); Nation-State APT; Insider (Malicious); Hacktivist; Unskilled/Opportunistic Attacker.
Kill Chains: KC1, KC3, KC4 and KC5.
Scenarios: S1 and S3.
Updated Risk Level: Critical — Upgraded from High
Justification: GAP-016 appears in six of eight paths—the joint-highest frequency—and is the common mechanism that turns VPN, workstation, insider and supplier footholds into access to AD, PACS, pumps and EHR. T7 already identifies the internal surface as MedDefense's greatest risk. Its cross-actor blast-radius effect makes verified least-privilege boundaries a Critical threat-informed priority.
```

### GAP-017 — Patient-record bulk export lacks documented authorization and detection safeguards

```text
Gap ID: GAP-017
Gap Description: EHR bulk-export permission, approval, volume limits and timely unusual-access detection are not demonstrated.
Original Risk Level: High
Threat Actors: Ransomware Groups (Organized Crime); Nation-State APT; Insider (Malicious); Insider (Negligent).
Kill Chains: KC5 — Compromised MedTech Channel to EHR Records.
Scenarios: S1, S2 and S3.
Updated Risk Level: Critical — Upgraded from High
Justification: GAP-017 is the only gap used by all three T14 scenarios and also appears in KC5, spanning ransomware, valid insider access and supplier-led espionage. Stolen records cannot be restored into confidentiality, and C-037's delayed audit export is not timely prevention. Four path dependencies and three distinct intentional actors elevate the residual risk to Critical.
```

### GAP-018 — Medical-device management credential baseline is unverified

```text
Gap ID: GAP-018
Gap Description: Unique, non-default, attributable and safely managed credentials for pump and other medical-device interfaces are not verified.
Original Risk Level: High
Threat Actors: Insider (Malicious); Ransomware Groups (Organized Crime); Unskilled/Opportunistic Attacker after an internal foothold.
Kill Chains: KC4 — Privileged Insider Manipulation of Infusion Pumps.
Scenarios: None of the three T14 scenarios explicitly depends on this gap.
Updated Risk Level: High — Same
Justification: KC4 establishes the importance of reusable device-management access, but First Watch does not confirm that default credentials remain or that a tested credential grants fleet-wide control. GAP-001 already carries the Critical detection/recovery failure; retaining High here prioritizes safe validation without double-counting the same device consequence.
```

### GAP-019 — Patient-portal transport baseline permits legacy TLS according to unverified draft

```text
Gap ID: GAP-019
Gap Description: Effective portal TLS protocols, ciphers, redirects and compatible client paths are not verified; legacy TLS is reported only in a draft.
Original Risk Level: High
Threat Actors: Nation-State APT; Unskilled/Opportunistic Attacker where network position and protocol negotiation permit abuse.
Kill Chains: None of the five selected T10 chains explicitly uses this gap.
Scenarios: None of the three T14 scenarios explicitly depends on this gap.
Updated Risk Level: Medium — Downgraded from High
Justification: None of the eight selected paths depends on transport downgrade or interception, and exploitation requires additional network position/client conditions. The legacy-TLS statement remains unverified rather than a measured configuration. Restricted portal data still requires prompt validation, but current threat evidence supports Medium until a usable weak protocol or unprotected route is confirmed.
```

### GAP-020 — Removable-media and outbound sharing restrictions lack verified data controls

```text
Gap ID: GAP-020
Gap Description: USB, personal cloud/email and other outbound channels lack verified content-aware restriction, monitoring and governed exceptions.
Original Risk Level: High
Threat Actors: Insider (Malicious); Insider (Negligent); Ransomware Groups (Organized Crime); Nation-State APT.
Kill Chains: None of the five selected T10 chains explicitly uses this gap.
Scenarios: S2 — malicious insider exfiltration.
Updated Risk Level: High — Same
Justification: S2 makes USB the direct channel that moves Restricted exports outside MedDefense control, matching T6's malicious-insider exposure. C-017–C-021 address malware but do not establish DLP or device control. One explicit exfiltration path supports High; the gap is not a dependency across enough selected paths to justify Critical.
```

### GAP-021 — HQ landlord-managed network lacks documented security responsibility and assurance

```text
Gap ID: GAP-021
Gap Description: HQ provider responsibilities, tenant isolation, patching, incident notification and MedDefense visibility are not documented or validated.
Original Risk Level: High
Threat Actors: Ransomware Groups (Organized Crime); Nation-State APT; Unskilled/Opportunistic Attacker compromising a provider or shared-network component.
Kill Chains: None of the five selected T10 chains explicitly uses this gap.
Scenarios: None explicitly; S1 originates at HQ but does not require landlord-network compromise.
Updated Risk Level: High — Same
Justification: T8 shows the HQ network and VPN as a critical dependency, but no selected path needs a weakness in the landlord service itself. Unknown responsibility and visibility can delay containment of an external compromise, while C-002/C-004 offer partial boundary control; this balance preserves High.
```

### GAP-022 — Organization-wide change approval and rollback evidence is incomplete

```text
Gap ID: GAP-022
Gap Description: Production changes lack consistently evidenced approval, testing, post-change validation, rollback and escalation across critical services.
Original Risk Level: High
Threat Actors: Insider (Negligent); Insider (Malicious); Nation-State APT using a trusted update path.
Kill Chains: KC2 — Unsafe Pharmacy Change to Dosage Integrity Failure.
Scenarios: S3 — compromised MedTech update.
Updated Risk Level: High — Same
Justification: Two dissimilar paths use this governance gap: an accidental pharmacy change and an APT-modified EHR update. The threat analysis broadens its relevance beyond ordinary error, but GAP-002 separately captures the Critical pharmacy-specific absence and partial rollback/detection controls exist; High remains proportionate for the enterprise-level governance gap.
```

### GAP-023 — Legacy print server remains active without verified supported maintenance and containment

```text
Gap ID: GAP-023
Gap Description: The active legacy print server has unverified support/patch status, restricted flows, endpoint protection, backup and migration planning.
Original Risk Level: Medium
Threat Actors: Ransomware Groups (Organized Crime); Unskilled/Opportunistic Attacker.
Kill Chains: None of the five selected T10 chains explicitly uses this gap.
Scenarios: None of the three T14 scenarios explicitly depends on this gap.
Updated Risk Level: Medium — Same
Justification: T8 identifies ransomware as the actor most likely to test legacy SMB/RPC after gaining access, so the server remains a credible pivot or spool-data target. No selected path, confirmed exploitable build, demonstrated privilege or known Restricted spool content raises it beyond Medium; flat-network containment should still be validated.
```

## Re-prioritized Gap List

Within each updated risk tier, explicit path frequency is the first ordering factor; ties are resolved by actor likelihood, clinical impact, active-compromise evidence and breadth of dependency. Arrows highlight movement from the final 1x00 rating.

| Rank | Gap | Updated risk and movement | KC count | Scenario count | Total paths | Threat-informed priority reason |
|---:|---|---|---:|---:|---:|---|
| 1 | **GAP-016** | **Critical — ↑ from High** | 4 | 2 | **6** | Joint-most-connected control failure; expands every major foothold across critical zones. |
| 2 | **GAP-011** | **Critical — ↑ from High** | 4 | 2 | **6** | Joint-most-connected identity weakness; enables external, insider and vendor abuse. |
| 3 | **GAP-017** | **Critical — ↑ from High** | 1 | 3 | **4** | Appears in every T14 scenario and makes patient-data loss irreversible. |
| 4 | **GAP-006** | **Critical — ↑ from High** | 1 | 2 | **3** | Repeated route to the #1 critical asset from ransomware and supplier footholds. |
| 5 | **GAP-007** | **Critical — ↑ from High** | 1 | 1 | **2** | Lets the highest-likelihood actor attack both production and demonstrated recovery. |
| 6 | GAP-001 | Critical — Same | 1 | 0 | 1 | Direct patient-safety integrity/recovery failure in KC4. |
| 7 | GAP-002 | Critical — Same | 1 | 0 | 1 | Legitimate change access can corrupt multi-site dosage information. |
| 8 | GAP-003 | Critical — Same | 1 | 0 | 1 | PACS extortion path has no documented recovery copy. |
| 9 | GAP-004 | Critical — Same | 0 | 0 | 0 | Top 5 shared dependency; missing core-specific resilience remains severe outside selected paths. |
| 10 | GAP-005 | Critical — Same | 0 | 0 | 0 | Unpatchable MRI controller retains high clinical impact and ransomware relevance. |
| 11 | **GAP-014** | **High — ↑ from Medium** | 1 | 1 | **2** | Human control failure initiates two ransomware/PACS paths. |
| 12 | GAP-022 | High — Same | 1 | 1 | 2 | Shared by accidental pharmacy corruption and malicious supplier update. |
| 13 | GAP-015 | High — Same | 1 | 0 | 1 | Conditional but consequential public-service entry route for several actors. |
| 14 | GAP-018 | High — Same | 1 | 0 | 1 | Direct medical-device credential path, pending safe credential validation. |
| 15 | GAP-020 | High — Same | 0 | 1 | 1 | Provides S2's direct EHR-data exfiltration channel. |
| 16 | GAP-008 | High — Same | 0 | 0 | 0 | Confirmed mining behavior and resale/pivot potential outweigh zero selected-path frequency. |
| 17 | GAP-009 | High — Same | 0 | 0 | 0 | Prior portal authorization failure exposes Restricted patient information. |
| 18 | GAP-012 | High — Same | 0 | 0 | 0 | Unmanaged devices support opportunistic entry and insider-created exposure. |
| 19 | GAP-013 | High — Same | 0 | 0 | 0 | Ransomware or deletion can affect repositories outside validated recovery scope. |
| 20 | GAP-010 | High — Same | 0 | 0 | 0 | Physical insider path reaches co-located critical systems and backups. |
| 21 | GAP-021 | High — Same | 0 | 0 | 0 | Critical HQ/VPN dependency lacks provider assurance despite partial boundary controls. |
| 22 | GAP-023 | Medium — Same | 0 | 0 | 0 | Legacy pivot remains plausible, but exploitability, privilege and sensitive spool scope are unverified. |
| 23 | **GAP-019** | **Medium — ↓ from High** | 0 | 0 | **0** | No selected path uses weak TLS and both configuration and attack prerequisites remain unverified. |

### Updated Distribution

| Updated risk level | Count | Change from 1x00 |
|---|---:|---:|
| Critical | 10 | +5 |
| High | 11 | −5 net |
| Medium | 2 | No net change |
| Low | 0 | No change |
| **Total** | **23** | — |

Six gaps move upward: GAP-006, GAP-007, GAP-011, GAP-016 and GAP-017 move from High to Critical, while GAP-014 moves from Medium to High. GAP-019 moves from High to Medium pending technical validation. The other 16 remain at their original level. The net High change is −5 because five High gaps move to Critical, one moves to Medium and GAP-014 enters High.

## The Critical Three

1. **GAP-016 — six paths (KC1, KC3, KC4, KC5, S1 and S3):** Least-privilege boundary enforcement is the broadest blast-radius control; closing unnecessary VPN, intersite, internal and supplier flows can prevent four different foothold types from reaching AD, PACS, pumps or EHR.
2. **GAP-011 — six paths (KC1, KC3, KC4, KC5, S1 and S3):** Strong individual identity, lifecycle control and phishing-resistant MFA can interrupt stolen, shared, retained and vendor-account abuse near the beginning of those same six paths.
3. **GAP-017 — four paths (KC5, S1, S2 and S3):** Export authorization and timely behavior detection protect against all three T14 actor models, so closure reduces ransomware double extortion, insider theft and state collection even when initial access succeeds.

GAP-016 and GAP-011 tie for the highest frequency; their ordering reflects T7's finding that the internal surface multiplies the impact of every entry path, not a meaningful numerical difference. GAP-006 is the nearest runner-up at three paths.

## The Surprise

**GAP-014 is the clearest surprise: Medium → High.** First Watch reasonably credited the existing annual program, tracked completion and workstation protection, so incomplete training originally appeared to be a program-quality problem with partial safeguards. Threat modeling changes that interpretation: KC3 uses a role-relevant Radiology phish to reach unrecoverable PACS, and S1 uses an urgent Fortinet-support pretext against IT to start hospital-wide theft, backup interference and encryption. The gap is therefore not merely low completion; it is missing role-specific resistance at the initial-access step for the highest-ranked T6 actor. Existing training still prevents a Critical rating, but tying the weakness to two severe operational paths makes High the more defensible threat-informed level.

## Decision Note

Frequency identifies reusable defensive leverage, not automatic remediation order during an active incident. Confirmed mining under GAP-008 still requires immediate incident handling even though it scores zero in the selected paths, and patient-safety gaps GAP-001–005 remain Critical despite lower frequency. Conversely, a tool purchase does not close GAP-011, GAP-016 or GAP-017 without verified identity coverage, enforced flows, timely review and tested operational procedures.
