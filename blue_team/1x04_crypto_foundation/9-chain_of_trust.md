# MedDefense Health Systems — Task 9: The Chain of Trust

- **Project:** 1x04 Cryptographic Foundation
- **Assessment date:** 5 November 2026
- **Environment:** Fedora Linux, OpenSSL 3.5.8
- **Target:** `github.com:443` (public TLS certificate chain; no MedDefense production systems tested)
- **Document status:** Completed lab analysis, based on observed Fedora command output
- **Audience:** James Chen (Deputy CISO), Sarah Park (IT Director), and MedDefense technical stakeholders

## Executive Result

- GitHub transmitted **three PEM certificates**: a leaf, an issuing intermediate, and a **cross-signed** Sectigo Root E46 certificate that can act as an intermediate for an alternative chain.
- OpenSSL successfully verified the leaf with the supplied intermediate certificates and Fedora's TLS CA bundle: **`chain-01.pem: OK`**, exit **0**.
- Removing the intermediates from the verification inputs produced **`error 20 at 0 depth lookup: unable to get local issuer certificate`**, exit **2**.
- OpenSSL's successful *selected trust path* ended at **Sectigo Public Server Authentication Root E46**, a certificate trusted locally. This is distinct from assuming that the third *server-sent* certificate is itself a self-signed root.
- Fedora reported **395 `trust` CA-anchor listings** and **121 certificates in the extracted TLS PEM bundle**. These are counts of different views; **395 is not proven to be 395 unique TLS-trusted root CAs**.

## Part 1 — Capture and Inspect the Server-Sent Chain

### 1.1 Commands

```bash
mkdir -p ~/.local/share/meddefense-crypto/chain_of_trust
cd ~/.local/share/meddefense-crypto/chain_of_trust
umask 077
openssl s_client -connect github.com:443 \
  -servername github.com -showcerts </dev/null > github_chain.txt 2>&1
```

Extract the certificates in server-supplied order, without extracting any private keys:

```bash
awk '
/-----BEGIN CERTIFICATE-----/ {n++; f=sprintf("chain-%02d.pem",n); active=1}
active {print > f}
/-----END CERTIFICATE-----/ {if(active) {close(f); active=0}}
END {print "Certificates sent by server:",n}
' github_chain.txt
ls -lh chain-*.pem
```

**Observed output:**

```text
Certificates sent by server: 3
chain-01.pem  1.4K
chain-02.pem  1.3K
chain-03.pem  1.2K
```

Inspect each certificate:

```bash
openssl x509 -in chain-01.pem -noout -subject -issuer -dates
openssl x509 -in chain-02.pem -noout -subject -issuer -dates
openssl x509 -in chain-03.pem -noout -subject -issuer -dates
openssl x509 -in chain-03.pem -noout -ext basicConstraints
```

### 1.2 Observed certificate identities and dates

| File | Role in transmitted bundle | Subject | Issuer | Valid from (UTC) | Valid until (UTC) |
|---|---|---|---|---|---|
| `chain-01.pem` | **Leaf / end-entity** | `CN=github.com` | `C=GB, O=Sectigo Limited, CN=Sectigo Public Server Authentication CA DV E36` | 2026-10-30 00:00:00 | 2027-01-27 23:59:59 |
| `chain-02.pem` | **Issuing intermediate CA** | `C=GB, O=Sectigo Limited, CN=Sectigo Public Server Authentication CA DV E36` | `C=GB, O=Sectigo Limited, CN=Sectigo Public Server Authentication Root E46` | 2021-03-22 00:00:00 | 2036-03-21 23:59:59 |
| `chain-03.pem` | **Cross-signed CA certificate** (acts as an intermediate in a legacy path) | `C=GB, O=Sectigo Limited, CN=Sectigo Public Server Authentication Root E46` | `C=US, ST=New Jersey, L=Jersey City, O=The USERTRUST Network, CN=USERTrust ECC Certification Authority` | 2021-03-22 00:00:00 | 2038-01-18 23:59:59 |

