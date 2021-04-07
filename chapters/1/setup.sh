#bin/sh

# Manjaro LinuxのKVMセットアップコマンド
yay -S qemu libvirt ebtables dnsmasq virt-manager

# ユーザをKVMグループに追加
sudo gpasswd -a reud kvm

# 他の参考

# https://blog.longkey1.net/2019/11/09/windows-on-manjaro-arch-linux-with-kvm/
