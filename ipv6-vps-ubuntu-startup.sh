#!/bin/bash

apt update -y
apt upgrade -y
apt install screen -y
echo 'caption always "%{= kc}Screen session on %H (system load: %l)%-28=%{= .m}%D %d.%m.%Y %0c"' >> /root/.screenrc
echo 'termcapinfo xterm* ti@:te@' >> /root/.screenrc
echo "screen -DRR" >> /root/.profile

wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh
chmod +x /root/menu.sh
echo "" | /root/menu.sh 4

wget -N https://github.com/rclone/rclone/releases/download/v1.64.2/rclone-v1.64.2-linux-amd64.zip