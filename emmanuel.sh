

#!/bin/bash

# Server details

MEDIA_SERVER="172.30.40.195"
CORE_SERVER="172.30.40.107"

PROXY_SERVER="3.132.189.237"
USER="admin"


gnome-terminal --tab -- bash -c "ssh $USER@$PROXY_SERVER; exec bash" & # Dev Proxy
gnome-terminal --tab -- bash -c "ssh $USER@$PROXY_SERVER -t 'ssh $CORE_SERVER; exec bash'" & # Dev Core


gnome-terminal --tab -- bash -c "ssh $USER@$PROXY_SERVER -t 'ssh $MEDIA_SERVER; exec bash'" & # Dev Media

