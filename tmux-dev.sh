tmux -2  new -s dev \; \
  send-keys 'gotop -a || htop || top' C-m \; \
  split-window -h -p 65 \; \
  send-keys "neofetch" C-m \; \
  select-pane -t 0 \; \
  split-window -v -p 30 \; \
  send-keys 'tty-clock -C1 -sc' C-m \; \
  select-pane -t 2 \; \
  select-pane -t 0 \; \
  select-pane -t 2 \;
