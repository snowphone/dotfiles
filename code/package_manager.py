from argparse import Namespace
from typing import Sequence

from shell import Shell


class PackageManager:
    def __init__(self, args: Namespace):
        self.args = args
        self.shell = Shell()

    @property
    def cmd(self) -> str:
        raise NotImplementedError()

    @property
    def pkgs(self) -> Sequence[str]:
        raise NotImplementedError()

    def do_misc(self):
        pass
