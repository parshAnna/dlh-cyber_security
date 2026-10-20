# MedDefense Health Systems — Vulnerability Priority Matrix

## Scope

This matrix covers all findings classified as Actionable Critical (AC) or Actionable Standard (AS) in Task 16.

- Actionable Critical: 7 findings
- Actionable Standard: 20 findings
- Total actionable findings: 27

The remediation horizon reflects exploitability, asset criticality, threat relevance, operational impact and the complexity of the required remediation.

---

## Immediate — 24–48 Hours

These findings provide the clearest path to high-impact compromise of critical or clinically important systems and require immediate containment or remediation.

| Finding | Description | Remediation Action | Owner | Estimated Cost |
|---|---|---|---|---:|
| 031 | Confirmed Ghostcat/AJP exposure on `ehr-srv-01` can expose application files and potentially database credentials. | Disable AJP if unused; otherwise restrict TCP/8009 to approved sources, require a secret and validate the Tomcat build. | IT / Security | $1,500 |
| 003 | PostgreSQL on `ehr-db-01` accepts connections from the entire internal `10.10.0.0/16` network. | Restrict TCP/5432 and `pg_hba.conf` to validated EHR application sources only. | IT / Security | $1,000 |
| 004 | Legacy Windows XP MRI controller exposes SMB and is vulnerable to mature legacy Windows attack techniques. | Immediately isolate the MRI controller with ACLs/VLAN controls and begin vendor-approved remediation or replacement planning. | IT / Security / Vendor / Clinical | $12,000 |
| 010 | BD Alaris environment has a security exposure affecting safety-critical infusion-pump infrastructure. | Apply network allowlisting immediately and begin the vendor-approved Alaris upgrade and validation process. | Vendor / Clinical / IT / Security | $35,000 |
| 001 | Apache 2.4.29 on `billing-srv-01` is affected by CVE-2021-44790 remote code execution. | Patch Apache through a supported Ubuntu package source after a tested billing maintenance window. | IT / Security | $2,500 |
| 008 | `print-srv-01` is affected by CVE-2021-34527 PrintNightmare with an active Print Spooler. | Apply Microsoft security updates and Print Spooler hardening; restrict printer-driver installation. | IT / Security | $2,000 |

**Immediate subtotal: $54,000**

---

## Short-Term — Within 7 Days

These findings represent serious privilege, identity, internal-access or publicly exploitable weaknesses that should be resolved immediately after the emergency items.

| Finding | Description | Remediation Action | Owner | Estimated Cost |
|---|---|---|---|---:|
| 002 | Apache CVE-2019-0211 can escalate an existing foothold on `billing-srv-01` to higher privileges. | Remediate through the same supported Apache upgrade used for Finding 001. | IT / Security | $0 incremental |
| 006 | MySQL on `billing-srv-01` listens on all interfaces and is broadly reachable internally. | Bind MySQL only to required interfaces and restrict TCP/3306 to approved application/admin sources. | IT / Security | $1,000 |
| 007 | Active Directory LDAP signing is not required, increasing credential-relay risk. | Identify unsigned LDAP clients, remediate them, then enforce LDAP signing on both domain controllers. | IT / Security | $3,000 |
| 009 | SSH password authentication is enabled on `billing-srv-01` without an effective lockout policy. | Require key-based SSH authentication and disable password authentication after validating administrative access. | IT / Security | $500 |
| 015 | NAS administrative interfaces are reachable network-wide and backup data is insufficiently protected. | Restrict DSM/SSH management to administrative sources and improve backup encryption and access control. | IT / Security | $5,000 |
| 018 | Domain controllers still support weak DES and RC4 Kerberos encryption. | Audit legacy dependencies and disable weak Kerberos encryption types after compatibility testing. | IT / Security | $3,000 |
| 027 | Fifteen Windows workstations have Sophos inactive or not reporting. | Restore endpoint protection, investigate why agents stopped reporting and validate all affected hosts. | IT / Security | $2,500 |
| 028 | An undocumented Linux system on the server subnet exposes SSH, Jupyter-like and Cockpit services. | Identify the owner and purpose immediately; quarantine the device until authorization and hardening are confirmed. | IT / Security | $1,500 |
| 029 | Undocumented Westside Linux host runs vulnerable Grafana 8.2.0 with publicly exploitable path traversal. | Isolate the host, patch/upgrade Grafana and determine whether exposed files or credentials were accessed. | IT / Security | $1,500 |

**Short-term subtotal: $18,000**

---

## Medium-Term — Within 30 Days

These findings require scheduled security hardening but do not currently present the same immediate compromise path as the higher-priority groups.

