# MedDefense Health Systems — Vector-to-Asset Matrix

Prepared for: James Chen, Deputy CISO

Prepared by: Junior Security Analyst

Scope: Artifact-based cross-reference of eight attack vectors against the five highest-ranked First Watch assets, Medical IoT and Active Directory; no live testing or exploitation performed.

## Evidence Basis and Reading Rules

The asset columns use the exact Top 5 from the First Watch [Criticality Assessment](../1x00_first_watch/8-criticality_assessment.md), supplemented by Medical IoT and Active Directory as required. Paths are grounded in the [Asset Registry](../1x00_first_watch/7-asset_registry.md), [Data Map](../1x00_first_watch/9-data_map.md), [Gap Analysis](../1x00_first_watch/12-gap_analysis.md), [Attack Surface Map](7-attack_surface_map.md), [Threat Actor Matrix](6-threat_actor_matrix.md), [Supply Chain Assessment](5-supply_chain_assessment.md) and [Technical Vector Assessment](8-technical_vectors.md).

Each filled cell is one plausible direct or indirect attack path supported by those artifacts; it represents exposure, not proof that exploitation has occurred. A blank cell means the available evidence does not support a sufficiently specific path, not that the asset is immune. “Other Medical IoT” excludes the separately ranked BD Alaris infusion-pump fleet and covers monitors, MRI/CT components and nurse-call systems. Counts below treat each filled cell as one reachable asset-vector intersection.

## Vector-to-Asset Matrix

| Attack Vector | EHR DB — `ehr-db-01` | Pharmacy Management System | Central Cisco Core Switch | BD Alaris Infusion-Pump Fleet | PACS — `pacs-srv-01` | Other Medical IoT | Active Directory — `ad-dc-01` / `ad-dc-02` |
|---|---|---|---|---|---|---|---|
| **Phishing / Spear Phishing** | Phishing → clinician credentials → EHR application session → Restricted patient records on `ehr-db-01`. | Spear phishing → pharmacist or IT credentials → pharmacy application access → medication-dosage data. |  |  | Phishing → radiology credentials or endpoint compromise → shared PACS workflow → `pacs-srv-01` imaging data. |  | Phishing → employee or administrator credential theft → AD authentication services → account and group access. |
| **VPN Exploit** | VPN exploit → Central server subnet → broad reachability → PostgreSQL 5432 on `ehr-db-01` → database authentication attempt. |  | VPN exploit → internal foothold → flat-network discovery → reachable core management plane, if identified → configuration attack. | VPN exploit → internal foothold → flat network → pump web interfaces on 80/443 → device access if authentication fails. | VPN exploit → ALL-service VPN rule → Central server subnet → PACS ports 4242/11112 → imaging-service access. | VPN exploit → broad internal reachability → monitor or nurse-call interfaces → device-service access. | VPN exploit → Central server subnet → AD ports 88/389/445 → identity-service attack. |
| **Default / Shared Credentials** |  |  |  | Internal access → test documented vendor defaults → pump web interface on 80/443 → device management if unchanged defaults are confirmed. | Shared PACS credential → radiology session → `pacs-srv-01` → imaging access without individual attribution. |  |  |
| **Vulnerable Software Exploit** | Known-flaw exploit against Apache or Ubuntu on `billing-srv-01` → code execution → flat-network discovery → attempt against `ehr-db-01` on 5432. |  |  | Applicable firmware exploit, if the reported vendor bulletin is validated → BD Alaris interface → pump disruption or setting access. |  | Legacy XP or outdated monitor-firmware exploit → controller or monitor compromise → medical-device service disruption. | Vulnerable billing or legacy host → code execution → credential capture → AD services → privilege escalation. |
| **Supply Chain Compromise** | Compromised MedTech identity or update → `ehr-srv-01` → application secrets or database connection → `ehr-db-01`. |  |  | Compromised BD maintenance or update channel → trusted firmware or configuration path → infusion-pump fleet. |  | Compromised Siemens maintenance laptop or update → `WS-RAD-01` and MRI → medical-imaging operation. | Compromised Sophos management or update channel → managed Windows endpoint → credential capture → Active Directory. |
| **Insider — Malicious** | Malicious clinician or administrator → valid EHR access → record lookup or export → `ehr-db-01` data. | Malicious pharmacy or IT user → authorized application access → medication-dosage data alteration. | Malicious network administrator → management credentials → core-switch configuration → network disruption. | Malicious biomedical or clinical administrator → pump management interface → unauthorized configuration change. | Malicious radiology user → shared PACS account → image access or copying without individual attribution. | Malicious IT or biomedical insider → reachable device interface → monitor or nurse-call manipulation. | Malicious domain administrator → AD tools → account, group or GPO changes → enterprise privilege. |
| **Insider — Negligent** | Unattended clinical session or personal copy → patient-record access → accidental EHR data exposure. | Untested change script → pharmacy database overwrite → unsafe dosage values across three sites. | Careless network administrator → unreviewed core change → configuration error → multi-service outage. | Unmanaged endpoint or poor credential hygiene → pump interfaces → accidental exposure or unsafe configuration change. | Shared PACS session left active → unauthorized local access → `pacs-srv-01` imaging data. | Shadow Raspberry Pi or personal device → flat network → monitor or nurse-call interfaces → unintended exposure. | Credential reuse or disclosure → compromised AD account → unauthorized authentication or access changes. |
| **Physical Access** | Generic employee badge → server room → physical access to `ehr-db-01` or storage → outage or media theft. |  |  | Unsupervised bedside access → pump controls or ports → local tampering or service interruption. | Generic employee badge → server room → `pacs-srv-01` → physical disruption or media access. | Physical access to MRI, monitor or nurse-call hardware → local interface or cabling → clinical-service disruption. | Generic employee badge → server room → domain controllers → physical outage or media access. |

