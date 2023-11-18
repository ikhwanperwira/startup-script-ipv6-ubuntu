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


wget -N https://raw.githubusercontent.com/wawan-ikhwan/startup-script-ipv6-ubuntu/main/.env

# importing var from .env
source .env

# assigning variable dns_server from MY_IPV6 var
dns_server=$MY_IPV6

# regex for IPv6 validation
ipv6_regex='^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$'

# check if dns_server is a valid IPv6 using the provided regex
if [[ $dns_server =~ $ipv6_regex ]]; then
  # Check if the provided DNS server is already set
  if grep -q "^DNS=$dns_server" /etc/systemd/resolved.conf; then
    echo "DNS server is already set to $dns_server"
    return
  fi

  # Check if there is an uncommented line for DNS
  if grep -q '^DNS=' /etc/systemd/resolved.conf; then
    # If found, overwrite existing DNS server to the new DNS server
    sudo sed -i '/^DNS=/ s/=.*$/='"$dns_server"'/' /etc/systemd/resolved.conf 
  else
    # If not found, create a new DNS key with the specified DNS server
    echo "DNS=$dns_server" | sudo tee -a /etc/systemd/resolved.conf > /dev/null
  fi

  # Restart the systemd-resolved service
  sudo systemctl restart systemd-resolved
else
  echo "Invalid IPv6 address: $dns_server"
fi

# Self destroy
rm -rf ./setup-warp-team.sh .env