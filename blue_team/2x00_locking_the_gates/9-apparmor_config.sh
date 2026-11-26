#!/bin/bash
set -euo pipefail
mode="${1:---audit}"
[[ "$mode" == --audit || "$mode" == --apply ]] || { echo 'Usage: sudo bash 9-apparmor_config.sh [--audit|--apply]'; exit 2; }
[[ $EUID -eq 0 ]] || { echo '[ERROR] Run with sudo'; exit 1; }
source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/task9-profiles"
command -v aa-status >/dev/null && command -v aa-enforce >/dev/null && command -v apparmor_parser >/dev/null && command -v aa-unconfined >/dev/null || { echo '[ERROR] Install AppArmor utilities'; exit 1; }
systemctl is-active --quiet apparmor || { echo '[ERROR] AppArmor service inactive'; exit 1; }
echo "[*] AppArmor status | Mode: $mode"
aa-status
apply_profile() {
  local name="$1" target="/etc/apparmor.d/$1"
  if [[ -f "$source_dir/$name" && -f "$target" ]] && ! cmp -s "$source_dir/$name" "$target"; then echo "[REVIEW] Installed policy differs: $name"; return 1; fi
  if [[ ! -f "$target" ]]; then [[ -f "$source_dir/$name" ]] || { echo "[ERROR] Profile missing: $name"; return 1; }; apparmor_parser -Q "$source_dir/$name"; install -m 644 "$source_dir/$name" "$target"; fi
  apparmor_parser -Q "$target"
  aa-enforce "$target"
}
if [[ "$mode" == --apply ]]; then
  apply_profile usr.sbin.apache2
  apply_profile usr.sbin.mysqld
  apply_profile opt.meddefense.billing-app.app.sh
fi
echo '[*] Network listeners without confinement:'
aa-unconfined | awk '/not confined/ {n++} {print} END {print "Unconfined listeners:", n+0}'
echo '[*] Final counts:'; aa-status | grep -E 'profiles are in (enforce|complain) mode|processes are unconfined but have a profile defined'
