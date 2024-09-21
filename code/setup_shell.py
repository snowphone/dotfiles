#!/usr/bin/env python3
import os
import re
from argparse import ArgumentParser

from link_files import FileLinker
from script import Script


class ShellSwitcher(Script):
    def run(self) -> None:
        HOME = self.HOME

        FileLinker(self.args).run()

        if not self._exists("zsh"):
            raise RuntimeError("zsh not exists")

        ok, zsh_path, _ = self.shell.run("which zsh")
        if not ok:
            raise RuntimeError("Command 'which zsh' failed")

        if os.environ["SHELL"] == zsh_path:
            print("zsh is already a default shell")
        else:
            self._switch_to_zsh()

        self.shell.exec(
            "Installing virtualenvwrapper",
            "python3 -m pip install --upgrade virtualenvwrapper",
        )

        self.shell.exec_list(
            "Running initialization commands in zsh",
            f"zsh {HOME}/.zshrc",
            f"zsh {HOME}/.zgenom/sources/init.zsh",
        )

        return

    def _color_ls(self):
        dir_color_path = f"{self.HOME}/.dircolors"
        self.shell.exec(
            "Using dircolor from default",
            f"""
            if [ $(uname) = 'Darwin' ]; then
                gdircolors -p > {dir_color_path}
            else
                dircolors -p > {dir_color_path}
            fi
            """,
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
                f'sed -i "s/^OTHER_WRITABLE .*/OTHER_WRITABLE {dir_color}/" {self.HOME}/.dircolors',
            )

    def _switch_to_zsh(self):
        user = self.USER
        HOME = self.HOME

        ok, new_shell, _ = self.shell.run("which zsh")
        if not ok:
            raise RuntimeError("zsh is not installed")

        ok, line_num, _ = self.shell.run(f"grep -n {user} /etc/passwd | cut -f1 -d:")
        if not ok:
            raise RuntimeError("Cannot read /etc/passwd")

        # | can be used as a separator in sed
        pattern = f"'{line_num}s|{HOME}:.*$|{HOME}:{new_shell}|'"
        self.shell.sudo_exec(
            "Changing default shell to zsh", f"sed -ie {pattern} /etc/passwd"
        )

    def _is_wsl(self):
        try:
            with open("/proc/version") as f:
                text = f.read()
            return bool(re.search(r"microsoft|wsl", text, re.IGNORECASE))
        except:
            return False


if __name__ == "__main__":
    ShellSwitcher(ArgumentParser().parse_args()).run()
