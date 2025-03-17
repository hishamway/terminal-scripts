#!/bin/bash

# Server details
SERVER="18.119.76.126"
USER="admin"

# Port range

PORT_ARRAY=(2224 2223  2222)

# Loop through the port range and open each SSH session in a new terminal
for PORT in "${PORT_ARRAY[@]}"; do
    if [[ $PORT == 2224 ]]; then
        # Open a new terminal for the Callcontroller server. (Media server)
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER -t 'sudo su - csiq && cd ~/CSIQ-Callcontroller && exec bash'" &
    else
        # Open a new terminal for the Core and Proxy server.
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER; exec bash" &
    fi
done
gnome-terminal --tab -- bash -c "ssh  hisham@3.130.186.139; exec bash" &

# Open a new terminal for Ansible server.
gnome-terminal --tab -- bash -c "ssh $USER@$SERVER; exec bash" &
