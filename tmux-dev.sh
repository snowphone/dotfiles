tmux -2  new -s dev \; \
  send-keys 'neofetch ' C-m \; \
  split-window -h -p 65 \; \
  send-keys "curl wttr.in/Daejeon?2" C-m \; \
  select-pane -t 0 \; \
  split-window -v -p 30 \; \
  send-keys 'htop -s PERCENT_CPU' C-m \; \
  select-pane -t 2 \; \
  select-pane -t 0 \; \
  select-pane -t 2 \;
