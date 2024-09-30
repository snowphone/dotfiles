import os
from argparse import Namespace
from pathlib import Path

from package_manager import PackageManager
from script import Script
from util import (
    GithubDownloadable,
    is_m1,
)

os.environ["PATH"] = f'/usr/local/bin:/opt/homebrew/bin:{os.environ["PATH"]}'


class DarwinPreparation(Script):
    def __init__(self, args: Namespace):
        super().__init__(args)

    def run(self):
        "Installs homebrew if not exists"

        if not self._exists("brew"):
            self.shell.exec_list(
                "Installing homebrew",
                "sudo echo hello",  # To acquire sudo permission
                '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null',
            )
        return


class DarwinPackageManager(PackageManager):
    @property
    def cmd(self) -> str:
        return "brew install "

    @property
    def pkgs(self):
        pkgs = [
            "bat",
            "bear",
            "bfs",
            "btop",
            "cmake",
            "convmv",
            "coreutils",
            "dict",
            "fd",
            "ffmpeg",
            "figlet",
            "font-d2coding",
            "font-d2coding-nerd-font",
            "font-delugia-complete",
            "git",
            "git-extras",
            "glow",
            "gotop",
            "grep",
            "gzip",
            "gawk",
            "gnu-getopt",
            "gnu-sed",
            "gnu-tar",
            "htop",
            "jq",
            "k9s",
            "lbzip2",
            "llvm",
            "make",
            "mmv",
            "multitail",
            "neofetch",
            "neovim",
            "num-utils",
            "parallel",
            "pigz",
            "pixz",
            "poppler",
            "p7zip",
            "rename",
            "ripgrep",
            "ripgrep-all",
            "rsync",
            "rust",
            "shfmt",
            "shellcheck",
            "sponge",
            "the_silver_searcher",
            "tmux --HEAD",
            "translate-shell",
            "tree",
            "tty-clock",
            "tldr",
            "unzip",
            "viddy",
            "vim",
            "w3m",
            "watch",
            "wget",
            "yq",
            "yt-dlp",
            "zip"
        ]

        if self.args.latex:
            pkgs.append("texlive")
        if self.args.boost:
            pkgs.append("boost")
        if self.shell.env.get("DISPLAY", False):
            print("X11 is not supported")
        if self.args.misc:
            print("Misc is not supported")
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
        for pkg in frozenset(self.pkgs) & {
            "java",
            "gnu-sed",
            "gnu-getopt",
            "grep",
            "gnu-tar",
            "coreutils",
        }:
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
            "curl -Lfo ~/.config/karabiner/karabiner.json https://gist.githubusercontent.com/snowphone/e28a836fe694a3e423ab42a37b99ba00/raw/karabiner.json",
        )

        self.shell.exec_list(
            "Downloading iTerm2 config",
            r"mkdir -p ~/Library/Application\ Support/iTerm2/DynamicProfiles",
            r"""
            cat <(echo '{ "Profiles": [') \
                <(curl https://gist.githubusercontent.com/snowphone/7f771242e80579b52fbd06c859af3853/raw/Default.json) \
                <(echo ']}') > ~/Library/Application\ Support/iTerm2/DynamicProfiles/Default.json
            """,
        )

        self.shell.exec(
            "Aliasing python to python3",
            "ln -sf /usr/local/bin/python3 /usr/local/bin/python",
        )


class Mac(Script, GithubDownloadable):
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

        self.shell.exec_list(
            "Installing 7zip",
            self.dl_cmd(
                "https://7-zip.org/a/7z2408-mac.tar.xz",
                tar_extract_flags="xJ",
            ),
            f"rm -rf {self.HOME}/.local/bin/MANUAL {self.HOME}/.local/bin/readme.txt  {self.HOME}/.local/bin/History.txt {self.HOME}/.local/bin/License.txt {self.HOME}/.locall/bin/7zzs",
            f"mv -f {self.HOME}/.local/bin/7zz {self.HOME}/.local/bin/7z",
        )

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

        self.shell.exec(
            "Installing bazel-lsp",
            self.github_dl_single_cmd(
                "cameron-martin/bazel-lsp",
                "osx-arm64" if is_m1() else "osx-amd64",
                f"{self.HOME}/.local/bin/bazel-lsp",
            ),
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
        casks = [
            "adguard",
            "firefox",
            "itsycal",
            "iina",
            "iterm2",
            "karabiner-elements",
            "keepingyouawake",
            "keka",
            "libreoffice",
            "microsoft-edge",
            "raycast",
            "rectangle",
            "visual-studio-code",
            "xquartz",
            "--no-quarantine middleclick",
        ]

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
