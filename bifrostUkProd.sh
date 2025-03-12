#!/bin/bash

# Server details
SERVER="51.24.8.28"
USER="admin"


PORT_ARRAY=(2224 2225 2222 2223 2226 2227 2228)

# Loop through the port range and open each SSH session in a new terminal
for PORT in "${PORT_ARRAY[@]}"; do
         # Check if the port matches the special case
    if [[ $PORT == 2226 || $PORT == 2227 ]]; then
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER -t 'sudo su - csiq && cd ~/CSIQ-Callcontroller && exec bash'" &
    else
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER; exec bash" &
    fi
done
