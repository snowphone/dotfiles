#!/usr/bin/env python3

from argparse import ArgumentParser, Namespace
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
            "Installing pudb, a python debugger", "pip3 install --user pudb"
        )
        self.shell.exec_list(
            "Installing yt-dlp",
            "pip3 install --user yt-dlp",
            f"ln -sf {self.HOME}/.local/bin/yt-dlp {self.HOME}/.local/bin/youtube-dl",
        )

        self.shell.exec(
            "Installing caterpillar, an hls downloader",
            "pip3 install --user caterpillar-hls",
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

        self._install_bat()

        self.shell.exec(
            "Installing glow",
            self.github_dl_cmd("charmbracelet/glow", "linux_x86_64.tar.gz"),
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

        self.shell.exec(
            "Installing asdf plugin manager",
            "git clone https://github.com/asdf-vm/asdf ~/.asdf",
        )

        return

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
            "asdf install erlang 23.3.4.15",
            "asdf global erlang 23.3.4.15",

            "asdf plugin add elixir",
            "asdf install elixir 1.13",
            "asdf global elixir 1.13",

            """curl -s https://api.github.com/repos/elixir-lsp/elixir-ls/releases/latest |
		grep browser_download_url | 
		grep -Po 'https://.*?'elixir-ls.zip  |
		xargs curl -L -o /tmp/elixir-ls.zip
        """,
            "unzip /tmp/elixir-ls.zip -d ~/.vim/plugged/coc-elixir/els-release",
                )
        return

    def github_dl_cmd(self, user_repo: str, suffix: str, strip: int = 0, binpath: str = "$HOME/.local/bin"):
        cmd = f"""curl -s https://api.github.com/repos/{user_repo}/releases/latest |
		grep browser_download_url | 
		grep -Po 'https://.*?'{suffix}  |
		xargs curl -L | 
		tar xz -C {binpath}"""
        if strip:
            cmd += f" --strip {strip}"

        return cmd


if __name__ == "__main__":
    argparser = ArgumentParser()
    argparser.add_argument("--latex", action="store_true")
    argparser.add_argument("--rust", action="store_true")
    argparser.add_argument("--golang", action="store_true")
    argparser.add_argument("--java", action="store_true")

    LinuxAMD64(argparser.parse_args()).run()
