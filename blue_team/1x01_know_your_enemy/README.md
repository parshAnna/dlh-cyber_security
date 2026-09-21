# Know Your Enemy — MedDefense Threat Landscape Analysis

This project examines external threats in relation to MedDefense's documented internal security posture. Work is artifact-based; no live systems are scanned or exploited.

## Deliverables

- [Task 0 — Healthcare Threat Landscape Summary](0-threat_landscape_summary.md): five actor categories, healthcare targeting mechanisms, evidenced trends and MedDefense-specific relevance.

- [Task 1 — Threat Actor Taxonomy](1-threat_actor_taxonomy.md): eight justified classifications, competing explanations for Report G and explicit attribution limits.

- [Task 2 — Ransomware Threat Assessment](2-ransomware_assessment.md): BlackReef operating model, healthcare incentives, four sequenced internal gaps and a qualified twelve-month likelihood judgment.

- [Task 3 — Insider Assessment](3-insider_assessment.md): five insider scenarios, observable warning signs, control/gap mappings and one proposed control per scenario.

- [Task 4 — Social Engineering Analysis](4-social_engineering_analysis.md): seven vector classifications with three warning signs and technical/administrative countermeasures for each.

- [Task 5 — Supply Chain Assessment](5-supply_chain_assessment.md): five vendor access maps, compromise paths, existing controls and a cross-vendor governance priority.

- [Task 6 — Threat Actor Matrix](6-threat_actor_matrix.md): six actor types with evidence-based likelihood, capability, motivation, vectors, asset/gap mappings and three priorities balancing likelihood and impact.

- [Task 7 — Attack Surface Map](7-attack_surface_map.md): external, internal and human entry points mapped to MedDefense assets, deployed controls and First Watch gap IDs.

- [Task 8 — Technical Vector Assessment](8-technical_vectors.md): six Sec+ technical vectors tied to scan evidence, affected MedDefense assets, T6 actors, existing controls and First Watch gaps.

- [Task 9 — Vector-to-Asset Matrix](9-vector_asset_matrix.md): eight human and technical vectors cross-referenced against seven critical asset groups, with quantified connectivity priorities.

- [Task 10 — Critical Kill Chains](10-kill_chains.md): five Task 9 threat paths developed from initial access through business impact, with evidence-based gaps and multiple defensive break points.

- [Task 11 — STRIDE Threat Model for the EHR](11-stride_ehr.md): twelve MedDefense-specific threats across all six STRIDE categories, mapped to T8 vectors, deployed controls and First Watch gaps.

- [Task 13 — MITRE ATT&CK Mapping](13-attck_mapping.md): all 17 steps from two MedDefense attack narratives mapped to primary Enterprise tactics, specific techniques, alternatives and environment factors.

- [Task 14 — Integrated Threat Scenarios](14-threat_scenarios.md): three distinct external, insider and supply-chain scenarios integrating actors, vectors, ATT&CK sequences, STRIDE threats, assets, business impacts, documented gaps and step-specific detection opportunities.

- [Task 15 — Gap–Threat Correlation](15-gap_threat_correlation.md): all 23 First Watch gaps correlated to T6 actors, T10 kill chains and T14 scenarios, with updated risk levels, a threat-informed ranking, the three most connected gaps and the Medium-to-High surprise.

## Sources and method

The summary reviews all six files in the [provided intelligence dossier](https://s3.eu-west-3.amazonaws.com/hbtn.intranet/uploads/text/2026/3/af4dc3417218ae10f115b06c4288dcf17f0dc80d.txt). Its statistics and source labels are attributed to the supplied excerpts, not represented as independently verified current publications. Marcus's interpretations are distinguished from direct evidence and confirmed internal findings.

The [First Watch assessment](../1x00_first_watch/16-security_posture_assessment.md), asset registry, criticality assessment and gap/control matrices provide the internal baseline. The completed data map and shadow-system findings are incorporated; unresolved actor attribution and unverified access paths remain explicit.

## Repository placement

Store these files in `blue_team/1x01_know_your_enemy` within `dlh-cyber_security`. Subsequent tasks will extend this analysis when their instructions and evidence are supplied.
