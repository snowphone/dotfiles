# -*- coding: future_fstrings -*-
from argparse import ArgumentParser
from getpass import getuser
import os
from pathlib import Path

from script import Script
from link_files import FileLinker


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
			f"zsh {HOME}/.zgenom/sources/init.zsh"
		)

		self._sourced_exec(
			"Installing nodejs lts via nvm",

			f"nvm install --lts",
		)

		if self.args.typescript:
			self._sourced_exec(
				"Installing typescript related things",

				"npm install -g typescript ts-node pkg tslib"
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
			"Changing default shell to zsh",
			f"sed -ie {pattern} /etc/passwd"
		)
	
	def _sourced_exec(self, message: str, cmd: str):
		return self.shell.exec(message, f"source {self.HOME}/.nvm/nvm.sh && {cmd}")

def setup_args(parser: ArgumentParser = ArgumentParser()):
	parser.add_argument("--typescript", '-t', action='store_true', help="install typescript", default=False)

	return parser


if __name__ == "__main__":
	ShellSwitcher(setup_args().parse_args()).run()

