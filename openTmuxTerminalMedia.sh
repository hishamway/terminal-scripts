#!/bin/bash

# Server details
SERVER="54.159.106.24"
USER="admin"

# Port range

PORT_RANGE=(2222 2226 2228)

# Start a new tmux session named "ssh_sessions"
tmux new-session -d -s ssh_sessions

# Loop through the port range and open each SSH session in a new tmux pane
for PORT in "${PORT_RANGE[@]}"; do
    tmux split-window -h "ssh -p $PORT $USER@$SERVER"
    tmux split-window -v -t ! "ssh -p $PORT $USER@$SERVER"
    tmux select-layout tiled   # Arrange panes in a tiled layout

done

# Kill the initial pane (optional, if you don't need an extra pane)
tmux kill-pane -t 0

# Attach to the tmux session to view all SSH sessions at once
tmux attach-session -t ssh_sessions
