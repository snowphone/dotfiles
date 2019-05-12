tmux new-session \; \
  send-keys 'date | figlet | lolcat' C-m \; \
  split-window -v -p 35 \; \
  split-window -h -p 75 \; \
  send-keys 'htop' C-m \; \
  select-pane -t 0 \;
