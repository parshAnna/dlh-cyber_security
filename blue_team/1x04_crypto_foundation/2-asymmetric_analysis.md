# MedDefense Health Systems — Task 2: The Asymmetric Engine

**Project:** 1x04 — Cryptographic Foundation  
**Deliverable:** `2-asymmetric_analysis.md`  
**Lab platform:** Fedora Linux, OpenSSL 3.5.8 (25 August 2026)  
**Lab observation:** 3 November 2026, approximately 00:02–00:07 local time  
**Status:** Completed local hands-on experiments; no production MedDefense systems changed  
**Scope:** RSA-2048 encryption, ECC P-256 key generation, asymmetric message-size limits, TLS hybrid encryption and algorithm selection

## Executive Findings

1. An **86-byte synthetic patient record** was successfully encrypted using **RSA-2048 with OAEP-SHA256** and recovered with the RSA private key. Both SHA-256 hashes matched, and `cmp` reported no differences.
2. An attempted RSA encryption of the **100 MiB** test file failed with the actual OpenSSL diagnostic **`data too large for key size`**. One RSA-2048 OAEP-SHA256 operation accommodates at most **190 bytes**, not a bulk file.
3. The generated **RSA private PEM was 1,704 bytes**; the **P-256 ECC private PEM was 302 bytes**. The measured **PEM-file-size ratio was 5.64:1**, which is a property of these encodings and keys, not a universal computational-speed ratio.
4. These results support **hybrid encryption**: authenticated asymmetric key establishment and identity verification, followed by fast authenticated symmetric encryption of application traffic.

> **Evidence boundary:** All commands and recorded outputs below are from this user's Fedora terminal session. The patient record is a synthetic lab example; the private keys were generated in a local directory outside the Git repository. Security-strength and protocol descriptions are standards-based explanations, **not claims of live MedDefense configuration or regulatory certification**.

---

## Part 1 — RSA Key Generation, Encryption and Size-Limit Experiment

### 1.1 Environment, paths and inputs

The user began inside `~/dlh-cyber_security/blue_team/1x04_crypto_foundation` and moved the private-key exercises into a separately permission-restricted lab directory:

```bash
cd ~/dlh-cyber_security/blue_team/1x04_crypto_foundation
LAB_SOURCE="$PWD"
mkdir -p "$HOME/.local/share/meddefense-crypto/asymmetric"
chmod 700 "$HOME/.local/share/meddefense-crypto/asymmetric"
cd "$HOME/.local/share/meddefense-crypto/asymmetric"
umask 077
ls -lh "$LAB_SOURCE/patient.txt" "$LAB_SOURCE/testfile"
openssl version
```

**Observed output (relevant lines):**

```text
-rw-------. 1 parshana parshana   86 Nov  2 23:09 .../patient.txt
-rw-------. 1 parshana parshana 100M Nov  2 23:51 .../testfile
OpenSSL 3.5.8 25 Aug 2026 (Library: OpenSSL 3.5.8 25 Aug 2026)
```

The source data came from Task 1: the small text record begins `Patient: Jane Doe` and the large file was generated using `dd if=/dev/urandom of=testfile bs=1M count=100` (100 MiB = 104,857,600 bytes). These files are test fixtures, not production patient records.

### 1.2 Generate an RSA-2048 key pair

```bash
openssl genrsa -out rsa_private.pem 2048
openssl rsa -in rsa_private.pem -pubout -out rsa_public.pem
ls -lh rsa_private.pem rsa_public.pem
```

**Observed output:**

```text
writing RSA key
-rw-------. 1 parshana parshana 1.7K Nov  3 00:04 rsa_private.pem
-rw-------. 1 parshana parshana  451 Nov  3 00:04 rsa_public.pem
```

The public key can be shared for encryption. The private key is needed for decryption and must not be published. This private key is **unencrypted at rest in the local lab**; production private keys require appropriately protected storage, restricted access, rotation/backup policy, and often a key-management system or hardware-backed protection.

### 1.3 Encrypt and decrypt the synthetic patient record

**Encryption with the public key, RSAES-OAEP and SHA-256:**

```bash
openssl pkeyutl -encrypt -pubin \
  -inkey rsa_public.pem \
  -in "$LAB_SOURCE/patient.txt" -out patient.rsa.enc \
  -pkeyopt rsa_padding_mode:oaep \
  -pkeyopt rsa_oaep_md:sha256
```