The third certificate has **`X509v3 Basic Constraints: critical`** and **`CA:TRUE`**. Despite `Root` in its subject name, its issuer is **different from its subject**, so this particular certificate is **not self-signed**. It is a **cross-certificate**: Sectigo's E46 subject/key is certified by USERTrust ECC to provide an alternative trust path for clients without the newer E46 self-signed root. This is documented in Sectigo's own CA migration material [1].

**Distinguished-name linkage:**

1. Leaf **Issuer** = `Sectigo Public Server Authentication CA DV E36` = intermediate (`chain-02`) **Subject**.
2. Intermediate **Issuer** = `Sectigo Public Server Authentication Root E46` = cross-certificate (`chain-03`) **Subject**.
3. Cross-certificate **Issuer** = `USERTrust ECC Certification Authority`; the corresponding USERTrust root was **not among the three certificates sent by GitHub**. It may be available from client trust stores for an alternative path.

**Important:** Servers normally send their leaf and necessary intermediates, not a self-signed trust anchor. The three transmitted objects are not evidence that GitHub sent a self-signed root; nor must a client necessarily use every certificate the server transmits. An alternate chain to USERTrust was **not independently verified in this lab**.

## Part 2 — Manual Certificate Chain Verification

### 2.1 Prepare intermediate bundle

```bash
awk '
/-----BEGIN CERTIFICATE-----/ {n++; active=1}
active && n>1 {print}
/-----END CERTIFICATE-----/ {active=0}
' github_chain.txt > intermediates.pem
```

### 2.2 Verify with the intermediates

```bash
openssl verify -show_chain \
  -no-CApath -no-CAstore \
  -CAfile /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem \
  -untrusted intermediates.pem \
  -verify_hostname github.com \
  -purpose sslserver chain-01.pem
echo "Exit code: $?"
```

**Exact observed result:**

```text
chain-01.pem: OK
Chain:
depth=0: CN=github.com (untrusted)
depth=1: C=GB, O=Sectigo Limited, CN=Sectigo Public Server Authentication CA DV E36 (untrusted)
depth=2: C=GB, O=Sectigo Limited, CN=Sectigo Public Server Authentication Root E46
Exit code: 0
```

**Interpretation:** The `untrusted` labels mark untrusted *input certificates*, not a verdict that the leaf is fraudulent. OpenSSL built a valid path to **a trusted E46 certificate in Fedora's CA bundle**. Its chosen path terminates at E46; it does **not** show a further hop to USERTrust, and does not establish that `chain-03.pem` was used. The self-signed E46 root and the cross-signed E46 certificate can share subject and public key while having different issuers [1, 2].

### 2.3 Repeat without the intermediates

```bash
openssl verify \
  -no-CApath -no-CAstore \
  -CAfile /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem \
  -verify_hostname github.com \
  -purpose sslserver chain-01.pem
echo "Exit code: $?"
```

**Exact observed result:**

```text
CN=github.com
error 20 at 0 depth lookup: unable to get local issuer certificate
error chain-01.pem: verification failed
Exit code: 2
```

**Explanation (three sentences):** A valid-looking server certificate does not prove its own issuer's identity; the verifier must have a complete path of authenticated signatures to a trusted CA. When the intermediate was omitted from the controlled OpenSSL test, Fedora could not locate the certificate that issued the GitHub leaf, so it refused to build the chain. Production servers should provide the required intermediate certificates because browsers and clients cannot safely depend on intermediates already being cached or retrieved through optional mechanisms.

**Scope limitation:** `openssl verify` in these commands checks the certificate path, validity and hostname for the specified purpose. It **does not demonstrate revocation checking**, which requires an appropriate additional status-checking method/configuration [3].

## Part 3 — Certificate Revocation: CRL, OCSP, and Stapling

