#!/bin/bash

# argument $1 diisi dengan token team yang bisa didapatkan di https://web--public--warp-team-api--coia-mfs4.code.run
# argument $2 diisi dengan nama perangkat

# ASUMSIKAN ipv6-vps-ubuntu-startup.sh sudah dijalankan dan warp sudah terinstall

# Check if both $1 and $2 arguments are provided
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <token team> <nama perangkat>"
  echo "Dapatkan token team di sini https://web--public--warp-team-api--coia-mfs4.code.run"
  exit 1
fi

# Check if 'warp' binary does not exist
if ! whereis warp | grep -q "bin/"; then
  echo "The 'warp' binary is not installed. Exiting."
  exit 1
fi

# Lanjutkan
echo "The 'warp' binary is installed. Continuing the script..."

# Masuk ke warp team
yes | warp a "$1"

# Mengganti nama perangkat
wget -N https://gitlab.com/fscarmen/warp/-/raw/main/api.sh
chmod +x ./api.sh
./api.sh -f /etc/wireguard/warp-account.conf -n "$2"
rm -rf ./api.sh

id=$(cat /etc/wireguard/warp-account.conf | grep 'id' | head -2 | tail -1 | awk -F '"id": "' '{print $2}' | awk -F '",' '{print $1}')
echo "Periksa daftar perangkat di https://one.dash.cloudflare.com/$id/team/devices seharusnya ada $2"

# Self destroy
rm -rf ./setup-warp-team.sh