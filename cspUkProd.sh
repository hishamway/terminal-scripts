#!/bin/bash
# Usage: ./bifrostUkProd.sh [media|core|proxy|proxy-core|web|micro|rabbit|mysql|mongo|transcript|asterisk|kamailio|all]

# Define servers and their details as associative arrays
declare -A SERVERS

SERVERS[web1-csp-uk]="35.178.6.37 2222 hisham"
SERVERS[web2-csp-uk]="35.178.6.37 2223 hisham"
SERVERS[web3-csp-uk]="35.178.6.37 2260 hisham"
SERVERS[micro1-csp-uk]="35.178.6.37 2224 hisham"
SERVERS[micro2-csp-uk]="35.178.6.37 2225 hisham"
SERVERS[rabbit1-csp-uk]="35.178.6.37 2227 hisham"
SERVERS[rabbit2-csp-uk]="35.178.6.37 2228 hisham"
SERVERS[mysql1-csp-uk]="35.178.6.37 2232 hisham"
SERVERS[mysql2-csp-uk]="35.178.6.37 2233 hisham"
SERVERS[mysql3-csp-uk]="35.178.6.37 2234 hisham"
SERVERS[mongo1-csp-uk]="35.178.6.37 2229 hisham"
SERVERS[mongo2-csp-uk]="35.178.6.37 2230 hisham"
SERVERS[mongo3-csp-uk]="35.178.6.37 2231 hisham"
SERVERS[trans1-csp-uk]="18.135.241.76 22 hisham"
SERVERS[asterisk-csphones-uk]="18.132.154.229 22 hisham" 
SERVERS[BIFROST-CORE1]="51.24.8.28 2222 admin"
SERVERS[BIFROST-CORE2]="51.24.8.28 2223 admin"
SERVERS[BIFROST-PROXY1]="51.24.8.28 2224 admin"
SERVERS[BIFROST-PROXY2]="51.24.8.28 2225 admin"
SERVERS[BIFROST-MEDIA1]="51.24.8.28 2226 admin"
SERVERS[BIFROST-MEDIA2]="51.24.8.28 2227 admin"
SERVERS[BIFROST-SIPTRACE]="51.24.8.28 2228 admin"


for server in "${!SERVERS[@]}"; do
    echo "$server -> ${SERVERS[$server]}"
done


# # Define port groups
declare -A SERVER_GROUPS

SERVER_GROUPS[media]="BIFROST-MEDIA1 BIFROST-MEDIA2"
SERVER_GROUPS[core]="BIFROST-CORE1 BIFROST-CORE2"
SERVER_GROUPS[proxy]="BIFROST-PROXY1 BIFROST-PROXY2"
SERVER_GROUPS[proxy-core]="BIFROST-CORE1 BIFROST-CORE2 BIFROST-PROXY1 BIFROST-PROXY2"
SERVER_GROUPS[kamailio]="BIFROST-CORE1 BIFROST-CORE2 BIFROST-PROXY1 BIFROST-PROXY2 BIFROST-MEDIA1 BIFROST-MEDIA2 BIFROST-SIPTRACE"
SERVER_GROUPS[web]="web1-csp-uk web2-csp-uk web3-csp-uk"
SERVER_GROUPS[micro]="micro1-csp-uk micro2-csp-uk"
SERVER_GROUPS[rabbit]="rabbit1-csp-uk rabbit2-csp-uk"
SERVER_GROUPS[mysql]="mysql1-csp-uk mysql2-csp-uk mysql3-csp-uk"
SERVER_GROUPS[mongo]="mongo1-csp-uk mongo2-csp-uk mongo3-csp-uk"
SERVER_GROUPS[transcript]="trans1-csp-uk"
SERVER_GROUPS[asterisk]="asterisk-csphones-uk"
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
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER -t 'sudo su - csiq && cd ~/CSIQ-Callcontroller && exec bash'" &
    else
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER; exec bash" &
    fi
done
