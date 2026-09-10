# MedDefense Health Systems — Insider Threat Assessment

Sources: The five scenarios supplied in this assignment; the First Watch [Control Matrix](../1x00_first_watch/10-complete_control_matrix.md), [Gap Analysis](../1x00_first_watch/12-gap_analysis.md), [Data Map](../1x00_first_watch/9-data_map.md) and [Shadow Systems assessment](../1x00_first_watch/11-shadow_systems.md). Recommendations below are proposed controls, not claims of implementation. Credentials are intentionally not reproduced.

**Evidence reconciliation:** The assignment's Scenario 2 reference to Incident F conflicts with the original incident log: Incident F described an intern's personal laptop running a torrent client, not a contractor account. The 47-day account lifetime and three later authentications are treated as new facts supplied by this scenario, not retroactively attributed to Incident F. Scenario 3 now explicitly confirms patient copies and missing encryption/backup on the personal NAS; earlier Task 11 uncertainties are resolved only to that extent.

## Scenario 1 — The Shared Login

```text
Scenario 1:
  Classification: Negligent — technicians prioritize convenient shared access and leave sessions open, weakening confidentiality and individual accountability; the scenario supplies no deliberate misuse or intent to harm.
  Behavioral Indicators:
    - Multiple technicians visibly use one account during successive patient encounters.
    - Session records, where available, show a single identity remaining active across handovers without logout.
    - Shared credentials appear in routine access instructions rather than individually assigned access arrangements.
  Existing Control (from 1x00): C-052 is the Weak shared PACS credential gate; C-016 requires shared-password changes on departure but does not identify individual users. C-032 awareness training is incomplete. No verified PACS control enforces individual session attribution or automatic locking.
  Gap Exploited (from 1x00): GAP-011 — Shared identities and limited MFA weaken clinical accountability; shared login prevents reliable attribution even without confirmed data theft.
  Recommended Mitigation: Technical — implement vendor-supported individual badge-and-PIN sessions with automatic locking and rapid user switching, preserving fast clinical access while associating each session with one technician.
```

The indicators describe observable practices or records to examine; they do not assert that the required session logs already exist. Individual authentication reduces anonymous misuse, while clinical testing must confirm that the session design is safe and usable.

## Scenario 2 — The Ghost Account

```text
Scenario 2:
  Classification: Negligent — failure to revoke access when the contract ended is an established offboarding failure. The later account use is suspicious and could be malicious, but successful authentication alone does not establish who used it or why.
  Behavioral Indicators:
    - The contractor end-date roster and enabled VPN-account inventory disagree.
    - The account remains enabled without a current sponsor or documented access extension.
    - Off-hours authentications occur after the contract ends, providing a warning before further access or damage.
  Existing Control (from 1x00): C-002 governs VPN traffic and C-004 provides local boundary logs, but neither revokes expired identities. C-016 concerns shared-password changes, not contractor-account termination; C-034 local directory logs do not establish coverage of independent VPN accounts. No verified contract-expiry deprovisioning control is documented.
  Gap Exploited (from 1x00): GAP-011 is the closest identity-governance gap, extended here by explicit evidence of missed contractor revocation; its original shared-identity/MFA title does not itself document this particular account. GAP-016's broad VPN access could increase reachable systems after authentication.
  Recommended Mitigation: Administrative — require a sponsor-owned contractor offboarding procedure that expires all remote-access accounts at contract end, verifies session/token revocation and records completion, including accounts outside the corporate directory.
```

Account expiry should prevent the first post-contract login; later off-hours activity is an early warning, not proof that no prior harm occurred. Investigators should reconcile authorization extensions, session activity and account ownership before accusing the former contractor; confirmed intentional use without authorization would support a malicious classification for that user.

## Scenario 3 — The Personal NAS

```text
Scenario 3:
  Classification: Negligent — Dr. Patel created unmanaged copies for convenience without the required protections; there is no stated intent to steal or disclose records maliciously.
  Behavioral Indicators:
    - An unregistered storage device appears on the office switch port or during an approved asset review.
    - Patient files are copied to a destination absent from the approved storage inventory.
    - Department interviews reveal reliance on personal storage with no IT owner or demonstrated recovery arrangements.
  Existing Control (from 1x00): C-056 discovery can identify responding devices but does not establish that this NAS was scanned or enrolled. C-022 covers specified approved backups, not A-124, and covered-endpoint antivirus does not establish NAS protection. C-032 training offers limited general guidance; no verified encryption or backup control covers this personal device.
  Gap Exploited (from 1x00): GAP-020 — Removable-media and outbound sharing restrictions lack verified data controls — applies to patient copies outside approved storage; Task 11/A-124 provides the specific asset evidence. GAP-012 addresses the broader unmanaged-device governance problem, but its two original unknown hosts must not be equated with this NAS.
  Recommended Mitigation: Administrative — require an IT-led migration of the patient and research files to an approved service with verified encryption, permissions and tested recovery, followed by validated removal of the unmanaged copies under the applicable retention requirements.
```

