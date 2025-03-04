#!/bin/bash

# Server details
SERVER="54.159.106.24"
USER="admin"

# Port range

PORT_ARRAY=(2224 2227 2223 2225 2229 2222 2226 2228)

# Loop through the port range and open each SSH session in a new terminal
for PORT in "${PORT_ARRAY[@]}"; do
        # Check if the port matches the special case
    if [[ $PORT == 2222 || $PORT == 2226 || $PORT == 2228 ]]; then
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER -t 'sudo su - csiq && cd ~/CSIQ-Callcontroller && exec bash'" &
    else
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER; exec bash" &
    fi
done


