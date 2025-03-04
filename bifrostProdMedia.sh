#!/bin/bash

# Server details
SERVER="3.221.147.179"
USER="admin"


PORT_ARRAY=(2245 2248 2250 )

# Loop through the port range and open each SSH session in a new terminal
for PORT in "${PORT_ARRAY[@]}"; do
    gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER -t 'sudo su - csiq && cd ~/CSIQ-Callcontroller && exec bash'" &

done

