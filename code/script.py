from abc import (
    ABC,
    abstractmethod,
)
from argparse import Namespace
from getpass import getuser
from os import makedirs
from pathlib import Path

from shell import Shell


class Script(ABC):
    def __init__(self, args: Namespace):
        self.shell = Shell()
        self.args = args
        self.HOME = Path.home()
        self.USER = getuser()
        self.proj_root = Path(__file__).resolve().parents[1]

    @abstractmethod
    def run(self) -> None:
        "Execute the script's main functionality"
        raise NotImplementedError()

    def _exists(self, cmd: str) -> bool:
        "Check whether command exists"
        return self.shell.run(f"{cmd} --version")[0]

    def _mkdir(self, path: str):
        "Do same function as mkdir"
        makedirs(path, exist_ok=True)