**Decryption with the private key:**

```bash
openssl pkeyutl -decrypt \
  -inkey rsa_private.pem \
  -in patient.rsa.enc -out patient.rsa.dec.txt \
  -pkeyopt rsa_padding_mode:oaep \
  -pkeyopt rsa_oaep_md:sha256
```

**Integrity-of-recovery check:**

```bash
sha256sum "$LAB_SOURCE/patient.txt" patient.rsa.dec.txt
cmp "$LAB_SOURCE/patient.txt" patient.rsa.dec.txt
```

**Observed output:**

```text
5c0a65d817510020e02ccb5d44ac30e6def0d5bf31b32a604c960aa1d4e03682  /home/parshana/dlh-cyber_security/blue_team/1x04_crypto_foundation/patient.txt
5c0a65d817510020e02ccb5d44ac30e6def0d5bf31b32a604c960aa1d4e03682  patient.rsa.dec.txt
```

`cmp` emitted **no differences**. **Result: PASS.** This demonstrates exact recovery of the laboratory plaintext using the matching private key. A matching hash in this test is not a substitute for a digital signature or authenticated encryption against an active attacker.

### 1.4 Attempt to encrypt 100 MiB directly with RSA

```bash
openssl pkeyutl -encrypt -pubin \
  -inkey rsa_public.pem \
  -in "$LAB_SOURCE/testfile" -out rsa_large.enc \
  -pkeyopt rsa_padding_mode:oaep \
  -pkeyopt rsa_oaep_md:sha256 \
  2> rsa_large_error.txt
cat rsa_large_error.txt
```

**Actual observed error:**

```text
Public Key operation error
00430374607F0000:error:0200006E:rsa routines:ossl_rsa_padding_add_PKCS1_OAEP_mgf1_ex:data too large for key size:crypto/rsa/rsa_oaep.c:107:
```

**Why RSA failed (3 sentences).** RSA encryption operates on a message block smaller than its modulus, and secure OAEP padding reserves additional space for randomness and hashing. For RSA-2048 and SHA-256 OAEP, the maximum single-message plaintext is `256 - 2(32) - 2 = 190 bytes`, whereas the test file contains `104,857,600 bytes`. Consequently, real systems use asymmetric cryptography to establish or protect a **short symmetric secret**, then use a symmetric authenticated cipher to encrypt the bulk data.

**MedDefense relevance:** RSA must not be used to encrypt all 50,000 EHR records or a full NAS backup directly. A validated key-wrapping/key-establishment design and authenticated symmetric data encryption are more appropriate; database-encryption and storage-encryption controls still need threat-model, key-lifecycle, backup and restoration testing.

---

## Part 2 — ECC P-256 Key Generation and Comparison

### 2.1 Generate a P-256 key pair

```bash
openssl ecparam -genkey -name prime256v1 -out ecc_private.pem
openssl ec -in ecc_private.pem -pubout -out ecc_public.pem
```

**Observed output:**

```text
read EC key
writing EC key
```

The OpenSSL name `prime256v1` identifies the NIST **P-256** curve (also called `secp256r1`). ECC keys can support operations such as ECDSA signatures and ECDH key agreement; an ordinary EC public key is **not a drop-in replacement for RSA `pkeyutl -encrypt`**.

### 2.2 Record exact PEM-file sizes and ratio

```bash
stat -c '%n: %s bytes' rsa_private.pem ecc_private.pem
RSA_BYTES=$(stat -c %s rsa_private.pem)
ECC_BYTES=$(stat -c %s ecc_private.pem)
awk -v rsa="$RSA_BYTES" -v ecc="$ECC_BYTES" \
  'BEGIN {printf "RSA/ECC file-size ratio: %.2f:1\n", rsa/ecc}'
```

**Observed output:**

```text
rsa_private.pem: 1704 bytes
ecc_private.pem: 302 bytes
RSA/ECC file-size ratio: 5.64:1
```

**Why the smaller key matters (3 sentences).** RSA security is based on the difficulty of factoring large integers, whereas typical elliptic-curve cryptography relies on the elliptic-curve discrete-logarithm problem, which resists known classical attacks more efficiently per key bit. Accordingly, **RSA-2048 provides roughly 112-bit classical security**, while **ECC P-256 provides roughly 128-bit security**—closer in security strength to RSA-3072, despite the much smaller ECC key. For MedDefense's **BD Alaris pumps and Philips monitors**, smaller public keys and signatures can reduce bandwidth, memory and some computational overhead, but adoption requires verification of firmware, vendor approval, approved curves and protocols, clinical interoperability and key lifecycle; file-size ratio alone does not prove faster execution.

