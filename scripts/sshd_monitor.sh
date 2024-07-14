#!/bin/bash

# Define the SSH service name (usually "sshd" or "ssh").
SSH_SERVICE_NAME="ssh"

# Define the host to test SSH connectivity.
HOST_TO_TEST="sixtyfive@sixtyfive.me"

# Define a port number for SSH (default is 22).
if [ $# -eq 0 ]; then
	SSH_PORTS=(22)
else
	SSH_PORTS=("$@")
fi

for SSH_PORT in "${SSH_PORTS[@]}"; do
	# Test SSH connectivity by attempting a connection.
	if ! ssh -q -p "$SSH_PORT" "$HOST_TO_TEST" exit; then # Check the exit status of the previous SSH command.
		msg="[sshd_monitor] SSH connection on $SSH_PORT failed. Restarting $SSH_SERVICE_NAME..."

		logger "$msg"

		sudo systemctl restart "$SSH_SERVICE_NAME"

		curl -H "Title: Restarting ssh daemon" \
			-H "X-Priority: default" \
			-d "$msg" \
			https://ntfy.sixtyfive.me/nas
	else
		logger "[sshd_monitor] SSH connection on $SSH_PORT successful."
	fi
	sleep 10
done
