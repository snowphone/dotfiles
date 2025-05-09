# dotfiles

## Installation

```bash
git clone 'https://junoh-moon@github.com/junoh-moon/dotfiles' ~/.dotfiles && \
cd ~/.dotfiles && ./install.sh -d [debian | redhat | darwin] [--java|--latex|--boost|--misc|--typescript]
```

Note that you may need to enter the password to decrypt the ssh key.

## How to Install openssh-server on WSL2

VM-based WSL2 gives us much faster native-filesystem-access-speed, but it also has some drawbacks. One of the drawbacks is an isolated network.
Thus, if you want to run ssh server and access from other hosts, you have to run ssh daemon after bootup and also forward ports.

If you don't want to think about it, you just run `./sshd.sh` and follow the instructions.

**CentOS7 Support:**

If you're looking for installing packages on CentOS7 without root privileges, please check out [here](https://gist.github.com/junoh-moon/f9c612a60aa25dc4940993529532eb97).
It will replace `install_packages.py`.

## MacOS Support

- XCode installation: [XcodesApp](https://github.com/XcodesOrg/XcodesApp)

## Switching from Https into Ssh

```sh
sed -Ei 's|https://(junoh-moon@)?github.com/junoh-moon/dotfiles|git@github.com:junoh-moon/dotfiles|' .git/config
```

## Windows Terminal settings.json and Delugia Font

[settings.json](https://nas.sixtyfive.me/s/botmPZwHwFCtENb)
[Delugia](https://github.com/adam7/delugia-code/releases)

## TODO

- [ ] Debugger integration
- [ ] Cloudflare
