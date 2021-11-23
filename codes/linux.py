
from argparse import Namespace
import os
from pathlib import Path
from script import Script


class LinuxAMD64(Script):
	def __init__(self, args: Namespace):
		super().__init__(args)
		self.HOME = Path.home()

		self.zsh_completion_path = f"{self.HOME}/.local/share/zsh/vendor-completions"
		self.bash_completion_path = f"{self.HOME}/.local/share/bash-completion/completions"
		self.man_path = f"{self.HOME}/.local/share/man/man1"

	def run(self):
		self._mkdir(f"{self.HOME}/.pip")
		self._mkdir(f"{self.HOME}/.local/bin")

		self.shell.run(
			f"ln -fs {self.proj_root}/pip.conf {self.HOME}/.pip/pip.conf")
		self.shell.exec("Installing pudb, a python debugger",
						"pip3 install --user pudb")
		self.shell.exec_list(
			"Installing yt-dlp",
			"pip3 install --user yt-dlp",
			f"ln -sf {self.HOME}/.local/bin/yt-dlp {self.HOME}/.local/bin/youtube-dl"
		)

		self.shell.exec("Installing caterpillar, an hls downloader",
						"pip3 install --user caterpillar-hls")
		if self.args.latex:
			self.shell.sudo_exec("Refreshing fonts", "fc-cache -f -v")

		if self.args.rust:
			self.shell.exec("Installing rust",
							'curl https://sh.rustup.rs -sSf | sh -s -- -y')

		self._mkdir(self.zsh_completion_path)
		self._mkdir(self.bash_completion_path)
		self._mkdir(self.man_path)

		self._install_fd()

		self.shell.exec(
			"Installing ripgrep-all",
			self.github_dl_cmd("phiresky/ripgrep-all",
							   "x86_64-unknown-linux-musl.tar.gz", 1))

		self.shell.exec(
			"Installing gotop",
			self.github_dl_cmd("xxxserxxx/gotop", "linux_amd64.tgz"))

		self._install_bat()

		self.shell.exec(
			"Installing glow",
			self.github_dl_cmd("charmbracelet/glow", "linux_x86_64.tar.gz"))

		if self.args.golang:
			ok, go_ver, _ = self.shell.exec(
				"Fetching latest golang version",
				'curl -s https://golang.org/VERSION?m=text')
			if not ok:
				return
			self.shell.exec(
				"Installing golang",
				f"curl -s https://dl.google.com/go/{go_ver}.linux-amd64.tar.gz | tar xz -C {self.HOME}/.local/ --strip 1"
			)

		self.shell.exec(
			"Removing auxiliary files",
			f"rm -rf {self.HOME}/.local/bin/autocomplete {self.HOME}/.local/bin/completion {self.HOME}/.local/bin/LICENSE* {self.HOME}/.local/bin/*.md {self.HOME}/.local/bin/doc"
		)

	def _install_fd(self):
		self.shell.exec_list(
			"Installing fd",
			self.github_dl_cmd("sharkdp/fd",
							   "x86_64-unknown-linux-musl.tar.gz", 1),
			f"mv {self.HOME}/.local/bin/autocomplete/_fd {self.zsh_completion_path}/_fd",
			f"mv {self.HOME}/.local/bin/autocomplete/fd.bash-completion {self.bash_completion_path}/fd",
			f"mv {self.HOME}/.local/bin/fd.1 {self.man_path}/fd.1")

	def _install_bat(self):
		self.shell.exec_list(
			"Installing bat",
			self.github_dl_cmd("sharkdp/bat",
							   "x86_64-unknown-linux-musl.tar.gz", 1),
			f"mv {self.HOME}/.local/bin/autocomplete/bat.zsh {self.zsh_completion_path}/_bat",
			f"mv {self.HOME}/.local/bin/autocomplete/bat.bash {self.bash_completion_path}/bat",
			f"mv {self.HOME}/.local/bin/bat.1 {self.man_path}/bat.1")

	def github_dl_cmd(self, user_repo: str, suffix: str, strip: int = 0):
		cmd = f"""curl -s https://api.github.com/repos/{user_repo}/releases/latest |
		grep browser_download_url | 
		grep -Po 'https://.*?'{suffix}  |
		xargs curl -L | 
		tar xz -C {self.HOME}/.local/bin"""
		if strip:
			cmd += f" --strip {strip}"

		return cmd
