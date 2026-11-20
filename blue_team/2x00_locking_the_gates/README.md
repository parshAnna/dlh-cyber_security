# Locking the Gates — Task 0: Baseline Snapshot

## Purpose

Capture the **current** Linux state of the authorized `billing-srv-01` training VM before applying any hardening. This is a read-only inspection of system configuration and permissions. The script writes a local structured JSON report; it does **not** edit SSH, sysctl, firewall, services, permissions or user accounts.

## Scope and controls

- System: hostname, OS, kernel, uptime, UTC collection timestamp.
- Services: all systemd service units and their states; running services separately.
- Network: listening TCP/UDP socket evidence and unique protocol/address bindings.
- Filesystem: SUID, SGID and world-writable **regular files**; skip `/proc`, `/sys` and `/dev`. A root-accessible read may traverse other mounted storage; use only on the authorized VM.
- Hardening: security-relevant `sysctl` values and effective global `sshd -T` settings.
- Identity: root and non-system interactive login accounts, with sudo group members.
- Collection limitations: errors from filesystem, systemd and sshd checks are retained in JSON rather than silently interpreted as a clean result.

## Requirements

Ubuntu 22.04 lab VM, `bash`, `python3`, `systemctl`, `ss`, `find`, `awk`, `getent` and root privileges. No external Python packages required.

## Run **on the lab VM**

If the supplied lab's SSH port forwarding is active, connect to it from Fedora:

```bash
ssh -p 2222 analyst@127.0.0.1
```

After copying `0-baseline_snapshot.sh` into the VM, run it from the intended project directory:

```bash
chmod +x 0-baseline_snapshot.sh
sudo ./0-baseline_snapshot.sh
sudo python3 -m json.tool 0-baseline_snapshot.json >/dev/null
sudo cat 0-baseline_snapshot.json
```

The script prints a short JSON summary and creates `0-baseline_snapshot.json` with restricted root ownership. Run it **before** changing any security setting, and preserve this first report as your baseline. On later reruns the output filename is overwritten unless a different path is specified:

```bash
sudo env BASELINE_OUTPUT="$PWD/0-baseline_after.json" ./0-baseline_snapshot.sh
```

The last command is for a later comparison, not a substitute for the original baseline. The directory must exist and be writable by root. A nonzero-error list in `scan_errors` means some collected evidence may be incomplete and needs review. `sshd -T` shows the default effective configuration; `Match`-specific behavior must be validated separately when applicable.

## Safety and repository handling

Run on **the authorized Ubuntu lab VM**, not the personal Fedora laptop. The JSON reveals usernames, listening services, filesystem paths and SSH settings, so do not push the **raw** JSON or secret-bearing evidence to a public repository. Keep the baseline in a restricted private location and create a reviewed/redacted copy only if an instructor explicitly requires an upload. Only the script and this README belong in the ordinary Git commit. Scripts are executable, idempotent for collection, and require no network scan or exploitation.

## Reference

DLH *Locking the Gates*, Task 0: The Baseline Snapshot; earlier MedDefense Findings 009 (SSH password authentication), 011 (legacy Ubuntu release; exercise states upgraded to 22.04), 026 (outdated kernel). These are **risks to investigate**; Task 0 does not assert they remain active on the refreshed lab VM.
