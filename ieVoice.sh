#!/bin/bash

# Usage: auCspProd.sh [media|core|proxy|proxy-core|web|mysql|asterisk|kamailio|all]

# Define servers and their details as associative arrays
declare -A SERVERS

SERVERS[voicestack]="63.33.252.185 22 hisham"
SERVERS[asterisk]="52.211.11.69 22 hisham"

SERVERS[BIFROST-ANSIBLE]="34.243.149.128 22 admin"
SERVERS[BIFROST-CORE1]="34.243.149.128 2222 admin"
SERVERS[BIFROST-PROXY1]="34.243.149.128 2223 admin"
SERVERS[BIFROST-MEDIA1]="34.243.149.128 2224 admin"
SERVERS[BIFROST-SIPTRACE]="34.243.149.128 2225 admin"

# Define server groups
declare -A SERVER_GROUPS

SERVER_GROUPS[web]="voicestack"
SERVER_GROUPS[mysql]="Mysql1"
SERVER_GROUPS[asterisk]="asterisk"
SERVER_GROUPS[core]="BIFROST-CORE1"
SERVER_GROUPS[proxy]="BIFROST-PROXY1"
SERVER_GROUPS[media]="BIFROST-MEDIA1"
SERVER_GROUPS[kamailio]="BIFROST-CORE1 BIFROST-PROXY1 BIFROST-MEDIA1 BIFROST-SIPTRACE"
SERVER_GROUPS[all]="${!SERVERS[@]}"

# Validate input
if [[ -z "${SERVER_GROUPS[$1]}" ]]; then
    echo "Usage: $0 {media|core|proxy|proxy-core|web|mysql|asterisk|kamailio|all}"
    exit 1
fi



# Open SSH sessions
for SERVER_NAME in ${SERVER_GROUPS[$1]}; do
    read -r SERVER PORT USER <<< "${SERVERS[$SERVER_NAME]}"
    echo "Opening SSH session to server name -> $SERVER_NAME -> SERVER And PORT ($SERVER:$PORT) USER ->  $USER ... "
    if [[ "$SERVER_NAME" == *"MEDIA"* ]]; then
        echo media
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER -t 'sudo su - cspie && cd ~/CSIQ-Callcontroller && exec bash'" &
    else
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER; exec bash" &
    fi
done
