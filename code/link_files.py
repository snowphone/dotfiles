#!/usr/bin/env python3
import os
import re
from argparse import ArgumentParser

from script import Script


class FileLinker(Script):
    def run(self) -> None:
        HOME = self.HOME
        proj_root = self.proj_root

        self._mkdir(f"{HOME}/.local/bin/")
        self.shell.exec(
            "Symbolic linking scripts",
            f'ln -fs "{proj_root}"/scripts/* {HOME}/.local/bin/',
        )

        self.shell.exec_list(
            "Enabling tar to parallelize archiving files",
            f"ln -sf -T /usr/bin/lbzip2 {HOME}/.local/bin/bzip2",
            f"ln -sf -T /usr/bin/lbzip2 {HOME}/.local/bin/bunzip2",
            f"ln -sf -T /usr/bin/lbzip2 {HOME}/.local/bin/bzcat",
            f"ln -sf -T /usr/bin/pigz {HOME}/.local/bin/gzip",
            f"ln -sf -T /usr/bin/pigz {HOME}/.local/bin/gunzip",
            f"ln -sf -T /usr/bin/pigz {HOME}/.local/bin/gzcat",
            f"ln -sf -T /usr/bin/pigz {HOME}/.local/bin/zcat",
            f"ln -sf -T /usr/bin/pixz {HOME}/.local/bin/xz",
        )

        trueline_path = f"{HOME}/.trueline.sh"
        if not os.path.exists(trueline_path):
            self.shell.exec(
                "Downloading trueline.sh",
                f"curl -s https://raw.githubusercontent.com/petobens/trueline/master/trueline.sh -o {trueline_path}",
            )

        self.shell.exec_list(
            "Symbolic linking essential files",
            f'ln -fs "{proj_root}"/.bashrc {HOME}/.bashrc',  # Deprecated: bashrc
            f'ln -fs "{proj_root}"/.gitconfig  {HOME}/.gitconfig',  # Global git configuration
            f'ln -fs "{proj_root}"/.common.shrc {HOME}/.common.shrc',
            f'ln -fs "{proj_root}"/.shinit {HOME}/.shinit',
            f'ln -fs "{proj_root}"/.zshrc {HOME}/.zshrc',
            f'ln -fs "{proj_root}"/.p10k.zsh {HOME}/.p10k.zsh',
            f'ln -fs "{proj_root}"/.mailcap {HOME}/.mailcap',  # Open text files with vim when using xdg-open
            f'ln -fs "{proj_root}"/.mailcap.order {HOME}/.mailcap.order',  # Set higher priority to vim
            f'ln -fs "{proj_root}"/.ideavimrc {HOME}/.ideavimrc',  # Set higher priority to vim
            f'ln -fs "{proj_root}"/.xprofile {HOME}/.xprofile',  # Set higher priority to vim
        )

        if not os.path.islink(f"{HOME}/.config"):
            self.shell.exec(
                f"Aliasing {HOME}/.config",
                f'ln -fs "{proj_root}"/config {HOME}/.config',
            )

        dir_color_path = f"{HOME}/.dircolors"
        self.shell.exec(
            "Using dircolor from default", f"dircolors -p > {dir_color_path}"
        )
        if self._is_wsl():
            # In WSL, folders in Windows storage look as OTHER_WRITABLE, so OTHER_WRITABLE is set as same as DIR.
            with open(dir_color_path) as f:
                text = f.read()
            dir_color = re.search(r"(?<=DIR ).+", text)
            if not dir_color:
                raise RuntimeError(
                    f"Failed to read DIR attribute from {dir_color_path}"
                )
            dir_color = dir_color.group()

            self.shell.exec(
                "Setting OTHER_WRITABLE same as DIR in WSL",
                f'sed -i "s/^OTHER_WRITABLE .*/OTHER_WRITABLE {dir_color}/" {HOME}/.dircolors',
            )

        self.shell.exec_list(
            "Setting up pip cache server",
            f"mkdir -p {HOME}/.pip",
            f'ln -nfs "$folder"/pip.conf {HOME}/.pip/pip.conf',
            f"ln -nfs $(which pip3) {HOME}/.local/bin/pip",
        )

        if not os.path.islink(f"{HOME}/.clipboard"):
            self.shell.exec(
                "Linking .clipboard",
                f"ln -fs -T {self.proj_root}/clipboard {HOME}/.clipboard",
            )

        WIN_CONV_PATH = f"{HOME}/.win_env_conv.shrc"
        if self._is_wsl() and not os.path.exists(WIN_CONV_PATH):
            self.shell.exec_list(
                "Fetch Windows environment variables",
                f'ln -fs "{proj_root}"/win_env_conv.shrc {WIN_CONV_PATH}',
            )

        if self._is_wsl() and os.path.exists("/mnt/c/Users"):
            link_cmds = [
                f"ln -nfs $USERPROFILE/Downloads $HOME/",
                f"ln -nfs $USERPROFILE/Videos $HOME/",
            ]
            if os.path.exists("/mnt/c/Users/mjo97"):
                link_cmds += [
                    f"ln -nfs $USERPROFILE/Dropbox/Documents $HOME/",
                ]
            else:
                link_cmds += [
                    f"ln -nfs $USERPROFILE/Documents $HOME/",
                ]

            if not os.path.islink(f"{HOME}/winHome"):
                link_cmds.append(f"ln -fs -T $USERPROFILE {HOME}/winHome")

            link_cmds = [f"source {WIN_CONV_PATH}; " + it for it in link_cmds]
            self.shell.exec_list("Symbolic linking windows folders", *link_cmds)

        return

    def _is_wsl(self):
        try:
            with open("/proc/version") as f:
                text = f.read()
            return bool(re.search(r"microsoft|wsl", text, re.IGNORECASE))
        except:
            return False


if __name__ == "__main__":
    parser = ArgumentParser()
    args = parser.parse_args()

    FileLinker(args).run()
