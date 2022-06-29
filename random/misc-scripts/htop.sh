#!/bin/bash

# Create a new session named "test", split panes and change directory in each
tmux new-session -d -s htopper
tmux send-keys -t htopper "ssh node-0" Enter
tmux split-window -v -t htopper
tmux send-keys -t htopper "ssh node-1" Enter
tmux select-pane -t htopper:0.1
tmux split-window -h -t  htopper
tmux send-keys -t htopper "ssh node-2" Enter
tmux select-pane -t htopper:0.3
tmux split-window -h -t htopper
tmux send-keys -t htopper "ssh node-3" Enter
tmux split-window -h -t htopper
tmux send-keys -t htopper "ssh node-4" Enter
tmux select-pane -t htopper:0.0
tmux split-window -h -t  htopper
tmux send-keys -t htopper "ssh node-5" Enter
tmux split-window -h  -t  htopper
tmux send-keys -t htopper "ssh node-6" Enter
tmux split-window -h -t htopper
tmux send-keys -t htopper "ssh node-7" Enter

tmux set-window-option -t htopper:0 synchronize-panes on

tmux send-keys -t htopper "htop" Enter

tmux attach -t htopper
