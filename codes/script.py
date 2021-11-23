from shell import Shell
from argparse import Namespace

class Script:
	def __init__(self, args: Namespace):
		self.shell = Shell()
		self.args = args
	
	def run(self) -> None:
		raise NotImplementedError()

