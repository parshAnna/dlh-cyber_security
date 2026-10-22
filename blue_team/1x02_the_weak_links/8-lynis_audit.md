# 8. The Self-Audit — Lynis System Audit and MedDefense Projection

**Project:** MedDefense Health Systems — Blue Team, 1x02 The Weak Links
**Audit date:** 22 October 2026
**Audit target:** Personal Fedora Linux workstation (not a MedDefense production asset)
**Tool:** Lynis 3.1.7
**Evidence:** Actual `sudo lynis audit system --quick --no-colors` run, `/var/log/lynis-report.dat`, and the terminal summary provided during the exercise.

## Part 1 — Install and Run

The exercise's `apt` instructions apply to Debian-based systems; this workstation uses Fedora, so Lynis was installed using `sudo dnf install -y lynis`. The audit was run using:

```bash
sudo lynis audit system --quick --no-colors | tee ~/lynis-self-audit/audit-output.txt
```

The `--quick` option disables interactive pauses; it does not turn the run into a quick or partial audit. Results were read from `/var/log/lynis-report.dat` and the saved terminal output. Sensitive raw logs are kept outside the project repository and are **not** committed.

## Part 2 — Analyze Results

### 1. Hardening Index and scan scope

| Metric | Observed result |
| --- | --- |
| Hardening Index | **69 / 100** |
| Tests performed | **268** |
| Lynis version | **3.1.7** |
| Plugins enabled | **0** |
| Reported warning records (`warning[]`) | **0 in the supplied report output** |
| Reported suggestions (`suggestion[]`) | **30** |
| Firewall detected | **Yes (`[V]`)** |
| Malware scanner detected | **Yes (`[V]`)** |
| Intrusion software detected | **No (`[X]`)** |

A score of 69 indicates useful security controls are present but additional host hardening is recommended. It is a **hardening benchmark**, not a percentage probability of being secure or a direct measurement of exploitable vulnerabilities. The scan did not establish that the machine is compromised.

The run also stated **“No OS entry was found in the end-of-life database.”** This means the tool lacked a matching support-lifecycle entry; it must **not** be interpreted as evidence that Fedora is unsupported or end-of-life.

### 2. Top 5 Warnings — accurate handling of zero warnings

**Lynis returned no entries matching `warning[]=` in the report examined for this exercise. Consequently there are no actual “top five warnings” to rank.** To satisfy the analytical purpose without fabricating scanner output, the five items below are explicitly designated **prioritized security observations**, derived from the *Suggestions* and *Software components* sections. They are **not Lynis warnings**, nor confirmed exploitable vulnerabilities.

| Priority | Observation and evidence | What Lynis checks | Why it matters | Recommended remediation / validation |
| --- | --- | --- | --- | --- |
| 1 | Intrusion software was not detected (`[X]`). | Whether a supported intrusion-detection or prevention capability is present/detectable. | An endpoint can have antivirus yet lack independent visibility into suspicious network or host behavior. | Check existing EDR/HIDS controls first; deploy a supported host-intrusion or detection solution only if there is an actual monitoring gap. |
| 2 | File-integrity monitoring recommended (`FINT-4350`). | Availability of integrity controls for sensitive files. | Unauthorized changes to executables and configuration may go unnoticed. | Evaluate AIDE or an equivalent integrity monitor, establish a trusted baseline, and alert on meaningful changes. |
| 3 | External log forwarding recommended (`LOGG-2154`). | Whether logs are archived on a separate logging host. | A local-only log may be lost or modified during compromise, limiting investigation. | Forward protected logs over an authenticated channel to a central log collector, with retention and access controls. |
| 4 | Authentication policy improvements recommended (`AUTH-9230`, `AUTH-9286`, `AUTH-9328`). | Password-hashing settings, password age parameters, and login umask. | Inconsistent account policy and overly permissive default file creation can expand the impact of stolen credentials or local access. | Review actual PAM/authselect settings and policy requirements; strengthen relevant settings without breaking Fedora-managed configuration. |
| 5 | Network protocols flagged for review (`NETW-3200`: DCCP, SCTP, RDS, TIPC). | Whether optional networking protocol support is necessary. | Unused protocol implementations can increase the potential kernel attack surface. | Check modules, current workload dependencies, and loaded state before disabling any unused protocol modules. |

