# MedDefense Health Systems — Task 12: The Disk Encryption Lab

**Project:** 1x04 — Cryptographic Foundation
**Deliverables:** `12-luks_manager.sh`, `12-disk_encryption.md`
**Assessment date:** 5 November 2026
**Status:** **Laboratory PASS** — manual 500 MiB LUKS2 workflow and 128 MiB manager `create/open/close` workflow verified on Fedora on 5 November 2026. This is not a production NAS deployment or an on-host encryption performance benchmark.
**Audience:** James Chen (Deputy CISO), Sarah Park (IT Director), backup operations and DPO
**Source context:** 1x00 asset/information inventory; 1x01 flat-network attack paths; 1x02 exposure findings; 1x03 proposed immutable offsite backup control C4; 1x04 Task 1 measured cryptographic throughput.

## 1. Scope, safety and threat model

NAS-01 is described in the case study as storing backup data without encryption at rest. Two threats are distinct: **offline physical theft** (an unopened LUKS2 volume protects its content if keys are kept elsewhere) and **online compromise** through network access (a mounted/unlocked NAS can still serve readable data to an attacker with sufficient access). LUKS is not a replacement for network segmentation, least privilege, backup immutability, offsite copies or detection.

The exercise operates on a **regular file**, not a real disk or partition. `cryptsetup` can internally allocate a loopback device for a file path. Never point `luksFormat` at `/dev/sda`, `/dev/nvme*`, a production NAS volume or an existing data-bearing disk. The lab uses **synthetic text only**, never actual protected health information (PHI). Keep the 500 MiB image and mount directory **outside Git** under `~/.local/share/meddefense-crypto/luks_task12/`.

**Prerequisites:** Fedora with working `sudo`, `cryptsetup`, `mkfs.ext4`, `mount`, `strings` and at least 700 MiB free for the manual image plus a small scripted test image. If needed, install `cryptsetup`, `e2fsprogs` and `binutils` from Fedora repositories. Use an interactive terminal for passphrase entry; **never** put the LUKS passphrase in shell history, Git, a script, or this report.

## 2. Part 1 — Manual LUKS2 setup on a 500 MiB virtual disk

### 2.1 Create the image safely (do not overwrite existing data)

**Assignment reference command (documentation only; do not rerun on an existing image):** `dd if=/dev/zero of=encrypted_volume.img bs=1M count=500`. The actual Fedora run used the guarded lab-path command below with `conv=excl` so an existing encrypted image cannot be silently overwritten.

```bash
LAB="$HOME/.local/share/meddefense-crypto/luks_task12"
IMG="$LAB/encrypted_volume.img"
MNT="$LAB/manual_mount"
umask 077
mkdir -p "$LAB" "$MNT"
chmod 700 "$LAB"
if [ -e "$IMG" ] || [ -L "$IMG" ]; then
  echo 'STOP: existing image; do not format it'
else
  dd if=/dev/zero of="$IMG" bs=1M count=500 conv=excl status=progress
fi
ls -lh "$IMG"
```

**Observed (20:55 CET):** `dd` returned `500+0 records in`, `500+0 records out`, `524288000 bytes (524 MB, 500 MiB) copied, 0.443719 s, 1.2 GB/s`; `ls -lh` showed `-rw-------` and `500M` for `encrypted_volume.img`. Local `/home` had 33 GiB available before the test. The 1.2 GB/s reading is buffered file creation, **not** LUKS or NAS encryption throughput. The safety check prevents overwriting an existing filename.

### 2.2 Initialize LUKS2; unlock; make ext4
**Assignment reference (documentation only; do not execute on an existing image):** `sudo cryptsetup luksFormat encrypted_volume.img`. The actual Fedora lab used explicit LUKS2 settings and the guarded `$IMG` path.

