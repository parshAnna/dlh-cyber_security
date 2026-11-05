# MedDefense Health Systems — Task 8: The Certificate Anatomy

- **Project:** 1x04 — Cryptographic Foundation
- **Deliverable:** `8-certificate_anatomy.md`
- **Assessment date:** 5 November 2026 (Fedora local capture; X.509 validity dates are GMT/UTC)
- **Tools:** OpenSSL 3.5.8 (25 August 2026), `s_client`, `x509`
- **Scope:** Three live TLS server leaf certificates and a proposed certificate profile for the MedDefense patient portal
- **Evidence classification:** Observed terminal results versus proposed MedDefense controls are explicitly distinguished. No MedDefense production change was performed.

## 1. Methodology and Recorded Commands

The three *leaf* certificates were retrieved from live HTTPS endpoints with Server Name Indication (SNI), saved as PEM, then decoded using `openssl x509`. The OpenSSL default trust store and hostname checks were applied separately using `-verify_return_error`.

```bash
mkdir -p ~/.local/share/meddefense-crypto/cert_anatomy
cd ~/.local/share/meddefense-crypto/cert_anatomy
openssl version
```

**Observed:** `OpenSSL 3.5.8 25 Aug 2026 (Library: OpenSSL 3.5.8 25 Aug 2026)`.

```bash
openssl s_client -connect letsencrypt.org:443 -servername letsencrypt.org -showcerts </dev/null 2> le_handshake.log | openssl x509 -outform PEM > le.pem
openssl s_client -connect github.com:443 -servername github.com -showcerts </dev/null 2> github_handshake.log | openssl x509 -outform PEM > github.pem
openssl s_client -connect expired.badssl.com:443 -servername expired.badssl.com -showcerts </dev/null 2> expired_handshake.log | openssl x509 -outform PEM > expired.pem
```

**Observed files:** `le.pem` 1.5K, `github.pem` 1.4K, `expired.pem` 1.9K (`ls -lh`; rounded display sizes).

```bash
openssl x509 -in le.pem -text -noout > le_details.txt
openssl x509 -in github.pem -text -noout > github_details.txt
openssl x509 -in expired.pem -text -noout > expired_details.txt
```

```bash
openssl x509 -in le.pem -noout -subject -issuer -dates -serial
openssl x509 -in github.pem -noout -subject -issuer -dates -serial
openssl x509 -in expired.pem -noout -subject -issuer -dates -serial
```

```bash
openssl x509 -in le.pem -noout -ext subjectAltName,keyUsage,extendedKeyUsage,authorityInfoAccess
openssl x509 -in github.pem -noout -ext subjectAltName,keyUsage,extendedKeyUsage,authorityInfoAccess
openssl x509 -in expired.pem -noout -ext subjectAltName,keyUsage,extendedKeyUsage,authorityInfoAccess
```

```bash
grep -E 'Signature Algorithm:|Public Key Algorithm:|Public-Key:' le_details.txt
grep -E 'Signature Algorithm:|Public Key Algorithm:|Public-Key:' github_details.txt
grep -E 'Signature Algorithm:|Public Key Algorithm:|Public-Key:' expired_details.txt
```

### 1.1 Comparative summary: actual leaf certificates