**Important distinction:** A 1,704-byte RSA PEM and a 302-byte ECC PEM include encoding overhead. The measured 5.64:1 comparison is **not** the ratio of 2,048 to 256 key bits, nor a benchmark of handshake speed.

---

## Part 3 — The Hybrid Encryption Model (5 Sentences)

Hybrid encryption combines asymmetric cryptography for authenticated key establishment with symmetric encryption for protecting large amounts of data. In a modern **TLS 1.3** connection, the patient portal and the patient's browser normally use an ephemeral **(EC)DHE key exchange** to derive a shared secret, while a trusted **X.509 certificate and digital signature** authenticate the server rather than using RSA to encrypt the entire session. Both endpoints derive symmetric traffic keys from that shared secret using the TLS key schedule, then an authenticated cipher such as **AES-GCM** or **ChaCha20-Poly1305** encrypts and integrity-protects patient appointments and other HTTPS traffic. This design avoids the challenge of pre-sharing a symmetric key with every patient and the severe performance and message-size limitations of direct RSA encryption, while ephemeral key exchange can provide forward secrecy. For MedDefense, it means the portal's reported **TLS 1.0 (1x02 Finding 005)** must be replaced by a correctly validated modern TLS configuration, including certificate chain, hostname, authentication, supported client compatibility and rollback procedures, before production cutover.

**Protocol accuracy:** Earlier TLS versions could support RSA key transport, but **TLS 1.3 does not use static RSA key transport**; the public-key certificate can still be RSA or ECDSA for authentication. Neither stand-alone unauthenticated Diffie–Hellman nor AES encryption without key validation establishes the identity of a legitimate server.

---

## Part 4 — Key-Length, Strength and Suitability Comparison

**Interpretation:** Security-strength estimates below are **approximate classical-bit estimates**, where meaningful, under correct implementation and key handling. **"Suitable?" means appropriate for a new MedDefense security design only with approved modes, properly managed keys, vendor/platform support and applicable organizational/regulatory checks; it is not a claim of automatic healthcare compliance or an individually certified cryptographic module.**

| Algorithm | Type | Key length(s) | Approx. equivalent classical security | Status / suitable for new healthcare protection? | MedDefense usage or decision |
|---|---|---|---|---|---|
| **AES-128** | Symmetric block cipher | 128 bits | ~128 bits | **Yes**, in approved authenticated mode such as GCM; CBC requires separate authenticated integrity protection | TLS 1.3 AEAD option; protected application traffic |
| **AES-192** | Symmetric block cipher | 192 bits | ~192 bits | **Yes**, with approved mode and key lifecycle | Possible approved encryption at rest where supported; not an assumed TLS 1.3 default |
| **AES-256** | Symmetric block cipher | 256 bits | ~256 bits | **Yes**, with suitable mode (e.g. GCM for AEAD, XTS for disk sectors in the appropriate threat model) | EHR application-layer data, encrypted backups, secure transport; choose deployment-specific mode |
| **RSA-2048** | Asymmetric (encryption/signatures) | 2,048 bits | ~112 bits | **Conditional/transitioning**, still supported in many deployments; not preferable for long-lived new high-assurance designs | RSA-OAEP demonstration; verify certificate lifecycle and migrate as required by policy |
| **RSA-4096** | Asymmetric (encryption/signatures) | 4,096 bits | Greater than 128, less than 192 bits (often estimated ~150) | **Yes where appropriate**, but larger keys/signatures and higher processing cost | Potential server certificate/signature compatibility; evaluate instead of assuming it is ideal for medical devices |
| **ECC P-256** | Asymmetric (ECDH/ECDSA) | 256-bit curve/order family | ~128 bits | **Yes**, with vetted curve, authenticated exchange and sound nonce/secret handling | Efficient TLS key exchange and certificates where supported; medical devices only after vendor review |
| **ECC P-384** | Asymmetric (ECDH/ECDSA) | 384-bit curve/order family | ~192 bits | **Yes**, with vetted implementation | Higher-strength certificate/key-establishment option for supported services |
| **DES** | Symmetric block cipher | 56-bit effective key | ~56 bits, insecure | **No** — obsolete and practically brute-forceable | Remove legacy DES use from AD/Kerberos configuration after dependency and clinical testing (1x02 Finding 018) |
| **3DES / TDEA** | Symmetric block cipher | 112/168 nominal bits (two-/three-key variants) | Up to ~112-bit strength for three-key TDEA; constrained by 64-bit blocks | **No for new encryption** under NIST; limited legacy decryption only | Migrate any legacy endpoint/financial protocols; do not deploy for new EHR or backup protection |
| **ChaCha20-Poly1305** | Symmetric authenticated stream cipher (AEAD) | 256-bit encryption key; 128-bit tag | ~256-bit key-search security; authentication constrained by tag/usage bounds | **Yes where protocol and policy permit**; ensure nonce uniqueness and vetted libraries | TLS 1.3 alternative to AES-GCM, especially on endpoints without AES acceleration |
| **RC4** | Symmetric stream cipher | Variable, historically often 40/128 bits | **No trustworthy equivalent today** due to exploitable keystream biases | **No** — forbidden for TLS negotiation | Exclude from legacy portal/VPN cipher lists; never use for patient records |

