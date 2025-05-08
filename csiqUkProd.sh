#!/bin/bash
# Usage: ./csiqUkProd.sh [media|core|proxy|proxy-core|web|micro|rabbit|mysql|mongo|transcript|asterisk|kamailio|all]

# Define servers and their details as associative arrays
declare -A SERVERS

SERVERS[web1-csiq-uk]="52.56.167.6 22 hisham"
SERVERS[web2-csiq-uk]="18.130.212.33 22 hisham"
SERVERS[Trans1-csiq-uk]="13.41.136.151 22 hisham"
SERVERS[Asterisk-csiq-uk]="3.9.92.236 22 hisham"
SERVERS[Rabbit-1-csiq-uk]="13.40.127.108 22 hisham"
SERVERS[Rabbit-2-csiq-uk]="18.170.79.103 22 hisham"
SERVERS[Mongo-1-csiq-uk]="3.10.8.160 22 hisham"
SERVERS[Mongo2-csiq-uk]="52.56.194.147 22 hisham"
SERVERS[Mongo3-csiq-uk]="18.171.6.185 22 hisham"
SERVERS[Micro1-csiq-uk]="18.171.151.81 22 hisham"
SERVERS[micro2-csiq-uk]="18.132.10.238 22 hisham"
SERVERS[mysql1-csiq-uk]="3.11.84.116 22 hisham"
SERVERS[mysql2-csiq-uk]="3.9.151.141 22 hisham"
SERVERS[mysql3-csiq-uk]="13.42.117.199 22 hisham"
SERVERS[mysqllb-csiq-uk]="3.11.37.2 22 hisham"

SERVERS[BIFROST-ANSIBLE]="51.24.28.150 22 admin"
SERVERS[BIFROST-CORE1]="51.24.28.150 2222 admin"
SERVERS[BIFROST-CORE2]="51.24.28.150 2223 admin"
SERVERS[BIFROST-PROXY1]="51.24.28.150 2224 admin"
SERVERS[BIFROST-PROXY2]="51.24.28.150 2225 admin"
SERVERS[BIFROST-MEDIA1]="51.24.28.150 2226 admin"
SERVERS[BIFROST-MEDIA2]="51.24.28.150 2227 admin"
SERVERS[BIFROST-SIPTRACE]="51.24.28.150 2228 admin"

# Define server groups
declare -A SERVER_GROUPS

SERVER_GROUPS[media]="BIFROST-MEDIA1 BIFROST-MEDIA2"
SERVER_GROUPS[core]="BIFROST-CORE1 BIFROST-CORE2"
SERVER_GROUPS[proxy]="BIFROST-PROXY1 BIFROST-PROXY2"
SERVER_GROUPS[proxy-core]="BIFROST-CORE1 BIFROST-CORE2 BIFROST-PROXY1 BIFROST-PROXY2"
SERVER_GROUPS[kamailio]="BIFROST-CORE1 BIFROST-CORE2 BIFROST-PROXY1 BIFROST-PROXY2 BIFROST-MEDIA1 BIFROST-MEDIA2 BIFROST-SIPTRACE BIFROST-ANSIBLE"
SERVER_GROUPS[web]="web1-csiq-uk web2-csiq-uk"
SERVER_GROUPS[micro]="Micro1-csiq-uk micro2-csiq-uk"
SERVER_GROUPS[rabbit]="Rabbit-1-csiq-uk Rabbit-2-csiq-uk"
SERVER_GROUPS[mysql]="mysql1-csiq-uk mysql2-csiq-uk mysql3-csiq-uk mysqllb-csiq-uk"
SERVER_GROUPS[mongo]="Mongo-1-csiq-uk Mongo2-csiq-uk Mongo3-csiq-uk"
SERVER_GROUPS[transcript]="Trans1-csiq-uk"
SERVER_GROUPS[asterisk]="Asterisk-csiq-uk"
SERVER_GROUPS[all]="${!SERVERS[@]}"

# Validate input
if [[ -z "${SERVER_GROUPS[$1]}" ]]; then
    echo "Usage: $0 {media|core|proxy|proxy-core|web|micro|rabbit|mysql|mongo|transcript|asterisk|kamailio|all}"
    exit 1
fi

if [[ "$2" == "tmux" ]]; then
    # Start a new tmux session named "ssh_sessions"
    tmux new-session -d -s ssh_sessions
    echo "tmux session started"

    for SERVER_NAME in ${SERVER_GROUPS[$1]}; do
        read -r SERVER PORT USER <<<"${SERVERS[$SERVER_NAME]}"
        echo "Opening SSH session to server name -> $SERVER_NAME -> SERVER And PORT ($SERVER:$PORT) USER ->  $USER ... "
        if [[ "$SERVER_NAME" == *"MEDIA"* ]]; then
            echo media
            tmux split-window -v "ssh -p $PORT $USER@$SERVER -t 'sudo su - csiq && cd ~/CSIQ-Callcontroller && exec bash'" &
        elif [[ "$SERVER_NAME" == *"web"* || "$SERVER_NAME" == *"micro"* || "$SERVER_NAME" == *"transcript"* ]]; then
            tmux split-window -v "ssh -p $PORT $USER@$SERVER -t 'csiq && exec bash'" &
        else
            tmux split-window -v "ssh -p $PORT $USER@$SERVER; exec bash" &
        fi
    done

    # Kill the initial pane (optional, if you don't need an extra pane)
    tmux kill-pane -t 0
    # tmux select-layout tiled   # Arrange panes in a tiled layout

    # Attach to the tmux session to view all SSH sessions at once
    tmux set-window-option synchronize-panes on
    tmux attach-session -t ssh_sessions
else
    for SERVER_NAME in ${SERVER_GROUPS[$1]}; do
        read -r SERVER PORT USER <<<"${SERVERS[$SERVER_NAME]}"
        echo "Opening SSH session to server name -> $SERVER_NAME -> SERVER And PORT ($SERVER:$PORT) USER ->  $USER ... "

        if [[ "$SERVER_NAME" == *"MEDIA"* ]]; then
            echo media
            gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER -t 'sudo su - csiq && cd ~/CSIQ-Callcontroller && exec bash'" &
        elif [[ "$SERVER_NAME" == *"web"* || "$SERVER_NAME" == *"micro"* || "$SERVER_NAME" == *"transcript"* ]]; then
            gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER -t 'csiq && exec bash'" &
        else
            gnome-terminal --tab -- bash -c "ssh -p $PORT $USER@$SERVER; exec bash" &
        fi
    done
fi
