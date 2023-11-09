#!/usr/bin/env python3
from argparse import (
    ArgumentParser,
    Namespace,
)

from darwin_pkg import (
    DarwinPackageManager,
    DarwinPreparation,
    Mac,
)
from debian_pkg import (
    DebianPackageManager,
    DebianPreparation,
)
from linux_pkg import LinuxAMD64
from redhat_pkg import (
    RedhatPackageManager,
    RedhatPreparation,
)
from script import Script


class Installer(Script):
    def __init__(self, args: Namespace):
        super().__init__(args)
        (
            self.preparation,
            self.package_manager,
            self.non_package_manager,
        ) = self._select_distro(args.distro)
        return

    def _select_distro(self, distro: str):
        args = self.args
        if distro == "debian":
            return (
                DebianPreparation(args),
                DebianPackageManager(args),
                LinuxAMD64(args),
            )
        elif distro == "redhat":
            return (
                RedhatPreparation(args),
                RedhatPackageManager(args),
                LinuxAMD64(args),
            )
        elif distro == "darwin":
            return (DarwinPreparation(args), DarwinPackageManager(args), Mac(args))
        raise NotImplementedError(f"{distro} is not supported yet")

    def run(self):
        self.preparation.run()
        self._install_packages()
        self.non_package_manager.run()
        return

    def _install_packages(self):
        pkg_list = self.package_manager.pkgs
        for pkg in pkg_list:
            self.shell.exec(f"Installing {pkg}", f"{self.package_manager.cmd} {pkg}")
        self.package_manager.do_misc()
        return

    def _is_m1(self):
        return self.shell.run("uname -m")[1] == "arm64"


def setup_args(parser: ArgumentParser = ArgumentParser()):
    def add_flag(long: str, short: str, helpstr: str):
        parser.add_argument(
            long, short, help=helpstr, action="store_true", default=False
        )
        return

    parser.add_argument(
        "--distro",
        "-d",
        help="select distribution",
        choices=["debian", "redhat", "darwin"],
        required=True,
    )

    add_flag("--latex", "-l", "install texlive-full")
    add_flag("--boost", "-b", "install libboost-all-dev")
    add_flag("--java", "-j", "install maven, gradle, and openjdk")
    add_flag("--rust", "-r", "install rust")
    add_flag("--golang", "-g", "install golang")
    add_flag("--misc", "-m", "install some miscellaneous stuffs")
    add_flag("--elixir", "-e", "install elixir")
    add_flag("--typescript", "-t", "install typescript")

    return parser


if __name__ == "__main__":
    Installer(setup_args().parse_args()).run()