```bash
sudo cryptsetup luksFormat --type luks2 --verify-passphrase "$IMG"
sudo cryptsetup luksDump "$IMG" | grep -E 'Version:|Cipher:|Cipher name:|Cipher mode:|PBKDF:'
sudo cryptsetup luksOpen "$IMG" secure_vol
sudo cryptsetup status secure_vol
sudo mkfs.ext4 /dev/mapper/secure_vol
```

**Observed (20:55–21:02 CET):** Two initial interactive confirmations failed because `y` and then `yes` were entered instead of the required uppercase `YES`; both returned `Operation aborted`. Accordingly, early `luksDump`/`luksOpen` reported `not a valid LUKS device` and `status` reported inactive. An early `mkfs.ext4` failed because the mapper did not exist. **These attempts were not successful encryption runs.** The initial synthetic marker was inadvertently written to the ordinary, unmounted `manual_mount` directory; it was identified and deleted interactively, with the directory confirmed empty, **before** the successful LUKS run. Thus the initial `strings` check on the unformatted image was **invalid evidence**.

**Corrected run:** user entered uppercase `YES`, supplied and verified the passphrase without disclosing it, then ran `sudo cryptsetup isLuks "$IMG"`, which returned **exit code 0**. `luksOpen` succeeded and `cryptsetup status secure_vol` reported:

```text
/dev/mapper/secure_vol is active.
  type:    LUKS2
  cipher:  aes-xts-plain64
  keysize: 512 [bits]
  key location: keyring
  device:  /dev/loop0
  sector size: 4096 [bytes]
  offset: 16777216 [bytes]
  size:   507510784 [bytes]
  mode:   read/write
```

The 512-bit XTS key contains two AES-256 keys (data and tweak); it **does not mean AES-512**. The device was backed by the 500 MiB image at the approved lab path. `mkfs.ext4 /dev/mapper/secure_vol` completed successfully, reporting **123,904 4 KiB blocks**, a 4,096-block journal and filesystem UUID `503c612d-6702-4525-acf1-a1c60ea365f8`. The original `luksDump` detail and PBKDF settings were **not recorded after the corrected run**, so no PBKDF claim is made.

### 2.3 Mount; write synthetic test data; read it back

```bash
sudo mount -o nodev,nosuid,noexec /dev/mapper/secure_vol "$MNT"
findmnt "$MNT"
printf '%s\n' 'MD12_LUKS_TEST_20261105_SYNTHETIC_ONLY' | sudo tee "$MNT/lab_record.txt" >/dev/null
sudo chmod 600 "$MNT/lab_record.txt"
sudo cat "$MNT/lab_record.txt"
sudo sha256sum "$MNT/lab_record.txt"
sudo umount "$MNT"
sudo cryptsetup luksClose secure_vol
```

**Observed (21:02 CET):** `findmnt "$MNT"` confirmed `SOURCE=/dev/mapper/secure_vol`, `FSTYPE=ext4`, and `rw,nosuid,nodev,noexec` mount options. The exact synthetic file content and its initial digest were:

```text
MD12_LUKS_TEST_20261105_SYNTHETIC_ONLY
ec3c73de024e258e8ebcd913238bc470f6945e1f7c73237323b5fe0096b57409  lab_record.txt
```

The subsequent `sudo umount "$MNT" && sudo cryptsetup luksClose secure_vol` completed without reported errors (21:04 CET). `nodev,nosuid,noexec` are defense-in-depth mount restrictions, not substitutes for authentication or encryption.

## 3. Part 2 — Verify encrypted-at-rest state and recovery

### 3.1 Examine the **closed** ciphertext image

```bash
strings -a "$IMG" | head -50
if strings -a "$IMG" | grep -Fq 'MD12_LUKS_TEST_20261105_SYNTHETIC_ONLY'; then
  echo 'FAIL: plaintext marker visible in raw image'
else
  echo 'PASS: plaintext marker not found in raw image'
fi
sudo cryptsetup isLuks "$IMG" && echo 'PASS: valid LUKS header'
```

