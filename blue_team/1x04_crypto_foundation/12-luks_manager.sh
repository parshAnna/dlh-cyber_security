#!/bin/bash
set -euo pipefail
umask 077
mode=${1:-}; size=${2:-}
base="$HOME/.local/share/meddefense-crypto/luks_task12"
img="$base/managed_volume.img"; mnt="$base/managed_mount"; name=secure_vol
mkdir -p "$base"; chmod 700 "$base"
case "$mode" in
  create)
    [[ "$size" =~ ^[0-9]+$ ]] && (( size >= 64 && size <= 4096 )) || { echo "Usage: $0 create SIZE_MiB (64..4096)" >&2; exit 2; }
    [[ ! -e "$img" && ! -L "$img" ]] || { echo "Refusing to overwrite existing image" >&2; exit 1; }
    dd if=/dev/zero of="$img" bs=1M count="$size" conv=excl status=progress
    sudo cryptsetup luksFormat --type luks2 --verify-passphrase "$img"
    sudo cryptsetup open "$img" "$name"
    sudo mkfs.ext4 "/dev/mapper/$name" || { sudo cryptsetup close "$name"; exit 1; }
    sudo cryptsetup close "$name"
    ;;
  open)
    [[ -f "$img" ]] || { echo "Image not found; run create first" >&2; exit 1; }
    mkdir -p "$mnt"; sudo cryptsetup open "$img" "$name"
    sudo mount -o nodev,nosuid,noexec "/dev/mapper/$name" "$mnt" || { sudo cryptsetup close "$name"; exit 1; }
    echo "Mounted encrypted filesystem: $mnt";;
  close) sudo umount "$mnt" && sudo cryptsetup close "$name" ;;
  *) echo "Usage: $0 {create SIZE_MiB|open|close}" >&2; exit 2 ;;
esac
