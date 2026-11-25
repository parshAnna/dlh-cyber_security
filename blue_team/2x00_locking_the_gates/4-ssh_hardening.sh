#!/bin/bash
set -Eeuo pipefail
cfg=/etc/ssh/sshd_config; banner=/etc/issue.net; ok=0; banner_had=0; err=$(mktemp); trap 'rm -f "$err"' EXIT
[[ $EUID -eq 0 && -f $cfg && -x /usr/sbin/sshd ]] || { echo 'ERROR: run as root on the Ubuntu SSH server' >&2; exit 1; }
getent passwd medadmin >/dev/null && getent passwd sysadmin >/dev/null || { echo 'ERROR: required SSH users medadmin and sysadmin do not both exist' >&2; exit 1; }
[[ -s "$(getent passwd medadmin | cut -d: -f6)/.ssh/authorized_keys" && -s "$(getent passwd sysadmin | cut -d: -f6)/.ssh/authorized_keys" ]] || { echo 'ERROR: both allowed accounts need authorized_keys' >&2; exit 1; }
[[ ${SSH_ACCESS_VERIFIED:-no} == yes ]] || { echo 'ERROR: verify SSH key login for medadmin and sysadmin before setting SSH_ACCESS_VERIFIED=yes' >&2; exit 1; }
echo '[*] Backing up /etc/ssh/sshd_config'; cp -a "$cfg" "$cfg.bak"
if [[ -e $banner ]]; then cp -a "$banner" "$banner.bak.meddefense"; banner_had=1; fi
trap 'rc=$?; if [[ $ok -ne 1 ]]; then cp -a "$cfg.bak" "$cfg"; if [[ $banner_had -eq 1 ]]; then cp -a "$banner.bak.meddefense" "$banner"; else rm -f "$banner"; fi; systemctl restart ssh || true; echo "ERROR: SSH changes rolled back" >&2; fi; rm -f "$err"; exit "$rc"' EXIT
echo '[*] Applying SSH hardening settings...'
python3 - "$cfg" <<'PY'
import pathlib,re,sys
p=pathlib.Path(sys.argv[1]); original=re.sub(r'(?ms)^# BEGIN MEDDEFENSE SSH HARDENING\n.*?^# END MEDDEFENSE SSH HARDENING\n?', '', p.read_text())
rules=[('PermitRootLogin','no','Finding 009: stop privileged lateral movement'),('PasswordAuthentication','no','Finding 009: block password brute force'),('PermitEmptyPasswords','no','Weak authentication: reject empty credentials'),('X11Forwarding','no','Reduce remote forwarding attack surface'),('MaxAuthTries','3','Finding 009: limit brute-force attempts'),('ClientAliveInterval','300','Limit unattended SSH sessions'),('ClientAliveCountMax','2','Expire unresponsive sessions after about 10 minutes'),('AllowUsers','medadmin sysadmin','Restrict administrative SSH access'),('Protocol','2','Require SSH protocol v2 only where supported'),('LoginGraceTime','60','Limit pre-authentication exposure'),('Banner','/etc/issue.net','Warn of monitored, authorized-only access'),('KbdInteractiveAuthentication','no','Block PAM keyboard-interactive password bypass')]
block='# BEGIN MEDDEFENSE SSH HARDENING\n'+''.join(map(lambda r:'# '+r[2]+'\n'+r[0]+' '+r[1]+'\n',rules))+'# END MEDDEFENSE SSH HARDENING\n'
p.write_text(block+original); print(''.join(map(lambda r:'    '+r[0]+' '+r[1]+'\n',rules[:-1])),end='')
PY
printf '%s\n' 'Authorized access only. Activity may be monitored and logged.' > "$banner"; chmod 644 "$banner"
printf '[*] Validating SSH configuration...\n'; if ! /usr/sbin/sshd -t 2>"$err"; then if grep -Eqi '(bad configuration option|unsupported option).*protocol' "$err"; then sed -i 's/^Protocol 2$/# Protocol 2: OpenSSH now supports only SSHv2; legacy directive unsupported/' "$cfg"; echo '    Protocol 2 implicit (legacy directive unsupported)'; else cat "$err" >&2; exit 1; fi; fi
/usr/sbin/sshd -t; /usr/sbin/sshd -T | python3 -c 'import sys; d=dict(map(lambda s:s.rstrip("\n").split(" ",1),filter(lambda s:" " in s,sys.stdin))); expected=dict(permitrootlogin="no",passwordauthentication="no",permitemptypasswords="no",x11forwarding="no",maxauthtries="3",clientaliveinterval="300",clientalivecountmax="2",allowusers="medadmin sysadmin",logingracetime="60",banner="/etc/issue.net",kbdinteractiveauthentication="no"); assert all(map(lambda k:d.get(k)==expected[k],expected)), "Effective SSH settings differ from required policy"'; echo '    sshd -t: OK'
echo '[*] Restarting SSH service...'; systemctl restart ssh; systemctl is-active --quiet ssh; ok=1; echo '    ssh.service: active (running)'; echo 'Settings applied: 11 (Protocol 2 may be implicit)'
