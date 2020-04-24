# dotfiles

## Installation
~~~bash
git clone 'https://snowphone:***REMOVED***@github.com/snowphone/dotfiles' ~/.dotfiles && \
cd ~/.dotfiles && ./install.sh -d [debian | redhat] [[--java|--latex|--boost|--fun] | [--all|-a]]
~~~

## Installation of openssh-server on WSL2
VM-based WSL2 gave us a much faster native filesystem access speed, but also got some drawbacks. One of the drawbacks is isolated network. Thus, if you want to run ssh server and access from other hosts, you  have to run ssh daemon after booting and also forward ports into WSL2's private ip and port.

If you don't want to think about it, you just run `./sshd.sh` and follow the instructions.
