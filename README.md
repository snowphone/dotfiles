# dotfiles

## Installation
~~~bash
git clone 'https://snowphone@github.com/snowphone/dotfiles' ~/.dotfiles && \
cd ~/.dotfiles && ./install.sh -d [debian | redhat | darwin] [--java|--latex|--boost|--misc|--typescript|--rust]
~~~
Note that you may need to enter the password to decrypt the ssh key.

## Installation of openssh-server on WSL2
VM-based WSL2 gave us a much faster native filesystem access speed, but also got some drawbacks. One of the drawbacks is isolated network. Thus, if you want to run ssh server and access from other hosts, you  have to run ssh daemon after booting and also forward ports into WSL2's private ip and port.

If you don't want to think about it, you just run `./sshd.sh` and follow the instructions.

**CentOS7 Support:**

If you're looking for installing packages on CentOS7 without root privileges, please check out [here](https://gist.github.com/snowphone/f9c612a60aa25dc4940993529532eb97).
It will replace `install_packages.py`.

## TODO

### Optimize PATH
After `brew link <pkg>` Refusing to link macOS provided/shadowed software are shown in stdout, then add to PATH

### GNU coreutils
ls, df, ...

### gdb
