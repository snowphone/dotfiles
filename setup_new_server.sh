#!/bin/sh

sudo apt-get install -y fail2ban xorg libssl-dev
cargo install macchina
cargo install --git https://github.com/snowphone/CommitGPT
git clone https://github.com/snowphone/cloudflare-cli && cd cloudflare-cli && make install

cd /etc/fail2ban/filter.d && sudo ln -sf sshd.conf sshd-61022.conf



cat <<'EOF'
- Restore crontab and backups created by crontab.
- Go to Code/typescript/add_music and link binary: (try cat makefile)
- Install X11 and Korean IME (kime)
EOF
