from argparse import Namespace
from typing import List

from shell import Shell

class PackageManager:
	def __init__(self, args: Namespace):
		self.args = args
		self.shell = Shell()
	
	@property
	def cmd(self) -> str:
		raise NotImplementedError()

	@property
	def pkgs(self) -> List[str]:
		raise NotImplementedError()

	def do_misc(self):
		pass
	