Migration is one governed treatment, not an assumption that an existing shared drive already meets every requirement. Validate Cardiology's performance needs to avoid recreating the same workaround. The new scenario establishes Restricted patient information on this device; it does not establish that all research files contain patient identifiers or that MedDefense operates an institutional research program.

## Scenario 4 — The Curious Employee

```text
Scenario 4:
  Classification: Malicious — the clerk deliberately accesses a record for curiosity rather than an authorized duty and intentionally discloses the visit. Profit, modification of the record and a desire to injure the patient are not required for intentional privacy abuse.
  Behavioral Indicators:
    - The clerk searches for a patient with no registration task or other documented work-related relationship.
    - Access records show opening clinical information beyond the clerk's assigned administrative need.
    - A review identifies unusual lookup activity focused on a public figure before any external disclosure is known.
  Existing Control (from 1x00): C-037 records EHR activity, but the 48-hour vendor export delay weakens timely detection. C-032 lacks healthcare-specific training. No verified patient-relationship access review or prompt inappropriate-access alert is documented.
  Gap Exploited (from 1x00): GAP-017 is the nearest authorization/detection gap, but originally concerns bulk export; this scenario extends the concern to one-record snooping and verbal disclosure. It must not be described as a proven bulk download or as GAP-009's patient-portal URL flaw.
  Recommended Mitigation: Technical — configure vendor-supported role-based EHR permissions that restrict registration staff to the administrative information required for their duties, with controlled, recorded exceptions for legitimate additional access.
```

The confirmed primary harm is confidentiality loss: information was disclosed without authorization even though the record was unchanged and the system remained available. Public-figure status alone is not evidence of misuse; the lack of an authorized work purpose is decisive. Narrow permissions reduce unnecessary clinical access but do not prevent every misuse of information legitimately visible to registration staff.

## Scenario 5 — The Overworked Admin

```text
Scenario 5:
  Classification: Negligent — the administrator intends to reduce the ticket backlog but exposes powerful credentials through unsafe storage and sharing; the scenario does not establish deliberate sabotage or theft.
  Behavioral Indicators:
    - Review of the reset script identifies an embedded password or reference to an unprotected desktop credential file.
    - A script requires broad directory-administrator credentials for routine password resets instead of limited delegated permissions.
    - A privileged automation script is distributed through email outside an approved review and release process.
  Existing Control (from 1x00): C-012/C-013 address password policy and complexity, not safe secret storage; C-034 logs some directory activity but does not prevent disclosure. C-032 is general training. No verified privileged-secret vault or automated credential-leak prevention control is documented.
  Gap Exploited (from 1x00): GAP-020 covers unverified outbound-sharing controls, including sensitive credentials; GAP-022's change approval and review weaknesses allow unsafe automation to be introduced. These are applications of existing broader gaps, not claims that the original records described this script.
  Recommended Mitigation: Technical — replace the script's administrator credential with a managed automation identity restricted to approved password-reset duties, using platform-managed authentication so reusable administrator passwords are neither stored on desktops nor emailed.
```

The scenario confirms emailing the script, but not whether the separate credential file or its contents accompanied it; inspect the actual artifact before asserting email disclosure of the password itself. The plaintext desktop secret already creates exposure regardless, and replacing future authentication does not invalidate previously exposed credentials or resolve any misuse that has occurred.

## Pattern Assessment

MedDefense's systemic weakness is that access granted for legitimate work is poorly tied to individual responsibility, continuing authorization and observable use. First Watch's GAP-011 and C-052 show how shared Radiology identities conceal who acted, while C-037's delayed EHR audit access makes prompt recognition of inappropriate patient-record use difficult. Task 11's personal NAS and GAP-020 demonstrate how convenience copies can leave approved storage without equivalent protection, and GAP-022 highlights weak review of operational changes such as unsafe automation. Together these findings allow negligent workarounds and intentional privacy abuse to persist behind normal-looking accounts; better accountability, timely access reviews and clinically appropriate permissions are necessary alongside monitoring, rather than assuming a successful login proves a legitimate purpose.
