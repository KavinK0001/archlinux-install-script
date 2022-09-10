# Arch Linux install script (very WIP)
A simple arch install script that installs arch linux on a computer with my preferred configuration

# UEFI ONLY!
BIOS support coming soon

# Default configuration
1. Uses the btrfs filesystem with zstd compression
2. Uses the stock linux kernel
3. Uses KDE Plasma for the desktop
4. Uses PipeWire as the audio server
5. Uses GRUB as the default bootloader
6. The btrfs subvolume layout is compatible with timeshift's snapshot functionality (just make sure not to enable backup @home subvolume)
7. Supports creating only one user while running the script for now (and gives them sudo privileges by defauly)


# Installation

Requires git to be installed
Clone this repo with `git clone https://KavinK0001/archlinux-install-script`
cd into the directory: `cd archlinux-install-script`
execute the script: `bash archinstaller.sh`

And follow the setup
