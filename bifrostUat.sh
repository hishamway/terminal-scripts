#!/bin/bash
# Usage: ./uatServerConfig.sh [media|core|proxy|proxy-core|web|micro|rabbit|mysql|mongo|transcript|asterisk|all]

# Define servers and their details as associative arrays
declare -A SERVERS

SERVERS[sip-ansible]="54.159.106.24 22 admin"
SERVERS[sip-media1]="54.159.106.24 2222 admin"
SERVERS[sip-core1]="54.159.106.24 2223 admin"
SERVERS[sip-proxy1]="54.159.106.24 2224 admin"
SERVERS[sip-core2]="54.159.106.24 2225 admin"
SERVERS[sip-media2]="54.159.106.24 2226 admin"
SERVERS[sip-proxy2]="54.159.106.24 2227 admin"
SERVERS[sip-media3]="54.159.106.24 2228 admin"
SERVERS[sip-core3]="54.159.106.24 2229 admin"
SERVERS[IDP-UAT]="52.207.59.71 22 hisham"
SERVERS[csiquat1]="44.218.188.130 22 hisham"
SERVERS[csiq-uat1-asterisk]="3.82.255.11 22 hisham"
SERVERS[web1-csp-uk]="18.170.233.43 22 hisham"
SERVERS[asterisk-Csphones-uk]="3.11.245.195 22 hisham"
SERVERS[Web1]="54.88.21.184 2224 hisham"
SERVERS[Web2]="54.88.21.184 2238 hisham"
SERVERS[Micro1]="54.88.21.184 2225 hisham"
SERVERS[Micro2]="54.88.21.184 2226 hisham"
SERVERS[Mongo1]="54.88.21.184 2227 hisham"
SERVERS[Mongo2]="54.88.21.184 2228 hisham"
SERVERS[Mongo3]="54.88.21.184 2229 hisham"
SERVERS[MySql-LB]="54.88.21.184 22 hisham"
SERVERS[Mysql-1]="54.88.21.184 2231 hisham"
SERVERS[Mysql-2]="54.88.21.184 2232 hisham"
SERVERS[Mysql-3]="54.88.21.184 2233 hisham"
SERVERS[Rabbit-1]="54.88.21.184 2236 hisham"
SERVERS[Rabbit-2]="54.88.21.184 2237 hisham"
SERVERS[Asterisk-1]="3.223.93.152 22 hisham"
SERVERS[Trans1]="35.169.227.8 22 hisham"

# Define server groups
declare -A SERVER_GROUPS

SERVER_GROUPS[media]="sip-media1 sip-media2 sip-media3"
SERVER_GROUPS[core]="sip-core1 sip-core2 sip-core3"
SERVER_GROUPS[proxy]="sip-proxy1 sip-proxy2"
SERVER_GROUPS[proxy-core]="sip-core1 sip-core2 sip-core3 sip-proxy1 sip-proxy2"
SERVER_GROUPS[kamailio]="sip-core1 sip-core2 sip-core3 sip-proxy1 sip-proxy2 sip-media1 sip-media2 sip-media3 sip-ansible"
SERVER_GROUPS[web]="Web1 Web2 web1-csp-uk"
SERVER_GROUPS[micro]="Micro1 Micro2"
SERVER_GROUPS[rabbit]="Rabbit-1 Rabbit-2"
SERVER_GROUPS[mysql]="MySql-LB Mysql-1 Mysql-2 Mysql-3"
SERVER_GROUPS[mongo]="Mongo1 Mongo2 Mongo3"
SERVER_GROUPS[transcript]="Trans1"
SERVER_GROUPS[asterisk]="asterisk-Csphones-uk Asterisk-1"
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
    if [[ "$SERVER_NAME" == *"media"* ]]; then
        echo media
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER -t 'sudo su - csiq && cd ~/CSIQ-Callcontroller && exec bash'" &
    elif [[ "$SERVER_NAME" == *"web"*  || "$SERVER_NAME" == *"micro"*  || "$SERVER_NAME" == *"transcript"* ]]; then
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER -t 'csiq && exec bash'" &
    else
        gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER; exec bash" &
    fi
done



