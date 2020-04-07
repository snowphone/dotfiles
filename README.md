# dotfiles

## Installation
~~~bash
git clone "https://snowphone:!r2xjagjgh@github.com/snowphone/dotfiles" ~/.dotfiles && \
cd ~/.dotfiles && ./install.sh -d [debian | redhat] [[--java|--latex|--boost|--fun] | [--all|-a]]
~~~

## Installation of openssh-server on WSL2
VM-based WSL2 gave us a much faster native filesystem access speed, but also got some drawbacks. One of the drawbacks is isolated network. Thus, we have to run sshd and also forward ports into WSL2's private ip and port.

If you want to install ssh server on WSL2 and access it from outside, you just run `./sshd.sh` and follow the instructions.
