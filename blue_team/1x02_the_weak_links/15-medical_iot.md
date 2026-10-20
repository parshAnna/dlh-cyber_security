# MedDefense Health Systems — Medical IoT Security Assessment

## Scope

This assessment analyzes the medical IoT and connected clinical-device findings identified in the MedDefense vulnerability scan, with primary attention to:

- Finding 010 — BD Alaris infusion-pump security concern;
- Finding 016 — Philips IntelliVue management and HL7 interfaces exposed across the internal network;
- Finding 024 — unencrypted DICOM communication involving PACS and radiology systems.

Related medical-device risks are also considered where they affect patient safety, clinical availability, or the impact of MedDefense's flat network architecture.

Medical IoT vulnerabilities require a different risk model from conventional IT vulnerabilities because these systems can participate directly in diagnosis, monitoring, and treatment. Confidentiality remains important, but integrity and availability failures can also affect clinical decisions and patient care.

---

## 1. BD Alaris Assessment

### MedDefense Evidence

**Finding:** 010

**Affected System:** BD Alaris infusion-pump environment / pump fleet A-061 through A-067.

**Observed Version:** `12.1.2`

The MedDefense evidence identifies BD Alaris software/firmware version 12.1.2. The version number must be interpreted carefully because the BD Alaris platform contains multiple components with separate version numbers, including the PC Unit, Guardrails Editor and Systems Manager.

It would therefore be inaccurate to assign every historical Alaris vulnerability to MedDefense solely because the number `12.1.2` appears in the scan.

### Vendor Security Bulletin Research

BD's 2023 security bulletin for the Alaris System with Guardrails Suite MX states that vulnerabilities affect the Alaris System version 12.1.3 and earlier.

The bulletin identifies several vulnerabilities affecting different components. Of particular relevance to version 12.1.2 is:

**CVE:** CVE-2023-30562

**Affected Component:** BD Alaris Guardrails Editor version 12.1.2 and earlier.

**Vulnerability:** Lack of Dataset Integrity Checking.

A Guardrails Editor dataset file stored within Systems Manager can be tampered with and then distributed to Alaris PC Units. BD explains that exploitation could allow an attacker to pivot from Systems Manager to Guardrails Editor and misconfigure a dataset, potentially resulting in activation of an undesired dataset on a PCU.

For Alaris Infusion System 12.1.3 with Guardrails Editor 12.1.2 and earlier, BD assigned CVE-2023-30562 a CVSS score of 6.7 Medium. The attack requires adjacent-network access, some level of permissions, and Systems Manager user interaction, so exploitation is not equivalent to an unauthenticated Internet-based remote attack.

The bulletin also identifies additional vulnerabilities affecting Alaris PCU Model 8015 version 12.1.3 and earlier, including:

- CVE-2023-30559 — improperly signed wireless-card firmware;
- CVE-2023-30560 — PCU configuration lacks authentication;
- CVE-2023-30561 — lack of cryptographic protection on the IUI bus.

These additional issues reinforce the need to treat the Alaris deployment as a connected clinical system rather than as an isolated pump.

### Important Historical Distinction

CVE-2020-25165 is a separate, older BD Alaris network-session authentication vulnerability affecting older Alaris PC Units and Systems Manager versions.

BD later released Alaris PC Unit software version 12.1.1 and newer to remediate that issue.

Therefore, if MedDefense's identified `12.1.2` value represents the PC Unit software version, it is newer than the version required to remediate CVE-2020-25165. This assessment does **not** incorrectly treat CVE-2020-25165 as an unpatched vulnerability on a PCU already running 12.1.2.

The newer 2023 Alaris bulletin remains relevant because it explicitly covers Alaris System 12.1.3 and earlier and Guardrails Editor 12.1.2 and earlier.

### Vendor-Recommended Mitigation

BD recommends updating to **BD Alaris System version 12.3**, where available and authorized for the customer's environment.

The vendor also recommends compensating controls including:

- placing BD Alaris PCUs on their own dedicated VLAN;
- using firewalls or ACLs so devices can communicate only with required endpoints and ports;
- restricting access to the Systems Manager server;
- enabling authentication protection for network-configuration changes;
- rotating Wi-Fi credentials according to security policy;
- monitoring the network for unexpected traffic;
- using MAC filtering or equivalent allowlisting where appropriate;
- periodically verifying that Alaris components run the intended software versions;
- physically inspecting systems for evidence of tampering.

