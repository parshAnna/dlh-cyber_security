# MedDefense Health Systems — Task 1: The Symmetric Engine

**Project:** 1x04 — Cryptographic Foundation  
**Environment:** Fedora Linux; OpenSSL 3.5.8 (as reported by `openssl speed`)  
**Source of results:** Operator-provided terminal output from 2 November 2026  
**Status:** Lab exercise completed for encryption, decryption, performance measurement and script execution; **not a production rollout**.

## 1. Objective and lab boundaries

Compare AES-256-CBC, AES-128-CBC and AES-256-GCM using a synthetic patient record and a 100 MiB random file. Demonstrate correct decryption, measured performance and a reusable Bash encryption script. **No live patient records, production encryption keys or production systems were used.**

OpenSSL's `enc` interface does **not** support GCM. CBC is tested with password-derived keys using `openssl enc`; GCM is tested with certificate-based `openssl cms` authenticated-enveloped data. These are different file formats and key-management mechanisms, even though both use AES for bulk encryption.

## 2. Part 1 — Encryption and decryption

### Test input

```bash
printf '%s\n' 'Patient: Jane Doe | DOB: 1985-03-14 | MRN: MED-50421 | Diagnosis: Atrial Fibrillation' > patient.txt
```

### Exact encryption commands executed

**AES-256-CBC (password-based; prompted for password twice):**

```bash
openssl enc -aes-256-cbc -salt -pbkdf2 -iter 200000 \
  -in patient.txt -out patient.256cbc.enc
```

**AES-256-GCM (CMS authenticated-enveloped data; lab recipient certificate):**

```bash
openssl cms -encrypt -binary -aes-256-gcm \
  -in patient.txt -out patient.256gcm.cms -outform DER \
  "$HOME/.config/meddefense-crypto/recipient.crt"
```

**AES-128-CBC (password-based; prompted for password twice):**

```bash
openssl enc -aes-128-cbc -salt -pbkdf2 -iter 200000 \
  -in patient.txt -out patient.128cbc.enc
```

**Observed output:** CBC asked for encryption passwords; the CMS command returned to the shell with no output. The presence of ciphertext files and successful downstream decryption supported successful encryption. Neither password nor private key was recorded in this report.

### Exact decryption commands executed

```bash
openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 \
  -in patient.256cbc.enc -out recovered.256cbc.txt
openssl cms -decrypt -binary -inform DER \
  -in patient.256gcm.cms \
  -recip "$HOME/.config/meddefense-crypto/recipient.crt" \
  -inkey "$HOME/.config/meddefense-crypto/recipient.key" \
  -out recovered.gcm.txt
openssl enc -d -aes-128-cbc -pbkdf2 -iter 200000 \
  -in patient.128cbc.enc -out recovered.128cbc.txt
```

**Initial failure (AES-256-CBC):** OpenSSL printed `bad decrypt` / `ossl_cipher_unpadblock:bad decrypt`; the first recovered file had a mismatching SHA-256 hash. Incorrect password entry was a plausible cause but was not conclusively established from the terminal output. The operator retried:

```bash
openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 \
  -in patient.256cbc.enc -out recovered.256cbc.retry.txt
sha256sum patient.txt recovered.256cbc.retry.txt
cmp patient.txt recovered.256cbc.retry.txt
```

**Observed retry evidence:**

```text
5c0a65d817510020e02ccb5d44ac30e6def0d5bf31b32a604c960aa1d4e03682  patient.txt
5c0a65d817510020e02ccb5d44ac30e6def0d5bf31b32a604c960aa1d4e03682  recovered.256cbc.retry.txt
```

`cmp` produced no output. Earlier SHA-256 output showed the same input digest for `recovered.128cbc.txt` and `recovered.gcm.txt`. **All three plaintext recoveries matched the original sample**, after the CBC-256 retry. A successful file comparison checks data recovery; it does **not** prove CBC offers cryptographic integrity protection.

## 3. Part 2 — Performance measurement

### Test-file generation

```bash
dd if=/dev/urandom of=testfile bs=1M count=100
```

**Observed output:** `100+0 records in`, `100+0 records out`, `104857600 bytes (105 MB, 100 MiB) copied, 0.365349 s, 287 MB/s`.

### File-based encryption commands and wall-clock observations

```bash
time openssl enc -aes-256-cbc -salt -pbkdf2 -iter 200000 -in testfile -out test.256cbc
time openssl enc -aes-128-cbc -salt -pbkdf2 -iter 200000 -in testfile -out test.128cbc
time openssl cms -encrypt -binary -aes-256-gcm -in testfile -out test.gcm -outform DER "$HOME/.config/meddefense-crypto/recipient.crt"
```

| Command | Observed wall-clock (`real`) | Interpretation |
|---|---:|---|
| AES-256-CBC `enc` | 11.098 s | Includes interactive password entry, KDF, file I/O and encryption. |
| AES-128-CBC `enc` | 18.634 s | Includes interactive password entry; **not** evidence AES-128 is intrinsically slower. |
| AES-256-GCM `cms` | 0.433 s | Includes CMS envelope generation and I/O; not directly equivalent to password-based CBC timings. |

**Conclusion:** The file-based wall-clock results are operational observations, not controlled cipher-throughput comparisons, because the workflows have different interactive and cryptographic overheads.

### Controlled OpenSSL benchmark commands

```bash
openssl speed -elapsed -seconds 3 -evp aes-256-cbc
openssl speed -elapsed -seconds 3 -evp aes-128-cbc
openssl speed -elapsed -seconds 3 -evp aes-256-gcm
```

