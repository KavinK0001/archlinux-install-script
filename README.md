# Arch Linux install script (very WIP)
A simple arch install script that installs arch linux on a computer with a configuration most people would be happy with

# UEFI works now!
haha fixed it now

# You can now choose between minimal and desktop mode
yessir

# Features (ignore whatever doesn't apply to a minimal system)
1. Uses the btrfs filesystem with zstd compression
2. Lets you choose the kernel you want to use
3. Uses KDE Plasma for the desktop
4. Uses PipeWire as the audio server
5. Uses GRUB as the default bootloader
6. The btrfs subvolume layout is compatible with timeshift's snapshot functionality (just make sure not to enable backup @home subvolume, it'll backup /home automatically)
7. Supports creating only one user while running the script for now (and gives them sudo privileges by default)
8. Can only generate locales for Indian formats

# Prerequisites
basic partitioning knowledge

# Installation
curl -LJO https://raw.githubusercontent.com/KavinK0001/archlinux-install-script/main/archinstaller.sh; chmod +x archinstaller.sh

And follow the setup as it goes
