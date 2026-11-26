#!/bin/bash
set -u
[[ $EUID -eq 0 ]] || { echo 'Run with sudo'; exit 1; }
mode="${1:---audit}"; [[ "$mode" == --audit || "$mode" == --apply ]] || { echo "Usage: $0 [--audit|--apply]"; exit 2; }
required=(ssh.service apache2.service mysql.service) # Secure admin; billing web; billing database
required+=(ufw.service auditd.service apparmor.service) # Firewall; audit trail; mandatory access controls
required+=(cron.service rsyslog.service systemd-timesyncd.service) # Scheduled billing jobs; logging; clock synchronization
required+=(rc-local.service snmpd.service) # Lab loopback IP aliases; service monitoring (verify business need)
protected=(systemd-networkd.service NetworkManager.service networking.service systemd-resolved.service dbus.service systemd-logind.service systemd-udevd.service systemd-journald.service getty@tty1.service lvm2-monitor.service) # Core OS/network access
unneeded=(avahi-daemon.service cups.service cups-browsed.service ModemManager.service bluetooth.service rpcbind.service multipathd.service open-iscsi.service open-vm-tools.service lxd-agent.service vgauth.service) # Reviewed nonessential services for this KVM billing VM
mapfile -t enabled < <(systemctl list-unit-files --type=service --state=enabled --no-legend --no-pager | awk '{print $1}')
before=${#enabled[@]}; disabled=0; review=0
printf '[*] Enabled services: %d | Required whitelist: %d | Mode: %s\n' "$before" "${#required[@]}" "$mode"
while IFS= read -r svc; do
  [[ -z "$svc" ]] && continue
  if [[ " ${required[*]} " == *" $svc "* ]]; then printf '%-36s [%s]\n' "$svc" "$(systemctl is-active "$svc" 2>/dev/null)"; continue; fi
  if [[ " ${protected[*]} " == *" $svc "* ]]; then printf '%-36s [PROTECTED]\n' "$svc"; continue; fi
  if [[ " ${unneeded[*]} " != *" $svc "* ]]; then printf '%-36s [REVIEW]\n' "$svc"; ((review+=1)); continue; fi
  if [[ "$mode" == --audit ]]; then printf '%-36s [WOULD STOP + DISABLE]\n' "$svc"; continue; fi
  if systemctl disable --now "$svc" >/dev/null 2>&1; then printf '%-36s [STOPPED] [DISABLED]\n' "$svc"; ((disabled+=1)); else printf '%-36s [FAILED]\n' "$svc"; fi
done < <(printf '%s\n' "${enabled[@]}")
printf '%s\n' '[*] Verifying required services...'
while IFS= read -r svc; do systemctl list-unit-files "$svc" --no-legend 2>/dev/null | grep -q . && printf '%-36s [%s]\n' "$svc" "$(systemctl is-active "$svc" 2>/dev/null)" || printf '%-36s [NOT INSTALLED]\n' "$svc"; done < <(printf '%s\n' "${required[@]}")
after=$(systemctl list-unit-files --type=service --state=enabled --no-legend --no-pager | awk 'END{print NR}')
printf 'Before: %d | After: %d | Disabled: %d | Review: %d\n' "$before" "$after" "$disabled" "$review"
