#!/bin/bash
# Usage: ./bifrostUkProd.sh [media|core|proxy|proxy-core|web|micro|rabbit|mysql|mongo|transcript|asterisk|kamailio|all]


# Load environment variables
if [ -f .env ]; then
    source .env
else
    echo ".env file not found! Exiting..."
    exit 1
fi

# Define servers and their details as associative arrays
declare -A SERVERS

SERVERS[Web1]="$MAIN_IP_US_CSIQ 2222 hisham"
SERVERS[Web2]="$MAIN_IP_US_CSIQ 2223 hisham"
SERVERS[Web3]="$MAIN_IP_US_CSIQ 2224 hisham"
SERVERS[Web4]="$MAIN_IP_US_CSIQ 2242 hisham"
SERVERS[Micro1]="$MAIN_IP_US_CSIQ 2225 hisham"
SERVERS[Micro2]="$MAIN_IP_US_CSIQ 2226 hisham"
SERVERS[Mongo1]="$MAIN_IP_US_CSIQ 2227 hisham"
SERVERS[Mongo2]="$MAIN_IP_US_CSIQ 2228 hisham"
SERVERS[Mongo3]="$MAIN_IP_US_CSIQ 2229 hisham"
SERVERS[MySQL-LB]="$MAIN_IP_US_CSIQ 2230 hisham"
SERVERS[Mysql-1]="$MAIN_IP_US_CSIQ 2231 hisham"
SERVERS[Mysql-2]="$MAIN_IP_US_CSIQ 2232 hisham"
SERVERS[Mysql-3]="$MAIN_IP_US_CSIQ 2233 hisham"
SERVERS[Rabbit-1]="$MAIN_IP_US_CSIQ 2236 hisham"
SERVERS[Rabbit-2]="$MAIN_IP_US_CSIQ 2237 hisham"
SERVERS[Asterisk-1]="$US_CSIQ_ASTERISK1_IP 22 hisham"
SERVERS[Asterisk-2]="$US_CSIQ_ASTERISK2_IP 22 hisham"
SERVERS[Trans1]="$US_CSIQ_TRANS1_IP 22 hisham"
SERVERS[sftp-prov]="$US_CSIQ_SFTP_PROV_IP 22 hisham"
SERVERS[provision]="$US_CSIQ_PROVISION_IP 22 hisham"
SERVERS[Jenkins]="$MAIN_IP_US_CSIQ 22 hisham"
SERVERS[sip-ansible]="$MAIN_IP_US_CSIQ 22 admin"
SERVERS[sip-media1]="$MAIN_IP_US_CSIQ 2245 admin"
SERVERS[sip-core1]="$MAIN_IP_US_CSIQ 2243 admin"
SERVERS[sip-proxy1]="$MAIN_IP_US_CSIQ 2244 admin"
SERVERS[sip-core2]="$MAIN_IP_US_CSIQ 2246 admin"
SERVERS[sip-media2]="$MAIN_IP_US_CSIQ 2248 admin"
SERVERS[sip-proxy2]="$MAIN_IP_US_CSIQ 2247 admin"
SERVERS[sip-media3]="$MAIN_IP_US_CSIQ 2250 admin"
SERVERS[sip-core3]="$MAIN_IP_US_CSIQ 2249 admin"

for server in "${!SERVERS[@]}"; do
    echo "$server -> ${SERVERS[$server]}"
done

# Define server groups
declare -A SERVER_GROUPS

SERVER_GROUPS[web]="Web1 Web2 Web3 Web4"
SERVER_GROUPS[micro]="Micro1 Micro2"
SERVER_GROUPS[mongo]="Mongo1 Mongo2 Mongo3"
SERVER_GROUPS[mysql]="MySQL-LB Mysql-1 Mysql-2 Mysql-3"
SERVER_GROUPS[rabbit]="Rabbit-1 Rabbit-2"
SERVER_GROUPS[asterisk]="Asterisk-1 Asterisk-2"
SERVER_GROUPS[transcript]="Trans1"
SERVER_GROUPS[provision]="sftp-prov provision"
SERVER_GROUPS[jenkins]="Jenkins"
SERVER_GROUPS[media]="sip-media1 sip-media2 sip-media3"
SERVER_GROUPS[core]="sip-core1 sip-core2 sip-core3"
SERVER_GROUPS[proxy]="sip-proxy1 sip-proxy2"
SERVER_GROUPS[proxy-core]="sip-proxy1 sip-proxy2 sip-core1 sip-core2 sip-core3"
SERVER_GROUPS[sip]="sip-ansible sip-media1 sip-core1 sip-proxy1 sip-core2 sip-media2 sip-proxy2 sip-media3 sip-core3"
SERVER_GROUPS[all]="${!SERVERS[@]}"


# Validate input
if [[ -z "${SERVER_GROUPS[$1]}" ]]; then
    echo "Usage: $0 {media|core|proxy|proxy-core|web|micro|rabbit|mysql|mongo|transcript|asterisk|kamailio|provision|jenkins|all}"
    exit 1
fi


# Open SSH sessions
for SERVER_NAME in ${SERVER_GROUPS[$1]}; do
    read -r SERVER PORT USER <<< "${SERVERS[$SERVER_NAME]}"
    echo "Opening SSH session to server name -> $SERVER_NAME -> SERVER And PORT ($SERVER:$PORT) USER ->  $USER ... "
    if [[ "$SERVER_NAME" == *"media"* ]]; then
        echo media
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER -t 'sudo su - csiq && cd ~/CSIQ-Callcontroller && exec bash'" &
    else
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER; exec bash" &
    fi
done
