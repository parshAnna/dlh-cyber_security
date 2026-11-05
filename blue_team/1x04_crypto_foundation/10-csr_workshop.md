# MedDefense Health Systems — Task 10: The CSR Workshop

**Project:** 1x04 — Cryptographic Foundation

**Deliverables:** `10-generate_csr.sh`, `10-csr_workshop.md`

**Status:** Fedora lab CSR generated and verified on 5 November 2026; production issuance not attempted

**Audience:** James Chen (Deputy CISO), Sarah Park (IT Director), web operations and DPO

**Baseline:** Patient portal TLS 1.0 remains available (1x02 Finding 005); certificate renewal is not automated (Finding 013 and Task 0). The scenario's “expires in 18 days” is relative to the original audit, **not a verified current expiry countdown**.

## 1. Key Generation Decision (Part 1)

**Decision: ECC P-256 (ECDSA)** for the portal's new private key. P-256 supplies approximately **128 bits of classical security**, compared with about 112 bits for RSA-2048, and its compact keys and efficient authentication operations suit a modern HTTPS service. The stated 800 patient connections per day is not itself a concurrency benchmark or evidence that RSA would be a bottleneck. RSA-4096 would provide a higher security margin than RSA-2048 but incurs greater private-key operation and certificate-size costs, while ECC P-256 offers a balanced modern profile in the Task 6 algorithm landscape. **Compatibility must be tested** across the reverse proxy, load balancers, older patient browsers, and clinical integrations; if a verified client requires RSA, a separately managed RSA certificate may be considered without keeping TLS 1.0 enabled.

| Option | Approximate classical security | Decision basis |
|---|---|---|
| RSA-2048 | 112 bits | Widespread legacy compatibility, but lower security strength than P-256 |
| RSA-4096 | Between 128- and 192-bit NIST reference groups | Larger keys, larger certificates and more expensive private-key operations |
| **ECC P-256** | **128 bits** | **Selected:** smaller keys, modern TLS suitability, efficient authenticated handshakes |

**Actual command used by the automation:**

```bash
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out "$dir/portal_key.pem"
```

This is an ECDSA-capable EC key for signing the TLS handshake, **not** an ECDH key for directly encrypting bulk patient data. Protect the private key with file permissions, restricted identities and secure storage; do not commit or upload it.

## 2. CSR Subject and SAN Design (Part 2)

| Field | CSR value | Reason / evidence status |
|---|---|---|
| `CN` | `portal.meddefense.local` | **Explicit task requirement; internal lab hostname only** |
| `O` | `MedDefense Health Systems` | Required organizational identification in the exercise; CA may not copy it |
| `OU` | `Information Technology` | Required exercise department; public CA certificates generally will not preserve unverified OU |
| `C` | Two-letter country supplied to the script | **MedDefense's legal country was not established** by the supplied fictional environment; do not invent a production address |
| `ST` | State/region supplied to the script | Must be authorized/verified prior to actual CA submission |
| `L` | City/locality supplied to the script | Must be authorized/verified prior to actual CA submission |
| SAN 1 | `DNS:portal.meddefense.local` | Mandatory exact host name for lab CSR |
| SAN 2 | Optional additional DNS argument | Include only an **approved actual alias** for production; `patients.meddefense.local` below is an **illustrative lab-only alias** |
| Key usage | `digitalSignature` (critical) | Appropriate for ECDSA TLS server authentication |
| Extended key usage | `serverAuth` | Requests web server authentication capability |
| Basic constraints | `CA:FALSE` (critical) | Requests an end-entity, not a CA, certificate |

**Issuance blocker:** `.local` is not a publicly registrable DNS name. A public CA such as Let's Encrypt **cannot issue a publicly trusted certificate** for `portal.meddefense.local`. The CSR in this exercise therefore cannot be used for the actual public patient portal: identify MedDefense's **real owned DNS hostname(s)** first, then generate a separate production CSR or have an ACME client generate the request. A private organizational CA could sign an internal `.local` lab certificate only if participating clients explicitly trust that CA; this does **not** solve public patient-browser trust.

**Public CA subject caveat:** A CSR is a *request*, not a promise that the CA copies every attribute. Let's Encrypt issues **DV certificates**, validates domain control and does not use unverified organizational identity fields as OV attributes; the resulting public certificate may not include the CSR's O, OU, L or ST values.

### 2.1 Automation syntax

The script resides in the repository, but writes the private key and CSR **outside the repository**. Its required inputs are: output directory, ISO country code, state, city; a fifth optional argument supplies an explicitly approved second SAN.

```bash
cd ~/dlh-cyber_security/blue_team/1x04_crypto_foundation
bash -n 10-generate_csr.sh
chmod +x 10-generate_csr.sh
./10-generate_csr.sh "$HOME/.local/share/meddefense-crypto/csr_workshop" US "Training State" "Training City" patients.meddefense.local
```

`US`, `Training State`, `Training City` and `patients.meddefense.local` are **fictional training inputs**, not factual MedDefense location or approved patient addresses. For operational work, replace every illustrative value with verified organization and DNS records. The script refuses overwriting either `portal_key.pem` or `portal.csr` and creates private files under a permission-restricted directory.

