#!/usr/bin/env python3

from argparse import (
    ArgumentParser,
    Namespace,
)
from pathlib import Path

from script import Script


class LinuxAMD64(Script):
    def __init__(self, args: Namespace):
        super().__init__(args)
        self.HOME = Path.home()

        self.zsh_completion_path = f"{self.HOME}/.local/share/zsh/vendor-completions"
        self.bash_completion_path = (
            f"{self.HOME}/.local/share/bash-completion/completions"
        )
        self.man_path = f"{self.HOME}/.local/share/man/man1"

    def run(self):
        self._mkdir(f"{self.HOME}/.pip")
        self._mkdir(f"{self.HOME}/.local/bin")

        self.shell.run(f"ln -fs {self.proj_root}/pip.conf {self.HOME}/.pip/pip.conf")

        self.shell.exec(
            "Installing visidata",
            "pip3 install --upgrade visidata",
        )

        self.shell.exec(
            "Installing MinySubtitleConverter",
            self.github_dl_cmd(
                "snowphone/MinySubtitleConverter",
                "linux-amd64.tar.gz",
            ),
        )

        self.shell.exec_list(
            "Installing subtitle matcher",
            "rm -rf /tmp/subtitle_matcher",
            "git clone https://github.com/snowphone/Subtitle-Matcher.git /tmp/subtitle_matcher",
            "cd /tmp/subtitle_matcher && make install",
            "python3 -m pip install --upgrade tabulate",
            "rm -rf /tmp/subtitle_matcher",
        )

        self.shell.exec(
            "Installing pudb, a python debugger", "pip3 install --upgrade pudb"
        )
        self.shell.exec_list(
            "Installing yq, an yaml parser",
            "wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O ~/.local/bin/yq",
            "chmod +x ~/.local/bin/yq",
        )
        self.shell.exec_list(
            "Installing yt-dlp",
            "pip3 install --user --force-reinstall https://github.com/yt-dlp/yt-dlp/archive/master.tar.gz",
            f"ln -sf {self.HOME}/.local/bin/yt-dlp {self.HOME}/.local/bin/youtube-dl",
        )

        self.shell.exec(
            "Installing tools for python",
            "pip3 install --upgrade black isort poetry",
        )

        self.shell.exec(
            "Installing caterpillar, an hls downloader",
            "pip3 install --upgrade caterpillar-hls",
        )
        if self.args.latex:
            self.shell.sudo_exec("Refreshing fonts", "fc-cache -f -v")

        if self.args.rust:
            self.shell.exec(
                "Installing rust",
                "curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path",
            )

        self._mkdir(self.zsh_completion_path)
        self._mkdir(self.bash_completion_path)
        self._mkdir(self.man_path)

        self._install_fd()

        self._install_tty_clock()

        self.shell.exec(
            "Installing ripgrep-all",
            self.github_dl_cmd(
                "phiresky/ripgrep-all", "x86_64-unknown-linux-musl.tar.gz", 1
            ),
        )

        self.shell.exec(
            "Installing gotop", self.github_dl_cmd("xxxserxxx/gotop", "linux_amd64.tgz")
        )

        self.shell.exec_list(
            "Installing btop++",
            self.github_dl_cmd(
                "aristocratos/btop",
                "x86_64-linux-musl.tbz",
                binpath="/tmp",
                tar_extract_flags="xj",
            ),
            "cd /tmp/btop && make install PREFIX=$HOME/.local",
            "rm -rf /tmp/btop",
        )

        self._install_bat()

        self.shell.exec_list(
            "Installing glow",
            self.github_dl_cmd("charmbracelet/glow", "linux_x86_64.tar.gz"),
            f"mv {self.HOME}/.local/bin/completions/glow.zsh {self.zsh_completion_path}/_glow",
            f"mv {self.HOME}/.local/bin/completions/glow.bash {self.bash_completion_path}/glow",
            f"mv {self.HOME}/.local/bin/manpages/glow.1.gz {self.man_path}/glow.1.gz",
            f"rm -rf {self.HOME}/.local/bin/completions",
            f"rm -rf {self.HOME}/.local/bin/manpages",

        )

        self.shell.exec(
            "Installing the latest stable neovim from Github repo",
            self.github_dl_cmd(
                "neovim/neovim",
                "linux64.tar.gz",
                strip=1,
                binpath=f"{self.HOME}/.local",
            ),
        )

        if self.args.golang:
            ok, go_ver, _ = self.shell.exec(
                "Fetching latest golang version",
                "curl -Ls https://golang.org/VERSION?m=text",
            )
            if not ok:
                return
            self.shell.exec(
                "Installing golang",
                f"curl -s https://dl.google.com/go/{go_ver}.linux-amd64.tar.gz | tar xz -C {self.HOME}/.local/ --strip 1",
            )

        if self.args.java:
            self._install_java()

        self.shell.exec(
            "Removing auxiliary files",
            f"rm -rf {self.HOME}/.local/bin/autocomplete {self.HOME}/.local/bin/completion {self.HOME}/.local/bin/LICENSE* {self.HOME}/.local/bin/*.md {self.HOME}/.local/bin/doc",
        )

        if self.args.elixir:
            self.shell.exec(
                "Installing asdf plugin manager",
                "git clone https://github.com/asdf-vm/asdf ~/.asdf",
            )

            self._install_elixir()

        self._install_node()

        return

    def _install_node(self):
        self.shell.exec(
            "Installing nvm",
            "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | PROFILE=/dev/null bash",
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

    def _install_tty_clock(self):
        self.shell.exec_list(
            "Installing tty_clock",
            f"git clone https://github.com/xorg62/tty-clock.git /tmp/tty_clock",
            f"cd /tmp/tty_clock && make install PREFIX={self.HOME}/.local MANPATH={self.HOME}/.local/share/man/man1",
            f"cd",
            f"rm -rf /tmp/tty_clock",
        )
        return

    def _install_fd(self):
        self.shell.exec_list(
            "Installing fd",
            self.github_dl_cmd("sharkdp/fd", "x86_64-unknown-linux-musl.tar.gz", 1),
            f"mv {self.HOME}/.local/bin/autocomplete/_fd {self.zsh_completion_path}/_fd",
            f"mv {self.HOME}/.local/bin/autocomplete/fd.bash {self.bash_completion_path}/fd",
            f"mv {self.HOME}/.local/bin/fd.1 {self.man_path}/fd.1",
        )

    def _install_bat(self):
        self.shell.exec_list(
            "Installing bat",
            self.github_dl_cmd("sharkdp/bat", "x86_64-unknown-linux-musl.tar.gz", 1),
            f"mv {self.HOME}/.local/bin/autocomplete/bat.zsh {self.zsh_completion_path}/_bat",
            f"mv {self.HOME}/.local/bin/autocomplete/bat.bash {self.bash_completion_path}/bat",
            f"mv {self.HOME}/.local/bin/bat.1 {self.man_path}/bat.1",
        )

    def _install_java(self):
        sdk_path = f"{self.HOME}/.sdkman/bin/sdkman-init.sh"

        def exec_list(msg: str, *cmds: str):
            sourced_cmds = [f"source {sdk_path} && {cmd}" for cmd in cmds]
            self.shell.exec_list(msg, *sourced_cmds)

        self.shell.exec(
            "Downloading sdkman",
            'curl -s https:"//get.sdkman.io?rcupdate=false" | bash',
        )
        exec_list(
            "Installing java, gradle, maven, and kotlin",
            "sdk install java",
            "sdk install gradle",
            "sdk install maven",
            "sdk install kotlin",
        )
        return

    def _install_elixir(self):
        def exec_list(msg: str, *cmds: str):
            asdf_path = f"{self.HOME}/.asdf/asdf.sh"
            sourced_cmds = [f"source {asdf_path} && {cmd}" for cmd in cmds]
            self.shell.exec_list(msg, *sourced_cmds)

        exec_list(
            "Installing elixir",
            "asdf plugin add erlang",
            "asdf install erlang 24.3.4.2",
            "asdf global erlang  24.3.4.2",
            "asdf plugin add elixir",
            "asdf install elixir 1.13.4-otp-24",
            "asdf global elixir 1.13.4-otp-24",
        )
        return

    def github_dl_cmd(
        self,
        user_repo: str,
        suffix: str,
        strip: int = 0,
        binpath: str = "$HOME/.local/bin",
        tar_extract_flags: str = "xz",
    ):
        cmd = f"""curl -s https://api.github.com/repos/{user_repo}/releases/latest |
		grep browser_download_url | 
		grep -Pio 'https://.*?'{suffix}  |
        head -n 1 |
		xargs curl -L | 
		tar {tar_extract_flags} -C {binpath}"""
        if strip:
            cmd += f" --strip {strip}"

        return cmd


if __name__ == "__main__":
    argparser = ArgumentParser()
    argparser.add_argument("--latex", action="store_true")
    argparser.add_argument("--rust", action="store_true")
    argparser.add_argument("--golang", action="store_true")
    argparser.add_argument("--java", action="store_true")
    argparser.add_argument("--elixir", action="store_true")
    argparser.add_argument(
        "--typescript",
        "-t",
        action="store_true",
        help="install typescript",
        default=False,
    )

    LinuxAMD64(argparser.parse_args()).run()
