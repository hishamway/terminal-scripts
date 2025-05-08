#!/bin/bash
# Usage: auCspProd.sh [media|core|proxy|proxy-core|web|micro|rabbit|mysql|mongo|transcript|asterisk|kamailio|all]

# Define servers and their details as associative arrays
declare -A SERVERS

SERVERS[web1-csphones-au]="54.252.115.150 2222 hisham"
SERVERS[transcript-csphones-au]="54.252.115.150 22 hisham"
SERVERS[Asterisk-csphones-au]="13.238.47.136 22 hisham"
SERVERS[Rabbit-1-csphones-au]="54.252.115.150 2226 hisham"
SERVERS[Mongo1-csphones-au]="54.252.115.150 2228 hisham"
SERVERS[micro-csphones-au]="54.252.115.150 2224 hisham"
SERVERS[mysql1-csphones-au]="54.252.115.150 2231 hisham"
SERVERS[mysql2-csphones-au]="54.252.115.150 2232 hisham"
SERVERS[mysql3-csphones-au]="54.252.115.150 2233 hisham"
SERVERS[mysqllb-csphones-au]="52.63.229.58 2234 hisham"
SERVERS[BIFROST-ANSIBLE]="13.210.81.244 22 admin"
SERVERS[BIFROST-CORE1]="13.210.81.244 2222 admin"
SERVERS[BIFROST-PROXY1]="13.210.81.244 2223 admin"
SERVERS[BIFROST-MEDIA1]="13.210.81.244 2224 admin"
SERVERS[BIFROST-SIPTRACE]="13.210.81.244 2225 admin"

# Define server groups
declare -A SERVER_GROUPS

SERVER_GROUPS[web]="web1-csphones-au"
SERVER_GROUPS[micro]="micro-csphones-au"
SERVER_GROUPS[rabbit]="Rabbit-1-csphones-au"
SERVER_GROUPS[mysql]="mysql1-csphones-au mysql2-csphones-au mysql3-csphones-au mysqllb-csphones-au"
SERVER_GROUPS[mongo]="Mongo1-csphones-au"
SERVER_GROUPS[transcript]="transcript-csphones-au"
SERVER_GROUPS[asterisk]="Asterisk-csphones-au"
SERVER_GROUPS[core]="BIFROST-CORE1"
SERVER_GROUPS[proxy]="BIFROST-PROXY1"
SERVER_GROUPS[media]="BIFROST-MEDIA1"
SERVER_GROUPS[kamailio]="BIFROST-CORE1 BIFROST-PROXY1 BIFROST-MEDIA1 BIFROST-SIPTRACE"
SERVER_GROUPS[all]="${!SERVERS[@]}"

# Validate input
if [[ -z "${SERVER_GROUPS[$1]}" ]]; then
    echo "Usage: $0 {media|core|proxy|proxy-core|web|micro|rabbit|mysql|mongo|transcript|asterisk|kamailio|all}"
    exit 1
fi


# Open SSH sessions
for SERVER_NAME in ${SERVER_GROUPS[$1]}; do
    read -r SERVER PORT USER <<< "${SERVERS[$SERVER_NAME]}"
    echo "Opening SSH session to server name -> $SERVER_NAME -> SERVER And PORT ($SERVER:$PORT) USER ->  $USER ... "
    if [[ "$SERVER_NAME" == *"MEDIA"* ]]; then
        echo media
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER -t 'sudo su - cspau && cd ~/CSIQ-Callcontroller && exec bash'" &
    elif [[ "$SERVER_NAME" == *"web"*  || "$SERVER_NAME" == *"micro"*  || "$SERVER_NAME" == *"transcript"* ]]; then
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER -t 'csiq && exec bash'" &
    else
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER; exec bash" &
    fi
done
