#!/bin/bash

# Server details
SERVER="3.221.147.179"
USER="hisham"

# Port range

PORT_ARRAY=(2222 2223 2224 2242)

# Loop through the port range and open each SSH session in a new terminal
for PORT in "${PORT_ARRAY[@]}"; do
    gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER -t 'csiq && exec bash'" &
    
done