# Healthcare Mobile App Threat Model

## 1. Critical Asset and CIA Analysis

**Most critical asset:** Patient health information and medical records

Patient medical records are classified as Protected Health Information (PHI). Unauthorized access, modification, or disclosure could harm patients and result in HIPAA compliance violations.

**Confidentiality:** Medical records contain highly sensitive personal data, including diagnoses, treatment history, mental health notes, and medications. If this information is exposed to unauthorized parties, patients could face discrimination, identity theft, or serious harm to their personal and professional reputations.

**Integrity:** If a patient's medical records, laboratory results, or prescribed medications are altered maliciously or accidentally, a doctor could make a treatment decision based on false information. This could lead to incorrect diagnoses, dangerous drug interactions, or life-threatening treatment errors.

**Availability:** During a medical emergency, healthcare providers need immediate access to a patient's allergies, current medications, and medical history. If the system becomes unavailable because of an outage or attack such as ransomware, critical treatment decisions could be delayed and the patient's life could be endangered.

## 2. STRIDE Threats for Patient-Doctor Messaging

### Spoofing

**STRIDE category:** Spoofing

**Threat description:** An attacker steals or guesses a user's login credentials and impersonates a patient or healthcare provider to send or read messages.

**Potential impact:** The attacker could access private medical conversations, impersonate a doctor to provide false medical advice, or impersonate a patient to request prescriptions or sensitive information.

**Suggested mitigation:** Enforce multi-factor authentication, especially for healthcare provider accounts, use strong password policies, and implement secure session management with proper token expiration.

### Tampering

**STRIDE category:** Tampering

**Threat description:** An attacker intercepts or modifies a message, such as changing a doctor's dosage instructions or a patient's reported symptoms.

**Potential impact:** A modified message could cause a patient to take an incorrect medication dosage or cause a doctor to make a treatment decision based on false information, directly endangering the patient's health.

**Suggested mitigation:** Use TLS to protect messages in transit, encrypt stored messages, apply integrity checks or digital signatures to critical medical instructions, and maintain secure audit logs.

### Repudiation

**STRIDE category:** Repudiation

**Threat description:** A doctor or patient denies sending a particular message. For example, a doctor might deny providing certain instructions, or a patient might deny reporting a symptom.

**Potential impact:** Without reliable evidence showing who sent a message and when it was sent, disputes concerning treatment decisions, medical liability, or malpractice claims could arise.

**Suggested mitigation:** Maintain immutable and timestamped audit logs containing the sender's verified identity. Digital signatures should also be considered for critical medical instructions.

### Information Disclosure

**STRIDE category:** Information Disclosure

**Threat description:** An unauthorized person, such as another patient, an attacker, or an unauthorized staff member, gains access to private messages exchanged between a patient and a healthcare provider.

**Potential impact:** Sensitive medical conversations, diagnoses, and personal health information could be exposed, resulting in privacy violations, discrimination, regulatory penalties, or reputational harm.

**Suggested mitigation:** Enforce strict access controls so that only the relevant patient and authorized healthcare providers can access a conversation. Encrypt messages at rest and in transit, and never record message contents in plaintext application logs.

### Denial of Service

**STRIDE category:** Denial of Service

**Threat description:** An attacker overwhelms the messaging system with excessive requests, preventing patients and healthcare providers from sending or receiving messages.

**Potential impact:** A patient might be unable to contact a healthcare provider during an urgent situation, or a doctor might be unable to deliver time-sensitive medical instructions, potentially delaying critical care.

**Suggested mitigation:** Apply rate limiting to messaging endpoints, use load balancing and scalable infrastructure, and monitor for abnormal traffic patterns.

## 3. Prioritized Security Controls for Protecting Patient Information

### Priority 1: Multi-Factor Authentication (MFA)

**Why it is the top priority:** Authentication is the first security barrier protecting patient accounts and medical records. Because the application is remotely accessible, stolen credentials obtained through phishing, password reuse, or data breaches could allow attackers to impersonate patients or healthcare providers. MFA significantly reduces the risk of account takeover even when a password has been compromised.

**Application:** Require MFA for all accounts, with particular emphasis on healthcare provider and administrative accounts because they have broader access to patient information. Secure session controls and appropriate token expiration must also be enforced.

### Priority 2: Role-Based Access Control (RBAC)

**Why it is a high priority:** Not everyone who interacts with the system requires access to complete patient records. Healthcare providers, receptionists, and billing employees need different access levels. Without strict access controls, a compromised or misused low-privilege account could expose more information than necessary.

**Application:** Apply the principle of least privilege. Patients should access only their own records, healthcare providers should access only records required for treatment, and administrative employees should receive limited, role-specific permissions.

### Priority 3: Encryption at Rest and in Transit

**Why it is a high priority:** Encryption protects patient information if network traffic is intercepted, a database is accessed without authorization, or backup storage is stolen. The information remains unreadable without the appropriate encryption keys.

**Application:** Encrypt all communications between the mobile app, REST API, database, and hospital systems using TLS. Encrypt databases and backups using strong encryption, and store encryption keys separately in a secure key-management system.

### Priority 4: Audit Logging and Monitoring

**Why it is a medium-high priority:** Logging supports accountability, detects suspicious activity, and provides evidence during incident investigations. Without reliable logs, unauthorized access to patient information could remain undetected.

**Application:** Record who accessed or modified patient information, which records were involved, and when the activity occurred. Protect logs from modification and configure alerts for unusual behavior, such as one account accessing an abnormally large number of patient records.

### Priority 5: Regular Security Testing and Vulnerability Scanning

**Why it is necessary:** Security testing identifies vulnerabilities before attackers can exploit them. Although it does not directly stop an active attack, it helps verify whether authentication, access control, encryption, and other safeguards are implemented correctly.

**Application:** Perform regular penetration tests, automated vulnerability scans, dependency checks, and secure code reviews. Testing should occur before major releases and after significant changes to the application or infrastructure.
o

