# dotfiles

## Installation

```bash
git clone 'https://junoh-moon@github.com/junoh-moon/dotfiles' ~/.dotfiles && \
cd ~/.dotfiles && ./install.sh -d [debian | redhat | darwin] [--java|--latex|--boost|--misc|--typescript]
```

Note that you may need to enter the password to decrypt the ssh key.

## Encryption and Decryption

Files with personal information are encrypted with [transcrypt](https://github.com/elasticdog/transcrypt).
The `install.sh` script will set up transcrypt and decrypt all files.

The following examples will be helpful:
- `transcrypt --list` to list encrypted files
- `transcrypt --display` to print current configuration for this repository 
- `transcrypt --add path/to/file && git add path/to/file .gitattributes` to add a file to encrypt

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
