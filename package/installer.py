from argparse import Namespace
from debian import DebianPackageManager, DebianPreparation
from package_manager import PackageManager
from redhat import RedhatPackageManager, RedhatPreparation
from script import Script
from shell import Shell
from linux import LinuxAMD64


class Installer:
	def __init__(self, preparation: Script, package_manager: PackageManager,
				 non_package_manager: Script):
		self.shell = Shell()
		self.preparation = preparation
		self.package_manager = package_manager
		self.non_package_manager = non_package_manager
		return

	def install(self):
		self.preparation.run()
		self._install_packages()
		self.non_package_manager.run()
		return

	def _install_packages(self):
		pkg_list = self.package_manager.pkgs
		for pkg in pkg_list:
			self.shell.exec(f"Installing {pkg}",
							f"{self.package_manager.cmd} {pkg}")
		self.package_manager.do_misc()
		return


def make(args: Namespace) -> Installer:
	dist = args.dist
	if dist == "debian":
		return Installer(DebianPreparation(args), DebianPackageManager(args),
						 LinuxAMD64(args))
	elif dist == "redhat":
		return Installer(RedhatPreparation(args), RedhatPackageManager(args),
						 LinuxAMD64(args))
	elif dist == "darwin":
		pass
	raise NotImplementedError()
