#!/usr/bin/env python3
from argparse import ArgumentParser
import os
from os import makedirs
from pathlib import Path

from script import Script
import re


class FileLinker(Script):
	def run(self) -> None:
		HOME = Path.home()
		proj_root = Path(__file__).resolve().parents[1]

		self._mkdir(f"{HOME}/.local/bin/")
		self.shell.exec(
			"Link scripts",

			f'ln -fs "{proj_root}"/scripts/* {HOME}/.local/bin/'
		)

		self.shell.exec_list(
			"Enable parallelism for tar",

			f"ln -sf /usr/bin/lbzip2 {HOME}/.local/bin/bzip2",
			f"ln -sf /usr/bin/lbzip2 {HOME}/.local/bin/bunzip2",
			f"ln -sf /usr/bin/lbzip2 {HOME}/.local/bin/bzcat",
			f"ln -sf /usr/bin/pigz {HOME}/.local/bin/gzip",
			f"ln -sf /usr/bin/pigz {HOME}/.local/bin/gunzip",
			f"ln -sf /usr/bin/pigz {HOME}/.local/bin/gzcat",
			f"ln -sf /usr/bin/pigz {HOME}/.local/bin/zcat",
			f"ln -sf /usr/bin/pixz {HOME}/.local/bin/xz"
		)

		trueline_path = f"{HOME}/.trueline.sh"
		if not os.path.exists(trueline_path):
			self.shell.exec(
				'Download trueline.sh',
				f'curl -s https://raw.githubusercontent.com/petobens/trueline/master/trueline.sh -o {trueline_path}'
			)

		self.shell.exec_list(
			"Symbolic-link essential files",

			f'ln -fs "{proj_root}"/.bashrc {HOME}/.bashrc',					# Deprecated: bashrc
			f'ln -fs "{proj_root}"/.gitconfig  {HOME}/.gitconfig',			# Global git configuration
			f'ln -fs "{proj_root}"/.common.shrc {HOME}/.common.shrc',
			f'ln -fs "{proj_root}"/.zshrc {HOME}/.zshrc',
			f'ln -fs "{proj_root}"/.p10k.zsh {HOME}/.p10k.zsh',
			f'ln -fs "{proj_root}"/.mailcap {HOME}/.mailcap',				# Open text files with vim when using xdg-open
			f'ln -fs "{proj_root}"/.mailcap.order {HOME}/.mailcap.order',	# Set higher priority to vim
			f'mkdir -p {HOME}/.config/translate-shell',
			f'ln -fs "{proj_root}"/init.trans {HOME}/.config/translate-shell/init.trans',
		)

		dir_color_path = f"{HOME}/.dircolors"
		self.shell.exec(
			"Use dircolor from dircolors-solarized",

			f"curl --silent -o {dir_color_path} https://raw.githubusercontent.com/huyz/dircolors-solarized/master/dircolors.256dark"
		)
		if self._is_wsl():
			# In WSL, folders in Windows storage look as OTHER_WRITABLE, so OTHER_WRITABLE is set as same as DIR.
			with open(dir_color_path) as f:
				text = f.read()
			dir_color = re.search(r"(?<=DIR ).+", text)
			if not dir_color:
				raise RuntimeError(f"Failed to read DIR attribute from {dir_color_path}")
			dir_color = dir_color.group()

			self.shell.exec(
				"Set OTHER_WRITABLE same as DIR in WSL",

				f'sed -i "s/^OTHER_WRITABLE .*/OTHER_WRITABLE {dir_color}/" {HOME}/.dircolors'
			)


		self.shell.exec_list(
			"Setup pip cache server",

			f'mkdir -p {HOME}/.pip',
			f'ln -fs "$folder"/pip.conf {HOME}/.pip/pip.conf',
			f'ln -fs $(which pip3) {HOME}/.local/bin/pip'
		)
		return
	
	def _is_wsl(self):
		with open("/proc/version") as f:
			text = f.read()
		return re.search(r"microsoft|wsl", text, re.IGNORECASE)


	def _mkdir(self, path: str):
		makedirs(path, exist_ok=True)

if __name__ == "__main__":
	parser = ArgumentParser()
	args = parser.parse_args()

	FileLinker(args).run()

