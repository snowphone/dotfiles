#!/usr/bin/env python3

from argparse import ArgumentParser, Namespace
from script import Script


class Vim(Script):
	def __init__(self, args: Namespace):
		super().__init__(args)
		self.nvm_path = f"{self.HOME}/.nvm/nvm.sh"

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

		self.shell.exec(
			"Adding executable permission to HOME",
			f"chmod 755 {HOME}"
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

		if self._exists("nvim"):
			self._setup_for_nvim()

		return

	def _setup_for_nvim(self):
		HOME = self.HOME
		proj_root = self.proj_root

		self.shell.exec_list(
			"Aliasing files for neovim",

			f'mkdir -p {HOME}/.config/nvim',
			f'ln -sf "{proj_root}"/coc-settings.json {HOME}/.config/nvim/',
			f'ln -sf "{proj_root}"/init.vim {HOME}/.config/nvim/',
			"python3 -m pip install --user neovim",
			"nvim --headless -c PlugInstall -c quitall",				# Install nvim plugins
			"nvim --headless -c 'TSInstallSync maintained' -c quitall"	# Install treesitter plugins
		)
		return

	def _exists(self, cmd: str) -> bool:
		return super()._exists(self._sourced_cmd(cmd))

	def _sourced_cmd(self, cmd: str):
		return f"source {self.nvm_path} && {cmd}"

	def _exec(self, message: str, cmd: str):
		if self._exists(self.nvm_path):
			return self.shell.exec(message, self._sourced_cmd(cmd))
		else:
			return self.shell.exec(message, cmd)

if __name__ == "__main__":
	Vim(ArgumentParser().parse_args()).run()
