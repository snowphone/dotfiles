import re
from argparse import Namespace

from package_manager import PackageManager
from script import Script


class DebianPreparation(Script):
    def __init__(self, args: Namespace):
        super().__init__(args)

    def run(self):
        self.shell.env["DEBIAN_FRONTEND"] = "noninteractive"

        self.shell.sudo_exec(
            "Hide $HOME/snap folder",
            "snap set system experimental.hidden-snap-folder=true",
        )

        self.shell.sudo_exec(
            "Prioritizing IPv4 in apt",
            r"""sed -riE 's/#\s*(precedence ::ffff:0:0[/]96\s+100)/\1/' /etc/gai.conf""",
        )
        self._add_repositories()

    def _add_repositories(self):
        self.shell.sudo_exec_list(
            "Switching apt repositories to those of Kakao",
            r"sed -i 's/kr.archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list",
            r"sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list",
            r"sed -i 's/security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list",
        )

        self.shell.sudo_exec_list(
            "Updating apt repositores",
            "apt update",
            "apt-get install -y curl software-properties-common",
            "apt update",
        )

        self.shell.sudo_exec(
            "Adding vim repository", "add-apt-repository -y ppa:jonathonf/vim"
        )

        self.shell.sudo_exec(
            "Adding golang repository",
            "add-apt-repository -y ppa:longsleep/golang-backports",
        )

        self.shell.sudo_exec(
            "Adding neovim repository",
            "add-apt-repository -y ppa:neovim-ppa/stable",
        )

        if self.shell.env.get("DISPLAY", False):
            self.shell.sudo_exec_list(
                "Adding gnome-epub-thumbnailer repository",
                "add-apt-repository -y ppa:ubuntuhandbook1/apps",
            )
        return


class DebianPackageManager(PackageManager):
    @property
    def cmd(self) -> str:
        return f"{self.shell.sudo} apt-get install -qy "

    @property
    def pkgs(self):
        pkgs = """
			build-essential gdb less tar vim neovim git gcc curl rename wget tmux make gzip zip unzip figlet
			zsh python-is-python3
			exuberant-ctags cmake
			python3-dev python3 python3-pip python3-venv
			bfs tree htop ripgrep silversearcher-ag rsync jq
			bear sshpass w3m traceroute git-extras multitail
			neofetch mmv rar
			poppler-utils mediainfo
			parallel moreutils num-utils
			lbzip2 pigz pixz p7zip-full
            libssl-dev pkg-config
			ffmpeg shfmt
			translate-shell dict
			""".split()

        if self.args.latex:
            self.shell.exec(
                "Preparing for installing ms core fonts",
                f"echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | {self.shell.sudo} debconf-set-selections",
            )
            pkgs += ["texlive-full", "ttf-mscorefonts-installer"]
        if self.args.boost:
            pkgs.append("libboost-all-dev")
        if self.shell.env.get("DISPLAY", False):
            self.shell.exec(
                "Download kime deb file",
                "curl -Lo /tmp/kime.deb https://github.com/Riey/kime/releases/download/v3.0.2/kime_ubuntu-22.04_v3.0.2_amd64.deb",
            )
            pkgs += [
                "evince",
                "mupdf",
                "xdotool",
                "nautilus",
                "mpv",
                "firefox",
                "zathura",
                "language-pack-ko",
                "gpicview",
                "fonts-noto-cjk",
                "/tmp/kime.deb",
                "vivaldi-stable",
                "gnome-epub-thumbnailer",
                "ffmpegthumbnailer",
                "gstreamer1.0-libav",
                "totem",
            ]
        if self.args.misc:
            pkgs += ["figlet", "lolcat", "toilet", "img2pdf"]
        if self.args.elixir:
            pkgs += [
                "libssl-dev",
                "automake",
                "m4",
                "autoconf",
                "libncurses5-dev",
                "libwxgtk3.0-gtk3-dev",
                "libwxgtk-webview3.0-gtk3-dev",
                "libgl1-mesa-dev",
                "libglu1-mesa-dev",
                "libpng-dev",
                "libssh-dev",
                "unixodbc-dev",
                "xsltproc",
                "fop",
                "libxml2-utils",
                "libncurses-dev",
                "openjdk-11-jdk",
            ]
        if self.args.golang:
            pkgs += ["golang-go"]
        return pkgs

    def do_misc(self):
        self._install_clang()

    def _install_clang(self):
        latest = 20
        for ver in range(latest, 0, -1):
            install_list = [
                f"clang-{ver}",
                f"clang-tools-{ver}",
                f"clangd-{ver}",
                f"clang-format-{ver}",
            ]
            alias_list = [
                f"clang-{ver}",
                f"clangd-{ver}",
                f"clang-format-{ver}",
                f"clang++-{ver}",
            ]
            succeeded, _, _ = self.shell.sudo_exec(
                f"Installing {install_list}", f"{self.cmd} {' '.join(install_list)}"
            )
            if not succeeded:
                continue
            for pkg in alias_list:
                pattern = re.compile(r"-\d+")
                basename = pattern.sub("", pkg)
                priority = latest + 1 - ver
                self.shell.sudo_exec(
                    f"{pkg} being aliased to {basename}",
                    f"update-alternatives --install /usr/bin/{basename} {basename} /usr/bin/{pkg} {priority}",
                )
            return
