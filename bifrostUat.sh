#!/bin/bash
#usage ./bifrostUat.sh [media|core|proxy|proxy-core]
# Server details
SERVER="54.159.106.24"
USER="admin"

# Port groups
ALL_PORTS=(2224 2227 2223 2225 2229 2222 2226 2228)
MEDIA_PORTS=(2222 2226 2228)
CORE_PORTS=(2223 2225 2229)
PROXY_PORTS=(2224 2227)
PROXY_CORE_PORTS=(2223 2225 2224 2227 2229) 

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
    if [[ $PORT == 2222 || $PORT == 2226 || $PORT == 2228 ]]; then
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER -t 'sudo su - csiq && cd ~/CSIQ-Callcontroller && exec bash'" &
    else
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER; exec bash" &
    fi
done


