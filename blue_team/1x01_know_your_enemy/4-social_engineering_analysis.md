# MedDefense Health Systems — Social Engineering Analysis

Basis: The seven supplied scenarios. Each record selects a primary term from the assignment's vector taxonomy; overlapping mechanisms are explained without treating categories as mutually exclusive. Controls are proposed, not represented as deployed. Suspicious domains below are scenario evidence, not links to visit.

## Scenario 1 — False Firmware Emergency

```text
Scenario 1:
  Vector Type: Brand impersonation — the message borrows Fortinet's support identity; phishing is the email delivery method.
  Target: Sarah Park, IT Director — responsibility for the FortiGate 100F and service continuity makes an urgent vendor patch request relevant to her duties.
  Psychological Lever: Fear — threatened service termination pressures Sarah to act; urgency reinforces it.
  Red Flags:
    1. The sender uses fortinet-support.net, a separate domain whose vendor ownership has not been established through the approved support records.
    2. The message threatens service termination within 24 hours unless a firmware download is followed.
    3. An unsolicited email directs installation through its own link instead of an independently accessed, approved support channel.
  Technical Control: Enforce application control on the administrative workstation so downloaded installers or update utilities cannot run unless approved through the software-release process.
  Administrative Control: Require firmware changes to be verified through the vendor portal or support contact already held in IT records before downloading or installing an update.
```

Knowledge of the firewall model is not proof of sender legitimacy. An emergency can justify expedited review, but not replacing source verification with trust in an email link.

## Scenario 2 — Executive Wire-Transfer Request

```text
Scenario 2:
  Vector Type: Business email compromise (BEC) — executive impersonation seeks fraudulent payment; actual compromise of the CEO mailbox is not established.
  Target: Robert Kim, CFO — payment authority and a reporting relationship with the CEO make an apparent executive instruction persuasive.
  Psychological Lever: Authority — the supposed CEO invokes executive direction, reinforced by secrecy and urgency.
  Red Flags:
    1. The sender address differs subtly from the CEO's known address.
    2. The request demands an immediate $85,000 transfer while forbidding normal discussion or independent review.
    3. The sender insists on email-only communication and claims to be unavailable for verification.
  Technical Control: Configure executive-impersonation protection in the email gateway to flag or quarantine messages using leadership names with unrecognized or lookalike sender addresses.
  Administrative Control: Require independently verified payment instructions and a second authorized approver for such transfers, using a known callback number rather than contact details in the request.
```

A plausible business purpose does not override payment verification. Sender authentication alone cannot prevent every lookalike-domain message or abuse of a genuinely compromised mailbox.

## Scenario 3 — Helpdesk Credential Call

```text
Scenario 3:
  Vector Type: Vishing — the attack uses a voice call, with an emergency-audit pretext and IT impersonation.
  Target: A MedDefense Central nurse — concern about the billing incident and reliance on the EHR make an apparent IT request seem relevant during a busy shift.
  Psychological Lever: Authority — the caller presents a security audit as an IT requirement.
  Red Flags:
    1. The caller asks the nurse to disclose the password rather than use an approved authentication process.
    2. An unsolicited caller's first name and claim to work in IT are the only identity evidence supplied.
    3. The supposed audit uses an incident-based emergency story to justify verbal credential collection.
  Technical Control: Deploy vendor-supported phishing-resistant multifactor authentication for EHR access so a disclosed password alone cannot authorize a new login.
  Administrative Control: Establish a no-password-disclosure procedure requiring staff to end unsolicited credential calls and contact the helpdesk through its published internal number.
```

The caller's knowledge of the incident is not authentication. The recommended authentication control depends on EHR support and does not make password disclosure acceptable.

## Scenario 4 — Parking Renewal Text

```text
Scenario 4:
  Vector Type: Smishing — SMS delivers a credential-harvesting link using parking and HR impersonation.
  Target: All employees, especially staff who depend on hospital parking — a threatened parking disruption can provoke a quick response before or during a shift.
  Psychological Lever: Fear — towing is the threatened consequence, reinforced by a next-day deadline.
  Red Flags:
    1. An unexpected text threatens towing unless renewal happens immediately.
    2. The text directs the employee to an embedded link rather than the established parking-renewal route.
    3. The linked page requests organizational AD credentials for the parking claim; its familiar appearance does not verify its address or ownership.
  Technical Control: Use phishing-resistant, site-bound authentication for the organizational sign-in service so a copied login page cannot obtain a reusable authentication response for the genuine service.
  Administrative Control: Require parking and HR requests to be checked through the bookmarked staff portal or published department contact, without following unsolicited message links.
```

