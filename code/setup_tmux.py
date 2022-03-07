#!/usr/bin/env python3
from argparse import ArgumentParser
from os import path

from script import Script

class Tmux(Script):
	def run(self) -> None:
		HOME = self.HOME

		tmux_dir = f"{HOME}/.tmux/plugins/tpm"
		if path.exists(tmux_dir):
			return

		self.shell.exec(
			"Aliasing .tmux.conf",
			f'ln -fs "{self.proj_root}"/.tmux.conf {HOME}/'
		)

		self.shell.exec_list(
			"Installing tpm, a plugin manager",

			f'git clone https://github.com/tmux-plugins/tpm {HOME}/.tmux/plugins/tpm',
			f'{HOME}/.tmux/plugins/tpm/bin/install_plugins',
			f'{HOME}/.tmux/plugins/tpm/bin/update_plugins all'
		)

		return

if __name__ == "__main__":
	Tmux(ArgumentParser().parse_args()).run()