| Finding | Description | Remediation Action | Owner | Estimated Cost |
|---|---|---|---|---:|
| 005 | Patient portal server still permits TLS 1.0. | Disable TLS 1.0 and validate supported TLS versions with all legitimate clients. | IT / Security | $1,500 |
| 012 | Patient portal is missing recommended HTTP security headers. | Configure appropriate HTTP security headers and regression-test portal functionality. | IT / Security | $500 |
| 013 | Patient-portal TLS certificate expires soon and automatic renewal is not demonstrated. | Renew the certificate and implement monitored automated certificate renewal. | IT | $500 |
| 014 | Westside router management interfaces are broadly reachable from the internal network. | Restrict HTTP/HTTPS management access to authorized administrative systems or the management network. | IT / Security | $0 incremental |
| 019 | RDP is enabled on multiple systems, including reception and Westside hosts. | Restrict RDP to approved administration sources, retain NLA and remove unnecessary RDP exposure. | IT / Security | $2,500 |
| 021 | HTTP TRACE is enabled on the patient portal server. | Disable the TRACE method and confirm application functionality after the change. | IT | $500 |
| 025 | DNS zone transfers are permitted to arbitrary requesters. | Restrict zone transfers to explicitly authorized secondary DNS servers only. | IT / Security | $500 |
| 026 | `billing-srv-01` runs an outdated kernel with numerous known vulnerabilities. | Apply supported kernel security updates, reboot during a controlled window and verify billing services. | IT / Security | $2,000 |

**Medium-term subtotal: $8,000**

---

## Long-Term — Within 90 Days

These findings require architecture changes, broad endpoint changes, vendor coordination or migration away from unsupported platforms.

| Finding | Description | Remediation Action | Owner | Estimated Cost |
|---|---|---|---|---:|
| 011 | `billing-srv-01` runs Ubuntu 18.04, creating an unsupported/EOL operating-system risk. | Migrate the billing workload to a currently supported Ubuntu release after application compatibility testing. | IT / Security | $15,000 |
| 016 | Philips IntelliVue management and HL7 services are broadly reachable across the flat network. | Create a dedicated medical-device security zone and allow only required management and clinical communication flows. | IT / Security / Vendor / Clinical | $25,000 |
| 023 | Approximately 280 clinical workstations do not restrict USB mass-storage devices. | Deploy centrally managed removable-media policy in phases, beginning with the highest-risk clinical endpoints. | IT / Security / Clinical | $10,000 |
| 024 | PACS DICOM traffic carries patient identifiers and medical images without TLS. | Implement vendor-supported DICOM TLS and restrict DICOM communication to approved modalities and radiology systems. | IT / Security / Vendor / Clinical | $20,000 |

**Long-term subtotal: $70,000**

---

## Budget Summary

### Total Estimated Remediation Cost

| Horizon | Estimated Cost |
|---|---:|
| Immediate | $54,000 |
| Short-term | $18,000 |
| Medium-term | $8,000 |
| Long-term | $70,000 |
| **Total** | **$150,000** |

MedDefense's annual security budget established in Project 1x00 is **$120,000**. The complete remediation program therefore represents approximately **125% of the annual security budget** and exceeds the available annual budget by approximately **$30,000**.

The Immediate, Short-term and Medium-term work totals approximately **$80,000** and should not be deferred because it addresses confirmed exploitable vulnerabilities, identity weaknesses, exposed critical systems and active endpoint-protection gaps. This leaves approximately **$40,000** of the annual budget for long-term work.

Because the Long-term program is estimated at approximately **$70,000**, approximately **$30,000 of long-term work must be deferred or funded separately**.

The recommended deferrals are:

1. **Finding 024 — DICOM TLS deployment ($20,000):** defer the full TLS modernization to the next funding cycle if vendor compatibility testing or capital funding cannot be completed this year. Until then, restrict DICOM traffic through segmentation and source allowlisting and monitor PACS network activity.

2. **Finding 023 — enterprise USB-control rollout ($10,000):** phase the deployment. Apply restrictions first to the highest-risk clinical and administrative systems, then complete organization-wide rollout in the next budget period. Existing endpoint protection, logging and removable-media monitoring should remain active during the phased deployment.

The Ubuntu migration in Finding 011 and medical-device segmentation in Finding 016 should remain funded because unsupported infrastructure and broad clinical-device network exposure create systemic risk that will continue to increase if remediation is postponed.

If additional funding becomes available, Findings 023 and 024 should be restored to the current-year program rather than treated as permanently accepted risks.

---

## Final Remediation Order

1. **24–48 hours:** contain or remediate Findings 031, 003, 004, 010, 001 and 008.
2. **Within 7 days:** remediate Findings 002, 006, 007, 009, 015, 018, 027, 028 and 029.
3. **Within 30 days:** remediate Findings 005, 012, 013, 014, 019, 021, 025 and 026.
4. **Within 90 days:** complete Findings 011 and 016 and begin the funded portions of Findings 023 and 024.

This sequence ensures that weaponized vulnerabilities and weaknesses affecting EHR, clinical, identity and externally exploitable systems are addressed before lower-risk hardening and capital-intensive architecture improvements.