**Observed (21:03 CET, after the valid LUKS write and close):** the full-file marker search returned `PASS: plaintext marker not found`. The corrected run's `strings -a "$IMG" | head -50` preview was **not preserved** in the supplied terminal output; do not represent that preview as observed. The first 50 printable strings could include unencrypted LUKS header metadata or incidental printable bytes. Absence of the marker in this search is **supporting evidence, not formal cryptographic proof**; verified LUKS2 unlock plus exact data recovery provide additional evidence. Ordinary LUKS2 AES-XTS does **not authenticate each data sector**; end-to-end backup-object authentication and restore-integrity checks are still necessary.

### 3.2 Reopen, verify unchanged data, and close again

```bash
sudo cryptsetup luksOpen "$IMG" secure_vol
sudo mount -o nodev,nosuid,noexec /dev/mapper/secure_vol "$MNT"
sudo cat "$MNT/lab_record.txt"
sudo sha256sum "$MNT/lab_record.txt"
sudo umount "$MNT"
sudo cryptsetup luksClose secure_vol
```

**Observed (21:04 CET):** reopening required the correct interactive passphrase. `findmnt "$MNT"` again showed ext4 sourced from `/dev/mapper/secure_vol` with `rw,nosuid,nodev,noexec`. The recovered marker was `MD12_LUKS_TEST_20261105_SYNTHETIC_ONLY`, and the SHA-256 was **exactly** `ec3c73de024e258e8ebcd913238bc470f6945e1f7c73237323b5fe0096b57409`, matching the original. The final `umount && luksClose` finished without an error message. **Result: PASS — integrity of this synthetic sample across close/reopen confirmed** (not a comprehensive tamper-resistance test).

### 3.3 Evidence register — real Fedora observations (5 November 2026)

| Requirement | Observed command/result | Status |
|---|---|---|
| File-backed 500 MiB disk | `dd`: 524,288,000 bytes; `ls -lh`: 500M, owner-only mode | **PASS** |
| LUKS2 initialized | uppercase `YES`, passphrase verification; `cryptsetup isLuks`: exit **0** | **PASS** |
| Unlock and AES-XTS | `cryptsetup status`: **active**, `LUKS2`, `aes-xts-plain64`, 512-bit XTS key | **PASS** |
| ext4 filesystem and secure mount | `mkfs.ext4` complete; `findmnt` shows mapper-backed ext4 with `nodev,nosuid,noexec` | **PASS** |
| Synthetic payload written/read | marker displayed; SHA-256 `ec3c73de024e258e8ebcd913238bc470f6945e1f7c73237323b5fe0096b57409` | **PASS** |
| Close encrypted mapper | `umount` and `luksClose` succeeded without errors | **PASS** |
| No plaintext marker in closed image | full `strings -a "$IMG" | grep -Fq ...` check: `PASS: plaintext marker not found` | **PASS** |
| Reopen and recovery | marker recovered, **identical** SHA-256, closed again | **PASS** |
| Manager `create`, `open`, `close` | See Section 4.1; 128 MiB managed image and recovery digest identical | **PASS** |

**Evidence qualification:** no secrets were included in the lab transcript. The two aborted formatting prompts and the initially misplaced plaintext file were recognized and corrected before valid encryption testing. Neither `luksDump` PBKDF details nor a `strings | head -50` output from the corrected run was supplied. No production system was assessed.

## 4. Part 3 — LUKS automation script

**Script:** [`12-luks_manager.sh`](12-luks_manager.sh), 25 Bash lines, no `for` loops or ternary operators. It accepts:

- `create SIZE_MiB`: require numeric **64–4096 MiB**, refuse any existing image or symlink, create `managed_volume.img`, initialize **LUKS2** with an interactively entered/verified passphrase, open, format ext4 and close.
- `open`: unlock the existing managed image, map it as `secure_vol`, and mount it at `.../luks_task12/managed_mount` with `nodev,nosuid,noexec`.
- `close`: unmount the managed filesystem, then close its mapper. The mapper name is intentionally fixed, so a previous `secure_vol` mapping must be fully closed first.

