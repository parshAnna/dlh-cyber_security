# MedDefense Health Systems — Algorithm Landscape & Crypto Gap Analysis

**Project:** 1x04 Cryptographic Foundation
**Task:** 6 — The Algorithm Landscape (`#advanced`)
**Prepared for:** James Chen (Deputy CISO), Sarah Park (IT Director), Robert Kim (CFO), DPO and Biomedical Engineering
**Assessment date:** 5 November 2026
**Evidence:** Task 0 `0-crypto_inventory.md` (Sarah Park's audit baseline) and Project 1x02 vulnerability findings; standards cited below.
**Status:** Reference and recommendations, **not evidence of deployed remediation**.

## 1. How to Read This Reference

- **Status:** `Current` means acceptable for the stated use **with appropriate modes, parameters, authenticated protocols, implementations and key management**; `Deprecated` means not preferred for new protection or subject to a formal phase-out; `Broken` means unsuitable for the security property in question. A primitive's status is context-sensitive (for example, SHA-1 collision resistance versus HMAC-SHA-1).
- **Size:** For symmetric algorithms, key bits; for RSA, modulus bits; for ECC, curve/key bits; for DH, group/modulus bits; for hashes, output bits; for KDFs, adjustable output and cost parameters. These sizes are **not interchangeable security strengths**.
- **Evidence:** `CONFIRMED` = described in the supplied MedDefense audit; `CONFIGURED` = option enabled but not necessarily observed in a transaction; `REPORTED` = audit-described configuration, not independently retested; `PROPOSED` = recommendation only; `UNVERIFIED` = no evidence of production use. Do not call an unknown cipher "deployed."
- **Healthcare:** There is no universal HIPAA/GDPR list of individually approved algorithms. Suitability depends on an adequate system-level implementation, legitimate use, sector rules, technical validation, data protection and risk management. This table does **not** certify legal compliance or FIPS validation.
- **Equivalent classical strength guide:** AES-128 ≈128, AES-192 ≈192, AES-256 ≈256; RSA-2048 ≈112; RSA-4096 lies between NIST's RSA-3072 (~128) and RSA-7680 (~192) reference points; P-256/ECDHE-P256 ≈128; P-384 ≈192; finite-field DH-2048 ≈112 bits. These are classical estimates and do not imply post-quantum resistance [S1].

## 2. Symmetric Algorithms

| Algorithm | Type | Key / output size (bits) | Primary use case | Status | Why deprecated / broken (if applicable) | MedDefense usage / recommended placement |
|---|---|---|---|---|---|---|
| **AES-128** | Symmetric block cipher | 128-bit key; 128-bit block | Fast encryption in vetted modes, e.g. GCM | **Current** | — | **CONFIRMED/CONFIGURED:** Kerberos AES-128 supported; **PROPOSED:** TLS 1.3 AES-128-GCM for patient portal and application paths. |
| **AES-192** | Symmetric block cipher | 192-bit key; 128-bit block | Data encryption with ~192-bit brute-force key strength | **Current** | — | **UNVERIFIED:** no specific MedDefense deployment; optional compliant implementation where interoperability allows. |
| **AES-256** | Symmetric block cipher | 256-bit key; 128-bit block | Strong storage and transport encryption in appropriate modes | **Current** | — | **REPORTED:** Central–Westside/HQ IPsec AES-256; **CONFIGURED:** Kerberos AES-256 supported; **PROPOSED:** EHR, billing, PACS and NAS at-rest protection with tested disk mode (e.g. AES-XTS) and safe key custody. |
| **DES** | Symmetric block cipher | 56 effective key bits (64 incl. parity); 64-bit block | Historical encryption | **Broken** | Exhaustive key search is practical; key length is far below modern security requirements. | **CONFIRMED CONFIGURED, not confirmed negotiated:** Kerberos DES enabled (F018); disable after dependency assessment, require AES Kerberos. |
| **3DES / TDEA** | Symmetric block cipher | 112/168 nominal key bits; 64-bit block; at most ~112-bit effective security for 3-key variant | Legacy payment/financial and other old systems | **Deprecated** (disallowed for *new* protection under NIST) | Small 64-bit blocks invite birthday-bound problems, and NIST disallowed applying new protection with TDEA after 2023 [S2]. | **UNVERIFIED:** inspect legacy billing, TLS, NAS and vendor integrations; migrate any confirmed usage to AES-GCM or suitable AES storage encryption; do not assert deployed. |
| **ChaCha20-Poly1305** | Symmetric AEAD (stream cipher + authenticator) | 256-bit ChaCha20 key; 96-bit nonce; 128-bit tag | Authenticated TLS/VPN/application traffic, especially without AES hardware acceleration | **Current** | — | **PROPOSED:** TLS 1.3 alternative for supported portal/medical endpoints; not documented as deployed; verify vendor and protocol support. |
| **RC4** | Symmetric stream cipher | Variable; 128-bit historically common | Obsolete stream encryption, including legacy Kerberos | **Broken** | Keystream biases and protocol weaknesses; forbidden in TLS [S3]. | **CONFIRMED CONFIGURED:** Kerberos RC4 enabled (F018); inventory issued tickets/service accounts and migrate to AES-128/256 Kerberos. **Not confirmed in portal TLS cipher suites.** |
| **Blowfish** | Symmetric block cipher | 32–448-bit key; 64-bit block | Legacy file encryption | **Deprecated** for new designs | Its 64-bit block size creates collision/birthday risks for sufficiently large encrypted traffic; modern AEAD modes are preferable. | **UNVERIFIED:** prohibit new use for clinical databases/backups; replace any discovered legacy deployment with AES-GCM or approved storage modes. |

**Mode matters:** Raw AES-CBC is encryption **without built-in authentication**; prefer AEAD (AES-GCM/ChaCha20-Poly1305) for messages. Full-disk/storage encryption typically uses a specialized mode such as AES-XTS, not GCM. Safe nonces, key rotation, integrity checking, recovery tests and vendor compatibility are mandatory design considerations. `AES-256-CBC supported but disabled` on Synology NAS is a *missing-control gap*, not evidence that CBC or 3DES currently encrypts backup data.

## 3. Asymmetric and Key-Agreement Algorithms

| Algorithm | Type | Key / output size (bits) | Primary use case | Status | Why deprecated / broken (if applicable) | MedDefense usage / recommended placement |
|---|---|---|---|---|---|---|
| **RSA-2048** | Asymmetric (public key) | 2048-bit modulus; ~112-bit classical strength | Signatures, certificates, small-key wrapping in suitable schemes | **Current** (minimum-strength/transition-sensitive) | —; not recommended as an indefinite long-term high-assurance default. | **LAB ONLY:** Task 2 RSA key pair and Task 5 signatures; **PROPOSED:** compatibility fallback for certificates, plan RSA-3072/4096 or ECC depending on policy. |
| **RSA-4096** | Asymmetric (public key) | 4096-bit modulus; between 128- and 192-bit classical reference categories | Higher-strength signatures/certificates | **Current** | — | **PROPOSED:** certificate/signature option when policy and device CPU/latency support it; not evidenced as deployed. |
| **ECC P-256** | Asymmetric / elliptic-curve cryptography | 256-bit curve/key; ~128-bit classical strength | ECDSA signatures, ECDH key agreement | **Current** | — | **LAB ONLY:** Task 2 ECC P-256 key; **PROPOSED:** TLS certificate/handshake options subject to biomedical vendor support. |
| **ECC P-384** | Asymmetric / elliptic-curve cryptography | 384-bit curve/key; ~192-bit classical strength | Higher-strength ECDSA/ECDH | **Current** | — | **PROPOSED:** higher-security certificate/connection option; validate support on Philips/BD Alaris endpoints; not confirmed deployed. |
| **Diffie–Hellman (finite-field)** | Asymmetric key agreement | Group-dependent; **2048-bit MODP Group 14** ~112-bit classical strength | Derive common session secret without sending it | **Current** with approved strong groups and authentication | —; unauthenticated DH alone permits MITM, and weak groups are unsafe. | **REPORTED:** IKEv2 site-to-site VPNs use DH Group 14; **LAB ONLY:** Task 4 DH-2048. Validate peer authentication and consider stronger/ECDH groups in future change windows. |
| **ECDHE** | Asymmetric ephemeral key agreement | Curve-dependent: P-256 ~128-bit, P-384 ~192-bit classical security | Authenticated TLS handshakes and forward secrecy | **Current** | —; ephemeral exchange **does not authenticate identity alone**. | **PROPOSED:** use authenticated ECDHE in TLS 1.3 for patient portal; not independently verified for deployed MedDefense TLS/VPN. |

**Important distinctions:** RSA and ECC are algorithm families; not every ECC operation directly encrypts arbitrary files. DH/ECDHE derive a shared secret that must be passed through an appropriate KDF to obtain session keys. DH Group 14 in the reported VPN is **not** broken merely because it is older; it provides a lower classical security margin than P-256 and needs authenticated peers.

## 4. Hash Algorithms

| Algorithm | Type | Key / output size (bits) | Primary use case | Status | Why deprecated / broken (if applicable) | MedDefense usage / recommended placement |
|---|---|---|---|---|---|---|
| **MD5** | Hash | 128-bit digest; **no key** | Obsolete checksums and legacy constructions | **Broken** for collision-sensitive security | Practical collision/chosen-prefix attacks invalidate unkeyed signature or collision-security use. | **PROTOCOL-DEPENDENT:** TLS 1.0's PRF uses HMAC-MD5 *with* HMAC-SHA-1 (portal allows TLS 1.0); **not proof of MD5-signed certificates or MD5 password storage**. Remove TLS 1.0; use SHA-256+ for signatures/integrity. |
| **SHA-1** | Hash | 160-bit digest; **no key** | Legacy hashes, certificate signatures and protocol MACs | **Deprecated / broken for collisions** | Practical collisions defeat uses requiring collision resistance; HMAC-SHA-1 is a separate keyed construction with different risk. | **PROTOCOL-DEPENDENT:** TLS 1.0 PRF includes HMAC-SHA-1; Windows Kerberos AES-SHA1 uses HMAC-SHA-1 (not equivalent to broken SHA-1 signatures). Move portal to TLS 1.3; do **not** indiscriminately disable AES Kerberos. |
| **SHA-256** | Hash (SHA-2) | 256-bit digest; **no key** | Integrity checks, HMAC, signatures, KDFs | **Current** | — | **REPORTED:** VPN SHA-256; **LAB:** Tasks 1/3/5 integrity/signing; **PROPOSED:** signed clinical logs, HMAC/HKDF and certificates. Raw SHA-256 alone is **not** a password hash. |
| **SHA-512** | Hash (SHA-2) | 512-bit digest; **no key** | Integrity, signatures and HMAC/KDFs | **Current** | — | **PROPOSED:** high-strength audit/archive integrity where compatible; not evidenced as deployed. |
| **SHA-3** | Hash family | SHA3-224/256/384/512-bit digests; **no key** | Alternative general-purpose hashes (FIPS 202) | **Current** | — | **PROPOSED:** optional approved alternative for archival integrity; no recorded deployment or need for forced migration from SHA-256. |
| **MD4 (additional: confirmed AD exposure)** | Hash | 128-bit digest; **no key** | Legacy Windows NT password hash | **Broken** for modern password-storage requirements | Fast, unsalted NT hashes make offline password guessing cheap once extracted; MD4 itself has severe cryptographic weaknesses. | **CONFIRMED:** NT hash/MD4 used for AD/NTLM compatibility; reduce NTLM dependency, enforce long passwords/MFA and protect AD credentials. Cannot simply switch native AD password hashes to Argon2. |

## 5. Password Key Derivation and Hashing

| Algorithm | Type | Key / output size (bits) | Primary use case | Status | Why deprecated / broken (if applicable) | MedDefense usage / recommended placement |
|---|---|---|---|---|---|---|
| **PBKDF2 (HMAC-SHA-256)** | KDF / password hashing | Configurable output (e.g. 256 bits), salt commonly ≥128 bits; iteration count configurable | Password-based key derivation, regulated-compatible app password storage | **Current** with high cost and unique salts | —; CPU-hard but not memory-hard, so tune cost and review regularly. | **PROPOSED:** FIPS-constrained application password storage; OWASP guidance ≥600,000 iterations for HMAC-SHA-256 where suitable, benchmark locally [S4]. Not AD's default hash. |
| **bcrypt** | KDF / adaptive password hashing | 128-bit salt; stored hash component ~184 bits; 2^cost work factor | Slow, salted application password verification | **Current for legacy**, **not preferred for new** | Limited to ~72 input bytes in common implementations; lacks Argon2id's memory hardness. | **PROPOSED only for compatible legacy apps:** cost ≥10 subject to testing; not evidenced in MedDefense systems. |
| **Argon2id** | KDF / memory-hard password hashing | Configurable tag (e.g. 256 bits); unique salt commonly 128 bits; memory/time/parallelism knobs | Preferred modern password hashing | **Current** | — | **PROPOSED:** first choice for *new MedDefense applications*, after resource/load testing; OWASP floor 19 MiB, 2 passes, 1 lane [S4]. Not a drop-in replacement for native Windows AD. |
| **scrypt** | KDF / memory-hard password hashing | Configurable derived key (e.g. 256 bits), salt and N/r/p parameters | Password hashing and key derivation with CPU+RAM cost | **Current** | — | **PROPOSED:** fallback if Argon2id unavailable; OWASP example N=2^17, r=8, p=1; not evidenced as deployed. |

**KDF exam note:** A fast checksum such as `SHA256(password)` is inappropriate for password storage; use **unique salts and deliberately expensive password KDFs**. `bcrypt` is backed by a Blowfish-derived construction, but this does **not** make legacy Blowfish-CBC suitable for new file encryption. A KDF's configurable output length is **not** its achieved password-guessing security; password entropy and work factors dominate.

## 6. MedDefense Crypto Gap Analysis — Confirmed Legacy Cryptography

The audit establishes **at least four distinct legacy-crypto/protocol exposures**. It does **not** establish four separately negotiated deprecated *cipher suites*: three relate to distinct primitives (DES, RC4, MD4) and the fourth to the protocol's MD5/SHA-1-based TLS 1.0 PRF. Treat configuration acceptance separately from observed transactions.

| ID | Actual evidence and finding | Old/deprecated component | Target replacement / required change | Validation for closure | Priority |
|---|---|---|---|---|---|
| **GAP-CRYPTO-01** | **CONFIGURED:** AD Kerberos DES enabled; Task 0 Credentials; **1x02 F018**. Actual DES tickets not proved. | **DES, 56-bit** | Audit supported encryption types and service/device accounts; disable DES and move to **AES-128/AES-256 Kerberos**. | KDC issued-ticket events show AES only; service and clinical workflows pass; DES requests denied; tested rollback. | **P1** |
| **GAP-CRYPTO-02** | **CONFIGURED:** AD Kerberos RC4 enabled; Task 0 Credentials; **1x02 F018**. Actual RC4 ticket use needs checking. | **RC4** | Rotate/strengthen vulnerable service-account credentials, inventory RC4 dependency, enable **AES Kerberos** and block RC4 after vendor-safe testing. | KDC event logs show no RC4 service tickets; Kerberoasting exposure reduced; applications pass negative/positive tests. | **P1** |
| **GAP-CRYPTO-03** | **CONFIRMED architecture:** AD stores legacy unsalted NT hashes based on MD4; Task 0 Credentials and 1x00 GAP-011. | **MD4/NT hashes**, NTLM dependency | Reduce/disable **NTLM** where safe, migrate protocols to **Kerberos AES** or stronger identity protocols, deploy MFA and long/unique managed credentials; use Argon2id for *separate custom applications*. | NTLM audit/deny events, documented service transition, offline credential-exposure controls, successful authorized logons. | **P1** |
| **GAP-CRYPTO-04** | **CONFIRMED protocol enabled:** patient portal supports **TLS 1.0**; Task 0 Portal, **1x02 F005**. TLS 1.0 specifies a **MD5+SHA-1 HMAC PRF**; portal's negotiated cipher suites were **not** inventoried. | **Legacy TLS 1.0 protocol** and its MD5/SHA-1-based PRF (not proof of MD5 password hashes) | Enable **TLS 1.3** with ECDHE and **AES-128/256-GCM** or **ChaCha20-Poly1305**; allow hardened TLS 1.2 if required; disable TLS 1.0 and renew/automate the portal certificate. | OpenSSL/SSL Labs accepted/rejected protocol tests; TLS 1.0 rejected, strong TLS succeeds; certificate chain/expiry and patient-client compatibility checked; 1x02 F013. | **P0** |

**Why GAP-CRYPTO-04 qualifies:** RFC 2246 §5 defines the TLS 1.0 PRF as `P_MD5 XOR P_SHA-1`; merely enabling TLS 1.0 preserves this obsolete design [S5]. **Do not misstate this as a standalone MD5 collision attack against HMAC**; the case for migration is the obsolete protocol and lack of modern AEAD guarantees [S6].

### Additional confirmed encryption-control gaps (not claims of deprecated algorithms)

| ID | Confirmed gap | Recommended cryptographic control | Evidence of successful remediation |
|---|---|---|---|
| **GAP-CRYPTO-05** | `ehr-db-01` PostgreSQL data files plaintext on ext4; `hostssl` **and** `hostnossl` allow optional TLS. | Encrypted storage (e.g. LUKS2/AES-XTS with separate key/recovery), enforce TLS for PostgreSQL client connections, validate CA/hostname. | EHR restore test, volume/key custody evidence; TLS session tests and rejection of plaintext DB connections. |
| **GAP-CRYPTO-06** | Billing MySQL plaintext on ext4; app-to-MySQL documented plaintext transport, F006. | Encrypted volumes; **mandatory authenticated TLS 1.2/1.3** for SQL clients; remove insecure DB exposure. | Successful encrypted transactions, plaintext refused, secure key/restore test. |
| **GAP-CRYPTO-07** | PACS images unencrypted on disk and DICOM flows in cleartext on TCP 4242/11112, F024. | Vendor-supported **DICOM over TLS**, certificates and encryption at rest; assess imaging equipment compatibility. | Approved MRI→PACS workflow, patient-study integrity, positive/negative TLS tests and vendor/clinical sign-off. |
| **GAP-CRYPTO-08** | Synology NAS backup data plaintext; optional AES-256-CBC folder feature **disabled**, F015. | Encrypted, **independently recoverable/immutable** backups with key separation and controlled access; evaluate native NAS or external AES-based solution. | Isolated restore and key-recovery exercise; encryption/key-custody evidence; tested backup transport security. |
| **GAP-CRYPTO-09** | Microsoft 365 transport TLS 1.2/managed storage encryption reported, but no S/MIME/OME and sensitive patient content sometimes sent as ordinary messages. | Introduce approved encrypted-message or patient-portal workflow; encrypt in transit **and** at message/content layer where required. | DPO-approved external-recipient test, handling policy, tenant audit evidence. |

### Not confirmed: do not count as production crypto defects without testing

- **3DES, Blowfish and RC4 in the patient portal**: TLS 1.0 is enabled, but no *negotiated* cipher-suite list was supplied. Inventory before asserting any of these is used for portal traffic.
- **SHA-1-signed certificates**: TLS 1.0 uses SHA-1 within its PRF, but this does **not** demonstrate an SHA-1-signed site certificate. Inspect actual certificate signature algorithms.
- **Backup traffic encryption**: NAS transport configuration is undocumented. Its at-rest plaintext is established; cleartext network backup transmission is not.
- **VPN degradation**: Central–Westside/HQ site-to-site tunnels are **REPORTED** to use IKEv2, IPsec AES-256, SHA-256 and DH Group 14; verify peer authentication, firmware, group policy and key lifetimes before any change. Do not label AES-256 or DH-2048 broken.
- **Device support**: do not deploy P-256/ECDHE/TLS settings to BD Alaris pumps, Philips monitors or legacy MRI stations without manufacturer guidance, biomedical acceptance and clinical continuity tests.

## 7. Implementation Sequence and Decision Ownership

1. **P0 portal:** Inventory protocols/cipher suites and certificate lifetime; stage TLS 1.3 and certificate renewal, test patient access and reject TLS 1.0. Owners: Sarah Park/web team + DPO; notify clinical staff.
2. **P1 directory:** Review Kerberos ticket encryption types and service-account compatibility; move DES/RC4 to AES, contain NTLM exposure; plan rollback instead of blanket disabling on medical devices. Owners: AD team, James Chen, Biomedical.
3. **P1 patient/financial systems:** Encrypt EHR and MySQL storage; enforce authenticated database TLS; coordinate maintenance, backup keys and restore tests. Owners: Sarah, application/data owners, Robert Kim for billing.
4. **P1 imaging/recovery:** Introduce vendor-supported DICOM TLS and protected PACS storage, followed by independent encrypted/immutable backup and successful restore. Owners: Radiology, Biomedical and Recovery team.
5. **P2 visibility:** Inventory actual suite negotiation, cert signatures, password schemes, device crypto capabilities and backup link protocols; update Task 0 evidence flags; record exceptions with expiry and compensating controls.

**Acceptance criteria:** No known DES/RC4 service tickets after approved migration; portal refuses TLS 1.0; clinical/billing/database encryption verified through positive and negative tests; signed-off key recovery and restore evidence; no patient care interruption. None of these are claimed completed in this reference.

## 8. Sources and Evidence Traceability

### MedDefense internal baseline (scenario evidence)

- [Task 0 — Cryptographic Inventory](0-crypto_inventory.md), particularly Credentials, Patient Portal, EHR, Billing, PACS, NAS, O365 and VPN sections. The inventory cites Sarah Park's *MedDefense Cryptographic Audit Notes*.
- [1x02 — Vulnerability Triage](../1x02_the_weak_links/16-triage.md): F005 (TLS 1.0), F007 (LDAP signing), F013 (portal certificate), F014 (Westside), F015 (NAS), F018 (Kerberos legacy encryption), F024 (cleartext DICOM), F003/F006 (database reachability).
- [1x00 — Gap Analysis](../1x00_first_watch/12-gap_analysis.md): GAP-011 shared identities/weak MFA; other operational assurance gaps.

### Public technical standards (algorithm guidance, not live deployment evidence)

- **[S1]** [NIST SP 800-57 Part 1 Rev. 5 — Recommendation for Key Management](https://doi.org/10.6028/NIST.SP.800-57pt1r5); [OWASP ASVS Cryptography Appendix](https://github.com/OWASP/ASVS/blob/master/5.0/en/0x92-Appendix-C_Cryptography.md): classical algorithm strength equivalences.
- **[S2]** [NIST: Withdrawal of SP 800-67 / TDEA transition](https://www.nist.gov/news-events/news/2023/06/nist-withdraw-special-publication-800-67-revision-2): TDEA new protection disallowed after 31 December 2023; legacy decryption allowance.
- **[S3]** [RFC 7465 — Prohibiting RC4 Cipher Suites](https://www.rfc-editor.org/info/rfc7465/); [Microsoft — Detect and Remediate RC4 Usage in Kerberos](https://learn.microsoft.com/en-us/windows-server/security/kerberos/detect-remediate-rc4-kerberos): RC4 risk and migration.
- **[S4]** [OWASP Password Storage Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html); [RFC 9106 — Argon2](https://www.rfc-editor.org/info/rfc9106/): Argon2id, scrypt, bcrypt and PBKDF2 operational guidance.
- **[S5]** [RFC 2246 §5 — TLS 1.0 PRF](https://www.rfc-editor.org/info/rfc2246/): HMAC-MD5 and HMAC-SHA-1 construction.
- **[S6]** [RFC 8996 — Deprecating TLS 1.0 and 1.1](https://www.rfc-editor.org/info/rfc8996/); [RFC 8446 — TLS 1.3](https://www.rfc-editor.org/info/rfc8446/): current protocol and cipher-suite guidance.
- **[S7]** [NIST Hash Functions Policy](https://csrc.nist.gov/projects/hash-functions/nist-policy-on-hash-functions): SHA-1 restrictions and SHA-2/SHA-3 recommendations.

**Review caveat:** This document is a reference and proposed control plan. Implementation choices, enterprise algorithm policy, medical-device support, certification requirements and risk acceptance require formal owner approval; closed findings require independent configuration evidence.
