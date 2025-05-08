#!/bin/bash

# Server details
SERVER="3.221.147.179"
USER="admin"

# Port range

PORT_RANGE=(2245 2250 2248)

# Start a new tmux session named "ssh_sessions"
tmux new-session -d -s ssh_sessions

# Loop through the port range and open each SSH session in a new tmux pane
for PORT in "${PORT_RANGE[@]}"; do
    tmux split-window -v "ssh -p $PORT $USER@$SERVER"

done

# Kill the initial pane (optional, if you don't need an extra pane)
tmux kill-pane -t 0
# tmux select-layout tiled   # Arrange panes in a tiled layout

# # Attach to the tmux session to view all SSH sessions at once
tmux set-window-option synchronize-panes on
tmux attach-session -t ssh_sessions