### 2.2 Equivalent manual OpenSSL commands

The exercise permits command-line subject and extension options as an alternative to a custom `openssl.cnf` file. The following is the equivalent flow inside a protected lab directory; the script performs the same steps.

```bash
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out portal_key.pem
openssl req -new -sha256 -key portal_key.pem -out portal.csr \
  -subj '/C=US/ST=Training State/L=Training City/O=MedDefense Health Systems/OU=Information Technology/CN=portal.meddefense.local' \
  -addext 'subjectAltName=DNS:portal.meddefense.local,DNS:patients.meddefense.local' \
  -addext 'keyUsage=critical,digitalSignature' -addext 'extendedKeyUsage=serverAuth' \
  -addext 'basicConstraints=critical,CA:FALSE'
```

The script does **not** automatically submit the request to a CA, prove domain control or deploy a certificate.

## 3. CSR Inspection and Validation (Part 3)

The following inspection commands were used on Fedora (the additional key-detail command is recommended for independent confirmation):

```bash
cd "$HOME/.local/share/meddefense-crypto/csr_workshop"
openssl req -text -noout -in portal.csr
openssl req -in portal.csr -noout -subject -verify
openssl req -in portal.csr -noout -text | grep -A3 'Subject Alternative Name'
openssl pkey -in portal_key.pem -noout -text | grep -E 'Private-Key:|ASN1 OID:|NIST CURVE:'
stat -c '%a %n' portal_key.pem portal.csr
```

### 3.1 Required verification checklist

- [x] **Subject:** `CN=portal.meddefense.local`, `O=MedDefense Health Systems`, `OU=Information Technology`; `C`, `ST`, `L` equal the **entered lab values**.
- [x] **SAN extension:** includes `DNS:portal.meddefense.local` and the explicitly supplied optional host, if any.
- [ ] **Public key:** `id-ecPublicKey`, **256 bits**, curve P-256 (`prime256v1`/`secp256r1`).
- [ ] **Signature algorithm:** `ecdsa-with-SHA256` for the CSR in the tested OpenSSL environment.
- [ ] **Extensions:** `digitalSignature`, `TLS Web Server Authentication`, `CA:FALSE`.
- [x] **Request self-signature:** `Certificate request self-signature verify OK` (does **not** establish CA trust or domain ownership).
- [x] **Private key handling:** key file owned by the lab user with mode `600`; no private key in Git.

**Independent test evidence:** The 21-line script was independently tested with OpenSSL 3.5.5 in a separate environment before delivery. **Fedora evidence on 5 November 2026:** the user then executed the delivered script and obtained a valid CSR self-signature, the requested subject and two SAN entries, plus restrictive permissions. A full Fedora dump of the public-key algorithm, signature algorithm, EKU and basic constraints has **not yet been pasted**; these extensions are requested by the script but must be checked explicitly before asserting their observed values.

### 3.2 Fedora evidence log — observed 5 November 2026

| Evidence | Observed Fedora output |
|---|---|
| Syntax and size | `bash -n 10-generate_csr.sh` returned without error; `wc -l` = **21** for the script and **156** for the initial report. |
| `openssl req -in portal.csr -noout -subject -verify` | `Certificate request self-signature verify OK` |
| Subject | `C=US, ST=Training State, L=Training City, O=MedDefense Health Systems, OU=Information Technology, CN=portal.meddefense.local` |
| SAN inspection | `DNS:portal.meddefense.local, DNS:patients.meddefense.local` |
| Key usage | `X509v3 Key Usage: critical` and `Digital Signature` |
| Private-key permission | `600 .../csr_workshop/portal_key.pem` |
| CSR permission | `600 .../csr_workshop/portal.csr` |
| Script completion | `LAB CSR created: /home/parshana/.local/share/meddefense-crypto/csr_workshop/portal.csr (not issuable for .local by a public CA)` |
| Public key/CSR signature details | **Await direct Fedora `openssl req -text` inspection**; the script requests an EC P-256 key and SHA-256 CSR signature. |

**Recorded successful command:**

```bash
./10-generate_csr.sh "$HOME/.local/share/meddefense-crypto/csr_workshop" \
  US "Training State" "Training City" patients.meddefense.local
```

**Additional confirmation before production (not yet run on Fedora):**

```bash
openssl req -in "$HOME/.local/share/meddefense-crypto/csr_workshop/portal.csr" \
  -text -noout | grep -E 'Signature Algorithm:|Public Key Algorithm:|Public-Key:|CA:FALSE|TLS Web Server Authentication'
```

The observed CSR signature check confirms that the request was signed consistently with its own public key; it is **not** a CA signature or proof of public trust.

## 4. Full Certificate Lifecycle — Proposed Procedure (Part 4)

**Prerequisites:** Authorization from James Chen does not by itself validate DNS ownership, the legal entity address, clinical availability or access to a public CA. Sarah Park and web operations must establish actual portal hostnames, asset owners, testing/rollback and certificate renewal responsibilities before production work.

