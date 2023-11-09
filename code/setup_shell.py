#!/usr/bin/env python3
import os
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

        self.shell.exec_list(
            "Running initialization commands in zsh",
            f"zsh {HOME}/.zshrc",
            f"zsh {HOME}/.zgenom/sources/init.zsh",
        )

        return

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

        self.shell.exec(
            "Installing virtualenvwrapper", "python3 -m pip install virtualenvwrapper"
        )


if __name__ == "__main__":
    ShellSwitcher(ArgumentParser().parse_args()).run()