| Field | `letsencrypt.org` | `github.com` | `expired.badssl.com` |
|---|---|---|---|
| Subject CN | `letsencrypt.org` | `github.com` | `*.badssl.com` |
| Subject O / L / ST / C | Not present in observed Subject | Not present in observed Subject | O, L, ST, C not present; **OU:** `Domain Control Validated`, `PositiveSSL Wildcard` |
| Issuer | `C=US, O=Let's Encrypt, CN=YE2` | `C=GB, O=Sectigo Limited, CN=Sectigo Public Server Authentication CA DV E36` | `C=GB, ST=Greater Manchester, L=Salford, O=COMODO CA Limited, CN=COMODO RSA Domain Validation Secure Server CA` |
| Not Before (UTC) | `Nov 3 13:44:34 2026 GMT` | `Oct 30 00:00:00 2026 GMT` | `Apr 9 00:00:00 2015 GMT` |
| Not After (UTC) | `Feb 1 13:44:33 2027 GMT` | `Jan 27 23:59:59 2027 GMT` | `Apr 12 23:59:59 2015 GMT` |
| Serial number | `05688C92AD512A3678DB6355831A0BFBBD32` | `3E1D6026B4B0AEA279DCA2EFBBCED82B` | `4AE79549FA9ABE3F100F17A478E16909` |
| Certificate signature algorithm | `ecdsa-with-SHA384` | `ecdsa-with-SHA256` | `sha256WithRSAEncryption` |
| Subject public-key algorithm / size | `id-ecPublicKey` / 256-bit EC | `id-ecPublicKey` / 256-bit EC | `rsaEncryption` / 2048-bit RSA |
| Key Usage | **Critical**: Digital Signature | **Critical**: Digital Signature | **Critical**: Digital Signature, Key Encipherment |
| Extended Key Usage | TLS Web Server Authentication | TLS Web Server Authentication | TLS Web Server Authentication; TLS Web Client Authentication |
| AIA: CA Issuers | `http://ye2.i.lencr.org/` | `http://crt.sectigo.com/SectigoPublicServerAuthenticationCADVE36.crt` | `http://crt.comodoca.com/COMODORSADomainValidationSecureServerCA.crt` |
| AIA: OCSP | No OCSP URI shown in observed AIA | `http://ocsp.sectigo.com` | `http://ocsp.comodoca.com` |
| Live verification | **OK**, name matched | **OK**, name matched | **Failed**, expired (code 10) |

**Interpretation:** `Subject` and `Issuer` describe *different parties*. Absent Subject organization/location fields are normal for a domain-validated certificate. The `Signature Algorithm` describes how the issuing CA signed the certificate, not how the server encrypts application traffic. AIA may omit an OCSP URL; absence alone is not a failed validity check.

### 1.2 All Subject Alternative Names (SAN)

- **Let's Encrypt endpoint:** `cp.letsencrypt.org`, `cp.root-x1.letsencrypt.org`, `cps.letsencrypt.org`, `cps.root-x1.letsencrypt.org`, `lencr.org`, `letsencrypt.com`, `letsencrypt.org`, `www.lencr.org`, `www.letsencrypt.com`, `www.letsencrypt.org`.
- **GitHub:** `github.com`, `www.github.com`.
- **Expired BadSSL:** `*.badssl.com`, `badssl.com`. The wildcard covers the one-label host `expired.badssl.com`; the demonstrated defect is **expiry**, not a hostname mismatch.

### 1.3 Validation of the two legitimate websites

```bash
openssl s_client -brief -connect letsencrypt.org:443 -servername letsencrypt.org -verify_hostname letsencrypt.org -verify_return_error </dev/null
openssl s_client -brief -connect github.com:443 -servername github.com -verify_hostname github.com -verify_return_error </dev/null
```

**Observed for both:** `CONNECTION ESTABLISHED`; `Protocol version: TLSv1.3`; `Ciphersuite: TLS_AES_128_GCM_SHA256`; `Verification: OK`; hostname verified (`letsencrypt.org` / `github.com`); `Peer Temp Key: X25519, 253 bits`; `DONE`.

**Distinguish three layers:** The certificate issuer's signature algorithm is ECDSA/SHA-384 or ECDSA/SHA-256; the subject's public key is EC-256; the *negotiated TLS data cipher* in these sessions is AES-128-GCM. The temporary X25519 key is for ephemeral key agreement, not the certificate's subject public key. These are separate cryptographic roles.

## 2. Broken Certificate Diagnosis: `expired.badssl.com`

### 2.1 Reproduction command and observed output

