#!/bin/zsh
set -eEuxo pipefail

buildctl build \
  --frontend=dockerfile.v0 \
  --local context=. \
  --local dockerfile=. \
  --opt target=export \
  --allow security.insecure \
  --output type=tar,dest=/tmp/build.tar

rm -rf ./dist
mkdir -p ./dist
tar -xf /tmp/build.tar -C ./dist

# qemu-system-x86_64 \
#     -enable-kvm -cpu host -m 2G -smp 2 -machine q35 \
#     -drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE.fd \
#     -drive file=particleos-debian.qcow2,media=disk,format=qcow2 \
#     -net dev=nic,model=virtio -net user,hostfwd=tcp::2222-:22 \
#     -vga virtio

# homectl create developer \
#     --storage=luks \
#     --real-name="Main Developer Account" \
#     --member-of=sudo,wheel \
#     --password=your_secure_password

