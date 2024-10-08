#!/usr/bin/env python3
from argparse import Namespace

import install_packages
from install_packages import Installer
from link_files import FileLinker
from script import Script
from setup_shell import ShellSwitcher
from setup_ssh_key import SshKey
from setup_tmux import Tmux
from setup_vim import Vim


def main(args: Namespace):
    installer_list = [
        FileLinker(args),
        Installer(args),
        ShellSwitcher(args),
        Vim(args),
        SshKey(args),
        Tmux(args),
    ]  # type: list[Script]
    for installer in installer_list:
        installer.run()


if __name__ == "__main__":
    parser = install_packages.setup_args()

    main(parser.parse_args())
