#!/bin/bash

# 🧼 Styling
GREEN="\e[1;32m"
BLUE="\e[1;34m"
YELLOW="\e[1;33m"
RESET="\e[0m"

# 🧾 Banner
clear
echo -e "${GREEN}===================================="
echo -e "      🌐 LOCALHOST LAUNCHER         "
echo -e "====================================${RESET}"

# 📁 List folders as numbered options
echo -e "\n${BLUE}Choose a project to deploy:${RESET}"
folders=()
i=1
for d in */ ; do
  folders+=("$d")
  echo -e "${i}) ${YELLOW}${d%/}${RESET}"
  ((i++))
done
echo -e "${i}) Advanced Settings"
echo -e "$((i+1))) Exit"

# 🎮 User input
read -p "Option: " opt

# Exit if chosen
if [[ "$opt" == "$((i+1))" ]]; then
  echo -e "\n❌ Exiting."
  exit 0
fi

# Advanced
if [[ "$opt" == "$i" ]]; then
  echo -e "\n⚙️  Advanced options coming soon!"
  exit 0
fi

# Get folder choice
selected_folder="${folders[$((opt-1))]}"
if [ -z "$selected_folder" ]; then
  echo -e "\n❌ Invalid selection."
  exit 1
fi

# Get current timestamp, timezone, IP geolocation, and device info
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
timezone=$(date +'%Z%z')  # Get the local timezone of the machine
ip_address=$(curl -s ifconfig.me)  # Getting the public IP address
geolocation=$(curl -s "http://ip-api.com/json/$ip_address" | jq -r '"City: " + .city + ", Country: " + .country')  # Using ip-api to get geolocation
device_info=$(uname -a)  # Device info (can be modified to capture more detailed info if necessary)

# Ask for username and password (for this demo, we are simulating as a placeholder)
read -p "Enter username: " username
read -p "Enter password: " password

# Log and display information
echo -e "\n${GREEN}[INFO]${RESET} Logging info..."
echo -e "\n[Timestamp: $timestamp] - Target: ${selected_folder}" >> log.txt
echo -e "Username: $username" >> log.txt
echo -e "Password: $password" >> log.txt
echo -e "IP Address: $ip_address" >> log.txt
echo -e "Geolocation: $geolocation" >> log.txt
echo -e "Timezone: $timezone" >> log.txt
echo -e "Device Info: $device_info\n" >> log.txt

# Display the info to the user
echo -e "\n${GREEN}[INFO]${RESET} Target info collected:"
echo -e "[Timestamp: $timestamp] - Target: ${selected_folder}"
echo -e "Username: ${YELLOW}$username${RESET}"
echo -e "Password: ${YELLOW}$password${RESET}"
echo -e "IP Address: ${YELLOW}$ip_address${RESET}"
echo -e "Geolocation: ${YELLOW}$geolocation${RESET}"
echo -e "Timezone: ${YELLOW}$timezone${RESET}"
echo -e "Device Info: ${YELLOW}$device_info${RESET}"

# Ask for port
read -p "Enter port (default 8080): " port
port=${port:-8080}

# Serve
cd "$selected_folder" || { echo "❌ Folder not found."; exit 1; }
php -S 127.0.0.1:$port > /dev/null 2>&1 &

SERVER_PID=$!
sleep 1
echo -e "\n✅ ${GREEN}Localhost running at: http://127.0.0.1:$port${RESET}"

# Ask for tunnel
echo -e "\n🌐 Do you want to tunnel it?"
echo "1) Ngrok"
echo "2) Cloudflared"
echo "3) Skip"
read -p "Option: " tunnel_opt

if [[ "$tunnel_opt" == "1" ]]; then
  if command -v ngrok &> /dev/null; then
    ngrok http $port > /dev/null &
    sleep 3
    PUBLIC_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')
    echo -e "\n🔗 Public URL: ${GREEN}$PUBLIC_URL${RESET}"
  else
    echo "❌ Ngrok not installed."
  fi
elif [[ "$tunnel_opt" == "2" ]]; then
  if command -v cloudflared &> /dev/null; then
    PUBLIC_URL=$(cloudflared tunnel --url http://127.0.0.1:$port 2>&1 | grep -o 'https://.*trycloudflare.com')
    echo -e "\n🔗 Public URL: ${GREEN}$PUBLIC_URL${RESET}"
  else
    echo "❌ Cloudflared not installed."
  fi
else
  echo -e "\n🛑 Tunnel skipped."
fi

echo -e "\n⏹ Press Ctrl+C to stop the server."
wait $SERVER_PID
