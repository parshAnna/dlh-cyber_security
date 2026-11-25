#!/bin/bash
set -Eeuo pipefail
[[ $EUID -eq 0 ]] || { echo 'ERROR: run with sudo' >&2; exit 1; }
config=/etc/sysctl.conf; backup=/etc/sysctl.conf.bak; tmp=$(mktemp); before=$(mktemp)
trap 'rm -f "$tmp" "$before"' EXIT
[[ -f "$config" ]] || { echo "ERROR: missing $config" >&2; exit 1; }
params='net.ipv4.ip_forward=0|net.ipv4.conf.all.accept_redirects=0|net.ipv4.conf.default.accept_redirects=0'
params+='|net.ipv4.conf.all.send_redirects=0|net.ipv4.conf.all.accept_source_route=0|net.ipv4.conf.all.log_martians=1'
params+='|net.ipv4.tcp_syncookies=1|net.ipv4.icmp_echo_ignore_broadcasts=1|net.ipv6.conf.all.disable_ipv6=1'
params+='|net.ipv6.conf.default.disable_ipv6=1|kernel.randomize_va_space=2|fs.suid_dumpable=0'
params+='|kernel.dmesg_restrict=1|kernel.kptr_restrict=2'
echo "[*] Backing up $config"; cp -p "$config" "$backup"
while IFS='=' read -r key value; do path="/proc/sys/${key//./\/}"; [[ -r "$path" ]] || { echo "ERROR: missing $path" >&2; exit 1; }; printf '%s = %s\n' "$key" "$(cat "$path")"; done < <(tr '|' '\n' <<< "$params") > "$before"
restore() { cp -p "$backup" "$config"; sysctl -p "$before" >/dev/null || echo 'WARNING: runtime rollback incomplete' >&2; }
sed '/^# BEGIN MEDDEFENSE SYSCTL$/,/^# END MEDDEFENSE SYSCTL$/d' "$config" > "$tmp"
{ cat "$tmp"; echo '# BEGIN MEDDEFENSE SYSCTL'; tr '|' '\n' <<< "$params" | sed 's/=/ = /'; echo '# END MEDDEFENSE SYSCTL'; } > "$config"
echo '[*] Applying kernel hardening parameters...'
if ! sysctl -p "$config" >/dev/null; then restore; echo 'ERROR: sysctl -p failed; restored backup' >&2; exit 1; fi
pass=0; fail=0
while IFS='=' read -r key value; do path="/proc/sys/${key//./\/}"; actual=$(cat "$path" 2>/dev/null) || actual='unreadable'; if [[ "$actual" == "$value" ]]; then printf '%-45s [PASS]\n' "$key = $value"; pass=$((pass+1)); else printf '%-45s [FAIL] (actual: %s)\n' "$key = $value" "$actual"; fail=$((fail+1)); fi; done < <(tr '|' '\n' <<< "$params")
echo 'Parameters applied: 14'; echo "Verified PASS: $pass"; echo "Verified FAIL: $fail"
if (( fail > 0 )); then restore; echo 'ERROR: verification failed; restored backup' >&2; exit 1; fi