1. **CSR generated (done in the lab).** In the restricted environment, verify P-256 key type, exact host SAN list and CSR self-signature; store the private key in a controlled key store or protected service directory. For real public issuance, regenerate for the actual registered FQDN, not `.local`.
2. **Submission to CA.** Choose **Let's Encrypt DV via an approved ACME client** for a public DNS name; a commercial OV CA is an alternative only if verified legal-identity fields are contractually necessary. ACME tools may generate or manage their own CSR/key; do not assume the lab CSR is submitted unchanged. A private CA applies only to devices explicitly configured to trust it.
3. **Validation process.** Complete CA authorization using **HTTP-01** (prove control over port 80 HTTP challenge) or **DNS-01** (automated DNS TXT record). Confirm every SAN against actual patient URLs and DNS ownership; guard DNS API credentials if DNS-01 is selected. `.local` is not a valid public challenge target.
4. **Certificate issuance.** Retrieve the leaf and the correct intermediate chain, verify subject/SAN, public key match, issuer, certificate dates, EKU, transparency expectations and trust path. CA issuance may omit O/OU/L/ST even if those fields appear in a lab CSR.
5. **Installation on the web server.** Deploy leaf/full chain and matching private key to the TLS terminator/reverse proxy, with restrictive permissions and no secrets in the Git repository. Test in staging, preserve a tested rollback path, coordinate clinical/patient access, and favor TLS 1.3 plus approved TLS 1.2 where required; remove TLS 1.0 after compatibility validation.
6. **Verification that the new certificate is serving correctly.** Validate SNI, hostname, SAN, dates, chain and expected cipher/protocol. Run patient login and mobile browser smoke tests, observe web/WAF monitoring, and capture evidence before announcing success.
7. **Decommission of the old certificate.** Remove the prior active certificate/key from live endpoints once successful cutover and rollback requirements are met; securely retire sensitive old key copies under retention policy. **Revoke if compromised**, and verify revocation response. Normal renewal does not automatically mean that an uncompromised prior certificate must be revoked.
8. **Monitoring for the next renewal.** Configure unattended ACME renewal, renewal-failure alerts, expiry monitoring, ownership, documented test/rollback and periodic verification after CA-chain rotations. Let's Encrypt announced a **64-day default lifetime starting 10 February 2027**, followed by **45 days from 16 February 2028**; prefer ACME Renewal Info (ARI) or client guidance over hard-coded 90-day assumptions.

**Suggested post-issuance verification template (not run against MedDefense):**

```bash
openssl s_client -connect '<VERIFIED_PUBLIC_FQDN>:443' -servername '<VERIFIED_PUBLIC_FQDN>' \
  -verify_hostname '<VERIFIED_PUBLIC_FQDN>' -verify_return_error -showcerts </dev/null
```

**Finding linkage:** 1x02 F005 (obsolete TLS), F013 (renewal/expiry risk), Task 0 (patient portal crypto baseline), Task 8 (certificate fields), Task 9 (trust chain and revocation) and 1x03 strategy's clinical validation/monitoring governance. Closure is contingent on production evidence; a successful lab CSR is not remediation.

## 5. Acceptance Criteria and Delivery Checklist

| Requirement | Implementation / evidence |
|---|---|
| P-256 versus RSA decision | Four-sentence rationale and decision table, Section 1 |
| Private-key generation | `openssl genpkey`; restricted output location; script `10-generate_csr.sh` |
| CSR subject and extensions | CN, O, OU, three user-supplied location fields, SAN and TLS EKU in Sections 2–3 |
| CSR text inspection | `openssl req -subject -verify` and SAN/Key Usage observed on Fedora; full algorithm/EKU/CA constraints inspection pending |
| Certificate lifecycle | Eight-step documented plan, Section 4 |
| Script ≤25 lines, `#!/bin/bash` | 21-line tested Bash script; executable permission required in Git |
| Repo hygiene | Commit only `.md` and `.sh`; **never** `portal_key.pem`, `portal.csr`, certificates or optional local configuration containing real org identifiers without review |

## References

- OpenSSL `req` command, CSR extensions, and `-addext`: https://docs.openssl.org/3.4/man1/openssl-req/
- OpenSSL `genpkey` EC curve generation: https://docs.openssl.org/3.0/man1/openssl-genpkey/
- Let's Encrypt challenge methods (HTTP-01 / DNS-01): https://letsencrypt.org/docs/challenge-types/
- Let's Encrypt DV-only product scope: https://letsencrypt.org/docs/faq/
- Public CA restrictions on internal names: https://letsencrypt.org/documents/isrg-cp-v3.0/
- Let's Encrypt 64-day default lifetime announcement (7 October 2026): https://letsencrypt.org/2026/10/07/64-day-certs
- MedDefense project context: `0-crypto_inventory.md`, `6-algorithm_landscape.md`, `8-certificate_anatomy.md`, `9-chain_of_trust.md`, 1x02 F005/F013, and 1x03 strategy.
