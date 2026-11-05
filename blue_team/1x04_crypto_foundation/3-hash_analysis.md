# MedDefense Health Systems — Task 3: The Hash Laboratory

**Project:** 1x04 Cryptographic Foundation
**Scope:** Avalanche effect, collision resistance, rainbow tables, password hashing, integrity verification
**Platform:** Fedora Linux; `sha256sum`, `md5sum`, Bash
**Evidence status:** COMPLETE — the learner confirmed all six exact digests on Fedora, supplied two CrackStation result screenshots, and tested both success and failure behavior of the Bash verifier (November 5, 2026). All password material in the demonstration is synthetic; no real credentials or AD secrets were used.

## Executive findings

1. SHA-256 changed 62 of 64 hexadecimal positions and 131 of 256 bits between the specified inputs; MD5 changed 30 of 32 positions and 71 of 128 bits. These are single-pair observations, not proof of overall cryptographic strength.
2. MD5's 128-bit output offers a generic birthday collision complexity of about 2^64 trials, versus about 2^128 for SHA-256. MD5 also has practical cryptanalytic collision weaknesses, so it must not be used for security-sensitive integrity checks.
3. Passwords must be stored with unique random salts and deliberately expensive password-hashing algorithms. Salting defeats generic precomputed tables but does not make weak passwords unguessable.
4. MedDefense should prefer Argon2id for new application password storage. Existing Active Directory NT-hash behavior cannot simply be replaced by an application-specific password hasher; instead harden authentication, passwords, service accounts, Kerberos encryption, and access to domain controllers.
5. The supplied `3-hash_verify.sh` checks a file against a trusted expected SHA-256 digest, prints the required status, and returns exit status 0 or 1.

## Part 1 — The avalanche effect

### Reproducible Fedora commands

```bash
echo -n 'MedDefense' | sha256sum
echo -n 'MedDefense1' | sha256sum
echo -n 'MedDefense' | md5sum
echo -n 'MedDefense1' | md5sum
```

### Exact-byte values verified on Fedora

| Algorithm | Input | Hex digest |
|---|---|---|
| SHA-256 | `MedDefense` | `39e026e107a44b2268e43e16e61033fdcc5d2bd62b23e03aca51db35c8671098` |
| SHA-256 | `MedDefense1` | `97a4141d69cc726a7f6ef577df588d4010c3fe4f235a8bdb616732ba9bf17b92` |
| MD5 | `MedDefense` | `75d47fd4b4d183456d0f98fd9ba6ae4d` |
| MD5 | `MedDefense1` | `0d2aed72043f78c2935e61ba8520306d` |

| Algorithm | Changed hexadecimal positions | Changed output bits | Bit-change percentage |
|---|---:|---:|---:|
| SHA-256 | 62 of 64 | 131 of 256 | 51.17% |
| MD5 | 30 of 32 | 71 of 128 | 55.47% |

**Interpretation:** The avalanche effect means a small input change produces a widespread, unpredictable-looking output change. Approximately half of the **bits** are expected to change for idealized random-looking hashes; the percentage of changed hexadecimal **characters** is not expected to be 50% (two independent random hex characters differ with probability 15/16). Appending one character is not the same as flipping exactly one input bit. A good avalanche result alone does not establish collision resistance: MD5 illustrates that distinction.

## Part 2 — Hash collisions and the birthday problem

| Hash function | Digest length | Possible outputs | Generic birthday collision work |
|---|---:|---:|---:|
| MD5 | 128 bits | 2^128 | Approximately 2^64 trials |
| SHA-256 | 256 bits | 2^256 | Approximately 2^128 trials |

A collision occurs when two distinct inputs produce the same hash, and the birthday paradox means a generic collision search needs on the order of 2^(n/2) samples for an n-bit digest, rather than 2^n. MD5's shorter output therefore offers a much smaller generic collision-security margin than SHA-256; furthermore, MD5 has known practical collision attacks beyond this generic bound. Collision resistance is distinct from reversing a hash or guessing a weak password: an attacker can test password guesses directly without constructing a hash collision. The strength of the hash function, the password's entropy, and the work factor must be assessed separately.

### Connection to MedDefense Finding 018 — weak Kerberos encryption