BD specifically states that a PCU normally requires access to DNS, DHCP and Systems Manager on port 3613 and recommends restricting unnecessary network communication.

### Has MedDefense Implemented the Recommendation?

**No — not fully.**

MedDefense is documented as operating the medical-device environment within a broadly connected flat network rather than placing the Alaris pump fleet inside a strongly restricted medical-device VLAN.

Therefore, the vendor's network-segmentation recommendation has not been implemented.

The observed `12.1.2` version also does not establish that the entire Alaris environment has been upgraded to the newer Alaris System v12.3 configuration recommended in the 2023 bulletin. Component versions for Systems Manager and Guardrails Editor should therefore be verified before remediation can be considered complete.

This distinction is important: MedDefense may already have addressed some older vulnerabilities through version 12.1.2, but the available evidence does not show implementation of the current segmentation and full-platform update recommendations.

### Patient-Safety Impact

The most important consequence of CVE-2023-30562 is not conventional information theft. A compromised Guardrails dataset could affect the safety configuration used by infusion pumps.

BD states that users are required to confirm datasets before activation and that built-in integrity controls reduce the probability of patient harm. Nevertheless, the vulnerability creates a path from cybersecurity compromise to a treatment-related configuration risk.

For MedDefense, the absence of strong segmentation increases concern because an attacker who first compromises another internal system may have broader network access toward systems supporting the pump environment.

---

## 2. Philips IntelliVue Assessment

### MedDefense Evidence

**Finding:** 016

**Affected Systems:** Multiple Philips IntelliVue patient monitors in the `10.10.3.10-32` medical-device range.

**Exposed Services:**

- `80/tcp` — web interface;
- `443/tcp` — HTTPS web interface;
- `2575/tcp` — HL7 service.

The scan reports that the management interfaces are accessible broadly across the internal network and do not provide an effective authentication boundary beyond network access.

In a properly segmented architecture, network location could act as an additional access-control layer. In MedDefense's flat environment, however, compromise of an ordinary internal endpoint can place an attacker on a network from which medical-device services can be reached.

### What Data Flows Through IntelliVue Interfaces?

Philips documentation shows that the IntelliVue monitoring ecosystem handles clinically significant information including:

- physiologic numeric measurements and vital signs;
- patient-monitoring waveforms;
- device measurements and settings;
- alarm information and clinical alerts;
- trend information;
- information collected from connected bedside devices;
- patient-associated information forwarded toward central monitoring or clinical documentation systems.

Depending on system configuration and connected devices, examples of physiologic data can include heart rate, respiratory measurements, oxygen saturation, blood pressure and other monitored parameters.

Philips documentation also shows that patient demographic identifiers can be associated with monitoring records and that HL7 output can be used to transfer numeric monitoring information toward an EMR or interface system.

This means that the interfaces carry information with both **confidentiality value** and **clinical-integrity value**.

### What Could an Attacker with Network Access See?

Because Finding 016 reports broadly reachable management and HL7 interfaces, an attacker who already has internal network access could identify the monitors and interact with services that should normally be restricted to trusted medical-device or management systems.

Depending on the exact monitor configuration and functions exposed through the web interface, the attacker may be able to view:

- device status;
- configuration information;
- network information;
- monitoring information exposed by the interface;
- patient-associated clinical information.

Access to HL7 traffic may expose physiologic observations and associated patient information when those data are transmitted through the monitoring infrastructure.

The confidentiality impact is significant because values that appear to be ordinary network traffic may actually represent real-time clinical measurements associated with identifiable patients.

### What Could an Attacker Do?

The scan proves excessive network reachability, but it does **not** prove that every exposed interface permits remote modification of patient-monitor settings.

Therefore, this assessment does not assume arbitrary control of an IntelliVue monitor.

A network attacker could at minimum:

1. discover and fingerprint the medical-device environment;
2. access any unauthenticated information exposed by the web-management service;
3. observe clinical data if able to access or intercept exposed HL7 communications;
4. use device, software and network information for more targeted attacks;
5. attempt to abuse any configuration functions actually exposed by the management interface.