| Mechanism | How it works | Main strength | Main limitation |
|---|---|---|---|
| **CRL — Certificate Revocation List** | An issuer publishes a signed list of revoked certificate serial numbers. The client obtains a current CRL, validates its signature, issuer, scope and update times, and checks whether the presented certificate is listed. | Can be cached and distributed without revealing each site's access to a live responder. | Lists can become large; revocation visibility depends on publication, freshness (`thisUpdate`/`nextUpdate`), caching and client support [3]. |
| **OCSP — Online Certificate Status Protocol** | A client queries an authorized responder about a specific certificate and validates the signed `good`, `revoked`, or `unknown` status response and its freshness. | Usually more targeted than downloading a whole CRL. | Responder availability, privacy leakage, stale status and client soft-fail behavior can undermine protection [4]. |
| **OCSP Stapling** | A TLS server attaches a recent CA-authorized OCSP response to its handshake so clients may validate status without a direct query to the responder. | Reduces client-responder traffic and related privacy/availability costs. | Requires participating CA, server and client support; not a universal substitute for all revocation mechanisms. |

**Current CA caveat:** Let's Encrypt **ended its OCSP service on 6 August 2025** and publishes revocation information via **CRLs**. Do not require Let's Encrypt OCSP stapling as a mandatory MedDefense deployment test; align tests with the selected CA's currently supported revocation mechanisms [5].

### 3.1 MedDefense patient-portal private-key compromise playbook

**Scenario:** The portal's TLS private key is found exposed in a public Git repository. This is a **hypothetical exercise**, not an observed MedDefense incident.

1. **Declare and contain the incident:** notify James Chen, Sarah Park, the incident-response lead and DPO; preserve the repository exposure, access logs, timestamps and available evidence. Treat the key as compromised even if the public commit is later deleted.
2. **Stop using the exposed key:** restrict access to the affected host, secrets store, CI jobs and credentials; audit where the key was copied or deployed. Coordinate a safe clinical-access continuity plan.
3. **Revoke promptly:** submit revocation to the issuing CA with reason **`keyCompromise`** using an authorized ACME account or other approved CA process; do not assume a Git commit deletion or issuing a new certificate revokes the old one. Revocation and replacement work should proceed urgently and in parallel where possible [6].
4. **Generate a fresh private key:** use protected key generation and storage with restricted access, backup/escrow procedures and separate trusted administrative credentials. Never reuse the exposed key.
5. **Issue a replacement certificate:** validate control of the correct patient-portal domain, request the minimal necessary SANs, ensure a trusted chain, and use the fresh key for the CSR and deployment.
6. **Deploy and test:** install the new leaf and intermediates; validate hostname, trust path, dates, TLS configuration and clinical login from supported clients. Activate automated renewal and expiry monitoring; avoid preventable patient-care downtime.
7. **Eradicate and investigate:** revoke/reset associated secrets if affected, remove exposed key copies from accessible stores and Git history/mirrors where feasible, scan logs for misuse, and determine whether reporting obligations arise. History rewrite alone cannot recall copies already obtained by an attacker.
8. **Close with evidence:** record CA revocation confirmation, replacement certificate serial/fingerprint, successful verification, completed ownership review, and DPO/clinical/incident sign-off. Verify revocation propagation as supported; do not claim that every relying client performs hard-fail status checking.

## Part 4 — Fedora Trust Store Exploration

### 4.1 Commands used

```bash
ls -l /etc/pki/tls/certs/ca-bundle.crt
trust list --filter=ca-anchors | grep -c '^pkcs11:'
grep -c '^-----BEGIN CERTIFICATE-----' \
  /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem
```

**Exact observed results:**

```text
ls: cannot access '/etc/pki/tls/certs/ca-bundle.crt': No such file or directory
395
121
```

The tested system did **not** contain that legacy symlink/path; the working trust bundle was `/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem`. The `trust` command counted **395 listed CA-anchor records** across its trust view, while the extracted TLS PEM bundle contained **121 certificate PEM blocks**. These different counting methods must not be reported as the same number: the reproducible answer for the **TLS bundle checked in this lab** is **121 certificate entries**, while a definitive count of *unique self-signed roots trusted for all contexts* would require a separate trust-policy and certificate-deduplication audit.

