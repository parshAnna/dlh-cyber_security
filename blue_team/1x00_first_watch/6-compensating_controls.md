# MedDefense Health Systems — MRI Compensating Control Strategy

Prepared for: James Chen, Deputy CISO  
Prepared by: Junior Security Analyst  
Scope: Task 6 — proposed safeguards for the MRI control workstation; no implementation performed.

Evidence basis: The supplied Legacy Dilemma scenario establishes Windows XP Embedded, certification tied to the existing OS, a $2.1 million scanner six years into a twelve-year expected life, approximately 45 studies per day, required PACS connectivity and a shared workstation VLAN. The [Asset Registry](7-asset_registry.md) identifies controller WS-RAD-01 at 10.10.1.70 and the documented PACS server pacs-srv-01 at 10.10.2.12; its XP SP3 fingerprint versus the scenario's Embedded edition and unnamed manufacturer require validation. These addresses support planning, not authorization to change a live device.

All controls below are **Proposed**. The scenario rules out patching, OS upgrades, device replacement and complete network disconnection; no agent installation, host firewall installation or controller configuration change is required by this strategy. The scenario's blanket April 2014 patch statement is not treated as independently verified support history for the exact Embedded edition; the decision rests on its explicit no-patching constraint.

## 1. Risk Analysis

The MRI controller is a critical risk because its legacy Windows XP Embedded environment cannot receive remediation under the scenario, leaving any applicable flaws in enabled network services unresolved rather than removed by patching. The supplied scan reports exposed ports 135, 139 and 445, associated with Windows RPC/NetBIOS/SMB service families, but the exact enabled versions, patch state and exploitable vulnerabilities must be verified rather than inferred from port numbers alone. Sharing the general workstation VLAN permits potential attack paths from compromised staff devices, and a compromised controller could in turn attempt to reach PACS or other accessible hospital systems, exposing confidentiality and integrity beyond Radiology. Controller disruption could interrupt approximately 45 MRI studies per day and delay diagnosis, so MedDefense must reduce reachable attack paths and improve detection and recovery while preserving clinically necessary image transfer.

## 2. Compensating Control Strategy

The principal function for every proposal is **Compensating**: these measures provide alternative protection where direct OS remediation is infeasible. Their preventive, detective or corrective effects are stated separately; no individual measure is claimed to replace all benefits of a supported, patched platform.

### CC-01 — Enforced MRI network isolation

- **Category + Function:** Technical + Compensating (preventive effect).
- **Specific design:** Place the controller on a dedicated network zone with an enforced firewall boundary, using a supported external firewall or existing network enforcement capability. Deny unsolicited access from general workstations and unnecessary outbound connections; permit only validated source/destination/service combinations required for PACS transfer and any separately justified clinical dependency. Validate the documented PACS endpoint and actual DICOM or other required protocol configuration rather than blindly allow every port seen in its scan. Arrange any essential vendor maintenance through a separately approved, restricted path instead of permanently opening broad access.
- **Reduction without OS modification:** Rules and placement are implemented on external network equipment; the controller's approved software remains unchanged. Preserve existing controller addressing through a suitable external design if changing it is not vendor-approved. This reduces both opportunistic access to the legacy host and its ability to reach unrelated systems while retaining imaging connectivity.
- **Limitations / residual risk:** A VLAN alone does not enforce access policy. Attacks through permitted PACS traffic, a compromised approved peer, local media or incorrect firewall rules remain possible; the unpatched vulnerabilities are not removed. Vendor/Radiology validation, a supervised clinical window, successful end-to-end study transfer and a tested rollback are prerequisites; the boundary itself becomes a dependency requiring operational support.

### CC-02 — Passive monitoring with an assigned response process