```bash
bash -n 12-luks_manager.sh
chmod +x 12-luks_manager.sh
./12-luks_manager.sh create 128
./12-luks_manager.sh open
sudo findmnt "$HOME/.local/share/meddefense-crypto/luks_task12/managed_mount"
./12-luks_manager.sh close
```

**Safety boundaries:** the script hardcodes a single **lab-only regular-file path** and does not accept arbitrary device paths. It refuses overwrites, never caches a passphrase, uses `umask 077`, checks argument ranges, and attempts to close the mapper if filesystem formatting or mounting fails. A creation failure may leave an incomplete image; inspect it manually rather than rerunning `create` and overwriting anything. The script is a **training aid, not a production backup orchestrator**: it lacks enterprise KMS, replication, rotation, extensive rollback/state management, monitoring and hardware validation.

### 4.1 Observed manager run — 128 MiB, real Fedora output (21:04–21:08 CET)

`./12-luks_manager.sh create 128` printed `128+0 records in/out`, `134217728 bytes (134 MB, 128 MiB) copied`, prompted for uppercase `YES`, passphrase creation/verification and unlock, and `mkfs.ext4` completed with **28,672 4 KiB blocks**. `ls -lh` showed `-rw------- ... 128M ... managed_volume.img`; `cryptsetup isLuks` returned **0** and `cryptsetup status secure_vol` showed **inactive** after creation, confirming that the manager did not leave a decrypted mapper open.

`./12-luks_manager.sh open` prompted for the passphrase and printed `Mounted encrypted filesystem: .../managed_mount`. `findmnt` confirmed the mount source as `/dev/mapper/secure_vol`, filesystem **ext4**, options `rw,nosuid,nodev,noexec`. `cryptsetup status secure_vol` confirmed `active and is in use`, type `LUKS2`, `aes-xts-plain64`, **512-bit** XTS key, `4096`-byte sectors and `117440512`-byte mapped size (**112 MiB** after the 16 MiB LUKS header offset).

A synthetic sample was written on that verified mounted mapper:

```text
MD12_MANAGER_TEST_SYNTHETIC
2e7b1776af5a08a4d7fe1fc0441359c6f1896ffcfa79564c60cbca51ff93b67d  manager_test.txt
```

`./12-luks_manager.sh close` then `cryptsetup status secure_vol` reported **inactive**. A second `open` recovered the same marker and **exact same SHA-256 digest**; final `close` exited without an error. **Result: PASS — all three modes and reopen/read/close cycle demonstrated.** The test image is separate from the manual 500 MiB image and remains outside Git.

**Important operating limit:** the script's mapper name is shared with the manual lab (`secure_vol`); check that no manual mapping is active before using it. The fixed-name `close` is for the manager's own mount only, not a general-purpose device management action.

## 5. Part 4 — NAS-01 backup encryption design

### 5.1 Recommended encryption layers and rationale

**Primary recommendation:** use **LUKS2 full-volume encryption** on dedicated NAS backup volumes or the underlying backup repository block device **where the NAS OS supports and properly manages it**. Encrypt **before data lands on persistent storage**, verify all backup datasets/snapshots are covered, and never encrypt a live filesystem without a tested backup and maintenance window. Volume-level encryption protects broad datasets with low operational complexity and preserves filesystem compatibility. For a hardware NAS or appliance that does not support LUKS2, use its **documented managed volume-encryption feature** with equivalent key-separation controls rather than assuming `cryptsetup` is installable.

