tmux -2  new -s dev \; \
  send-keys 'screenfetch ' C-m \; \
  split-window -h -p 65 \; \
  send-keys 'date | figlet | lolcat' C-m \; \
  select-pane -t 0 \; \
  split-window -v -p 30 \; \
  send-keys 'htop -s PERCENT_CPU' C-m \; \
  select-pane -t 2 \;