```bash
openssl s_client -brief -connect expired.badssl.com:443 -servername expired.badssl.com -verify_hostname expired.badssl.com -verify_return_error </dev/null
```

```text
Connecting to 104.154.89.105
depth=0 OU=Domain Control Validated, OU=PositiveSSL Wildcard, CN=*.badssl.com
verify error:num=10:certificate has expired
notAfter=Apr 12 23:59:59 2015 GMT
...:SSL routines:tls_post_process_server_certificate:certificate verify failed:ssl/statem/statem_clnt.c:2124:
```

The exact OpenSSL error prefix/hex address is process-specific; the stable evidence is **`verify error:num=10:certificate has expired`** and **`certificate verify failed`**. The certificate's validity ended on **12 April 2015**, well before the 5 November 2026 test. SNI and hostname checks were supplied, and the SAN covers `expired.badssl.com`; no separate wrong-host error was observed.

### 2.2 Browser warning, risk and patient decision

A browser will normally display a privacy/security interstitial such as **"Your connection is not private"** and a certificate-date error, often `NET::ERR_CERT_DATE_INVALID` in Chromium-based browsers; actual wording depends on browser and platform. An expired certificate means the browser cannot establish that the presented certificate remains valid; **expiry alone does not prove an attacker is present or that traffic was already disclosed**. If patients bypass the warning, they lose an essential assurance that the site is currently authenticated and might expose credentials or health data to an impersonating service. **Patients should not proceed or enter credentials/medical information**; IT should restore a trusted, correctly named and currently valid certificate, verify the chain, and confirm that automated renewals work.

## 3. Proposed MedDefense Patient Portal Certificate Profile

| Decision field | Recommendation | Rationale / verification |
|---|---|---|
| Type | **DV** (domain-validated) for routine public HTTPS; assess **OV** only if organizational identity validation is a documented business/legal requirement; **EV** not required by default. | TLS validation proves control of the hostname, not clinical accreditation, quality of care, or patient identity. OV/EV provide additional applicant validation but do not replace HTTPS configuration. |
| Certificate authority | A publicly trusted CA, with **Let's Encrypt** as a practical default. | Automated issuance/renewal via ACME, trust-store compatibility, auditable operations; procure a commercial CA if justified by contracts or operational constraints. |
| CN / SAN | Use the **real, DNS-verified portal FQDN** as a SAN (`portal.<verified-domain>` is a *placeholder*, **not an asserted MedDefense hostname**). Add only necessary independently controlled DNS names. | Browsers validate the requested host against SAN. Do not invent production DNS names; verify all patient login URLs before ordering. |
| Public key | **ECDSA P-256**, with **RSA-2048 or RSA-3072** as compatibility fallback if required by tested client infrastructure. | Modern, efficient server authentication with suitable performance; test supported versions across patient clients, load balancers and clinical integrations. |
| Signature / KU / EKU | CA-approved SHA-256-or-better signature; `digitalSignature` KU; `serverAuth` EKU; correct `basicConstraints CA:FALSE`. | Make the certificate fit TLS server authentication; rely on CA profile and validated chain. |
| Validity | **Short-lived, automatically renewed**, no fixed calendar assumption in deployment logic. | The live LE certificate observed had ~90-day validity; LE announced **64-day default issuance from 10 February 2027** and **45-day default from 16 February 2028**. Trigger renewal early and monitor issuance failures. |
| Wildcard or single domain | **Specific-host certificate**; avoid broad wildcard unless multiple required hosts and threat model justify it. | Limits unnecessary private-key sharing and hostname scope; no need to expose unrelated services. |
| Private-key protection | Restrict filesystem/HSM access, use service identities, avoid repository/backup plaintext copies, define secure backup/recovery and rotation. | A valid certificate cannot compensate for theft of its matching private key. |
| Transport configuration | Prefer **TLS 1.3**; allow strong TLS 1.2 if needed for verified clients; disable TLS 1.0/1.1 and obsolete cipher suites after clinical compatibility testing. | Task 0 identified portal TLS 1.0 as enabled (1x02 Finding 005). Test access and rollback before cutover. |
| Operations | ACME renewal, monitoring/alerting, pre-expiry validation, certificate chain/hostname testing, CT observability, documented incident response and rollback. | Task 0/Finding 013 reported a certificate due to expire within **18 days of the original audit**, with no automatic renewal; this is historical context, **not a verified live expiry date**. |

