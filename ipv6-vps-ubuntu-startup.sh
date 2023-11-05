#!/bin/bash

# catatan, jalankan skrip ini di direktori /root
# argument $1 diisi dengan password rclone_conf yait awalannya T akhirannya _

expected_hash="c33de7686f61c393647fc1116604bacc07718a580e9cecd6121d1025fcbc3f2f"

# Check if an argument was provided
if [ -z "$1" ]; then
  echo "No input string provided. Exiting."
  exit 1
fi

# Calculate the SHA-256 hash of the input string
input_hash=$(echo -n "$1" | sha256sum | awk '{print $1}')

# Check if the calculated hash matches the expected hash
if [ "$input_hash" != "$expected_hash" ]; then
  echo "Hash does not match. Exiting."
  exit 1
fi

# If the hash matches, continue with the rest of script....
echo "Hash matches. Continuing with the script."

# updating
export DEBIAN_FRONTEND=noninteractive
apt -y update
apt -y upgrade

# install screen
apt -y install screen
echo 'caption always "%{= kc}Screen session on %H (system load: %l)%-28=%{= .m}%D %d.%m.%Y %0c"' >> /root/.screenrc
echo 'termcapinfo xterm* ti@:te@' >> /root/.screenrc
echo "screen -DRR" >> /root/.profile

# sesuatu barrier agar bisa memanggil
echo "sleeping"
sleep 2
echo "done sleep"

# install warp
wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh
chmod +x /root/menu.sh
echo "" | /root/menu.sh 4

# sesuatu barrier agar bisa memanggil
echo "sleeping"
sleep 2
echo "done sleep"

# install rclone
wget -N https://github.com/rclone/rclone/releases/download/v1.64.2/rclone-v1.64.2-linux-amd64.zip
apt -y install unzip
unzip /root/rclone-v1.64.2-linux-amd64.zip
cp /root/rclone-v1.64.2-linux-amd64/rclone /bin

# configuring rclone
wget -N https://github.com/wawan-ikhwan/startup-script-ipv6-ubuntu/raw/main/rclone_conf.zip
unzip -o -P $1 /root/rclone_conf.zip
mkdir /root/.config
mkdir /root/.config/rclone
cp /root/rclone.conf /root/.config/rclone

# creating fuse device
apt -y install fuse3
if hostnamectl | grep -q openvz && [ ! -e /dev/fuse ]; then
  wget -N https://raw.githubusercontent.com/wawan-ikhwan/startup-script-ipv6-ubuntu/main/create-fuse-node.sh
  wget -N https://raw.githubusercontent.com/wawan-ikhwan/startup-script-ipv6-ubuntu/main/create-fuse-node.service
  chmod 777 /root/create-fuse-node.sh 
  mv /root/create-fuse-node.sh /usr/local/bin/
  mv /root/create-fuse-node.service /etc/systemd/system/create-fuse-node.service
  systemctl daemon-reload
  systemctl enable create-fuse-node.service
  systemctl start create-fuse-node.service
else
  echo "This virtualization is not OpenVZ or /dev/fuse already exists"
fi

# rclone mounting setup
mkdir /mnt/gdunsri
fusermount -u /mnt/gdunsri

# startup mount
wget -N https://raw.githubusercontent.com/wawan-ikhwan/startup-script-ipv6-ubuntu/main/rclone-mount.service
mv /root/rclone-mount.service /etc/systemd/system/rclone-mount.service
systemctl daemon-reload
systemctl enable rclone-mount.service
systemctl start rclone-mount.service

# cleaning resource
rm -rf ipv6-vps-ubuntu-startup.sh menu.sh rclone.conf rclone_conf.zip rclone-v1.64.2-linux-amd64 rclone-v1.64.2-linux-amd64.zip

# tampilkan direktori yang dimount
echo "menampilkan direktori /mnt/gdunsri..."
sleep 2
ls /mnt/gdunsri