If a writable management function or a separate exploitable vulnerability were available, the consequences could extend to altered configuration, loss of monitoring availability, or corrupted clinical information. However, those capabilities require validation and are not claimed as proven by Finding 016 alone.

### Patient-Safety Significance

A patient monitor supports clinical decisions in real time.

Incorrect or unavailable monitoring information can therefore create a safety risk even if an attacker never directly changes a medication dose. Loss of alarms, misleading observations, or unavailable monitoring data could delay recognition of patient deterioration.

For this reason, the combination of broad network access and weak segmentation materially increases the importance of Finding 016.

---

## 3. Finding 024 — Unencrypted DICOM Traffic

**Finding:** 024

**Host:** `pacs-srv-01 — 10.10.2.12`

**Ports:** `4242/tcp`, `11112/tcp`

**Protocol:** DICOM without TLS encryption.

The scan reports that DICOM communication between the MRI workstation, radiology workstations and PACS traverses the network without encryption.

DICOM traffic can contain:

- patient identifiers;
- medical images;
- imaging-study metadata;
- information associated with diagnostic examinations.

The immediate demonstrated risk is **confidentiality exposure**: an attacker capable of observing this traffic could obtain protected medical information because the application protocol does not encrypt the data.

There is also an integrity concern because clinical imaging is used for diagnosis and treatment decisions. However, Finding 024 proves the absence of encryption; it does not by itself prove that an attacker can successfully alter or upload images.

The flat network increases the environmental risk because systems that do not participate in radiology workflows are not strongly isolated from the imaging infrastructure.

This finding is closely related to the legacy MRI-controller exposure identified elsewhere in the scan: weaknesses in the endpoint, network transport and PACS environment can combine into an attack path that is more significant than any one isolated finding.

---

## 4. Combined Medical IoT Risk

The three primary findings demonstrate different parts of the same medical-device security problem.

Finding 010 concerns a treatment system where configuration integrity can have clinical consequences.

Finding 016 exposes monitoring systems and clinical-data interfaces across a network with inadequate internal segmentation.

Finding 024 shows that sensitive imaging data moves between clinical systems without transport encryption.

The common architectural issue is that MedDefense places safety-relevant technology on networks where compromise of an ordinary IT endpoint can provide reachability toward devices and services that participate directly in patient care.

Network segmentation therefore provides an important compensating control even when a medical device cannot immediately be patched.

---

## 5. Patient Safety Dimension

Medical-device vulnerabilities belong to a different risk category because a compromised device can affect the physical delivery or monitoring of patient care rather than only the confidentiality, integrity or availability of digital information. In the worst case, compromise of an infusion-pump environment could contribute to an incorrect, interrupted or unsafe infusion and therefore create a direct risk of patient injury or death. A compromised workstation can also cause serious harm through stolen records, credential theft, ransomware or interruption of hospital operations, but its effect on the patient is usually indirect. Medical IoT risk must therefore evaluate cyber-physical safety and clinical consequences in addition to traditional IT security impact.

---

## 6. Remediation Challenge

Patching medical devices is more difficult than patching ordinary IT systems because cybersecurity changes must coexist with patient-safety, regulatory and clinical requirements.

### 1. Regulatory and Safety Validation

A medical device performs a defined clinical function and changes to its software may affect safety-critical behavior.

Hospitals cannot safely treat an infusion pump like an ordinary workstation and install arbitrary operating-system or third-party patches.

Updates need to be supported by the manufacturer, validated for the device and, where applicable, made available under the relevant regulatory authorization.

A security improvement that unexpectedly affects alarms, dosage calculations, monitoring accuracy or interoperability can itself create patient risk.

### 2. Operational Availability

Medical devices may be in continuous clinical use.

Taking a workstation offline for maintenance may inconvenience one employee; taking an infusion pump, patient monitor or imaging system offline can affect active patient care.

Hospitals therefore have to coordinate:

- clinical downtime;
- replacement or spare equipment;
- biomedical engineering staff;
- device testing after the change;
- nursing or clinical workflow;
- rollback procedures if the update fails.

This can make even an available patch slower to deploy across a hospital fleet.

### 3. Vendor Dependency

