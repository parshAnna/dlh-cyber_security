#!/bin/bash
set -Eeuo pipefail
[[ $EUID -eq 0 ]] || { echo 'ERROR: Run with sudo on the authorized lab VM.' >&2; exit 1; }
command -v python3 >/dev/null && command -v ss >/dev/null && command -v systemctl >/dev/null || { echo 'ERROR: python3, ss and systemctl are required.' >&2; exit 1; }
umask 077
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
OUT="${BASELINE_OUTPUT:-$PWD/0-baseline_snapshot.json}"
hostname > "$TMP/hostname"; . /etc/os-release; printf '%s\n' "${PRETTY_NAME:-unknown}" > "$TMP/os"; uname -r > "$TMP/kernel"; uptime -p > "$TMP/uptime"
systemctl list-units --type=service --all --no-pager --plain --no-legend > "$TMP/services" 2> "$TMP/service_errors" || true
systemctl list-units --type=service --state=running --no-pager --plain --no-legend > "$TMP/running" 2>> "$TMP/service_errors" || true
ss -H -lntup > "$TMP/sockets"; awk '{print $1, $5}' "$TMP/sockets" | sort -u > "$TMP/endpoints"
find / \( -path /proc -o -path /sys -o -path /dev \) -prune -o -type f -perm /6002 -printf '%m\t%p\n' > "$TMP/files" 2> "$TMP/find_errors" || true
sysctl -a 2>/dev/null | grep -E '^(net\.ipv4\.ip_forward|net\.ipv4\.tcp_syncookies|net\.ipv4\.conf\.(all|default)\.(accept_redirects|send_redirects|accept_source_route)|net\.ipv6\.conf\.(all|default)\.(accept_redirects|forwarding)|kernel\.(randomize_va_space|kptr_restrict|dmesg_restrict|yama\.ptrace_scope|unprivileged_bpf_disabled)|fs\.(suid_dumpable|protected_hardlinks|protected_symlinks))\s*=' > "$TMP/sysctl" || true
if command -v sshd >/dev/null; then sshd -T > "$TMP/ssh" 2> "$TMP/ssh_errors" || true; else printf 'sshd not installed\n' > "$TMP/ssh"; : > "$TMP/ssh_errors"; fi
getent passwd | awk -F: '$1=="root" || ($3>=1000 && $3<65534 && $7 !~ /(nologin|false)$/) {print $1 "\tuid=" $3 "\thome=" $6 "\tshell=" $7}' > "$TMP/users"
getent group sudo > "$TMP/sudo" || : > "$TMP/sudo"
python3 - "$TMP" "$OUT" <<'PY'
import sys, json, pathlib, datetime
p, out = pathlib.Path(sys.argv[1]), pathlib.Path(sys.argv[2]); lines = lambda n: (p/n).read_text(errors='replace').splitlines()
f = lines('files'); mode = lambda x: int(x.split('\t', 1)[0], 8)
suid = list(filter(lambda x: bool(mode(x) & 0o4000), f)); sgid = list(filter(lambda x: bool(mode(x) & 0o2000), f)); writable = list(filter(lambda x: bool(mode(x) & 0o0002), f))
services, running, sockets, endpoints = lines('services'), lines('running'), lines('sockets'), lines('endpoints')
report = {'timestamp_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(), 'hostname': lines('hostname')[0], 'os': lines('os')[0], 'kernel': lines('kernel')[0], 'uptime': lines('uptime')[0], 'summary': {'running_services': len(running), 'listening_sockets': len(sockets), 'unique_protocol_address_bindings': len(endpoints), 'suid_binaries': len(suid), 'sgid_binaries': len(sgid), 'world_writable_files': len(writable)}, 'all_service_states': services, 'running_service_details': running, 'listening_socket_details': sockets, 'open_port_bindings': endpoints, 'suid_binaries': suid, 'sgid_binaries': sgid, 'world_writable_files': writable, 'security_sysctls': lines('sysctl'), 'effective_sshd_config': lines('ssh'), 'login_accounts': lines('users'), 'sudo_group': lines('sudo'), 'scan_errors': {'filesystem': lines('find_errors'), 'systemctl': lines('service_errors'), 'sshd': lines('ssh_errors')}}
pathlib.Path(out).write_text(json.dumps(report, indent=2) + '\n'); print(json.dumps({'output':str(out), 'hostname':report['hostname'], **report['summary']}, indent=2))
PY
