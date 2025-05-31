#!/usr/bin/env bash


export PATH=$HOME/.local/bin:$PATH

proj_root="$(git rev-parse --show-toplevel)"

# transcrypt script를 ~/.local/bin에 설치. manpage 포함
"$proj_root/install_transcrypt.sh"

# if transcrypt is not installed
if ! transcrypt --display; then
	printf "Enter password: "
	read -r PASSWORD
	# transcrypt가 레포지토리 안에 설정된다.
	# 레포지토리 안에 이미 암호화된 파일이 있는 경우, 복호화도 진행한다.
	transcrypt --cipher aes-256-cbc --password "$PASSWORD"
fi

"$proj_root"/code/full_install.py "$@"

cat <<EOF
Try the below to substitute a github protocol:

sed -Ei 's|https://(junoh-moon@)?github.com/junoh-moon/dotfiles|git@github.com:junoh-moon/dotfiles|' ${proj_root}/.git/config
EOF
