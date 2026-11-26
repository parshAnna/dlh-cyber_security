#!/bin/bash
set -euo pipefail
mode="${1:---audit}"; [[ "$mode" == --audit || "$mode" == --apply ]] || { echo 'Usage: sudo bash 8-service_minimization.sh [--audit|--apply]'; exit 2; }
[[ $EUID -eq 0 ]] || { echo '[ERROR] Run with sudo'; exit 1; }
if [[ "$mode" == --apply ]]; then
  [[ -f /usr/share/pam-configs/unix && -f /etc/pam.d/common-auth && -f /etc/pam.d/common-password ]] || { echo '[ERROR] Unsupported PAM layout'; exit 1; }
  grep -q 'pam_unix.so' /etc/pam.d/common-auth || { echo '[ERROR] Inspect custom PAM auth stack manually'; exit 1; }
  backup=$(mktemp -d /root/meddefense-pam.XXXXXXXX); cp -a /etc/pam.d/common-{auth,account,password} "$backup/"
  cp -a /etc/security/pwquality.conf /etc/security/faillock.conf "$backup/" 2>/dev/null || true
  dpkg -s libpam-pwquality >/dev/null 2>&1 || DEBIAN_FRONTEND=noninteractive apt-get install -y libpam-pwquality
  [[ -f /usr/share/pam-configs/pwquality ]] || { echo '[ERROR] Missing pwquality PAM profile'; exit 1; }
  kv() { local f="$1" k="$2" v="$3"; touch "$f"; sed -i -E "/^[[:space:]]*#?[[:space:]]*${k}[[:space:]]*(=|$)/d" "$f"; printf '%s = %s\n' "$k" "$v" >> "$f"; }
  # Ubuntu 22.04 uses usercheck=1 for username rejection (not reject_username).
  kv /etc/security/pwquality.conf minlen 14; kv /etc/security/pwquality.conf dcredit -1; kv /etc/security/pwquality.conf ucredit -1; kv /etc/security/pwquality.conf lcredit -1; kv /etc/security/pwquality.conf ocredit -1; kv /etc/security/pwquality.conf maxrepeat 3; kv /etc/security/pwquality.conf usercheck 1
  kv /etc/security/faillock.conf deny 5; kv /etc/security/faillock.conf unlock_time 900; kv /etc/security/faillock.conf fail_interval 900
  printf '%s\n' 'Name: MedDefense faillock preauth' 'Default: no' 'Priority: 1024' 'Auth-Type: Primary' 'Auth:' $'\trequisite\tpam_faillock.so preauth' 'Account-Type: Primary' 'Account:' $'\trequired\tpam_faillock.so' > /usr/share/pam-configs/meddefense_faillock_pre
  printf '%s\n' 'Name: MedDefense faillock authfail' 'Default: no' 'Priority: 0' 'Auth-Type: Primary' 'Auth:' $'\t[default=die]\tpam_faillock.so authfail' > /usr/share/pam-configs/meddefense_faillock_post
  printf '%s\n' 'Name: MedDefense password history' 'Default: no' 'Priority: 1000' 'Password-Type: Primary' 'Password:' $'\trequisite\tpam_pwhistory.so remember=12 enforce_for_root try_first_pass use_authtok' > /usr/share/pam-configs/meddefense_pwhistory
  DEBIAN_FRONTEND=noninteractive pam-auth-update --enable pwquality meddefense_faillock_pre meddefense_faillock_post meddefense_pwhistory
  echo "[*] PAM backup saved to $backup"
fi
echo "[*] Mode: $mode | libpam-pwquality: $(dpkg-query -W -f='${Version}' libpam-pwquality 2>/dev/null || echo NOT-INSTALLED)"
grep -E '^[[:space:]]*(minlen|dcredit|ucredit|lcredit|ocredit|maxrepeat|usercheck|deny|unlock_time|fail_interval)[[:space:]]*=' /etc/security/pwquality.conf /etc/security/faillock.conf 2>/dev/null || true
grep -E '^[[:space:]]*(auth|account|password)[[:space:]]+.*pam_(faillock|pwquality|pwhistory)\.so' /etc/pam.d/common-{auth,account,password} || true
if grep -q 'pam_pwquality.so' /etc/pam.d/common-password && grep -q 'pam_pwhistory.so.*remember=12' /etc/pam.d/common-password && grep -q 'pam_faillock.so preauth' /etc/pam.d/common-auth && grep -q 'pam_faillock.so authfail' /etc/pam.d/common-auth; then echo 'Password minimum: 14 | Lockout: 5 attempts / 900s | History: 12 [STACK OK]'; else echo '[REVIEW] One or more PAM modules are not enabled yet'; fi
