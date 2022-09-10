#!/bin/bash

clear

echo "Press any key to enter cfdisk to create your partitions"
read rafrgrgdfgds
cfdisk
clear

echo "Enter efi partition id"
read efi_system

echo "Enter swap partition id"
read swap_partition

echo "Enter the root partition id: "
read root_partition

echo "This will format the entered devices... Press Enter to confirm. If you want to make changes, press Ctrl + C and restart the script "
echo "efi  = $efi_system"
echo "swap = $swap_partition"
echo "root = $root_partition"
read randomvariable

#user stuff
echo "What do you want your root password to be?"
read root_password

echo "Enter a username: "
read username

echo "Enter a password for the user: "
read username_password

echo "Enter your preferred hostname: "
read arch_hostname

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

pacstrap /mnt base linux linux-firmware sudo nano grub efibootmgr dolphin plasma-meta konsole btrfs-progs networkmanager neofetch pipewire-pulse pipewire-jack pipewire-alsa

#generating the fstab

genfstab -U /mnt > /mnt/etc/fstab

#going into chroot

arch-chroot /mnt <<EOF
set -e
echo "root:$root_password" | chpasswd
useradd -m $username
echo "$username:$username_password" | chpasswd
sed -i "/en_IN/s/^#//g" /etc/locale.gen
locale-gen
echo LANG=en_IN.UTF-8 > /etc/locale.conf
echo $arch_hostname > /etc/hostname
export LANG=en_IN.UTF-8
{
        echo '127.0.0.1       localhost'
        echo '::1             localhost'
        echo '127.0.1.1       $arch_hostname'
} >> /etc/hosts
timedatectl set-timezone Asia/Kolkata
mkdir /boot/efi
mount $efi_system /boot/efi
grub-install --target=x86_64-efi --bootloader-id=archbtw --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
sed -i "/%wheel ALL=(ALL:ALL) ALL/s/^#//g" /etc/sudoers
usermod -aG wheel $username
systemctl enable NetworkManager
systemctl enable sddm
EOF

clear
echo "Finished installing! Click enter to reboot"
read gtrtguytrbrygrtg
reboot