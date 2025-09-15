# https://wiki.archlinux.org/title/Installation_guide
# https://wiki.archlinux.org/title/EFI_boot_stub

curl -sSLO https://archlinux.org/static/netboot/ipxe-arch.efi
gdisk /dev/usb_disk
mkfs.fat -F 32 /dev/usb_disk
cp pxe-arch.efi /mnt/EFI/BOOT/BOOTx64.EFI

gdisk /dev/root_disk
mkfs.fat -F 32 /dev/efi_system_partition
mkfs.ext4 /dev/root_partition
mount /dev/root_partition /mnt
mount --mkdir /dev/efi_system_partition /mnt/boot
pacstrap -K /mnt base linux linux-firmware efibootmgr dhcpcd NetworkManager openssh vim curl zsh man-db

lsblk
blkid
findmnt /mnt

genfstab -U /mnt >> /mnt/etc/fstab
efibootmgr --create --disk /dev/nvme0n1 --part 6 --label "Arch Linux" --loader '\vmlinuz-linux' --unicode ' root=UUID=root_disk5_not_boot_disk6 rw initrd=\initramfs-linux.img'

arch-chroot /mnt
passwd
# ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
# /etc/locale.gen
# /etc/locale.conf

# reboot
systemctl enable --now NetworkManager
systemctl enable --now dhcpcd
systemctl enable --now sshd
systemctl enable --now systemd-networkd
systemctl enable --now systemd-resolved
systemctl enable --now systemd-timesyncd
systemctl enable --now rtkit-daemon

nmcli device wifi list
nmcli device wifi connect "SSID_NAME" password "WIFI_PASSWORD"

timedatectl

pacman -Syu nvidia-open nvidia-utils linux-headers mesa
pacman -Syu ntfs-3g
pacman -Syu gptfdisk
pacman -S sway swaylock swayidle ttf-input-nerd ghostty firefox pipewire-jack playerctl brightnessctl wl-clipboard wev rtkit jq git git-zsh-completion 
pacman -S make pkg-config debugedit fakeroot

echo 1 > /sys/module/kernel/parameters/consoleblank
setterm --blank 2

# waybar wl-clipboard grim slurp
# wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+

useradd -m gert
usermod -aG video gert
usermod -aG audio gert
usermod -aG wheel gert

# echo "Battery: $(cat /sys/class/power_supply/BAT1/capacity)% ($(cat /sys/class/power_supply/BAT1/status))"
# /sys/class/power_supply/BAT1/capacity
# /sys/class/power_supply/BAT1/status
# /sys/class/backlight/amdgpu_bl0/max_brightness
# /sys/class/backlight/nvidia_wmi_ec_backlight/brightness
# /sys/class/leds/asus::kbd_backlight

brightnessctl -d asus::kbd_backlight info
brightnessctl -d asus::kbd_backlight set 1

export WLR_EGL_PLATFORM=drm
export GBM_BACKEND=nvidia-drm

###############################################################################

git clone https://aur.archlinux.org/supergfxctl.git
git clone https://aur.archlinux.org/asusctl.git

makepkg -si

# [Install]
# WantedBy=multi-user.target

systemctl edit asusd
systemctl daemon-reexec

systemctl enable --now asusd
systemctl enable --now supergfxd