**Additional layer:** perform **client-side, application-level authenticated encryption** of backup objects (e.g., backup software using AES-256-GCM, with unique nonces and integrity tags) **before sending them offsite**. This safeguards replicated objects even if a storage/cloud provider has infrastructure access; LUKS on the local NAS does not by itself make cloud object copies encrypted. Avoid unauthenticated DIY object-encryption schemes or ad hoc nonce handling; use a supported enterprise backup product. TLS 1.2/1.3 remains necessary for data **in transit**.

**Not sufficient in isolation:** file permissions, disk RAID5, “encrypted connection to NAS,” local-only encrypted disks, or encryption of the disk while an attacker has the unlock key or live mounted access.

### 5.2 Performance estimate tied to Task 1 (not a measured LUKS benchmark)

Task 1 on the Fedora lab laptop measured **AES-256-CBC at 774.56 MB/s** and **AES-256-GCM at 3,284.10 MB/s** on 16 KiB buffers. These are **OpenSSL primitive-throughput figures**, not the LUKS **AES-XTS** volume throughput and not measurements of NAS-01. A 500 MiB dataset is **524.288 decimal MB**.

| Illustrative calculation | Arithmetic | Result |
|---|---|---|
| 500 MiB at AES-256-CBC Task 1 throughput | 524.288 MB / 774.56 MB/s | **~0.677 seconds** equivalent CPU processing |
| 500 MiB at AES-256-GCM Task 1 throughput | 524.288 MB / 3,284.10 MB/s | **~0.160 seconds** equivalent CPU processing |
| Hypothetical unencrypted NAS throughput | 500 MiB / 100 MiB/s (assumed, **not measured**) | **5.00 seconds** storage transfer |
| Illustrative *fully serial* processing penalty | 0.160–0.677 / 5.00 | **~3.2–13.5%** *in this artificial model only* |

**Interpretation:** the ~3.2–13.5% figures are **scenario arithmetic, not a predicted NAS/LUKS overhead band**: AES-XTS differs from both test algorithms, modern I/O and CPU work overlap, and NAS CPU, RAID, disks, compression, deduplication, concurrency and snapshots determine actual throughput. Before production: benchmark real representative backup, restore and replication jobs **with and without** NAS-at-rest encryption; capture MB/s, CPU, latency, restore RTO and concurrent clinical-service impact. Use `cryptsetup benchmark` only as a CPU cryptographic capability check, not a substitute for full I/O tests. Approve rollout only when the measured performance meets backup-window/RTO requirements.

### 5.3 Key custody — never store the only unlock key on NAS-01

- Generate/maintain volume keys using supported LUKS2 keyslots and a centrally managed key-encryption process; store unlock credentials, recovery secrets and any key escrow in an **organization-controlled KMS/HSM or segregated secret vault**, accessible by restricted backup administrators with MFA and audit logs.
- Do **not** keep the only recovery key or an unattended plaintext auto-unlock key **on NAS-01**: theft or compromise of the storage device would then expose the very secret required to decrypt it.
- Establish **two-person** authorized break-glass recovery, backup administrator separation of duties, key versioning, rotation/revocation runbooks, and documented access reviews. A security-approved hardware-backed unlock strategy is preferable to automatically storing a recoverable passphrase on the disk.
- Securely back up the **LUKS header/keyslot metadata** separately and protect its confidentiality and availability. A header backup plus a previously valid passphrase may still unlock data after keyslot changes; treat header copies as sensitive. Retest the restoration procedure after any keyslot change. <https://man7.org/linux/man-pages/man8/cryptsetup-luksheaderbackup.8.html>

### 5.4 Lost keys and disaster recovery

If **all** valid LUKS passphrases/recovery keys or the required key-management service and escrow are irrecoverably lost, a properly encrypted backup is **effectively unrecoverable**. If the LUKS header is lost or damaged, even a known passphrase may be insufficient without a secure, compatible header backup. A header backup does not replace a passphrase. Keep independent secured escrow, verify dual-custodian recovery, and run **quarterly** documented end-to-end restore tests into an isolated environment. Test both **NAS loss** and **KMS unavailability**, with documented RPO/RTO and an offline recovery path approved by IT and the DPO.

