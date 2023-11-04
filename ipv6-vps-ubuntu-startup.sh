#!/bin/bash

# argument $1 diisi dengan konfigurasi rclone.conf

export DEBIAN_FRONTEND=noninteractive
apt -y update
apt -y upgrade
apt -y install screen
echo 'caption always "%{= kc}Screen session on %H (system load: %l)%-28=%{= .m}%D %d.%m.%Y %0c"' >> /root/.screenrc
echo 'termcapinfo xterm* ti@:te@' >> /root/.screenrc
echo "screen -DRR" >> /root/.profile

wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh
chmod +x /root/menu.sh
echo "" | /root/menu.sh 4
exec bash

wget -N https://github.com/rclone/rclone/releases/download/v1.64.2/rclone-v1.64.2-linux-amd64.zip
apt -y install unzip
unzip rclone-v1.64.2-linux-amd64.zip
cp rclone-v1.64.2-linux-amd64/rclone /bin
mkdir /root/.config
mkdir /root/.config/rclone
cp $1 /root/.config/rclone