### 3.1 Example validation procedure for a production change (not executed)

```bash
openssl s_client -connect '<ACTUAL_PORTAL_FQDN>:443' -servername '<ACTUAL_PORTAL_FQDN>' -verify_hostname '<ACTUAL_PORTAL_FQDN>' -verify_return_error </dev/null
```

Before and after replacement: verify the approved hostname and SAN, chain to trusted root, current validity, correct server-auth EKU, secure cipher suites, expiry alerts and successful patient workflow. Test a wrong-host/expired negative case in staging. Coordinate change windows with clinical leadership and the DPO; never advise patients to click through warnings.

## 4. MedDefense Findings, Ownership and Closure Evidence

| Reference | Baseline observation | Proposed action | Evidence for closure |
|---|---|---|---|
| **1x02 F005 / Task 0** | Patient portal accepts TLS 1.0 alongside TLS 1.2. | Inventory clients and suites; enforce TLS 1.3/strong TLS 1.2 with approved fallback testing. | `s_client` positive and downgrade-negative tests; verified patient logins. |
| **1x02 F013 / Task 0** | Portal certificate near expiry at audit time; no auto-renewal. | Stage and deploy a valid SAN-matching CA-issued certificate; enable automated renewal. | `notAfter`, chain, SAN, renewal logs, monitoring alert test. |
| **1x03 Defense Blueprint** | Security strategy prioritizes protective controls, evidence, risk ownership and clinically safe implementation. | Sarah Park/Web owner implements; James Chen reviews security; DPO and clinical owner approve patient-impacting changes. | Change ticket, rollback steps, approvals and test results. |

**Status:** This document records successful real-world **third-party** certificate inspection; no evidence is provided that the MedDefense portal's actual certificate has been retrieved or replaced.

## 5. Sources and Evidence Provenance

1. **User-observed Fedora outputs, 5 November 2026:** OpenSSL 3.5.8; certificate Subject/Issuer/dates/serial; SAN/KU/EKU/AIA; signature and public-key algorithm; hostname-and-chain checks for `letsencrypt.org` and `github.com`; expiry verification error for `expired.badssl.com`. These observations support all certificate-specific values above.
2. **MedDefense Task 0:** `0-crypto_inventory.md`, patient portal section and 1x02 Findings 005/013. These describe a historical assessment, not a fresh portal scan.
3. **RFC 5280 — Internet X.509 Public Key Infrastructure Certificate and CRL Profile:** <https://www.rfc-editor.org/rfc/rfc5280>. Defines certificate fields, extensions, SAN, Key Usage and Extended Key Usage.
4. **Let's Encrypt — 64-Day Certificate Lifetimes Coming Feb 2027 (7 October 2026):** <https://letsencrypt.org/2026/10/07/64-day-certs>. Announces the 64-day default on 10 February 2027 and recommends automated renewal and ACME Renewal Info.
5. **Let's Encrypt — Upcoming Features:** <https://letsencrypt.org/upcoming-features/>. Lists the planned 45-day validity stage on 16 February 2028.

**Assessment conclusion:** Both live legitimate hosts presented trusted, hostname-matching certificates and negotiated TLS 1.3 during the test. The BadSSL example failed certificate validation because it expired in April 2015. MedDefense should deploy a trusted, narrowly scoped, automatically renewed certificate and remove legacy transport versions through a controlled, clinically tested change process.