Kerberos RC4-HMAC derives its long-term key from the **unsalted NT hash** of the account password, which is computed with **MD4**; the encryption type also uses **HMAC-MD5** internally. If MedDefense permits RC4 service tickets, an attacker able to obtain suitable tickets may attempt **offline password guessing (Kerberoasting)**, especially against weak service-account passwords. The relevant practical risk is rapid password-to-key derivation and weak credentials, **not** the MD5 collision result from the avalanche demonstration. Audit Kerberos encryption types and service-account configuration, prefer AES-compatible accounts and services, use managed service accounts and strong randomly generated secrets, and remove RC4 only after testing clinical-system compatibility.

## Part 3 — Rainbow tables, an unsalted hash, and a salted demonstration

### Reproducible commands

```bash
echo -n 'password123' | md5sum
echo -n 's4lt9xQ2:password123' | md5sum
```

| Test | MD5 reference digest | CrackStation result |
|---|---|---|
| Unsalted `password123` | `482c811da5d5b4bc6d497ffa98491e38` | **Cracked / exact match:** `password123` (MD5; green result) |
| Demo salted `s4lt9xQ2:password123` | `6d537fa53f1db2c22b0451ef4ef9fbe8` | **Not found** (CrackStation listed type as `Unknown`; red result) |

**Observed demonstration (November 5, 2026):** The learner submitted both synthetic MD5 hashes at <https://crackstation.net/> and supplied screenshots of the site's responses. The unsalted hash returned `password123` with an exact match; the salted-input digest returned **Not found**, not proof of cryptographic uncrackability. CrackStation is optimized for lookup of unsalted hashes. Never submit production password hashes, credential dumps, or a real user's secrets to a public lookup service.

**Explanation (4 sentences):** An attacker can precompute digests for common passwords once and reuse them against many unsalted accounts, making lookup tables and related precomputation techniques effective. A unique, randomly generated salt changes the input for each account, even when passwords are identical, preventing one shared precomputed table from working across users. Salts are normally stored alongside password hashes and do not need to remain secret; they must, however, be independently generated with sufficient unpredictability and length. This exercise's fixed `s4lt9xQ2` string is illustrative only, and concatenating a salt with MD5 is **not** a secure password-storage design because targeted offline guesses remain fast.

## Part 4 — Key stretching and Active Directory

### bcrypt

bcrypt is a password-hashing function built around the Blowfish key schedule, intentionally performing expensive computation rather than a single fast hash operation. Its cost/work factor grows exponentially (roughly 2^cost), increasing the resources needed for each verification and therefore for offline guessing, although bcrypt is primarily CPU-hard rather than memory-hard. It remains relevant for legacy systems; implementation details such as the common **72-byte password input limit** must be handled correctly.

### PBKDF2

PBKDF2 derives a password-based key through repeated applications of a pseudorandom function such as HMAC-SHA-256, with a salt and an explicit iteration count. More iterations make every candidate password slower to verify or attack, but PBKDF2 is not inherently memory-hard and GPUs/ASICs can still be effective at parallel guessing. OWASP's published starting guidance for FIPS-oriented password storage is **PBKDF2-HMAC-SHA-256 with at least 600,000 iterations**, subject to current policy, application performance, and validation requirements.

### Argon2id

Argon2id is a modern, memory-hard password hashing scheme combining properties of Argon2i and Argon2d to resist multiple practical attack strategies. Its **memory cost**, **time/iteration cost**, and **parallelism** parameters make bulk offline guessing expensive in RAM as well as CPU time. OWASP's published baseline is **19 MiB memory, 2 iterations, and parallelism 1**; production settings should be benchmarked and raised as feasible, without creating denial-of-service risk at login.

### Recommendation for MedDefense applications

Use **Argon2id** with a unique cryptographically random salt per password and a versioned, parameterized hash format for newly developed applications. Where an applicable validated/FIPS requirement rules out a particular Argon2 implementation, evaluate a compliant **PBKDF2-HMAC-SHA-256** implementation with an appropriately high calibrated iteration count. Add breached-password screening, MFA, account lockout/rate limiting, secure secret handling, and periodic parameter re-evaluation. Fast MD5, unsalted SHA-256, and bare NT hashes are not acceptable substitutes for dedicated application password hashing.

### What Active Directory uses by default — and whether it is adequate

