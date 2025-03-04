#!/bin/bash

# Server details
SERVER="3.229.214.89"
USER="admin"

# Port range

PORT_ARRAY=(2224 2223  2222)

# Loop through the port range and open each SSH session in a new terminal
for PORT in "${PORT_ARRAY[@]}"; do
    gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER; exec bash" &
done

gnome-terminal --tab -- bash -c "ssh $USER@$SERVER; exec bash" &
