tmux -2  new -s dev \; \
  send-keys 'date | figlet | lolcat' C-m \; \
  split-window -v -p 35 \; \
  split-window -h -p 25 \; \
  send-keys 'htop -s PERCENT_CPU' C-m \; \
  select-pane -t 0 \;
