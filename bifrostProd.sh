#!/bin/bash

# Server details
SERVER="3.221.147.179"
USER="admin"


PORT_ARRAY=(2245 2243 2244 2246 2248 2247 2250 2249)

# Loop through the port range and open each SSH session in a new terminal
for PORT in "${PORT_ARRAY[@]}"; do
         # Check if the port matches the special case
    if [[ $PORT == 2245 || $PORT == 2248 || $PORT == 2250 ]]; then
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER -t 'sudo su - csiq && cd ~/CSIQ-Callcontroller && exec bash'" &
    else
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER; exec bash" &
    fi
done