### 3. Top 5 Suggestions — prioritized improvements

| Priority | Lynis ID | Actual suggestion | Recommended improvement and security value |
| --- | --- | --- | --- |
| 1 | `FINT-4350` | Install a file integrity tool to monitor changes to critical and sensitive files. | Configure an integrity monitor (for example AIDE), protect its baseline, and alert on unexpected executable and configuration changes; improves persistence and tampering detection. |
| 2 | `LOGG-2154` | Enable logging to an external logging host for archiving purposes and additional protection. | Send important audit, authentication, and system logs to a centrally protected log destination; improves incident reconstruction and resistance to local log deletion. |
| 3 | `BOOT-5264` | Consider hardening system services using `systemd-analyze security SERVICE`. | Review exposed services individually and apply relevant systemd sandboxing options such as filesystem and privilege restrictions after functional testing; reduces service-compromise impact. |
| 4 | `AUTH-9328` | Default umask in `/etc/login.defs` could be more strict, like `027`. | Review umask values actually applied through login, shell, PAM, and service configuration; use a stricter default where compatible to limit group/other access to new files. |
| 5 | `KRNL-6000` | One or more sysctl values differ from the scan profile and could be tweaked. | Compare specific reported sysctl keys with workstation requirements, document approved changes, and test before applying; reduces kernel/network attack surface without blindly applying every suggested setting. |

**Noise and applicability:** The report also recommended `debsums` (`PKGS-7370`), a Debian-oriented integrity utility. Fedora uses RPM tooling, so this is an example of a suggestion that must be evaluated for operating-system applicability rather than followed blindly. Likewise, USB restrictions may be inappropriate on a workstation that legitimately needs removable media.

### 4. Category Breakdown

Lynis did **not** provide numerical scores for individual categories in the supplied output. Therefore the counts below are **suggestions per test-ID prefix**, not invented per-category hardening scores. They describe improvement opportunities and should not be read as a formal risk ranking.

| Category (Lynis test prefix) | Suggestions | Evidence in audit |
| --- | ---: | --- |
| Boot/services (`BOOT`) | 1 | BOOT-5264 |
| Kernel (`KRNL`) | 2 | KRNL-5820, KRNL-6000 |
| Authentication (`AUTH`) | 4 | AUTH-9230, AUTH-9286 (minimum and maximum age), AUTH-9328 |
| File systems (`FILE`) | 1 | FILE-6310 |
| USB devices (`USB`) | 1 | USB-1000 |
| Storage (`STRG`) | 1 | STRG-1846 |
| Name services (`NAME`) | 3 | NAME-4028, NAME-4402, NAME-4404 |
| Software packages (`PKGS`) | 2 | PKGS-7370, PKGS-7420 |
| Networking (`NETW`) | 4 | NETW-3200 (four separate protocols) |
| Web services (`HTTP`) | 2 | HTTP-6640, HTTP-6643 |
| Logging (`LOGG`) | 2 | LOGG-2154, LOGG-2190 |
| Banners (`BANN`) | 2 | BANN-7126, BANN-7130 |
| Accounting (`ACCT`) | 1 | ACCT-9626 |
| Cryptography (`CRYP`) | 1 | CRYP-7902 |
| File integrity (`FINT`) | 1 | FINT-4350 |
| System management (`TOOL`) | 1 | TOOL-5002 |
| General hardening (`HRDN`) | 1 | HRDN-7222 |
| **Total** | **30** | **All supplied `suggestion[]` entries** |

**Areas with the most outstanding suggestions:** Authentication and Networking have **4 each**, followed by Name Services with **3**. This points to password/account-policy tuning, optional protocol hardening, and hostname/DNS hygiene as areas requiring attention. **Areas with fewer suggestions:** Boot/Services, Filesystems, USB, Storage, Accounting, Cryptography, File Integrity, System Management, and General Hardening have **1 each**, but a low suggestion count does not prove those areas are secure. Among the explicit control detections, **Firewall** and **Malware Scanner** are positive, while **Intrusion Software** is not detected. Thus the most defensible posture summary is partial baseline protection with gaps in detection, centralized evidence, and configuration hardening—not a claim that any one category scored numerically highest or lowest. For formal category-by-category scores, a separate test pass/fail tally would be required; the provided Lynis summary does not contain such scores.