**Healthcare suitability note:** Algorithms are not universally "HIPAA-approved" or "GDPR-approved" in isolation; legal applicability, verified implementations, data classification, authenticated protocols, access control, key custody and documented risk decisions determine the defensibility of the complete system. In Luxembourg, clinical change and data-protection review remain required for MedDefense's EHR, image-processing and medical-device workflows.

### Standards consulted for the analysis (not live scan results)

1. **NIST SP 800-57 Part 1 Rev. 5 — Recommendation for Key Management**, classical security-strength groupings (RSA-2048 ~112; RSA-3072 and ECC P-256 ~128; ECC P-384 ~192): <https://doi.org/10.6028/NIST.SP.800-57pt1r5>
2. **NIST SP 800-131A Rev. 2 — Algorithm and Key-Length Transitions**, including the disallowance of TDEA for new encryption after 2023: <https://csrc.nist.gov/pubs/sp/800/131/a/r2/final>
3. **RFC 8446 — TLS 1.3**, key exchange, server authentication, HKDF and AEAD record encryption: <https://www.rfc-editor.org/rfc/rfc8446>
4. **RFC 7465 — Prohibiting RC4 Cipher Suites**, RC4 exclusion from TLS: <https://www.rfc-editor.org/rfc/rfc7465>

### Links to MedDefense project evidence

- [1x04 Task 0 — Crypto Inventory](0-crypto_inventory.md): inventory of EHR, billing, PACS, AD, backup, email and VPN cryptographic states.
- [1x03 Task 17 — Security Strategy](../1x03_defense_blueprint/17-security_strategy.md): proposed cryptographic workstream, clinical approvals and 1x04 handoff.
- [1x03 Task 10 — Risk Register](../1x03_defense_blueprint/10-risk_register.md): EHR, PACS, MRI, device and ransomware risks; treatments remain subject to validation.
- [1x02 Task 16 — Triage](../1x02_the_weak_links/16-triage.md): legacy patient portal TLS, NAS protection, AD/Kerberos weaknesses and unencrypted DICOM transport (including Findings 005, 015, 018 and 024 as relevant).

## Lab Safety, Evidence Integrity and Next Actions

- **Never commit** `rsa_private.pem`, `ecc_private.pem`, patient plaintext, ciphertext fixtures or the 100 MiB random file. Preserve only the nonsecret Markdown analysis and any separately authorized, sanitized evidence.
- Retain the original failure text as proof that `pkeyutl` rejected oversized RSA-OAEP input. Do not fabricate a successful large-file RSA operation or confuse ECC ECDH with public-key encryption.
- For production, select authenticated encryption and protect keys separately from datasets and backups; plan key loss/recovery, rotation, retention and cryptographic agility.
- The lab did **not** validate a production TLS negotiation, measure ECC handshake performance or alter MedDefense medical devices. These require independent planned tests and clinical/vendor authorization.

**Task 2 evidence conclusion:** RSA-OAEP small-message round trip **PASS**; RSA-OAEP bulk-input rejection **OBSERVED**; ECC P-256 key generation **PASS**; private-PEM size ratio **5.64:1**; hybrid TLS architecture **EXPLAINED**, not deployed.
