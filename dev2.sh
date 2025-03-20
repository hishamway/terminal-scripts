#!/bin/bash
#usage: ./dev2.sh [proxy|core|media|ansible|main]
# Server details
SERVER="3.229.214.89"
USER="admin"

ANSIBLE_SERVER="$USER@$SERVER"
MAIN_SERVER="hisham@54.208.211.137"

# Port groups
ALL_PORTS=(2222 2223 2224)
MEDIA_PORTS=(2224)
CORE_PORTS=(2223)
PROXY_PORTS=(2222)
PROXY_CORE_PORTS=(2222 2223)

# Check argument and assign the corresponding ports
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
elif [[ "$1" == "ansible" ]]; then
    PORT_ARRAY=()  # No SSH port session, only ansible
    gnome-terminal --tab -- bash -c "ssh $ANSIBLE_SERVER; exec bash" &
    exit 0
elif [[ "$1" == "main" ]]; then
    PORT_ARRAY=()  # No SSH port session, only main server
    gnome-terminal --tab -- bash -c "ssh $MAIN_SERVER; exec bash" &
    exit 0
else
    # No arguments: Open all ports + ansible + main server
    PORT_ARRAY=("${ALL_PORTS[@]}")
    OPEN_ANSIBLE=true
    OPEN_MAIN=true
fi

echo "Opening ports: ${PORT_ARRAY[@]}"

# Loop through the port range and open each SSH session in a new terminal
for PORT in "${PORT_ARRAY[@]}"; do
    if [[ $PORT == 2224 ]]; then
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER -t 'sudo su - csiq && cd ~/CSIQ-Callcontroller && exec bash'" &
    else
        echo "Opening port $PORT"
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER; exec bash" &
    fi
done

# Open Ansible and Main servers if no argument is passed
if [[ $OPEN_ANSIBLE == true ]]; then
    gnome-terminal --tab -- bash -c "ssh $ANSIBLE_SERVER; exec bash" &
fi

if [[ $OPEN_MAIN == true ]]; then
    gnome-terminal --tab -- bash -c "ssh $MAIN_SERVER; exec bash" &
fi
