#!/bin/bash

update_resolved_conf() {
  local dns_server="$1"

  # Check if the DNS server is already present in the file
  if grep -q "^DNS=$dns_server" /etc/systemd/resolved.conf; then
    echo "DNS server $dns_server is already present. No changes made."
    return
  fi

  # Check if the DNS key already exists in the file
  if grep -q '^#?DNS=' /etc/systemd/resolved.conf; then
    # If found, uncomment the line and append the new DNS server
    sudo sed -i '/^#DNS=/ s/^#//; /^DNS=/ s/$/ '"$dns_server"'/' /etc/systemd/resolved.conf
  else
    # If not found, add a new line with the DNS server
    echo "DNS=$dns_server" | sudo tee -a /etc/systemd/resolved.conf > /dev/null
  fi

  # Restart the systemd-resolved service
  sudo systemctl restart systemd-resolved
}

# Check if the user provided an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <dns_server>"
  exit 1
fi

# Call the function with the provided DNS server argument
update_resolved_conf "$1"
