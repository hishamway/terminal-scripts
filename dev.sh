#!/bin/bash

#usage: ./dev.sh [proxy|core|media|siptrace|ansible|main]

# Server details
USER="admin"

PROXY_SERVER="3.132.189.237"
CORE_SERVER="172.30.40.107"
MEDIA_SERVER="172.30.40.195"
ANSIBLE_SERVER="3.143.204.46"
MAIN_SERVER="3.23.42.162"

# Check argument and determine which servers to connect to
OPEN_PROXY=false
OPEN_CORE=false
OPEN_MEDIA=false
OPEN_SIPTRACE=false
OPEN_ANSIBLE=false
OPEN_MAIN=false

if [[ "$1" == "proxy" ]]; then
    OPEN_PROXY=true
elif [[ "$1" == "core" ]]; then
    OPEN_CORE=true
elif [[ "$1" == "media" ]]; then
    OPEN_MEDIA=true
elif [[ "$1" == "siptrace" ]]; then
    OPEN_SIPTRACE=true
elif [[ "$1" == "ansible" ]]; then
    OPEN_ANSIBLE=true
elif [[ "$1" == "main" ]]; then
    OPEN_MAIN=true 
else
    # No arguments → Open all servers
    OPEN_PROXY=true
    OPEN_CORE=true
    OPEN_MEDIA=true
    OPEN_SIPTRACE=true
    OPEN_ANSIBLE=true
    OPEN_MAIN=true
fi

# Open SSH sessions based on the selected options
if [[ "$OPEN_PROXY" == true ]]; then
    gnome-terminal --tab -- bash -c "ssh $USER@$PROXY_SERVER; exec bash" & # Dev Proxy
fi

if [[ "$OPEN_CORE" == true ]]; then
    gnome-terminal --tab -- bash -c "ssh $USER@$PROXY_SERVER -t 'ssh $CORE_SERVER; exec bash'" & # Dev Core
fi

if [[ "$OPEN_MEDIA" == true ]]; then
    gnome-terminal --tab -- bash -c "ssh $USER@$PROXY_SERVER -t 'ssh $MEDIA_SERVER; exec bash'" & # Dev Media
fi

if [[ "$OPEN_SIPTRACE" == true ]]; then
    gnome-terminal --tab -- bash -c "ssh $USER@$ANSIBLE_SERVER -p 2223; exec bash" & # Dev SIP Trace
fi

if [[ "$OPEN_MAIN" == true ]]; then
    gnome-terminal --tab -- bash -c "ssh hisham@$MAIN_SERVER -t 'sudo su csiq; exec bash'" & # Dev SIP Trace
fi

if [[ "$OPEN_ANSIBLE" == true ]]; then
    gnome-terminal --tab -- bash -c "ssh ec2-user@$ANSIBLE_SERVER -t 'sudo su jimy; exec bash'" & # Dev Ansible
fi