Medical-device software and firmware are frequently proprietary.

The healthcare organization may depend on the manufacturer for:

- validated firmware;
- specialized service tools;
- installation procedures;
- compatibility information;
- regulatory approval status;
- confirmation that a security update will not interfere with clinical functionality.

MedDefense therefore cannot assume that an ordinary IT administrator can independently modify every vulnerable device.

### 4. Interoperability Dependencies

A medical device rarely operates alone.

An Alaris pump can depend on Systems Manager, Guardrails datasets, wireless infrastructure and other hospital systems. IntelliVue monitors can exchange information with central monitoring, EMRs and other clinical devices. PACS depends on imaging workstations and modalities using protocols such as DICOM.

An update to one component must therefore be tested against the rest of the clinical ecosystem.

### 5. Long Device Lifecycles

Medical devices may remain in service substantially longer than conventional IT endpoints.

Hardware can still be clinically functional even when embedded operating systems, network libraries or protocols have become outdated.

Replacing the device may require substantial cost, procurement, validation and staff training, so hospitals often need compensating controls such as segmentation while waiting for replacement or vendor remediation.

---

## 7. Recommended MedDefense Actions

MedDefense should treat the medical-device network as a dedicated security zone rather than another part of the general internal network.

Priority actions are:

1. place BD Alaris pumps and supporting systems in dedicated medical-device VLANs with restrictive firewall and ACL rules;
2. verify the exact versions of the Alaris PCU, Guardrails Editor and Systems Manager rather than treating `12.1.2` as one universal platform version;
3. coordinate with BD to determine availability and regulatory applicability of the recommended Alaris System v12.3 remediation;
4. restrict access to Philips IntelliVue web-management and HL7 services to explicitly authorized monitoring, management and clinical-integration systems;
5. determine whether authentication and encrypted transport can be enabled for the Philips environment;
6. enable TLS or another vendor-supported secure configuration for DICOM traffic where supported;
7. restrict PACS DICOM ports to approved MRI and radiology systems;
8. monitor east-west medical-device traffic for unexpected sources, destinations and management activity;
9. maintain a medical-device firmware and software inventory with vendor security-bulletin tracking;
10. require biomedical engineering, clinical owners and cybersecurity personnel to jointly evaluate remediation when patient-care equipment is affected.

Where immediate patching is not operationally or regulatorily possible, segmentation and strict allowlisting should be treated as compensating controls rather than as reasons to accept unrestricted network exposure.

---

## Conclusion

The MedDefense scan demonstrates that medical IoT risk is not limited to whether an individual device contains a high-CVSS software flaw. BD Alaris systems introduce treatment-integrity and infusion-safety concerns, Philips IntelliVue monitors expose real-time clinical information and management services, and unencrypted DICOM exposes diagnostic imaging data. These risks are amplified by MedDefense's flat network because compromise of an unrelated endpoint can create network reachability toward systems directly involved in monitoring, diagnosis and treatment. Medical-device remediation therefore requires a combination of vendor-supported updates, clinical validation, restricted network architecture and ongoing coordination between cybersecurity, biomedical engineering and clinical teams.

## Research Sources

- BD — BD Alaris System with Guardrails Suite MX security bulletin, originally published July 13, 2023 and updated October 26, 2023.
- BD — BD Alaris 8015 PC Unit and BD Alaris Systems Manager Network Session Vulnerability bulletin.
- Philips — IntelliBridge Bedside medical-device interfacing documentation.
- Philips — IntelliVue patient-monitoring and HL7 connectivity documentation.
- FDA — Cybersecurity in Medical Devices guidance and cybersecurity frequently asked questions.
- MedDefense Vulnerability Scan Report — Findings 010, 016 and 024.
- [1x00 Asset Registry](../1x00_first_watch/7-asset_registry.md)
- [1x00 Gap Analysis](../1x00_first_watch/12-gap_analysis.md)
- [1x01 Threat Actor Matrix](../1x01_know_your_enemy/6-threat_actor_matrix.md)
- [1x01 Kill Chains](../1x01_know_your_enemy/10-kill_chains.md)
- [1x02 Misconfiguration Analysis](6-misconfiguration_analysis.md)
- [1x02 Network Posture Analysis](14-network_posture.md)
