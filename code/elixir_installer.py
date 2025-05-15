#!/usr/bin/env python3
from argparse import (
    ArgumentParser,
    Namespace,
)
from pathlib import Path

from script import Script


class ElixirInstaller(Script):
    def __init__(self, args: Namespace):
        super().__init__(args)
        self.HOME = Path.home()
        self.asdf_path = f"{self.HOME}/.asdf/asdf.sh"

    def run(self):
        self.shell.exec(
            "Installing asdf plugin manager",
            "git clone https://github.com/asdf-vm/asdf ~/.asdf",
        )

        self._exec_list(
            "Installing elixir",
            "asdf plugin add erlang",
            "asdf install erlang 24.3.4.2",
            "asdf global erlang  24.3.4.2",
            "asdf plugin add elixir",
            "asdf install elixir 1.13.4-otp-24",
            "asdf global elixir 1.13.4-otp-24",
        )
        return

    def _exec_list(self, msg: str, *cmds: str):
        sourced_cmds = [f"source {self.asdf_path} && {cmd}" for cmd in cmds]
        self.shell.exec_list(msg, *sourced_cmds)


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument(
        "--elixir",
        "-e",
        action="store_true",
        help="install elixir",
        default=False,
    )

    ElixirInstaller(parser.parse_args()).run()

