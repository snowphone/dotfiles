tmux -2  new -s dev \; \
  send-keys 'date | figlet | lolcat' C-m \; \
  split-window -v -p 42 \; \
  send-keys 'screenfetch ' C-m \; \
  split-window -h -p 35 \; \
  send-keys 'htop -s PERCENT_CPU' C-m \; \
  select-pane -t 0 \;