- **Category + Function:** Technical + Compensating (detective effect).
- **Specific design:** Use a network tap, suitable mirrored port or the isolation boundary's telemetry to observe controller traffic without installing software on the controller. Establish its approved traffic pattern and alert on unexpected peers, attempted external connections, scanning behavior and relevant suspicious protocol activity. Send alerts to a named security/IT responder with a Radiology escalation contact and documented triage steps; avoid collecting image payloads unless specifically justified and protected.
- **Reduction without OS modification:** Observation and analysis occur outside the MRI host, helping staff recognize compromise attempts that cannot be prevented by patching this device. Alert handling makes monitoring an operational control rather than merely another unreviewed log source.
- **Limitations / residual risk:** Passive monitoring does not block attacks or guarantee detection; encryption, limited visibility and false negatives can hide activity. False positives consume staff time, and mirrored traffic may be incomplete. Any response affecting connectivity must be clinically coordinated; no automatic shutdown of the MRI is proposed.

### CC-03 — Restricted console and removable-media access

- **Category + Function:** Physical + Compensating (preventive effect).
- **Specific design:** Limit physical access to the controller console and maintenance interfaces to authorized Radiology/biomedical personnel and escorted service staff. Use vendor-approved enclosure or physical port protection for unused removable-media interfaces where it does not interfere with required equipment, cooling or emergency access. Record service visits and maintain controlled custody of approved recovery and maintenance media; use equipment appropriate to its actual location and MRI safety requirements.
- **Reduction without OS modification:** Physical access restrictions reduce opportunities to attach an unauthorized device, introduce malware or manipulate the console without adding drivers, endpoint agents or registry policies to the certified host.
- **Limitations / residual risk:** Authorized insiders and compromised approved media remain threats, and this control does not prevent network exploitation. A physical barrier must not obstruct clinical operation or emergency procedures; console location and vendor compatibility require confirmation. Broad building entrance checks alone are not equivalent to controller-specific protection.

### CC-04 — Controlled vendor maintenance and recovery readiness

- **Category + Function:** Administrative + Compensating (preventive and corrective effects).
- **Specific design:** Assign a Radiology service owner and biomedical/IT custodians, require recorded approval and supervision for maintenance, verify service personnel, and specify exactly when any approved remote-access path may be enabled. Obtain vendor-approved recovery media, configuration information and restore instructions, keep protected copies separate from the controller, and rehearse supported recovery on appropriate non-production equipment or through a vendor-supervised process. Establish a clinical downtime/escalation procedure, including how urgent imaging requests are handled, with clinical leadership approving feasible arrangements.
- **Reduction without OS modification:** The process governs who can act on the legacy device and how to restore its approved state; it does not introduce an OS update or modify the production installation. Separately controlled records and recovery materials reduce reliance on improvised responses after failure.
- **Limitations / residual risk:** Procedures depend on compliance, vendor availability and usable recovery materials. The scenario's acquired-manufacturer history means a responsible support contact and supported recovery method must be established rather than assumed. A paper exercise alone does not prove restoration, and no specific recovery time or available substitute scanner is promised.

## 3. Implementation Priority

**Implement CC-01, enforced MRI network isolation, first.** The shared general-workstation network provides broad potential access to the legacy controller; an external deny-by-default boundary removes unnecessary paths in both directions while allowing the clinically required PACS exchange. It directly reduces exposure before an attacker reaches a service that cannot be patched, whereas monitoring primarily improves recognition and physical/administrative controls primarily address other access routes.

This priority is conditional on validated clinical flows and a safe change window, not permission to disrupt imaging immediately. First confirm the controller/PACS identities, vendor constraints and required communications; test study transfer, image availability, essential maintenance and rollback before acceptance. If only this control is funded initially, local-media exposure, malicious approved peers, detection gaps and recovery uncertainty remain open and should be documented for James and clinical leadership; CC-02–CC-04 remain planned rather than silently assumed present.

## Relationship to the Assessment and Budget

This strategy elaborates MRI GAP-005 in the [Gap Analysis](12-gap_analysis.md) and the external safeguards proposed in [Risk Treatment Decisions](14-risk_decisions.md). The existing $12,000 MRI allowance is a planning envelope, not a new allocation or proof that all vendor-specific requirements fit; validate equipment, staffing and support costs before committing. CC-identifiers identify proposed designs and must not be added to deployed-control counts or assigned operational effectiveness until implementation evidence is available.
