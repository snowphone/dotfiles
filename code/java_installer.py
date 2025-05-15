#!/usr/bin/env python3
from argparse import (
    ArgumentParser,
    Namespace,
)
from pathlib import Path

from script import Script


class JavaInstaller(Script):
    def __init__(self, args: Namespace):
        super().__init__(args)
        self.HOME = Path.home()
        self.sdk_path = f"{self.HOME}/.sdkman/bin/sdkman-init.sh"

    def run(self):
        self.shell.exec(
            "Downloading sdkman",
            'curl -s https:"//get.sdkman.io?rcupdate=false" | bash',
        )
        self._exec_list(
            "Installing java, gradle, and kotlin",
            "sdk install java",
            "sdk install gradle",
            "sdk install kotlin",
        )
        return

    def _exec_list(self, msg: str, *cmds: str):
        sourced_cmds = [f"source {self.sdk_path} && {cmd}" for cmd in cmds]
        self.shell.exec_list(msg, *sourced_cmds)


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument(
        "--java",
        "-j",
        action="store_true",
        help="install java",
        default=False,
    )

    JavaInstaller(parser.parse_args()).run()