The matrix contains **39 filled cells**, exceeding the required minimum of 20.

## Connectivity Counts

### Assets Reached by Each Vector

| Vector | Reachable Assets | Count |
|---|---|---:|
| Phishing / Spear Phishing | EHR DB, Pharmacy, PACS, Active Directory | 4 |
| VPN Exploit | EHR DB, Core Switch, Infusion Pumps, PACS, Other Medical IoT, Active Directory | 6 |
| Default / Shared Credentials | Infusion Pumps, PACS | 2 |
| Vulnerable Software Exploit | EHR DB, Infusion Pumps, Other Medical IoT, Active Directory | 4 |
| Supply Chain Compromise | EHR DB, Infusion Pumps, Other Medical IoT, Active Directory | 4 |
| Insider — Malicious | All seven asset columns | 7 |
| Insider — Negligent | All seven asset columns | 7 |
| Physical Access | EHR DB, Infusion Pumps, PACS, Other Medical IoT, Active Directory | 5 |
| **Total filled intersections** |  | **39** |

### Vectors Reaching Each Asset

| Asset | Reachable Vector Count |
|---|---:|
| EHR DB — `ehr-db-01` | 7 |
| Pharmacy Management System | 3 |
| Central Cisco Core Switch | 3 |
| BD Alaris Infusion-Pump Fleet | 7 |
| PACS — `pacs-srv-01` | 6 |
| Other Medical IoT | 6 |
| Active Directory — `ad-dc-01` / `ad-dc-02` | 7 |

## Three Most Connected Assets

The three assets tie at seven vectors, so their presentation order reflects the consequence of the resulting intersection rather than a difference in connectivity count.

1. **EHR DB — 7 vectors:** Its combination of 50,000-plus patient records, treatment dependency and network/database reachability makes every supported path a high-priority confidentiality, integrity and availability intersection.
2. **BD Alaris infusion-pump fleet — 7 vectors:** Its exposure spans network, vendor, credential, insider and local-access paths, while successful manipulation can affect medication delivery and patient safety.
3. **Active Directory — 7 vectors:** Its identity and authorization role lets a successful path amplify one compromise into broader account, privilege and lateral-movement exposure across MedDefense.

## Three Most Versatile Vectors

1. **Insider — Malicious — 7 assets:** Legitimate access and knowledge can bypass perimeter assumptions and reach every asset class, making privilege scope and individual accountability the priority intersection controls.
2. **Insider — Negligent — 7 assets:** Routine access, unsafe changes, credential handling and unmanaged-device behavior can expose every asset class without requiring attacker-level sophistication.
3. **VPN Exploit — 6 assets:** The ALL-service rule into the Central server subnet and flat internal network turn a remote-access failure into a broad route toward identity, clinical systems and medical devices.

## Key Qualification

The matrix deliberately does not claim that an open port grants access, that the core management interface is confirmed reachable, or that BD Alaris default credentials and the reported firmware issue are validated. The pharmacy system's hosting and recovery path remain unknown, which is why only three evidence-supported routes are recorded for it; identifying that host and its dependencies could materially change both its row coverage and the final rankings.
