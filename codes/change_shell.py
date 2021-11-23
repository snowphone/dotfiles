#!/usr/bin/env python3
from argparse import ArgumentParser
from getpass import getuser
import os
from pathlib import Path

from script import Script
from link_files import FileLinker


class ShellSwitcher(Script):
	def run(self) -> None:
		HOME = Path.home()

		FileLinker(self.args).run()

		if not self._exists("zsh"):
			raise RuntimeError("zsh not exists")

		ok, zsh_path, _ = self.shell.run("which zsh")
		if not ok:
			raise RuntimeError("Command 'which zsh' failed")
		zsh_path = zsh_path.decode("utf-8").strip()

		if os.environ["SHELL"] == zsh_path:
			print("zsh is already a default shell")
		else:
			self._switch_to_zsh()
			self.shell.exec_list(
				"Running initialization commands in zsh",

				f"zsh {HOME}/.zshrc",
				f"zsh {HOME}/.zgenom/sources/init.zsh"
			)

		self.shell.exec(
			"Installing nodejs via nvm",

			f". {HOME}/.nvm/nvm.sh && nvm install node",
		)

		if self.args.typescript:
			self.shell.exec(
				"Installing typescript related things",

				". {HOME}/.nvm/nvm.sh && npm install -g typescript ts-node pkg tslib"
			)

		return

	def _exists(self, cmd: str) -> bool:
		return self.shell.run(f"{cmd} --version")[0]

	def _switch_to_zsh(self):
		user = getuser()
		HOME = Path.home()

		ok, new_shell, _ = self.shell.run("which zsh")
		if not ok:
			raise RuntimeError("zsh is not installed")
		new_shell = new_shell.decode("utf-8").rstrip()

		ok, lineNum, _ = self.shell.run(f"grep -n {user} /etc/passwd | cut -f1 -d:")
		if not ok:
			raise RuntimeError("Cannot read /etc/passwd")
		lineNum = int(lineNum.decode("utf-8"))

		# | can be used as a separator in sed
		pattern = f"'{lineNum}s|{HOME}:.*$|{HOME}:{new_shell}|'"
		self.shell.sudo_exec(
			"Change default shell to zsh",
			f"sed -ie {pattern} /etc/passwd"
		)

if __name__ == "__main__":
	parser = ArgumentParser()
	parser.add_argument("--typescript", '-t', action='store_true')
	args = parser.parse_args()

	ShellSwitcher(args).run()

