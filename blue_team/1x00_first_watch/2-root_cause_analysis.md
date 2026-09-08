# MedDefense Health Systems — Billing Server Root-Cause Analysis

Prepared for: James Chen, Deputy CISO  
Prepared by: Junior Security Analyst  
Asset: billing-srv-01, 10.10.2.15 (registry A-039)  
Scope: Analysis of supplied diagnostics and incident context; no live investigation performed.

Source: [billing-srv-01 diagnostics](https://s3.eu-west-3.amazonaws.com/hbtn.intranet/uploads/text/2026/3/07ba3ac82ad9b417be4eea857654adcf945e0c9e.txt), including system information, process and connection snapshots, executable/configuration details and ticket #4471. The Task 2 context and January incident provide the historical comparison. Relative dates do not establish a complete forensic timeline.

## 1. Process Identification

**The evidence identifies a cryptocurrency-mining workload masquerading as a legitimate system process, consistent with unauthorized cryptojacking of the billing server.** PID 8834 is not explained by normal billing demand.

| Evidence | Interpretation |
|---|---|
| PID 8834 runs as www-data with command ./kworker | A user-space program is running under the web-service account; a familiar system-like name does not make it legitimate. |
| /proc/8834/exe points to /var/www/html/.cache/kworker | The process executes a file in a hidden directory under the web root, rather than being a genuine kernel worker thread. |
| Command includes stratum+tcp://pool.monero.org:4443 | Stratum is a mining-pool communication protocol; the command specifies a Monero-named pool endpoint for receiving work and submitting mining results. It is not a billing-service connection. |
| config.json specifies pools, a redacted wallet/user value, four threads and background operation | The configuration corroborates mining intended to benefit the configured recipient using hospital computing resources. It does not identify the human attacker. |
| The process shows 94.2% CPU; Apache 2.1% and MySQL 1.3% in the snapshot | The suspicious workload is the prominent reported CPU consumer, contradicting an unsupported assumption that ordinary billing demand explains the slowdown. These process percentages must not be equated automatically to percentages of total four-vCPU capacity. |
| Full netstat associates PID 8834 with three established external connections | Connections to 185.243.115.89:4443, 91.121.87.10:8080 and 104.238.140.32:3333 corroborate the configured external mining activity. Their existence alone does not prove patient-data exfiltration. |

A genuine Linux kernel worker is a kernel thread, not a web-root executable receiving a mining-pool URL. The command, executable path and configuration together are stronger evidence than the process name or port number alone. A precise malware family, exploit or operator cannot be established from these artifacts.

## 2. The Real Compromise: CIA Analysis

The two underlying pillars to examine before the visible availability symptom are **Integrity and Confidentiality**, but the evidence supports different confidence levels for each.

**Integrity — directly evidenced.** An unauthorized executable and its configuration have been introduced into the server's filesystem and processing environment, and the server is performing work outside its approved billing purpose. This violates system integrity even if no billing database record has been altered. The attack changes what code runs and how hospital resources are used before users notice degraded performance.

**Confidentiality — the access boundary is compromised; specific information disclosure is not established.** Unauthorized code running as www-data can potentially access information readable by that account, including application files and any exposed connection secrets. That creates a confidentiality exposure before resource consumption becomes noticeable: hospital information is no longer demonstrably restricted to authorized application activity. However, the supplied snapshots do not show the effective permissions, files read, credentials captured or patient records transmitted, so confirmed theft of confidential data must not be claimed. Successful execution under a service account is evidence of unauthorized system use, not proof that every dataset on the host was readable or disclosed.

**Availability — observed consequence.** Mining consumes processing resources needed by the billing service, and Finance reports recurring slowdown; the January ransomware separately made insurance-claim processing unavailable for four days. Availability symptoms draw attention to the host, but restoring speed alone does not restore integrity or resolve confidentiality exposure.

The wording “before Availability” describes the causal relationship between unauthorized execution/access and resource exhaustion, not a timestamp sequence proven by these snapshots. The assignment's two-pillar framing does not justify inventing evidence of a data breach.

## 3. Why a Hardware Upgrade Does Not Resolve the Security Problem

Additional CPU or RAM does not remove the mining executable, revoke unauthorized access, correct the exploited weakness or establish trustworthy data and software. It may temporarily reduce visible contention while leaving the attacker-controlled workload active, and could provide it with additional resources. The administrator's capacity explanation is therefore inadequate as the root-cause diagnosis, although legitimate workload sizing can still be reviewed after the host is secured.

Restarting the machine or its services likewise does not establish eradication. The recurrence may result from an undiscovered startup mechanism, retained malicious files or fresh exploitation of an unresolved access path; none of those mechanisms is demonstrated conclusively here. Moving the same compromised image to a larger VM can move the problem with it, while rebuilding a clean VM but restoring the same weaknesses can allow another compromise.

The appropriate next step is an incident investigation coordinated by James and IT: preserve available process, file and connection evidence; assess clinically appropriate containment; determine the entry and recurrence mechanisms; then remediate them and validate recovery. Root-cause closure requires evidence that unauthorized execution and access have been addressed, not merely a normal CPU reading after a restart. No containment or remediation action has been performed as part of this document.

## 4. Connection to the January Ransomware

Ransomware and mining on the same billing server indicate that recovery has not demonstrated durable restoration of a trustworthy security posture. The Task 2 context says performance symptoms predated January and returned after rebuilding; symptoms alone do not prove that the same miner existed before January. The current binary's reported relative timestamps do not establish continuity across the rebuild, and the two payloads need not come from the same attacker or entry vector.

**The central question is: What initial-access or persistence weakness allowed unauthorized execution, and was it actually eliminated and verified during the January rebuild?**

The investigation should compare January records with current evidence to determine whether a vulnerable application, stolen credential, unsafe restored image, retained persistence or another network access path explains recurrence. Marcus's Apache theory is plausible because the executable runs as www-data under the web root, but that does not prove Apache itself was exploited, that the service was directly internet-reachable or that a particular vulnerability in version 2.4.29 applies. The installed package/build, relevant advisories and actual access/application logs would be needed to validate that claim; service-account compromise can arise through several routes.

The existing [Control Matrix](10-complete_control_matrix.md) records Linux-server protection gaps, weak local logging, broad outbound permissions and ad-hoc response; [GAP-008](12-gap_analysis.md) connects these weaknesses to billing mining. These conditions can enable prolonged activity and ineffective recovery, but they are not substitutes for identifying the actual entry mechanism. January closure should therefore be reviewed for patch/configuration validation, credential handling, clean recovery provenance and post-recovery monitoring rather than assumed successful because billing resumed.

### Evidence limitations

The supplied excerpt simplifies the listener notation; use the full diagnostic report for the stated local addresses and process associations, and do not infer an enforced source ACL from a LISTEN row. Some memory figures in the full process snapshot do not reconcile, so precise resource accounting needs reliable telemetry. Neither domain/IP reputation, specific CVE applicability nor a forensic attack timeline has been independently established; the conclusion of mining activity rests on the provided command, configuration, executable path and process-associated connections.
