from argparse import Namespace
from pathlib import Path

from script import Script

from script import Script
from package_manager import PackageManager


class DarwinPreparation(Script):
	def __init__(self, args: Namespace):
		super().__init__(args)

	def run(self):
		'Installs homebrew'

		self.shell.exec("Installing homebrew",
				 '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null'
				 )
		return


class DarwinPackageManager(PackageManager):
	@property
	def cmd(self) -> str:
		return "brew install "

	@property
	def pkgs(self):
		pkgs = """
			llvm vim git rename wget tmux make gzip zip unzip figlet
			zsh cmake python poppler
			tree htop ripgrep the_silver_searcher rsync
			bear w3m git-extras multitail
			neofetch mmv
			parallel moreutils num-utils
			lbzip2 pigz pixz p7zip
			ffmpeg
			translate-shell dict

			yt-dlp fd ripgrep-all gotop bat glow
			""".split()

		if self.args.latex:
			pkgs.append("texlive")
		if self.args.boost:
			pkgs.append("boost")
		if self.shell.env.get("DISPLAY", False):
			print("X11 is not suppored")
		if self.args.misc:
			print("Misc is not suppored")
		if self.args.rust:
			pkgs.append("rust")
		if self.args.golang:
			pkgs.append("go")
		if self.args.java:
			pkgs += ["java", "kotlin", "gradle", "maven"]
		return pkgs

	def do_misc(self):
		'''
		TODO: Installs gdb
		'''
		paths = set()
		for pkg in self.pkgs:
			ok, path, _ = self.shell.run(f"brew --prefix {pkg}")
			if not ok:
				print(f"Problem occurred while brew --prefix {pkg}")
				continue
			paths.add(path)

		path = ":".join(paths) + ":$PATH"
		HOME = Path.home()
		self.shell.exec(
			"Updating PATH",
			f"printf '%s' '{path}' > {HOME}/.paths"
		)



class Mac(Script):
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

		self.shell.exec("Installing caterpillar, an hls downloader",
						"pip3 install --user caterpillar-hls")


		self._mkdir(self.zsh_completion_path)
		self._mkdir(self.bash_completion_path)
		self._mkdir(self.man_path)


		self.shell.exec(
			"Removing auxiliary files",
			f"rm -rf {self.HOME}/.local/bin/autocomplete {self.HOME}/.local/bin/completion {self.HOME}/.local/bin/LICENSE* {self.HOME}/.local/bin/*.md {self.HOME}/.local/bin/doc"
		)