### 4.2 Inspect an example CA certificate

```bash
awk '
/-----BEGIN CERTIFICATE-----/ {active=1}
active {print}
/-----END CERTIFICATE-----/ && active {exit}
' /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem > root_sample.pem
openssl x509 -in root_sample.pem -noout -subject -issuer -dates -serial
openssl x509 -in root_sample.pem -text -noout > root_details.txt
grep -A2 'Basic Constraints' root_details.txt
```

**Exact observed certificate:**

```text
subject=CN=ACCVRAIZ1, OU=PKIACCV, O=ACCV, C=ES
issuer=CN=ACCVRAIZ1, OU=PKIACCV, O=ACCV, C=ES
notBefore=May  5 09:37:37 2011 GMT
notAfter=Dec 31 09:37:37 2030 GMT
serial=5EC3B7A6437FA4E0
X509v3 Basic Constraints: critical
    CA:TRUE
```

**Interpretation:** This Spanish CA certificate has matching subject/issuer and `CA:TRUE`, consistent with a root CA entry. Its approximately **19-year, 8-month validity window** is far longer than a public TLS leaf certificate's lifetime, which is unsurprising: stable trust anchors are designed to support many short-lived end-entity certificates while being updated or distrusted by managed trust-store policy. Equality of subject and issuer does not alone cryptographically prove a self-signature; the lab did not separately verify this root's self-signature.

## MedDefense Recommendations and Evidence Boundaries

1. **Trust-chain deployment:** serve the patient-portal leaf plus required intermediate(s), and validate from a fresh client trust store; do not indiscriminately append unnecessary root certificates.
2. **Separate authentication and revocation:** test both certificate-path/hostname validation and supported revocation mechanisms; the successful GitHub `openssl verify` command was **not** a live CRL or OCSP test.
3. **Automate renewal and continuity:** use approved ACME automation, expiry alerts, safe rollover and documented rollback. Task 0 reported a portal certificate with **18 days remaining relative to its earlier audit**, not an independently established present-day expiry date.
4. **Protect signing material:** keep private keys outside Git, limit host/service access and audit deployment; rehearse `keyCompromise` revocation and replacement.
5. **Clinical dependency:** stage changes with patient-portal and vendor compatibility tests. Maintain DPO, security and clinical sign-off; a certificate replacement must not unnecessarily disrupt patient access.

## References

[1] Sectigo, *New Public Roots and Issuing CAs Hierarchy / Cross-Signing*: <https://support.sectigo.com/Com_KnowledgeDetailPage?Id=kA0Uj0000004IrB>
[2] Sectigo, *Sectigo Root Certificates and Cross-Signing*: <https://www.sectigo.com/knowledge-base/detail/Sectigo-Root-Certificates>
[3] IETF, **RFC 5280**, *Internet X.509 PKI Certificate and CRL Profile*: <https://www.rfc-editor.org/rfc/rfc5280>
[4] IETF, **RFC 6960**, *Online Certificate Status Protocol*: <https://www.rfc-editor.org/rfc/rfc6960>
[5] Let's Encrypt, *OCSP Service Has Reached End of Life* (6 Aug 2025): <https://letsencrypt.org/2025/08/06/ocsp-service-has-reached-end-of-life>
[6] Let's Encrypt, *Revoking Certificates*: <https://letsencrypt.org/docs/revoking/>
[7] OpenSSL, *openssl-verify documentation*: <https://docs.openssl.org/master/man1/openssl-verify/>
[8] MedDefense internal baseline: [Task 0 — Crypto Inventory](0-crypto_inventory.md), [Task 8 — Certificate Anatomy](8-certificate_anatomy.md), and [Project 1x03 Security Strategy](../1x03_defense_blueprint/17-security_strategy.md).

**Completion note:** This document records the user's observed local results and externally sourced protocol/CA background. It does not claim a deployment change, revocation event or live MedDefense certificate validation.
