#!/bin/bash

# Server details
SERVER="54.159.106.24"
USER="admin"

# Port range

PORT_ARRAY=(2222 2226 2228)

# Loop through the port range and open each SSH session in a new terminal
for PORT in "${PORT_ARRAY[@]}"; do
    gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER -t 'sudo su - csiq && cd ~/CSIQ-Callcontroller && exec bash'" &

done


