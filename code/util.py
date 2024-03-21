from sys import stderr

from shell import Shell


def is_m1():
    "Check whether the machine is Apple Silicon Mac"
    return Shell().run("uname -m")[1] == "arm64"


class GithubDownloadable:
    def github_dl_cmd(
        self,
        user_repo: str,
        suffix: str,
        strip: int = 0,
        binpath: str = "$HOME/.local/bin",
        tar_extract_flags: str = "xz",
    ):
        cmd = f"""curl -L {self.get_download_link(user_repo, suffix)} | 
		tar {tar_extract_flags} -C {binpath}"""
        if strip:
            cmd += f" --strip {strip}"

        return cmd

    def github_dl_single_cmd(self, user_repo: str, suffix: str, fullpath: str):
        """
        It is almost same to `github_dl_cmd`,
        but it downloads a single executable file and makes it executable."
        """
        return f"curl -L {self.get_download_link(user_repo, suffix)} -o {fullpath} && chmod +x {fullpath}"

    def get_download_link(self, user_repo: str, suffix: str):
        cmd = f"""curl -s https://api.github.com/repos/{user_repo}/releases/latest |
            grep browser_download_url | 
            grep -ioe 'https://.*{suffix}'  |
            
            head -n 1 
            """
        shell = Shell()
        ok, out, err = shell.run(cmd)
        if not ok:
            print(f"Failed to get download link: {err}", file=stderr)
            return None

        return out
