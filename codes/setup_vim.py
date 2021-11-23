#!/usr/bin/env python3

from argparse import ArgumentParser
from script import Script


class Vim(Script):
	def run(self) -> None:
		for cmd in ["npm", "python3 -m pip", "vim"]:
			if not self._exists(cmd):
				raise RuntimeError(f"{cmd} is required")

		HOME = self.HOME
		proj_root = self.proj_root

		self.shell.exec(
			"Symbolic linking .vimrc",
			f'ln -fs "{proj_root}"/.vimrc {HOME}/.vimrc'
		)

		self._mkdir(f"{HOME}/.config/coc")
		self._exec(
			"Installing vim plugins",

			"vim --not-a-term -c PlugInstall -c quitall"
		)

		self.shell.sudo_exec(
			"Adding executable permission to HOME",
			f"chmod +w {HOME}"
		)

		self.shell.exec_list(
			"Symbolic linking other files",

			f'ln -sf "{proj_root}"/coc-settings.json {HOME}/.vim/',
			f'ln -sf "{proj_root}"/.coc.vimrc {HOME}/',
			f'mkdir -p {HOME}/.config/yapf',
			f'ln -sf "{proj_root}"/py_style {HOME}/.config/yapf/style',
			f'ln -fs "{proj_root}"/.latexmkrc {HOME}/.latexmkrc'
		)

		self.shell.exec(
			"Installing yapf",
			"python3 -m pip install --user yapf"
		)
		return

	def _exec(self, message: str, cmd: str):
		nvm_path = f"{self.HOME}/.nvm/nvm.sh"
		if self._exists(nvm_path):
			return self.shell.exec(message, f". {nvm_path} && {cmd}")
		else:
			return self.shell.exec(message, cmd)

if __name__ == "__main__":
	Vim(ArgumentParser().parse_args()).run()
