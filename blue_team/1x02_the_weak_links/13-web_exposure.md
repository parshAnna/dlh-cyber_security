# MedDefense Health Systems — Web Exposure Analysis

## Scope and Method

This analysis compares the three web-exposure groups identified in the task context: the Internet-facing patient portal, the internal Synology NAS management interface, and the internally exposed EHR application server.

The scan findings directly associated with these web, TLS, information-disclosure, and application surfaces are:

| Host | Findings |
|---|---|
| `web-srv-01` / Patient Portal | 005, 012, 013, 021 |
| `NAS-01` / Backup Storage | 015 |
| `ehr-srv-01` / EHR Application | 017, 030, 031 |

The vulnerability scan also identifies other HTTP-capable systems such as the Westside Netgear management interface, Philips IntelliVue management interfaces, and undocumented systems exposing Cockpit, Jupyter, or Grafana. Those findings are primarily architecture, medical-device, or asset-inventory issues. The three hosts above are the comparative web-exposure set explicitly identified by this task.

Exposure is treated as a major risk modifier. An Internet-facing weakness can be reached without first compromising MedDefense's internal network, while an internal-only weakness requires an initial foothold. However, MedDefense's flat internal network significantly reduces the protection normally provided by internal placement.

---

## 1. Patient Portal — web-srv-01

**Host:** `web-srv-01 — 10.10.2.50`
Asset Registry references: server A-046 and patient portal A-114.

**Exposure:** Internet-facing. The patient portal is intentionally published over HTTP/HTTPS, and the 1x01 Attack Surface Map documents WAN access to this host.

**Findings:**

- **Finding 005 — TLS 1.0 Enabled**
  - Port: `443/tcp`
  - TLS 1.0 is enabled alongside TLS 1.2.
  - Scan references CVE-2011-3389 (BEAST) and CVE-2014-3566 (POODLE).
  - CVSS Base: 7.5.
  - The portal transmits protected health information.

- **Finding 012 — HTTP Security Headers Missing**
  - Ports: `80/tcp`, `443/tcp`
  - Missing `X-Content-Type-Options`.
  - Missing `X-Frame-Options`.
  - Missing `Content-Security-Policy`.
  - Missing `Strict-Transport-Security`.
  - Missing `X-XSS-Protection`.

- **Finding 013 — TLS Certificate Expiration Warning**
  - Port: `443/tcp`
  - Certificate expires in 23 days.
  - Automatic renewal is not configured.

- **Finding 021 — HTTP TRACE Method Enabled**
  - Port: `80/tcp`
  - TRACE can contribute to Cross-Site Tracing attacks when combined with another weakness such as XSS.

**Combined Risk:** **High.**

No single finding in this group provides a confirmed remote-code-execution or authentication-bypass path. However, the aggregate risk is High because the weaknesses exist on an Internet-facing patient service that handles protected health information.

Finding 005 weakens transport security. Finding 012 removes several browser-side defense-in-depth protections. Finding 021 exposes an unnecessary HTTP method that could amplify another application weakness. Finding 013 creates an availability and user-trust risk if the certificate expires.

The Asset Registry and prior attack-surface analysis identify this host as A-046 with portal A-114. Relevant prior gaps include GAP-019 for legacy TLS exposure, GAP-015 for incomplete public-service remediation assurance, GAP-016 for weak internal boundaries, and GAP-009 for unresolved closure evidence around the prior patient-portal authorization issue.

The 1x01 Threat Actor Matrix identifies ransomware groups as capable of exploiting exposed web services, opportunistic attackers as likely to scan Internet-facing services automatically, and hacktivists as a credible direct threat to the public website and patient portal.

**Attack Scenario:**

An opportunistic attacker, ransomware affiliate, or hacktivist scans the public patient portal.

The attacker identifies support for TLS 1.0 and the absence of HSTS and other security headers. These conditions do not by themselves provide application compromise, but they reduce defensive depth.

If an attacker can place themselves in a suitable interception position, weak TLS and the absence of HSTS can increase the opportunity for downgrade or traffic-manipulation attacks. If an application-side XSS weakness exists, the lack of CSP and the enabled TRACE method may increase the consequences.

Finding 021 should not be treated as proof that XSS currently exists; the scan specifically describes TRACE as useful when combined with XSS.

If a separate portal vulnerability provides execution, authorization bypass, or credential theft, GAP-016 becomes important because weak internal separation could allow an Internet-facing compromise to become an internal foothold.

This scenario is consistent with the Threat Actor Matrix's ransomware and opportunistic web-entry paths, although none of the five existing 1x01 kill chains explicitly starts at the patient portal.

**Priority:** **2 of 3 — High priority.**

The patient portal should be remediated quickly because it is reachable directly from the Internet and handles patient information.

Recommended ordering within this host:

1. Disable TLS 1.0 and permit only supported modern TLS versions.
2. Ensure certificate renewal is completed before expiration and configure reliable automated renewal.
3. Add appropriate HTTP security headers.
4. Disable HTTP TRACE unless there is a documented operational requirement.
5. Revalidate previously documented portal authorization concerns and verify that external compromise cannot pivot directly into the internal network.

