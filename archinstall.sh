#!/bin/bash

clear

echo "Press any key to enter cfdisk to create your partitions"
read rafrgrgdfgds
cfdisk

echo "Enter efi partition id"
read efi_system

echo "Enter swap partition id"
read swap_partition

echo "Enter the root partition id: "
read root_partition

echo "This will format the entered devices... If you want to make changes, press Ctrl + C and restart the script "
read randomvariable

echo "efi  = $efi_system"
echo "swap = $swap_partition"
echo "root = $root_partition"
echo ""
echo "Installation starting in 5"
sleep 1
echo "Installation starting in 4"
sleep 1
echo "Installation starting in 3"
sleep 1
echo "Installation starting in 2"
sleep 1
echo "Installation starting in 1"
sleep 1
echo "Starting!"

#unmounts the partitions before starting the installation

umount $efi_system
swapoff $swap_partition
umount $root_partition

#making the filesystems

mkfs.fat -F32 $efi_system
mkswap $swap_partition
mkfs.btrfs -f $root_partition

#mounting the partitions and creating the necessary btrfs subvolumes

mount $root_partition /mnt
btrfs su cr /mnt/@
umount /mnt

mount -o compress=zstd,noatime,commit=120,space_cache=v2,subvol=@ $root_partition /mnt

#running pacstrap

pacstrap /mnt base linux linux-firmware sudo nano

#generating the fstab

genfstab -U /mnt > /mnt/etc/fstab

#setting root password

arch-chroot /mnt <<RANDOM
echo "Enter your root password (Don't worry if nothing shows up, your inputs are being registered)"
set -e
read root_password
passwd $root_password
RANDOM


