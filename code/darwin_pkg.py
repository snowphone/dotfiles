from argparse import Namespace
from pathlib import Path

from package_manager import PackageManager
from script import Script


class DarwinPreparation(Script):
    def __init__(self, args: Namespace):
        super().__init__(args)

    def run(self):
        "Installs homebrew if not exists"

        self._mkdir(f"{self.HOME}/.config/pip")
        self.shell.exec(
            "Symlinking pip.conf",
            f"ln -fs {self.proj_root}/pip.conf {self.HOME}/.config/pip/pip.conf",
        )

        if not self._exists("brew"):
            self.shell.exec(
                "Installing homebrew",
                '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null',
            )

        self.shell.exec("Tap homebrew/cask-fonts", "brew tap homebrew/cask-fonts")
        return


class DarwinPackageManager(PackageManager):
    @property
    def cmd(self) -> str:
        return "brew install "

    @property
    def pkgs(self):
        pkgs = """
			llvm vim neovim git rename wget tmux make gzip zip unzip figlet
			cmake poppler watch
			tree htop ripgrep the_silver_searcher rsync
			bear w3m git-extras multitail
			neofetch mmv
			parallel sponge num-utils
            coreutils gnu-sed gawk gnu-tar grep
			lbzip2 pigz pixz p7zip
			ffmpeg
			translate-shell dict jq rust

			yt-dlp fd ripgrep-all gotop bat glow

            tldr yq btop bat glow k9s yt-dlp

            karabiner-elements firefox microsoft-edge code-cli
            iterm2 raycast

            font-delugia-complete font-d2coding font-d2coding-nerd-font
			""".split()

        if self.args.latex:
            pkgs.append("texlive")
        if self.args.boost:
            pkgs.append("boost")
        if self.shell.env.get("DISPLAY", False):
            print("X11 is not suppored")
        if self.args.misc:
            print("Misc is not suppored")
        if self.args.golang:
            pkgs.append("go")
        if self.args.java:
            pkgs += ["java", "kotlin", "gradle", "maven"]
        return pkgs

    def do_misc(self):
        """
        TODO: Installs gdb
        """
        paths = set()
        for pkg in frozenset(self.pkgs) & {"java", "gnu-sed", "grep", "gnu-tar"}:
            ok, path, _ = self.shell.run(f"brew --prefix {pkg}")
            if not ok:
                print(f"Problem occurred while brew --prefix {pkg}")
                continue
            paths.add(f"{path}/bin")

        path = ":".join(paths)
        HOME = Path.home()
        self.shell.exec("Updating PATH", f"printf '%s' '{path}' > {HOME}/.paths")

        self.shell.exec(
            "Download karabiner configuration",
            "curl -Lfo $HOME/.config/karabiner/karabiner.json https://gist.githubusercontent.com/snowphone/e28a836fe694a3e423ab42a37b99ba00/raw/karabiner.json",
        )

        self.shell.exec_list(
            "Downloading iTerm2 config",
            "mkdir -p '$HOME/Library/Application Support/iTerm2/DynamicProfiles'",
            """
            cat <(echo '{ "Profiles": [') \
                <(curl https://gist.githubusercontent.com/snowphone/7f771242e80579b52fbd06c859af3853/raw/Default.json) \
                <(echo ']}') | 
            tee '~/Library/Application Support/iTerm2/DynamicProfiles/Default.json'
            """,
        )

        self.shell.exec(
            "Aliasing python to python3",
            "ln -sf /usr/local/bin/python3 /usr/local/bin/python",
        )


class Mac(Script):
    def __init__(self, args: Namespace):
        super().__init__(args)
        self.HOME = Path.home()

        self.zsh_completion_path = f"{self.HOME}/.local/share/zsh/vendor-completions"
        self.bash_completion_path = (
            f"{self.HOME}/.local/share/bash-completion/completions"
        )
        self.man_path = f"{self.HOME}/.local/share/man/man1"

    def run(self):
        self._mkdir(f"{self.HOME}/.local/bin")

        self.shell.exec(
            "Installing commitgpt",
            f"cargo install --git https://github.com/snowphone/CommitGPT",
        )

        self.shell.exec(
            "Installing macchina",
            f"cargo install macchina",
        )

        self.shell.exec(
            "Installing pudb, a python debugger", "pip3 install --user pudb"
        )

        self.shell.exec(
            "Installing caterpillar, an hls downloader",
            "pip3 install --user caterpillar-hls",
        )

        self.shell.exec(
            "Installing visidata",
            "pip3 install --user visidata",
        )

        self._install_casks()
        self._install_node()

        self._mkdir(self.zsh_completion_path)
        self._mkdir(self.bash_completion_path)
        self._mkdir(self.man_path)

        self.shell.exec(
            "Removing auxiliary files",
            f"rm -rf {self.HOME}/.local/bin/autocomplete {self.HOME}/.local/bin/completion {self.HOME}/.local/bin/LICENSE* {self.HOME}/.local/bin/*.md {self.HOME}/.local/bin/doc",
        )

    def _install_casks(self):
        casks = ["visual-studio-code", "xquartz"]

        for cask in casks:
            self.shell.exec(
                f"Installing {cask}",
                f"brew install --cask {cask}",
            )
        return

    def _install_node(self):
        self.shell.exec(
            "Installing nvm",
            "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | PROFILE=/dev/null bash",
            # Set PROFILE to /dev/null to not update .zshrc or .bashrc
        )
        self._sourced_exec(
            "Installing nodejs lts via nvm",
            f"nvm install --lts",
        )
        self._sourced_exec(
            "Installing yarn",
            f"npm install --global yarn",
        )

        if self.args.typescript:
            self._sourced_exec(
                "Installing typescript related things",
                "npm install -g typescript ts-node pkg tslib",
            )
        return

    def _sourced_exec(self, message: str, cmd: str):
        return self.shell.exec(message, f"source {self.HOME}/.nvm/nvm.sh && {cmd}")
