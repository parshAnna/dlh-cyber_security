# MedDefense Health Systems — False Positive Analysis

## Introduction

Automated vulnerability scanners are designed to identify conditions that may represent security weaknesses, but they do not always have enough operational context to determine whether a reported issue is actually exploitable in a specific environment.

The MedDefense OpenVAS report contains several findings that require manual validation before remediation resources are committed. The following findings are assessed as false positives or non-security findings in the MedDefense context.

---

## Finding 020 — OpenSSH CVE-2023-38408

**Finding ID:** 020

**Reported Vulnerability:**
The scanner reported `CVE-2023-38408` on `backup-srv-01`, where OpenSSH 8.9p1 was detected. The CVE has a CVSS v3.1 Base score of 9.8 and affects the PKCS#11 functionality used by `ssh-agent`.

**Why It Is a False Positive:**
The installed OpenSSH version falls within the affected version range, but version detection alone is not sufficient to establish exploitability.

CVE-2023-38408 requires the victim's `ssh-agent` to be forwarded to an attacker-controlled system and to permit use of PKCS#11 providers. SecurePoint explicitly noted that this operating condition is unlikely for `backup-srv-01` and marked the result as a possible false positive.

If `backup-srv-01` does not use SSH agent forwarding, or no forwarded `ssh-agent` with the vulnerable PKCS#11 behavior is exposed to untrusted hosts, the prerequisite for exploitation is absent. In that operational context, the version match does not represent an exploitable vulnerability on this server.

**Validation Method:**
Validate whether SSH agent forwarding is actually used on `backup-srv-01`.

Checks should include:

- Review `/etc/ssh/sshd_config` and included configuration files for agent-forwarding settings.
- Check whether administrative workflows use `ssh -A`, `ForwardAgent yes`, or equivalent agent forwarding.
- Review active SSH sessions and relevant process/environment information for forwarded agent sockets such as `SSH_AUTH_SOCK`.
- Confirm with system administrators whether the backup server ever acts as an intermediate SSH host for connections to other systems.
- If agent forwarding is not used, document the finding as not applicable to the server's current operational configuration.

**Risk of Acting on This FP:**
Treating the finding as an immediately exploitable Critical vulnerability could cause MedDefense to prioritize an emergency OpenSSH upgrade ahead of vulnerabilities with demonstrated exposure or active exploitation paths.

This could consume administrator time, testing effort, change-control resources, backup-system maintenance windows, and potentially introduce availability risk on an important recovery system without reducing a currently exploitable attack path.

**Risk of Not Validating:**
The finding must not simply be dismissed. If administrators do use SSH agent forwarding to or through `backup-srv-01`, the exploit prerequisite may exist and the vulnerability could allow code execution against the system running the forwarded agent.

Failure to validate the configuration could therefore result in a real Critical vulnerability being incorrectly ignored.

---

## Finding 022 — System Clock Skew

**Finding ID:** 022

**Reported Vulnerability:**
OpenVAS reported that `ehr-srv-01` was approximately 47 seconds ahead of the scanner's NTP reference and classified the condition as Low severity.

The report stated that time differences can affect certificate validation, Kerberos authentication, and log correlation.

**Why It Is a False Positive:**
A 47-second difference does not by itself represent an exploitable security vulnerability.

Kerberos environments normally tolerate a substantially larger clock difference. Microsoft's recommended and default maximum Kerberos clock-skew tolerance is five minutes. The measured 47-second difference therefore remains well inside the normal Kerberos authentication tolerance.

The scan also provides no evidence that the 47-second difference caused authentication failures, certificate-validation failures, replay-protection failures, or other security impact.

This should therefore be treated as a time-synchronization quality issue rather than an exploitable vulnerability.

**Validation Method:**
Verify the real time-synchronization state rather than relying on a single scanner measurement.

If administrative access to `ehr-srv-01` were available, validation would include checking:

```bash
timedatectl
```

and, depending on the configured NTP service:

```bash
chronyc tracking
chronyc sources -v
```

or:

```bash
ntpq -p
```

These commands are proposed validation steps; no remote MedDefense lab access is available for this task, so no live host output is claimed.

**Risk of Acting on This FP:**
Treating a small clock offset as a security incident could cause unnecessary troubleshooting, NTP reconfiguration, change-control work, service restarts, or investigation effort.

An unnecessary time correction can also create operational problems if performed aggressively on production systems whose logs, databases, or distributed applications depend on predictable time behavior.

**Risk of Not Validating:**
Although 47 seconds does not by itself demonstrate a meaningful security vulnerability, a growing or persistent offset could indicate a failed NTP configuration.

If clock drift later becomes significant, MedDefense could experience authentication failures, inaccurate security logs, event-correlation problems, or certificate-validation issues. The finding should therefore be validated and monitored rather than simply ignored.

