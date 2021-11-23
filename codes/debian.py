from argparse import Namespace
import re

from script import Script
from package_manager import PackageManager


class DebianPreparation(Script):
	def __init__(self, args: Namespace):
		super().__init__(args)

	def run(self):
		self.shell.env["DEBIAN_FRONTEND"] = "noninteractive"

		self.shell.sudo_exec(
			"Prioritizing IPv4 in apt",
			r"""sed -riE 's/#\s*(precedence ::ffff:0:0[/]96\s+100)/\1/' /etc/gai.conf"""
		)
		self._add_repositories()

	def _add_repositories(self):
		self.shell.sudo_exec_list(
			"Switching apt repositories to those of Kakao",
			r"sed -i 's/kr.archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list",
			r"sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list",
			r"sed -i 's/security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list"
		)

		self.shell.sudo_exec_list(
			"Updating apt repositores",
			"apt update",
			"apt install -y curl software-properties-common", "apt update")

		self.shell.sudo_exec("Adding vim repository",
							 "add-apt-repository -y ppa:jonathonf/vim")
		return


class DebianPackageManager(PackageManager):
	@property
	def cmd(self) -> str:
		return f"{self.shell.sudo} apt install -qy "

	@property
	def pkgs(self):
		pkgs = """
			build-essential gdb less tar vim git gcc curl rename wget tmux make gzip zip unzip figlet
			zsh python-is-python3
			exuberant-ctags cmake
			python3-dev python3 python3-pip
			bfs tree htop ripgrep silversearcher-ag rsync
			bear sshpass w3m traceroute git-extras multitail
			neofetch mmv
			poppler-utils
			parallel moreutils num-utils
			lbzip2 pigz pixz p7zip-full
			ffmpeg
			translate-shell dict
			""".split()

		if self.args.latex:
			self.shell.exec(
				"Preparing for installing ms core fonts",
				f"echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | {self.shell.sudo} debconf-set-selections"
			)
			pkgs += ["texlive-full", "ttf-mscorefonts-installer"]
		if self.args.boost:
			pkgs.append("libboost-all-dev")
		if self.shell.env.get("DISPLAY", False):
			pkgs += ["mupdf", "xdotool", "nautilus", "mpv"]
		if self.args.misc:
			pkgs += ["figlet", "lolcat", "toilet", "img2pdf"]
		return pkgs

	def do_misc(self):
		self._install_clang()

	def _install_clang(self):
		latest = 15
		for ver in range(latest, 0, -1):
			install_list = [
				f"clang-{ver}", f"clang-tools-{ver}", f"clangd-{ver}",
				f"clang-format-{ver}"
			]
			alias_list = [
				f"clang-{ver}", f"clangd-{ver}", f"clang-format-{ver}",
				f"clang++-{ver}"
			]
			succeeded, _, _ = self.shell.sudo_exec(
				f"Installing {install_list}",
				f"{self.cmd} {' '.join(install_list)}")
			if not succeeded:
				continue
			for pkg in alias_list:
				pattern = re.compile(r"-\d+")
				basename = pattern.sub('', pkg)
				priority = latest + 1 - ver
				self.shell.sudo_exec(
					f"{pkg} being aliased to {basename}",
					f"update-alternatives --install /usr/bin/{basename} {basename} /usr/bin/{pkg} {priority}"
				)
			return
