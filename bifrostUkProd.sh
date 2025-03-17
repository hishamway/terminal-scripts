#!/bin/bash
#usage ./bifrostUkProd.sh [media|core|proxy|proxy-core]

# Server details
SERVER="51.24.8.28"
USER="admin"

# Port groups
ALL_PORTS=(2224 2225 2222 2223 2226 2227 2228)
MEDIA_PORTS=(2226 2227)
CORE_PORTS=(2222 2223)
PROXY_PORTS=(2224 2225)
PROXY_CORE_PORTS=(2222 2223 2224 2225)

# Argument check
if [[ "$1" == "media" ]]; then
    PORT_ARRAY=("${MEDIA_PORTS[@]}")
elif [[ "$1" == "core" ]]; then
    PORT_ARRAY=("${CORE_PORTS[@]}")
elif [[ "$1" == "proxy" ]]; then
    PORT_ARRAY=("${PROXY_PORTS[@]}")
elif [[ "$1" == "proxy-core" ]]; then
    PORT_ARRAY=("${PROXY_CORE_PORTS[@]}")
elif [[ "$1" == "all" ]]; then
    PORT_ARRAY=("${ALL_PORTS[@]}")
else
    echo "Usage: $0 {media|all}"
    exit 1
fi

# Loop through the port range and open each SSH session in a new terminal
for PORT in "${PORT_ARRAY[@]}"; do
         # Check if the port matches the special case
    if [[ $PORT == 2226 || $PORT == 2227 ]]; then
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER -t 'sudo su - csiq && cd ~/CSIQ-Callcontroller && exec bash'" &
    else
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER; exec bash" &
    fi
done
