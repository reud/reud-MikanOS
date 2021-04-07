#bin/sh

# ref: https://blog.longkey1.net/2019/11/09/windows-on-manjaro-arch-linux-with-kvm/
qemu-img create -f raw disk.img 200M
mkfs.fat -n 'MIKAN OS' -s 2 -f 2 -R 32 -F 32 disk.img
mkdir -p mnt
sudo mount -o loop disk.img mnt
sudo mkdir -p mnt/EFI/BOOT
sudo cp hello-world.efi mnt/EFI/BOOT/BOOTX64.EFI
sudo umount mnt