## Part 3 — MedDefense Projection: `billing-srv-01`

The following are **predictions based on MedDefense's supplied scan**, not findings from running Lynis on `billing-srv-01`. Linux audit tools cannot establish every CVE, remote network exposure, or compromise condition from local configuration alone. Relevant follow-up checks are identified below.

| # | Expected Lynis finding or related hardening gap | MedDefense evidence and reasoning | How to verify / respond |
| --- | --- | --- | --- |
| 1 | **Outdated operating system and incomplete security updates** (OS/package/kernel checks). | Finding **011** records Ubuntu 18.04 without ESM, and Finding **026** records an old `4.15.0-213-generic` kernel with outstanding CVEs; the host is likely behind on security maintenance. | Review Ubuntu support/ESM status, installed package updates, kernel and package repositories; move to a supported release or formally supported maintenance channel. Lynis's EOL detection depends on its lifecycle database. |
| 2 | **Apache web-service hardening weaknesses** (HTTP/service configuration checks). | Finding **001** reports Apache **2.4.29** and vulnerable `mod_lua` behavior; an older and exposed web stack may also lack defense-in-depth modules/configuration. | Review the installed Apache package, loaded modules, privileges, TLS and access configuration; patch/upgrade and confirm CVE-2021-44790 with vendor advisories or a vulnerability scanner. **Lynis alone is not proof of this CVE.** |
| 3 | **SSH password authentication / weak brute-force resistance** (SSH and authentication checks). | Finding **009** explicitly reports SSH password authentication enabled without sufficient login-attempt controls, enabling password spraying or guessing. | Inspect `sshd_config` and effective `sshd -T` settings; prefer approved key-based access, appropriate MFA, and rate-limiting/lockout safeguards tested against remote administration needs. |
| 4 | **Overly exposed database service** (database/service/network configuration checks). | Finding **006** states MySQL listens on **`0.0.0.0`**, increasing reachability beyond necessary application clients. | Inspect `bind-address`, local sockets and firewall policies and validate exposure with `ss -lntp` and authorized reachability tests; bind to approved interfaces and allowlist clients. **Lynis may not establish actual network exposure without separate checks.** |
| 5 | **Insufficient detection and incident evidence** (logging, malware/intrusion-detection and file-integrity checks). | The billing server has a **crypto-miner compromise history**, so monitoring for malicious persistence, tampering and renewed execution is especially important, regardless of whether an antivirus product is installed. | Check local/central log collection, process/account/service baselines, malware/EDR coverage and integrity monitoring; investigate known miner indicators and verify eradication. **A history of compromise does not by itself prove these controls are absent.** |

### Conclusion

The Fedora workstation received a **69/100** hardening index after **268** tests, with **zero reported `warning[]` records** and **30** recommendations. Its detected firewall and malware scanner are strengths; unattended improvements concern authentication, optional protocols, log retention, file integrity and service/kernel hardening. Some suggestions are generic or distribution-specific, and recommendation counts are not category scores. The projected MedDefense findings illustrate how poor patch governance, remote access configuration, broad database binding and deficient detection can combine to create a much higher-risk server environment. A real Lynis run on `billing-srv-01`, supported by package/CVE checks and network tests, would be needed to confirm these projections.

## Evidence and Reproduction Commands

```bash
# Read actual Lynis summary values
sudo grep -E '^(hardening_index|tests_executed|tests_performed)=' /var/log/lynis-report.dat
sudo grep '^warning\[\]=' /var/log/lynis-report.dat
sudo grep '^suggestion\[\]=' /var/log/lynis-report.dat

# Inspect saved console summary and audit log
# (Keep raw security logs outside the public Git repository.)
tail -n 100 ~/lynis-self-audit/audit-output.txt
sudo less /var/log/lynis.log
```
