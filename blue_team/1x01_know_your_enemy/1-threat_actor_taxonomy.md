# Threat Actor Taxonomy

Source: [Eight anonymized intelligence reports](https://s3.eu-west-3.amazonaws.com/hbtn.intranet/uploads/text/2026/3/5d870ae3a4339537802dc6f8b806a4968b0cafca.txt).

Classifications describe the best behavioral fit, not confirmed identities. Resource levels are estimates of demonstrated capability, not known budgets. This exercise treats Shadow IT as a category; in practice, it describes unmanaged technology rather than the identity of an attacker.

## Report A

```text
Report A:
  Actor Type: Nation-state
  Internal/External: External — the reported entry was exploitation of the company's VPN appliance; no insider role is evidenced.
  Resources: High — zero-day access, a custom remote access tool, a stolen signing certificate and a 14-month operation indicate substantial capability and sustained effort.
  Sophistication: High — covert communication through encrypted DNS queries, signed malware and prolonged concealed collection indicate advanced operational skill.
  Primary Motivation: Espionage — selective collection of proprietary Phase III trial results supports strategic research intelligence gathering rather than immediate extortion.
  Confidence Level: Medium — the behavior strongly fits state-linked espionage, but a well-funded commercial espionage or criminal operator could also possess these capabilities; state sponsorship is not established.
```

## Report B

```text
Report B:
  Actor Type: Organized crime
  Internal/External: External — vendor-impersonation emails delivered the initial malicious attachment to hospital staff.
  Resources: Medium — commercial malware, external storage and a coordinated three-week operation require operational resources, but custom development or state funding is not evidenced.
  Sophistication: Medium — the actors combined a known document-reader exploit, commercially available malware, data theft and network-wide ransomware deployment.
  Primary Motivation: Financial gain — the 40-Bitcoin demand and threatened publication seek payment; blackmail is the mechanism used to obtain it.
  Confidence Level: High — coordinated encryption and disclosure-based extortion strongly fit organized criminal operations, although the specific group and affiliate arrangement are unknown.
```

## Report C

```text
Report C:
  Actor Type: Hacktivist
  Internal/External: External — exploitation of the public website is the best-supported entry route; no authorized internal access is reported.
  Resources: Low — a limited website defacement using an existing application weakness does not demonstrate major funding or extensive infrastructure.
  Sophistication: Low — the observed attack stops at the website and shows no custom tooling or advanced persistence; the exact exploit complexity remains unknown.
  Primary Motivation: Philosophical or political beliefs — the message criticizes closure of the free clinic and mobilizes public protest.
  Confidence Level: High for the behavioral category — the stated cause and publicity objective fit hacktivism, but the displayed logo does not authenticate the named activist group's involvement.
```

## Report D

```text
Report D:
  Actor Type: Insider threat
  Internal/External: Internal — the former administrator abused privileges and knowledge acquired during employment; connecting from home after termination does not remove the insider origin.
  Resources: Low — existing administrative access and a secondary account enabled sabotage without evidence of purchased infrastructure or substantial funding.
  Sophistication: Medium — creating an account outside directory oversight and disabling backups demonstrate deliberate preparation and knowledge of recovery dependencies.
  Primary Motivation: Revenge — destructive actions surrounding disciplinary termination support retaliatory sabotage rather than theft for sale.
  Confidence Level: High — account creation, prior backup interference, timing and the home address strongly support the insider scenario; intent is inferred and the address alone would not prove identity.
```

## Report E

```text
Report E:
  Actor Type: Unskilled attacker
  Internal/External: External — the reported automated exploitation spans more than 300 organizations and does not depend on employment or authorized access.
  Resources: Low — a public miner and automated exploitation of a known flaw lower operating costs; infection scale alone does not demonstrate substantial funding.
  Sophistication: Low — observed behavior uses packaged exploitation and mining without advanced persistence or demonstrated deeper intrusion.
  Primary Motivation: Financial gain — the attacker diverts workstation computing power to generate Monero.
  Confidence Level: Medium — low-skill opportunistic behavior is the best exercise fit, but a skilled criminal can choose simple automated methods; absence of additional activity does not establish the operator's maximum ability.
```

## Report F

```text
Report F:
  Actor Type: Shadow IT
  Internal/External: Could be either — an internal employee introduced the unmanaged device and accidental exposure; an external attacker then exploited it and reached the nurse call system.
  Resources: Low — the personal Raspberry Pi and use of default credentials show no need for substantial funding.
  Sophistication: Low — entry relied on exposed default credentials; the reported pivot demonstrates further access but does not establish advanced techniques.
  Primary Motivation: Service disruption — this is the closest listed fit for the harmful activity affecting the nurse call system, but attacker intent is unconfirmed; the employee's stated purpose was benign performance monitoring.
  Confidence Level: High for Shadow IT as the enabling condition — personal unmanaged technology is explicit; confidence in the external attacker's motivation is Low because malfunction could be incidental rather than intended.
```

The employee should not be labeled malicious: the report expressly denies malicious intent. Shadow IT explains the governance failure; the external exploiter is a separate actor whose identity and ultimate objective remain unknown.

## Report G

```text
Report G:
  Actor Type: Organized crime — provisional leading hypothesis, not attribution.
  Internal/External: Could be either — a stolen physician account could be used by an external criminal or another insider; legitimate credentials identify the account, not the operator.
  Resources: Low — sustained account use and downloads show no custom tools or expensive infrastructure; the cost of obtaining access is unknown.
  Sophistication: Medium — selective collection over six weeks and off-hours account misuse suggest planning, but no advanced exploit is demonstrated.
  Primary Motivation: Financial gain — concentration on high-value insurance plans suggests insurance fraud or profitable data misuse; this remains an inference rather than a confirmed sale or fraud event.
  Confidence Level: Low — the report establishes unauthorized-looking access patterns but cannot distinguish external credential theft, insider misuse or collaboration.
```

### Competing explanations and distinguishing evidence

- **Organized crime:** an external operator could have obtained the physician's credentials and collected records for insurance fraud. Look for credential-theft evidence, account recovery changes, phishing reports, associated access infrastructure and subsequent fraudulent claims.
- **Insider threat:** another employee could have used shared or stolen credentials, or an insider could have collaborated with outsiders. Correlate application access with authorized duties, workstation sessions, relevant staff access records and lawful investigative evidence. Medical leave and travel documents do not by themselves exclude remote access or collaboration by the physician.
- **Unskilled attacker:** an opportunist could reuse exposed credentials and download accessible records without developing malware. Evidence of automated downloads, broadly reused credentials or a simple account compromise would support this alternative, although selective insurance targeting suggests a planned objective.

Establish what the repeated address represents: a hospital gateway, household connection, commercial VPN or proxy can each hide different users. Preserve authentication, remote-access, application and endpoint records; examine session identifiers, devices, authentication factors, token reuse and the precise download sequence. An unchanged IP address does not prove one person, and absence of a ransom demand or a visible marketplace listing does not exclude private sale, fraud or future extortion. No reported political objective or strategic research target supports hacktivism or nation-state espionage as a leading explanation.

## Report H

```text
Report H:
  Actor Type: Organized crime — closest of the six categories for financially motivated data extortion; a coordinated organization is not proven.
  Internal/External: External — an unknown sender used unauthorized access through a Tor exit node; the report does not connect the sender to an employee.
  Resources: Low — exploiting an existing authentication failure and using Tor require no demonstrated major funding; the amount demanded is not evidence of resources.
  Sophistication: Medium — the actor identified or exploited an authentication flaw, extracted records and supplied a verified sample, but neither a zero-day nor custom tooling is established.
  Primary Motivation: Blackmail — the payment demand is explicitly conditioned on withholding vulnerability details and patient records; financial gain is the underlying objective.
  Confidence Level: Medium — extortion is strongly supported, but a lone opportunist could perform the same acts, making organizational attribution uncertain.
```

Calling the approach vulnerability disclosure does not make it ethical research: unauthorized patient-data extraction and a threat to publish distinguish the reported conduct. Only the 50-record sample is explicitly verified; the claimed total of 2,000 should be reconciled with application logs before being treated as a confirmed count. The previously ignored internal report establishes a remediation failure, not proof that the sender was the junior developer.