The reported `openssl speed` figures below are in **thousands of bytes/second (decimal kB/s)**, as printed by OpenSSL. Each test used 3 seconds per block size.

| Algorithm | 16 B | 64 B | 256 B | 1,024 B | 8,192 B | 16,384 B |
|---|---:|---:|---:|---:|---:|---:|
| AES-256-CBC | 659,607.13 | 758,259.56 | 770,938.62 | 769,842.52 | 776,757.25 | **774,564.52** |
| AES-128-CBC | 805,375.69 | 1,025,272.17 | 1,051,216.21 | 1,056,493.57 | 1,041,421.65 | **1,057,363.29** |
| AES-256-GCM | 53,465.09 | 205,856.49 | 717,592.06 | 1,722,508.63 | 3,114,601.13 | **3,284,101.80** |

**At 16,384-byte blocks:** AES-256-CBC = **774.56 MB/s**; AES-128-CBC = **1,057.36 MB/s**; AES-256-GCM = **3,284.10 MB/s** (decimal megabytes/s). Calculations: `3,284,101.80 ÷ 774,564.52 = 4.24` and `1,057,363.29 ÷ 774,564.52 = 1.37`. Thus GCM reached **4.24×** AES-256-CBC throughput on the large-block benchmark, whereas AES-128-CBC reached **1.37×** AES-256-CBC. **At 16-byte blocks GCM was slower than either CBC mode.** These are local, single-session observations and should not be extrapolated directly to database, NAS or VPN production throughput.

## 4. Part 3 — Bash automation evidence

**Required deliverable:** [`1-symmetric_encrypt.sh`](1-symmetric_encrypt.sh), an executable Bash script taking `INPUT OUTPUT {cbc|gcm}`.

**Operator's commands:**

```bash
cp -i ~/Downloads/1-symmetric_encrypt.sh .
chmod +x 1-symmetric_encrypt.sh
bash -n 1-symmetric_encrypt.sh
wc -l 1-symmetric_encrypt.sh
./1-symmetric_encrypt.sh patient.txt script-cbc.enc cbc
./1-symmetric_encrypt.sh patient.txt script-gcm.cms gcm
```

**Observed:** `bash -n` returned no syntax error; `wc -l` showed **22 lines**. The script printed `Created: script-cbc.enc (cbc)` and `Created: script-gcm.cms (gcm)`. It rejected a second attempt to use the same output paths with `Input missing, output exists, or paths are identical`; this correctly avoids silently overwriting the existing ciphertext. The script's GCM mode requires the lab recipient certificate at `~/.config/meddefense-crypto/recipient.crt`; private-key material stays outside Git.

## 5. Security comparison and MedDefense decisions

| Property | AES-128-CBC | AES-256-CBC | AES-256-GCM |
|---|---|---|---|
| Confidentiality | Yes with proper key/IV | Yes with proper key/IV | Yes with proper key/nonce |
| Built-in authentication/integrity tag | **No** | **No** | **Yes** |
| Key length | 128 bits | 256 bits | 256 bits |
| IV/nonce requirement | Unpredictable CBC IV | Unpredictable CBC IV | **Never reuse a nonce with the same key** |
| Important failure mode | Padding/malleability unless authenticated separately | Padding/malleability unless authenticated separately | Catastrophic nonce-reuse risk; reject bad tags |

**Recommended use:** For application-level encryption of selected sensitive EHR fields, prefer a vetted AES-256-GCM implementation with reliable unique nonces, authenticated metadata, secure key storage/rotation, and verified tag checking. Do **not** assume `openssl cms` is the correct format for PostgreSQL database fields: it is used here to demonstrate AEAD in the lab. For disk/volume encryption of PostgreSQL storage and NAS backups, evaluate supported block-encryption modes such as AES-XTS via LUKS, plus separate application integrity and recovery protections; **GCM is not a universal replacement for storage encryption**. For VPN and DICOM in transit, use vendor-supported, authenticated modern transport protocols, not this local file-encryption script.

**Operational prerequisites:** Protect encryption keys separately from NAS/production data; document recovery of keys and backups; test performance using a realistic workload; verify PACS/MRI/clinical compatibility; and obtain Sarah Park's IT and the relevant Clinical/Biomedical approvals before production changes. CBC encrypted files from `openssl enc` lack an authentication tag, so a successful decryption comparison is not an integrity guarantee.

## 6. Evidence, outstanding checks and repository hygiene

- **Completed with supplied outputs:** sample-file encrypt/decrypt for all three algorithms; SHA-256 equality after CBC retry; 100 MiB generation; file-based timing; three `openssl speed` runs; Bash syntax check and two successful script modes.
- **Not demonstrated by the supplied outputs:** authenticated tamper-rejection test for GCM; automated decryption of the script-created CBC/CMS files; production integration and real-world cryptographic performance.
- **Do not commit:** `patient.txt`, recovered plaintext, password files, `recipient.key`, `recipient.crt`, any `.enc`/`.cms` ciphertext, `testfile`, `test.*`, or other lab artifacts. A synthetic patient record is still unnecessary in a public repository.
- **Commit only:** the reviewed, executable `1-symmetric_encrypt.sh` and this optional evidence report, after confirming `git diff --cached --name-only` is limited to those files.

**Related source work:** [1x04 Crypto Inventory](0-crypto_inventory.md), [1x03 Security Strategy](../1x03_defense_blueprint/17-security_strategy.md), [1x02 Vulnerability Triage](../1x02_the_weak_links/16-triage.md). The report is an educational lab analysis, not an assertion that MedDefense's production EHR, backups, VPN or PACS has been encrypted.
