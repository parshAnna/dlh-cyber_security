# MedDefense Health Systems — Remediation Map

## Scope and Prioritization Basis

This remediation map covers the same eight prioritized findings used in the Threat-Vulnerability Correlation: Findings 031, 003, 004, 010, 001, 008, 002 and 007.

The objective is not only to remove the technical vulnerability but to do so without creating unacceptable clinical or operational disruption. Each remediation therefore considers testing, maintenance windows, rollback capability, vendor dependency and the effect on production services.

---

## Remediation Plans

```yaml
Finding 031:
  Response Type: Configuration Change

  If Configuration Change:
    Change Description: "Disable the AJP connector on ehr-srv-01 if it is not operationally required. If AJP is required, restrict port 8009 to the approved local or reverse-proxy source only, require an AJP secret, block all general internal access to TCP/8009, and validate the installed Tomcat package/build against the vendor-supported security baseline."
    Impact Assessment: "The EHR application or front-end integration could fail if it currently depends on AJP. Before enforcement, identify the application component using port 8009, test the configuration in staging, back up server.xml and related Tomcat configuration, and perform the change during an approved EHR maintenance window. If application communication fails, restore the previous connector configuration while retaining the temporary network ACL until the application dependency is corrected."

  Timeline: Immediate
  Owner: IT / Security
  Cost Estimate: $0-1K


Finding 003:
  Response Type: Configuration Change

  If Configuration Change:
    Change Description: "Remove the PostgreSQL pg_hba.conf rule that permits the entire 10.10.0.0/16 network and replace it with least-privilege rules allowing TCP/5432 only from the validated EHR application source, currently ehr-srv-01 at 10.10.2.10, using the approved application database role. Add a host firewall or network ACL enforcing the same source restriction."
    Impact Assessment: "Reporting tools, administration scripts or integrations that currently connect directly to ehr-db-01 may lose access. Inventory legitimate PostgreSQL clients before the change, test each approved dependency, back up pg_hba.conf and firewall policy, and retain the previous configuration for immediate rollback if a required clinical workflow is unexpectedly blocked."

  Timeline: Immediate
  Owner: IT / Security
  Cost Estimate: $0-1K


Finding 004:
  Response Type: Compensating Control

  If Compensating Control:
    Control Description: "Place WS-RAD-01 and the MRI controller in a dedicated radiology/medical-device VLAN. Deny SMB/RPC traffic on TCP/135, TCP/139 and TCP/445 from general user networks, deny direct Internet access, permit only explicitly required MRI-to-PACS and vendor-management flows, and require administration through an approved management host. Apply the vendor-approved Microsoft MS17-010 update only after Siemens or the responsible medical-device vendor confirms compatibility."
    Residual Risk: "Windows XP Embedded remains an unsupported legacy operating system, so unpatched vulnerabilities and local compromise risk remain even after segmentation. Any service that must remain permitted through the firewall can still provide an attack path, and long-term remediation requires a vendor-supported software upgrade or replacement of the legacy controller."

  Timeline: Immediate
  Owner: IT / Security / Vendor / Clinical
  Cost Estimate: $1-10K


Finding 010:
  Response Type: Patch

  If Patch:
    Patch Source: "Coordinate a vendor-approved BD Alaris System upgrade through the BD Account Executive. Upgrade the affected Alaris environment to the BD Alaris System v12.3 generation and associated supported component versions where regulatory authorization permits."
    Prerequisites: "Inventory the exact PCU, Guardrails Editor and Systems Manager versions; confirm regulatory authorization and vendor compatibility; back up the approved drug library/dataset and system configuration; validate interoperability with clinical systems; test a small number of pumps first; provide spare pumps; and schedule the rollout with Pharmacy, Biomedical Engineering, Nursing and IT."
    Rollback Plan: "Stop the rollout if validation fails, return affected devices to the last vendor-supported validated configuration using the BD-approved recovery procedure, restore the approved dataset/configuration backup, and return tested spare pumps to clinical service while the vendor investigates."
    Operational Risk: "A failed or incompatible upgrade could remove pumps from service, disrupt drug-library distribution, affect interoperability or delay therapy. The BD update does not eliminate every possible PCU security issue, so segmentation and restricted management access must remain in place after the upgrade."

  Timeline: Immediate
  Owner: Vendor / Clinical / IT / Security
  Cost Estimate: $10-50K


Finding 001:
  Response Type: Patch

  If Patch:
    Patch Source: "Upgrade Apache HTTP Server using Canonical-supported Ubuntu packages that contain the CVE-2021-44790 fix. Because billing-srv-01 runs Ubuntu 18.04, use an authorized Ubuntu Pro/ESM security source or migrate the service to a supported Ubuntu release rather than installing an untracked upstream binary."
    Prerequisites: "Reproduce the billing application in staging; verify mod_lua use and application compatibility; back up /etc/apache2, application files and relevant databases; record enabled modules and virtual-host configuration; validate the package source; and schedule a maintenance window with the Finance/Billing team."
    Rollback Plan: "Restore the pre-change VM or system backup and Apache configuration, or revert to the previous validated application node if the upgraded package causes application failure. Keep network restrictions in place while troubleshooting rather than reopening the vulnerable service."
    Operational Risk: "Apache, PHP or application-module compatibility problems could cause billing outages, failed integrations, authentication problems or unexpected TLS behavior. The Apache restart required by the change will also create a short service interruption."

  Timeline: Immediate
  Owner: IT / Security
  Cost Estimate: $1-10K


Finding 008:
  Response Type: Patch

  If Patch:
    Patch Source: "Use the Microsoft security update applicable to the exact Windows Server edition/build through Windows Update or the Microsoft Update Catalog, ensuring that the installed update includes protection for CVE-2021-34527. Apply current supported Print Spooler hardening and restrict driver installation to administrators."
    Prerequisites: "Confirm whether print-srv-01 is Windows Server 2012 or 2012 R2 and record its current patch level; test critical printers and signed drivers; create a system-state/server backup; export print queues and printer configuration; and schedule the update outside peak clinical printing periods."
    Rollback Plan: "If printing fails, restore the server/system-state backup or remove the problematic update only under an approved emergency rollback procedure, restore the exported printer configuration if required, and temporarily restrict access to the Print Spooler until a corrected patch state is established."
    Operational Risk: "Printer drivers or legacy clinical printers may become incompatible after security hardening. Print queues can stop, users may be unable to install drivers, and departments that rely on printed labels, forms or reports may experience workflow disruption."

  Timeline: Immediate
  Owner: IT / Security
  Cost Estimate: $1-10K


Finding 002:
  Response Type: Patch

  If Patch:
    Patch Source: "Remediate CVE-2019-0211 through the same supported Apache package upgrade used for Finding 001. Use the Canonical-supported Ubuntu security package rather than relying only on the upstream version string; the upgraded package must contain the privilege-escalation fix."
    Prerequisites: "Combine this remediation with Finding 001 where possible. Test the billing application, Apache modules and startup behavior in staging; back up Apache configuration and application data; confirm a working system rollback point; and schedule a Finance/Billing maintenance window."
    Rollback Plan: "Restore the known-good server or package/configuration backup if the new Apache package causes service failure. If rollback becomes necessary, maintain temporary network restrictions and enhanced monitoring because the privilege-escalation exposure will again be present."
    Operational Risk: "The Apache upgrade may break application modules or configuration and could temporarily interrupt the billing service. Because Finding 002 requires an existing lower-privileged foothold, rolling back the patch also restores an escalation path for an attacker who gains execution through Finding 001 or another weakness."

  Timeline: Immediate
  Owner: IT / Security
  Cost Estimate: $0-1K


Finding 007:
  Response Type: Configuration Change

  If Configuration Change:
    Change Description: "Identify all clients performing unsigned LDAP binds, migrate them to signed LDAP or LDAP over TLS as appropriate, and then set the Domain controller: LDAP server signing requirements policy to Require signing on ad-dc-01 and the other MedDefense domain controllers. Monitor Directory Service LDAP events during the transition before enforcing the policy."
    Impact Assessment: "Legacy applications, appliances, scripts or medical systems using unsigned LDAP simple binds over TCP/389 may lose directory connectivity when signing becomes mandatory. First collect LDAP bind telemetry and identify affected source systems, remediate or configure those clients, test authentication-dependent applications, and then enforce the policy in a controlled change window. If a critical dependency fails, temporarily revert the policy while that specific client is remediated rather than leaving the exception undocumented."

  Timeline: 7 days
  Owner: IT / Security
  Cost Estimate: $1-10K
