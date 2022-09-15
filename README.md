# Arch Linux install script (very WIP)
A simple arch install script that installs arch linux on a computer with a configuration most people would be happy with

# UEFI ONLY! (kind of)
just realised, if you just don't enter anything when it asks you to enter your efi partition, it works on legacy bios too lol (it still installs efibootmgr though)

# Default configuration (doesn't really allow you to customize anything tbh, will be improved soon)
1. Uses the btrfs filesystem with zstd compression
2. [UPDATE]: Lets you choose the kernel you want to use!
3. Uses KDE Plasma for the desktop
4. Uses PipeWire as the audio server
5. Uses GRUB as the default bootloader
6. The btrfs subvolume layout is compatible with timeshift's snapshot functionality (just make sure not to enable backup @home subvolume, it'll backup /home automatically)
7. Supports creating only one user while running the script for now (and gives them sudo privileges by default)
8. Can only generate locales for Indian formats

# Prerequisites
1. Git, Install with: `pacman -Sy git`
2. And some basic partitioning knowledge

# Installation
`git clone https://KavinK0001/archlinux-install-script; cd archlinux-install-script; bash archinstaller.sh`

And follow the setup as it goes
