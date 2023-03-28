#!/bin/bash

# Check if the user has provided the IP address
if [ -z "$1" ]; then
  echo "Usage: $0 <IP_ADDRESS>"
  exit 1
fi

# Set the IP address and the port range to scan
IP_ADDRESS="$1"
START_PORT=1
END_PORT=65535

# Function to check for open ports
check_ports() {
  for port in $(seq $START_PORT $END_PORT); do
    nc -z -v -w1 $IP_ADDRESS $port 2>&1 | grep -E "succeeded|open"
  done
}

# Run the function to check for open ports
check_ports
