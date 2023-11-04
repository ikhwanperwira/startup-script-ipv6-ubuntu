#!/bin/bash

# catatan, jalankan skrip ini di direktori /root
# argument $1 diisi dengan password rclone_conf yait awalannya T akhirannya _

# updating
export DEBIAN_FRONTEND=noninteractive
apt -y update
apt -y upgrade

# install screen
apt -y install screen
echo 'caption always "%{= kc}Screen session on %H (system load: %l)%-28=%{= .m}%D %d.%m.%Y %0c"' >> /root/.screenrc
echo 'termcapinfo xterm* ti@:te@' >> /root/.screenrc
echo "screen -DRR" >> /root/.profile

# install warp
wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh ||
chmod +x /root/menu.sh ||
yes "" | /root/menu.sh 4 ||

# sesuatu barrier agar bisa memanggil
echo "sleeping" ||
sleep 2
echo "done sleep"

# install rclone
yes "" | wget -N https://github.com/rclone/rclone/releases/download/v1.64.2/rclone-v1.64.2-linux-amd64.zip
apt -y install unzip
unzip /root/rclone-v1.64.2-linux-amd64.zip
cp /root/rclone-v1.64.2-linux-amd64/rclone /bin

# configuring rclone
yes "" | wget -N https://github.com/wawan-ikhwan/startup-script-ipv6-ubuntu/raw/main/rclone_conf.zip
unzip -o -P $1 /root/rclone_conf.zip
mkdir /root/.config
mkdir /root/.config/rclone
cp /root/rclone.conf /root/.config/rclone

# mounting rclone
mkdir /mnt/gdunsri
/bin/rclone mount gdunsri:/ /mnt/gdunsri --daemon
