#!/bin/bash

# Server details
USER="admin"

PROXY_SERVER="3.132.189.237"
CORE_SERVER="172.30.40.107"
MEDIA_SERVER="172.30.40.195"
ANSIBLE_SERVER="3.143.204.46"

# Port range

# Loop 3 times.

gnome-terminal --tab -- bash -c "ssh $USER@$PROXY_SERVER; exec bash" & # dev proxy
gnome-terminal --tab -- bash -c "ssh $USER@$PROXY_SERVER -t 'ssh $CORE_SERVER; exec bash'" & # dev core 
gnome-terminal --tab -- bash -c "ssh $USER@$PROXY_SERVER -t 'ssh $MEDIA_SERVER; exec bash'" & # dev  media.


# dev siptrace
gnome-terminal --tab -- bash -c "ssh $USER@$ANSIBLE_SERVER -p 2223; exec bash" & 
# # dev ansible
gnome-terminal --tab -- bash -c "ssh ec2-user@$ANSIBLE_SERVER -t 'sudo su jimy; exec bash'" & 



