#!/usr/bin/env bash

## Check for accessibility
if [[ $(whoami) == "root" ]]; then
	sudo=""
else
	sudo="sudo"
fi

folder=$(dirname $0 | xargs realpath)

# Main phase

$sudo apt install -y openssh-server net-tools
$sudo ssh-keygen -A

#.bashrc 설정
#ssh server 설정
echo "Change port address to 61022"
$sudo sed -i 's/#\?Port 22/Port 61022/' /etc/ssh/sshd_config
$sudo sed -i 's/UsePrivilegeSeparation */UsePrivilegeSeparation no/' /etc/ssh/sshd_config
$sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

echo "Edited /etc/sudoers to run 'service' command without asking passwords"
echo '%sudo ALL=NOPASSWD: /usr/sbin/service' | $sudo tee -a /etc/sudoers >/dev/null

echo "Please visit https://github.com/snowphone/WSL2-port-forwarding-guide and follow Instruction section"
