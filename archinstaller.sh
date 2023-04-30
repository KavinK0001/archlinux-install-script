#!/bin/bash
clear

echo "Hello!"
sleep 2
read -p "Enter country for reflector mirrorlist: " country
echo "This might take a while..."
reflector --country $country --sort rate --save /etc/pacman.d/mirrorlist >/dev/null 2>&1
echo "Fetched the latest mirrors from $country!"

echo "Press ENTER to enter cfdisk"
read foo
cfdisk
clear


read -p "Enter efi partition (Leave blank if installing on a legacy BIOS system): " efi_system
read -p "Enter swap partition (Leave blank if not necessary): " swap_partition
read -p "Enter root partition: " root_partition

echo "This will format the entered devices... Press Enter to confirm. If you want to make changes, press Ctrl + C and restart the script "
echo "efi  = $efi_system"
echo "swap = $swap_partition"
echo "root = $root_partition"
read bar

read -p "Enter grub installation disk (Legacy BIOS only): " GRUBDISK

read -p "Installing on UEFI? (y,n): " BOOTMODE
if [ "$BOOTMODE" == "y" ]; then
  GRUBCOMMAND="grub-install --bootloader-id=GRUB --efi-directory=/boot/efi"
elif [ "$BOOTMODE" == "n" ]; then
  GRUBCOMMAND="grub-install $GRUBDISK"
fi

#profile

read -p "Which kernel do you want to use? (linux, linux-zen, linux-hardened, linux-lts): " kernel


read -p "Which profile would you like to use? (desktop, minimal): " INSTALLPROFILE
if [ "$INSTALLPROFILE" == "desktop" ]; then
  PACKAGES="base $kernel linux-firmware sudo vim neofetch grub efibootmgr dolphin plasma-meta konsole btrfs-progs networkmanager neofetch pipewire-pulse jack2"
elif [ "$INSTALLPROFILE" == "minimal" ]; then
  PACKAGES="base $kernel linux-firmware sudo vim neofetch grub efibootmgr networkmanager"
fi	

#user stuff
read -p "Enter preferred root password: " root_password
read -p "Enter the user's name: " username
read -p "Enter the user's password: " username_password
read -p "Enter the preferred hostname: " arch_hostname


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

sed -i '/ParallelDownloads = 5/s/^#//g' /etc/pacman.conf
pacstrap /mnt $PACKAGES

#generating the fstab

genfstab -U /mnt > /mnt/etc/fstab

#going into chroot

arch-chroot /mnt <<EOF
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
mkdir /boot/efi
mount $efi_system /boot/efi
$GRUBCOMMAND
grub-mkconfig -o /boot/grub/grub.cfg
sed -i "/%wheel ALL=(ALL:ALL) ALL/s/^#//g" /etc/sudoers
usermod -aG wheel $username
systemctl enable NetworkManager
systemctl enable sddm
EOF