---

## 2. NAS Management Interface — NAS-01

**Host:** `NAS-01 — 10.10.2.41`
Asset Registry reference: A-045, backup storage.

**Exposure:** Internal-only, but the DSM management interface is reachable from the entire internal network on `5000/tcp` and `5001/tcp`.

**Findings:**

- **Finding 015 — Synology DSM Web Interface Accessible**
  - Port `5000/tcp` — HTTP.
  - Port `5001/tcp` — HTTPS.
  - Management interface is reachable network-wide.
  - Access is not restricted to dedicated administrator IP addresses.
  - Backup data on the NAS is stored unencrypted.

**Combined Risk:** **High.**

Finding 015 is scanner-rated Medium, but its environmental risk is higher because this system stores MedDefense backup data.

The issue is not that DSM is a web application; DSM is an intended management service. The risk is that a privileged management plane is reachable by far more internal systems than require administrative access.

MedDefense's flat network means that compromise of an ordinary workstation or server may create a direct path to the NAS management interface.

The Threat Actor Matrix specifically identifies `NAS-01 A-045` as a supporting ransomware target because recoverable backups reduce attacker extortion leverage. GAP-007 records the risk created when production and recovery assets share exposure, while GAP-016 concerns insufficient internal separation.

**Attack Scenario:**

A ransomware actor first obtains an internal foothold through phishing, VPN compromise, an exposed web service, or purchased access.

Once inside, the attacker scans the flat network and discovers DSM on `NAS-01` ports 5000 and 5001.

Because management access is available network-wide, the attacker does not need to first cross a dedicated backup-management security boundary. The attacker can then attempt to obtain valid administrative credentials or abuse any subsequently discovered DSM weakness.

If administrative access is obtained, the attacker may be able to access, delete, modify, or encrypt backup data. Because the scan states that the backup data is stored unencrypted, successful storage access also increases confidentiality impact.

This scenario supports the later stages of 1x01 Kill Chain #1, VPN Foothold to Domain-Wide Ransomware: after initial access and lateral movement, attacking recovery infrastructure increases the impact of encryption and makes restoration more difficult.

The scan does not prove that NAS administrative credentials are weak or that DSM currently contains an exploitable CVE, so those conditions must not be assumed.

**Priority:** **3 of 3 — High, but after the EHR and Internet-facing portal.**

The NAS is not publicly reachable, which reduces initial exposure compared with the patient portal. However, its role in organizational recovery means that it should still be treated as an important ransomware-resilience issue.

Recommended remediation:

1. Restrict DSM ports 5000/5001 to approved administrative hosts or a dedicated management network.
2. Prefer HTTPS management and remove unnecessary HTTP exposure.
3. Encrypt sensitive backup data at rest.
4. Separate backup infrastructure from normal workstation/server access paths.
5. Protect backup administration with strong individual credentials and MFA where supported.
6. Maintain isolated or otherwise protected recovery copies that cannot be modified through ordinary production credentials.

---

## 3. EHR Application Server — ehr-srv-01

**Host:** `ehr-srv-01 — 10.10.2.10`
Related critical asset: `ehr-db-01` A-037 and logical EHR data store A-112.

**Exposure:** Internal but accessible across MedDefense's flat internal network.

The EHR application server is not described as directly Internet-facing. However, internal placement provides limited protection because an attacker who compromises another MedDefense system can reach services across the broadly connected network.

**Findings:**

- **Finding 017 — Apache Tomcat Information Disclosure**
  - Port: `8080/tcp`
  - Default Tomcat error pages expose Tomcat version `9.0.31`.
  - Stack traces expose internal path information.
  - Scanner noted that Tomcat 9.0.31 is associated with CVE-2020-1938.
  - Automated scan could not confirm whether AJP was active.
  - Scanner recommended manual verification.

- **Finding 030 — TLS Certificate Common Name Mismatch**
  - Port: `443/tcp`
  - Certificate is issued for `ehr.meddefense.local`.
  - Some clients access the service directly through `10.10.2.10`.
  - This produces browser validation warnings.
  - The scan explicitly describes this as an operational issue rather than a security vulnerability.

- **Finding 031 — Ghostcat / CVE-2020-1938**
  - Port: `8009/tcp`
  - Added manually by SecurePoint after investigating Finding 017.
  - AJP connector was confirmed active.
  - CVSS Base: 9.8.
  - Allows unauthorized file reading through AJP.
  - Configuration files may contain database credentials.

**Combined Risk:** **Critical.**

Finding 030 contributes little to the technical attack path because it is primarily an operational hostname/certificate issue.

Findings 017 and 031 are different. Finding 017 provides reconnaissance information that identifies the exact Tomcat version and potential vulnerable component. SecurePoint used that information to investigate AJP manually and confirmed Finding 031.

Finding 031 creates a direct path to sensitive application files. If configuration files expose valid PostgreSQL credentials, the attacker could then take advantage of Finding 003, which allows PostgreSQL access from the broad internal `10.10.0.0/16` network.

The ultimate target is MedDefense's highest-ranked asset: `ehr-db-01` A-037 and EHR data store A-112.

