#!/bin/bash

# Server details
SERVER="54.88.21.184"
USER="hisham"

# Port range

PORT_ARRAY=(2238 2224)

# Loop through the port range and open each SSH session in a new terminal
for PORT in "${PORT_ARRAY[@]}"; do
    gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER -t 'csiq && exec bash'" &
    
done