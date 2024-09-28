#!/bin/bash

# Colors for output
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
CYAN='\e[36m'
RESET='\e[0m'

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if dig and nmap are installed
if ! command_exists dig || ! command_exists nmap; then
    echo -e "${RED}Error: dig and/or nmap are not installed. Please install the>
    exit 1
fi

# Check if domain or IP is provided as an argument
if [ -z "$1" ]; then
  echo -e "${RED}Usage: $0 <domain or IP>${RESET}"
  exit 1
fi

# Get the domain/IP from the first argument
TARGET=$1

# Resolve the domain to an IP address using dig
echo -e "${CYAN}Finding IP address for: ${TARGET}${RESET}"
IP_ADDRESS=$(dig +short $TARGET)

# Check if dig was able to resolve the IP address
if [ -z "$IP_ADDRESS" ]; then
  echo -e "${RED}Error: Unable to resolve IP address for ${TARGET}.${RESET}"
  exit 1
fi

# Output the resolved IP address
echo -e "${GREEN}IP address for ${TARGET} is: ${IP_ADDRESS}${RESET}"

# Ask the user if they want to perform a port scan
read -p "Do you want to scan open ports on $IP_ADDRESS? (y/n): " answer

# If the user agrees, perform the port scan using nmap
if [ "$answer" == "y" ] || [ "$answer" == "Y" ]; then
  echo -e "${YELLOW}Scanning open ports on ${IP_ADDRESS}...${RESET}"

  # Use nmap to scan for open ports
  nmap -Pn $IP_ADDRESS

  # Check if nmap executed successfully
  if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to scan ports.${RESET}"
    exit 1
  fi
else
  echo -e "${CYAN}Port scanning skipped.${RESET}"
fi