Relevant gaps include GAP-006 for overly broad EHR database access, GAP-016 for weak internal boundaries, and GAP-017 for insufficient or delayed detection of large-scale EHR data access.

**Attack Scenario:**

This host maps directly to **1x01 Kill Chain #5 — Compromised MedTech Channel to EHR Records**.

An attacker first obtains an internal foothold, for example through compromised vendor access, phishing, or another trusted maintenance path.

During reconnaissance, the attacker reaches Tomcat on port 8080. Finding 017 reveals Tomcat 9.0.31 and internal stack/path information.

That version information tells the attacker or analyst which vulnerabilities deserve additional investigation. SecurePoint followed exactly this process and tested whether AJP was active.

Manual validation confirmed the AJP connector on port 8009 and created Finding 031.

An attacker able to exploit Ghostcat could read application configuration files. If those files contain valid database credentials, the attacker could follow the same dependency described in Kill Chain #5 Step 3: from `ehr-srv-01` to PostgreSQL on `ehr-db-01`.

Finding 003 makes this chain more dangerous because PostgreSQL accepts connections from the broad internal network rather than only the validated EHR application path.

The attacker could then progress toward Kill Chain #5 Step 4 by collecting or modifying EHR records.

**Priority:** **1 of 3 — Immediate priority.**

Although the patient portal is Internet-facing, the EHR host should be fixed first because Finding 031 is a confirmed CVSS 9.8 application vulnerability with a demonstrated path toward MedDefense's highest-value clinical data.

Internal-only placement is not a sufficient compensating control in a flat network.

Recommended remediation:

1. Patch or upgrade Tomcat to a version that is not vulnerable to CVE-2020-1938.
2. Disable the AJP connector if it is not required.
3. If AJP is operationally required, restrict it to only approved application paths and trusted hosts.
4. Remove default error pages and suppress detailed stack traces/version disclosure.
5. Rotate application and database credentials after remediation if exposure of configuration files cannot be ruled out.
6. Restrict PostgreSQL port 5432 to the validated EHR application source.
7. Correct client use of the EHR hostname so certificate warnings do not encourage unsafe warning bypass.

---

## Relative Remediation Priority

| Rank | Host | Exposure | Aggregate Risk | Main Reason |
|---|---|---|---|---|
| **1** | `ehr-srv-01` | Internal but flat-network accessible | **Critical** | Confirmed Ghostcat CVSS 9.8 can expose application files and potentially database credentials leading toward the Critical EHR database |
| **2** | `web-srv-01` | Internet-facing | **High** | Multiple TLS and HTTP weaknesses affect a public patient service handling protected information |
| **3** | `NAS-01` | Internal-only, network-wide management reachability | **High** | Broad access to backup management increases ransomware impact and threatens recovery capability |

Exposure alone does not determine priority. The Internet-facing patient portal has the largest number of external attack opportunities, but the EHR server has the most dangerous confirmed technical vulnerability and the clearest path to MedDefense's highest-value data. The NAS requires an internal foothold first, but compromise could undermine recovery during ransomware.

---

## What Finding 017 Teaches About Medium Information-Disclosure Findings

Finding 017 demonstrates why a Medium information-disclosure finding should not automatically be treated as low-value noise.

The initial finding did not itself provide direct code execution or database access. It revealed the Tomcat product, exact version, stack traces and internal path information. That information reduced uncertainty about the application stack and gave SecurePoint a specific hypothesis to test: whether the AJP connector associated with CVE-2020-1938 was active.

The automated scanner could not answer that question, so SecurePoint performed manual validation. The result was Finding 031: an active AJP connector and a confirmed Ghostcat vulnerability with a CVSS Base score of 9.8.

This shows that version disclosure has **reconnaissance value**. It allows an attacker or defender to:

- identify the exact software family and version;
- map that version to known vulnerabilities;
- identify additional ports, modules, or connectors worth testing;
- focus exploit research on a much smaller set of possibilities;
- uncover vulnerabilities that an automated scan could not confirm.

The lesson is not that every version disclosure should automatically become Critical. The lesson is that severity must be combined with asset criticality, exposure, software context, and follow-up validation.

On an unimportant isolated host, a Medium information disclosure may remain Medium. On `ehr-srv-01`, which provides a path toward MedDefense's Critical EHR database in a flat network, the same reconnaissance information justified deeper investigation and directly led to discovery of a High-severity finding.

Finding 017 therefore demonstrates that Medium findings can be **investigation pivots**: their value may lie not in their immediate exploit impact, but in what they reveal about a more serious attack path.

## References

- [1x00 Asset Registry](../1x00_first_watch/7-asset_registry.md)
- [1x00 Gap Analysis](../1x00_first_watch/12-gap_analysis.md)
- [1x01 Threat Actor Matrix](../1x01_know_your_enemy/6-threat_actor_matrix.md)
- [1x01 Kill Chains](../1x01_know_your_enemy/10-kill_chains.md)
- [1x02 First Impressions](0-first_impressions.md)
- [1x02 Misconfiguration Analysis](6-misconfiguration_analysis.md)
- MedDefense Vulnerability Scan Report — supplied project scan artifact