---

## Finding 030 — TLS Certificate Common Name Mismatch

**Finding ID:** 030

**Reported Vulnerability:**
The scanner reported a TLS certificate name mismatch on `ehr-srv-01`.

The certificate is issued for `ehr.meddefense.local`, but some clients access the server directly using `10.10.2.10`, causing certificate-validation warnings.

**Why It Is a False Positive:**
The scan report itself states that this is an operational issue rather than a security vulnerability.

The certificate is being presented for the hostname `ehr.meddefense.local`, while the warning occurs when clients connect using the IP address instead. If the certificate is valid for the intended hostname and normal clients use that hostname, the certificate is functioning as intended.

The scanner is therefore detecting a hostname-access inconsistency rather than proving that the TLS certificate itself is insecure.

**Validation Method:**
Validate the certificate using the intended service hostname.

If access to the MedDefense server were available, validation could include:

```bash
openssl s_client -connect 10.10.2.10:443 \
-servername ehr.meddefense.local </dev/null
```

The certificate details could then be inspected with:

```bash
openssl s_client -connect 10.10.2.10:443 \
-servername ehr.meddefense.local </dev/null 2>/dev/null \
| openssl x509 -noout -subject -issuer -dates -ext subjectAltName
```

Validation should confirm that:

- `ehr.meddefense.local` is present in the certificate identity or Subject Alternative Name.
- The certificate is within its validity period.
- The certificate chain is trusted.
- Normal EHR clients are expected to use the DNS hostname rather than the server IP address.

These commands are proposed validation steps; no live MedDefense host output is claimed.

**Risk of Acting on This FP:**
Treating the finding as a defective TLS deployment could lead to unnecessary certificate replacement, certificate-authority work, application reconfiguration, testing effort, and possible EHR service disruption.

It could also result in adding the internal IP address to a certificate unnecessarily instead of correcting clients to use the intended DNS hostname.

**Risk of Not Validating:**
The warning should not simply be ignored. If the approved hostname is actually missing from the certificate, the certificate chain is invalid, or production applications are required to connect by IP address, then corrective action may still be necessary.

Manual validation distinguishes a simple naming inconsistency from a genuine TLS trust problem.

---

## Finding Considered but Not Classified as a False Positive

### Finding 017 — Tomcat / Possible Ghostcat Exposure

Finding 017 should not be classified as a false positive.

The automated scanner identified Tomcat 9.0.31 but could not initially confirm whether the AJP connector associated with CVE-2020-1938 was active.

SecurePoint subsequently performed manual verification and added Finding 031. That validation confirmed that the AJP connector was active on port `8009/tcp` and that the Ghostcat condition was present.

This demonstrates why uncertain automated findings should be validated rather than automatically dismissed.

---

## Expected False Positive Rate

The SecurePoint scan methodology states that the false positive rate for OpenVAS in this configuration is typically approximately **5–10%**.

For a report containing 31 findings:

- 5% of 31 is approximately 1.6 findings.
- 10% of 31 is approximately 3.1 findings.

Therefore, a reasonable expectation is approximately **2 to 3 false positives** in a 31-finding report.

The three findings analyzed in this report are consistent with that expected range.

---

## Why Manual Validation Is Essential

Automated vulnerability scanners identify indicators of possible weaknesses, but they do not always have enough operational context to determine whether a condition is genuinely exploitable.

Finding 020 demonstrates this problem clearly. The scanner identified an OpenSSH version associated with CVE-2023-38408, but exploitation depends on specific `ssh-agent` forwarding conditions that may not exist on `backup-srv-01`.

Finding 022 shows that a measurable technical condition does not necessarily equal an exploitable vulnerability. A small clock difference should be investigated, but its actual operational impact must be established before security resources are committed.

Finding 030 demonstrates a similar distinction. A certificate warning caused by clients using an IP address instead of the certificate's intended hostname is not automatically evidence of a defective TLS deployment.

Manual validation is equally important for avoiding the opposite mistake: dismissing a genuine vulnerability. Finding 017 initially contained uncertainty because the scanner could not confirm the AJP connector. SecurePoint's later manual verification established Finding 031 and confirmed that the connector was active.

Acting on every scanner result without validation can waste administrator time, maintenance windows, testing resources, and change-management effort. At the same time, dismissing uncertain results without validation can leave real vulnerabilities exposed.

Manual validation therefore turns automated scan output into reliable vulnerability intelligence and allows MedDefense to prioritize remediation based on actual exposure rather than scanner assumptions.

## References

- [1x02 First Impressions](0-first_impressions.md)
- [1x02 CVE Ecosystem Research](1-cve_ecosystem.md)
- MedDefense Vulnerability Scan Report — supplied project scan artifact
