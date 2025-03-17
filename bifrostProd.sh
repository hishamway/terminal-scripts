#!/bin/bash
#usage ./bifrostProd.sh [media|core|proxy|proxy-core]

# Server details
SERVER="3.221.147.179"
USER="admin"


# Port groups
ALL_PORTS=(2245 2243 2244 2246 2248 2247 2250 2249)
MEDIA_PORTS=(2245 2248 2250)
CORE_PORTS=(2243 2246 2249)
PROXY_PORTS=(2244 2247)
PROXY_CORE_PORTS=(2243 2244 2246 2247 2249)

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
    if [[ $PORT == 2245 || $PORT == 2248 || $PORT == 2250 ]]; then
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER -t 'sudo su - csiq && cd ~/CSIQ-Callcontroller && exec bash'" &
    else
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER; exec bash" &
    fi
done
