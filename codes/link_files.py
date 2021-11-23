#!/usr/bin/env python3
from argparse import ArgumentParser
import os
from pathlib import Path

from script import Script
import re


class FileLinker(Script):
	def run(self) -> None:
		HOME = self.HOME
		proj_root = self.proj_root

		self._mkdir(f"{HOME}/.local/bin/")
		self.shell.exec(
			"Symbolic linking scripts",

			f'ln -fs "{proj_root}"/scripts/* {HOME}/.local/bin/'
		)

		self.shell.exec_list(
			"Enabling tar to parallelize archiving files",

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
				'Downloading trueline.sh',
				f'curl -s https://raw.githubusercontent.com/petobens/trueline/master/trueline.sh -o {trueline_path}'
			)

		self.shell.exec_list(
			"Symbolic linking essential files",

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
			"Using dircolor from dircolors-solarized",

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
				"Setting OTHER_WRITABLE same as DIR in WSL",

				f'sed -i "s/^OTHER_WRITABLE .*/OTHER_WRITABLE {dir_color}/" {HOME}/.dircolors'
			)


		self.shell.exec_list(
			"Setting up pip cache server",

			f'mkdir -p {HOME}/.pip',
			f'ln -fs "$folder"/pip.conf {HOME}/.pip/pip.conf',
			f'ln -fs $(which pip3) {HOME}/.local/bin/pip'
		)

		if self._is_wsl():
			link_cmds = [
				f'ln -fs /mnt/c/Users/mjo97/Downloads/ $HOME/',
				f'ln -fs /mnt/c/Users/mjo97/Dropbox/Documents/ $HOME/',
				f'ln -fs /mnt/c/Users/mjo97/Videos/ $HOME/',
			]
			if not os.path.islink(f"{HOME}/kaist"):
				link_cmds.append(
					f'ln -fs /mnt/c/Users/mjo97/OneDrive\ -\ kaist.ac.kr/ {HOME}/kaist'
				)
			if not os.path.islink(f"{HOME}/winHome"):
				link_cmds.append(
					f'ln -fs /mnt/c/Users/mjo97/ {HOME}/winHome'
				)

			self.shell.exec_list(
				"Symbolic linking windows folders",
				*link_cmds
			)

		return
	
	def _is_wsl(self):
		with open("/proc/version") as f:
			text = f.read()
		return re.search(r"microsoft|wsl", text, re.IGNORECASE)

	def _link_exists(self, path: str) -> bool:
		pass


if __name__ == "__main__":
	parser = ArgumentParser()
	args = parser.parse_args()

	FileLinker(args).run()