A legitimate parking workflow might use organizational sign-in; the suspicious combination is unsolicited pressure plus an unverified login destination, not the use of single sign-on by itself.

## Scenario 5 — Compromised Professional Association Website

```text
Scenario 5:
  Vector Type: Watering hole — the attacker compromises a site that the intended physician population already visits.
  Target: MedDefense physicians obtaining continuing medical education credits — an established monthly habit and trust in the association bring them to the compromised pages.
  Psychological Lever: Familiarity — the attacker relies on existing trust and routine browsing rather than necessarily sending a persuasive message.
  Red Flags:
    1. If visible, the browser address changes from the association's site to an unrelated destination without an expected navigation step.
    2. If generated, browser or endpoint protection reports a blocked exploit, malicious redirect or unexpected executable download during the visit.
    3. If observed, the browser crashes or behaves abnormally immediately after opening the affected pages, warranting reporting rather than repeated retries.
  Technical Control: Enforce timely security updates for managed browsers to remove known exploitable browser flaws before routine browsing.
  Administrative Control: Provide a reporting procedure for unexpected redirects or security warnings that requires stopping the session and contacting IT rather than bypassing warnings or repeatedly reopening the page.
```

The scenario expressly describes a silent redirect: none of these possible warning signs is guaranteed to be visible. User vigilance therefore cannot be the primary defense, and browser updates do not guarantee protection against an unknown vulnerability; a training answer must not invent a certificate warning or download prompt as a confirmed event.

## Scenario 6 — Lookalike Patient Portal

```text
Scenario 6:
  Vector Type: Typosquatting — meddefence-portal.com substitutes “defence” for “defense”; brand impersonation and search advertising support the deception.
  Target: MedDefense patients, with patient-support staff as a secondary audience — people searching for the portal may trust a prominent result and familiar design without checking the address.
  Psychological Lever: Familiarity — the copied portal appearance and near-identical name imitate a known service.
  Red Flags:
    1. The domain spells the organization name “meddefence” instead of “meddefense.”
    2. The result is a sponsored advertisement, which indicates paid placement rather than verification that it is the official portal.
    3. The destination differs from the portal address supplied through verified hospital communications despite copying its visual design.
  Technical Control: Deploy lookalike-domain and brand-abuse monitoring with alerts to the security team so malicious portal copies can be investigated and submitted for ad removal or domain takedown.
  Administrative Control: Publish and consistently use one verified portal entry route in patient communications, instructing patients and support staff to use that link or a saved bookmark rather than search advertisements.
```

The task does not supply the genuine portal domain, so none is invented. Advertising alone is not proof of fraud, and monitoring or takedown cannot guarantee immediate removal; the three indicators should be assessed together.

## Scenario 7 — Scrubs and an Expired Visitor Badge

```text
Scenario 7:
  Vector Type: Impersonation — the person presents as hospital staff; pretexting supplies the forgotten-badge story, while following another person through the door is tailgating.
  Target: A staff member entering the restricted IT corridor — a friendly apparent colleague in clinical clothing can exploit the habit of holding doors for coworkers.
  Psychological Lever: Helpfulness — the person requests an informal favor and presents the access problem as a harmless inconvenience.
  Red Flags:
    1. The person follows through a controlled door without presenting their own valid badge.
    2. The claimed employee identity conflicts with a partially concealed visitor badge that expired two days earlier.
    3. The forgotten-badge explanation asks the employee to bypass the normal access check rather than use the reception or security process.
  Technical Control: Configure the electronic access system to detect and alert on multiple entrants following a single badge authorization, with coverage validated for the doorway and a designated responder.
  Administrative Control: Require every entrant to present valid authorization; staff should refer people with missing or expired badges to security rather than lend access or physically confront them.
```

Electronic entry detection is the requested Technical control; a staffed checkpoint or physical barrier would be a different control category. Scrubs, a stethoscope and a branded cup are visual cues, not authorization to enter the restricted corridor. Any entry-control change must preserve emergency egress.