### 5.5 Offsite replication integration — 1x03 C4

The proposed 1x03 control **C4** calls for **immutable offsite backup replication**; this remains **planned, not yet deployed**. Replicate **already encrypted, authenticated backup objects** to an offsite region/provider under immutable retention/object-lock controls. The **organization (MedDefense)** must control the decryption authority and hold escrowed recovery keys independently of both NAS-01 and the offsite provider. Provider-managed server-side encryption may be used as an **additional** layer, but **must not be the only protection** if the threat model includes cloud provider/operator compromise. Distinguish the local LUKS volume key from backup-object encryption keys; document custody and restore dependencies for each.

Use mutual/verified TLS for replication, scoped service identities, MFA on administrators, per-job permissions, alerting on deletion and failed jobs, versioned retention, immutable snapshots where supported, integrity verification and tested air-gapped/offline recovery. A ransomware actor with credentials to a **mounted LUKS volume** may still encrypt or delete logical files; independent immutable offsite copies and segmentation are essential.

### 5.6 Prioritized implementation and ownership

| Order | Proposed control / check | Owner | Acceptance evidence |
|---|---|---|---|
| P0 | Backup NAS-01 and inventory datasets, snapshots and firmware | Backup Operations / Sarah Park | Verified coverage and rollback plan |
| P0 | Choose supported full-volume encryption; integrate external KMS/recovery custody | Infrastructure + Security | Architecture, access policy, escrow drill |
| P0 | Enable encrypted immutable offsite objects and independent key custody (C4) | Backup Operations + Security | Offsite immutable object and key separation evidence |
| P1 | Test actual job throughput, encryption compatibility, RPO/RTO and restore | Infrastructure + Clinical IT | Workload benchmark and clinical sign-off |
| P1 | Roll out with monitored maintenance window, backups first, tested rollback | Change Board | Change ticket and successful restore |
| Continuous | Monitor key access, renewal/recovery, alerts and quarterly restore drills | Security Operations | Audit trail, restore outcomes and exceptions |

## 6. Acceptance criteria and outstanding evidence

**Practical lab status: PASS.** Fedora confirmed 500 MiB image creation, LUKS2 initialization, active AES-XTS mapper, ext4 mount and synthetic write, clean closure, absent marker in raw ciphertext, identical SHA-256 after reopen, and manager `create/open/close` plus repeat recovery on a separate 128 MiB image. Evidence is limited to user-supplied terminal output; no independent host access, formal cryptographic penetration test, LUKS2 sector-integrity validation or NAS throughput measurement occurred.

**Production status: NOT IMPLEMENTED.** Encryption, KMS separation, immutable offsite replication (1x03 C4), recovery escrow and backup-job testing remain recommendations until authorized and proven on NAS-01. Do not upload the images, mount contents, passphrases or LUKS keys to Git. Follow the ownership, staged rollout, measurement and restore-acceptance steps in Section 5.

## 7. Technical references

- cryptsetup manual: file-backed LUKS devices can use automatic loopback mapping — <https://man7.org/linux/man-pages/man8/cryptsetup.8.html>
- cryptsetup FAQ: LUKS on a loop device — <https://gitlab.com/cryptsetup/cryptsetup/-/wikis/FrequentlyAskedQuestions>
- LUKS2 header backup and security implications — <https://man7.org/linux/man-pages/man8/cryptsetup-luksheaderbackup.8.html>
- LUKS header restore semantics — <https://man7.org/linux/man-pages/man8/cryptsetup-luksheaderrestore.8.html>
- Internal MedDefense evidence: 1x00 inventory, 1x01 attack-path analysis, 1x03 C4 roadmap, and Task 1 `1-symmetric_engine_report.md` measurements; no fictional live NAS throughput is asserted.