Microsoft documents the **NT one-way-function (NT hash)**, calculated using **MD4 over the password's UTF-16LE representation**, as a Windows/Active Directory authentication credential; the NT and historical LM hashes are not salted. The NT hash is held in protected, encrypted form in the AD database and the system may retain additional Kerberos key material, including AES keys; it is inaccurate to say AD simply saves a raw MD5 password hash. This legacy design is not a modern, salted, computationally expensive password-storage scheme, so if credentials or derivable ticket material are exposed, weak passwords are vulnerable to offline guessing. MedDefense should restrict domain-controller access, protect credential material, monitor identity events, deploy MFA where supported, enforce long strong passwords, use gMSAs for services, audit Kerberos ticket encryption, and transition RC4 dependencies to AES after application/device compatibility testing. **Argon2id is a recommendation for MedDefense-managed applications, not a drop-in replacement for Windows AD's built-in NT hash mechanism.**

## Part 5 — Integrity verification script

**Deliverable:** `3-hash_verify.sh` (Bash, executable). The script accepts `FILE EXPECTED_SHA256`, calculates the SHA-256 digest with `sha256sum`, and returns success only on an exact match. The expected digest must come from a trusted source; a matching checksum alone provides **integrity comparison**, not authenticated provenance, when an adversary can replace both file and reference hash.

### Fedora verification checklist

```bash
bash -n 3-hash_verify.sh
printf 'MedDefense' > /tmp/meddefense-hash-lab.txt
sha256sum /tmp/meddefense-hash-lab.txt
./3-hash_verify.sh /tmp/meddefense-hash-lab.txt 39e026e107a44b2268e43e16e61033fdcc5d2bd62b23e03aca51db35c8671098
echo "success exit code: $?"
./3-hash_verify.sh /tmp/meddefense-hash-lab.txt 0000000000000000000000000000000000000000000000000000000000000000
echo "failure exit code: $?"
```

**Observed success on Fedora:** `INTEGRITY OK`; `Exit code: 0`.
**Observed intentional mismatch on Fedora:** `INTEGRITY FAILED - expected 0000000000000000000000000000000000000000000000000000000000000000 got 39e026e107a44b2268e43e16e61033fdcc5d2bd62b23e03aca51db35c8671098`; `Exit code: 1`.
**Additional check:** `bash -n 3-hash_verify.sh` produced no syntax errors. Both cases were run with `/tmp/meddefense-hash-lab.txt` containing exactly `MedDefense` without a newline.

## Risks and clinical implications

- **Patient records, billing records, and forensic images:** Use SHA-256 with a separately trusted signed manifest or authenticated transfer to verify integrity; plain hashes cannot prove who supplied a file.
- **Clinical credentials:** Use slow password hashes for new applications, retain unique salts, and enforce MFA and access restrictions to reduce the consequences of credential compromise.
- **Finding 018 (Kerberos):** Prioritize inventory and monitoring of RC4 ticket issuance, remediation of weak service accounts, and controlled AES migration that avoids disrupting PACS, EHR, pumps, or monitoring workflows.
- **Migration discipline:** Test cryptographic changes in a staging environment; do not disable legacy Kerberos encryption blindly on production medical devices.

## References and research provenance

1. OWASP Cheat Sheet Series, *Password Storage*: <https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html>
2. NIST SP 800-63B, *Digital Identity Guidelines — Authentication and Authenticator Management*: <https://pages.nist.gov/800-63-4/sp800-63b.html>
3. Microsoft Learn, *Passwords technical overview*: <https://learn.microsoft.com/en-us/windows-server/security/kerberos/passwords-technical-overview>
4. Microsoft Learn, *Detect and remediate RC4 usage in Kerberos*: <https://learn.microsoft.com/en-us/windows-server/security/kerberos/detect-remediate-rc4-kerberos>
5. Microsoft Security Blog, *Microsoft's guidance to help mitigate Kerberoasting*: <https://www.microsoft.com/en-us/security/blog/2024/10/11/microsofts-guidance-to-help-mitigate-kerberoasting/>
6. RFC 4757, *The RC4-HMAC Kerberos Encryption Types Used by Microsoft Windows*: <https://www.rfc-editor.org/rfc/rfc4757>
7. CrackStation, *Free Password Hash Cracker — lookup scope and limitations*: <https://crackstation.net/>

---

**Finalization status:** The six hashes, CrackStation lookups, script syntax check, and both exit-code tests have been confirmed. Stage **only** `3-hash_verify.sh` and `3-hash_analysis.md` for Git. Do not commit patient files, password lists, lab inputs/outputs, or credential material.
