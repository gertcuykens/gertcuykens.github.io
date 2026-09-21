#!/bin/zsh
set -eEuxo pipefail

# apt install ovmf
# apt install qemu-system-x86 qemu-system-gui qemu-utils

if [ -f "/usr/share/OVMF/OVMF_CODE.fd" ]; then
    OVMF_CODE="/usr/share/OVMF/OVMF_CODE.fd"
    OVMF_VARS="/usr/share/OVMF/OVMF_VARS.fd"
elif [ -f "/usr/share/edk2/x64/OVMF_CODE.fd" ]; then
    OVMF_CODE="/usr/share/edk2/x64/OVMF_CODE.fd"
    OVMF_VARS="/usr/share/edk2/x64/OVMF_VARS.fd"
elif [ -f "/opt/homebrew/share/qemu/edk2-x86_64-code.fd" ]; then
    OVMF_CODE="/opt/homebrew/share/qemu/edk2-x86_64-code.fd"
    OVMF_VARS="/opt/homebrew/share/qemu/edk2-i386-vars.fd"
else
    echo "❌ Error: UEFI OVMF firmware files not found."
    echo "Please install 'ovmf' or 'edk2-ovmf' on your host system."
    exit 1
fi

OVMF_LOCAL="local_vars.fd"

if [ ! -f "$OVMF_LOCAL" ]; then
    echo "🔄 Initializing persistent UEFI NVRAM variables..."
    cp "$OVMF_VARS" "$OVMF_LOCAL"
fi

IMAGE="$1"

if [ ! -f "$IMAGE" ]; then
    echo "❌ Error: Image '$IMAGE' not found in current directory."
    exit 1
fi

echo "🚀 Booting UEFI Q35 Machine..."

qemu-system-x86_64 \
    -cpu max \
    -m 2G \
    -smp 2 \
    -machine q35 \
    -device virtio-blk-pci,drive=hd0,bootindex=1 \
    -drive if=none,format=qcow2,id=hd0,cache=unsafe,discard=on,file="$IMAGE"\
    -drive if=pflash,format=raw,readonly=on,file="$OVMF_CODE" \
    -drive if=pflash,format=raw,file="$OVMF_LOCAL" \
    -device virtio-net-pci,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::2222-:22 \
    -nodefaults \
    -serial mon:stdio \
    -display none

    # -net nic,model=virtio -net user
    # -netdev user,id=net0,hostfwd=tcp::2222-:22 \
    # -device virtio-scsi-pci,id=scsi0 \
    # -device scsi-hd,drive=hd0,bus=scsi0.0,channel=0,scsi-id=0,lun=0,serial=UEFI \
    # -blockdev driver=qcow2,node-name=hd0,file.driver=file,file.filename="$IMAGE" \

    # qemu-img create -f qcow2 usr.qcow2 1G
    # -device scsi-hd,drive=hd1,bus=scsi0.0,channel=0,scsi-id=1,lun=0,serial=USR \
    # -blockdev driver=qcow2,node-name=hd1,file.driver=file,file.filename="usr.qcow2" \

    # -nographic
    # -vga virtio \
    # -display default,show-cursor=on
    # -cpu host \
    # -enable-kvm \

# echo "🌐 SSH forwarded -> ssh root@localhost -p 2222"
# echo "🔒 Log in..."
# -drive file="$IMAGE",media=disk,format=qcow2,if=virtio \
