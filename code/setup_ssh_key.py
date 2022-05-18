#!/usr/bin/env python3
from argparse import ArgumentParser
from os import path

from script import Script


class SshKey(Script):
    def run(self) -> None:
        HOME = self.HOME

        ssh_dir = f"{HOME}/.ssh"
        if path.isdir(ssh_dir) and not path.islink(ssh_dir):
            self.shell.exec("Removing existing .ssh folder", f"rm -rf {ssh_dir}")

        # gpg encryption example:
        # gpg --symmetric --cipher-algo=AES256 $HOME/.ssh/id_ed25519
        self.shell.exec_list(
            "Decrypting id_ed25519",
            f'ln -sf "{self.proj_root}"/.ssh {HOME}/',
            f'''gpg --decrypt \
                    --yes \
                    --cipher-algo=AES256 \
                    --output={self.HOME}/.ssh/id_ed25519 \
                    {self.HOME}/.ssh/id_ed25519.gpg
            ''',
        )

        self.shell.exec_list(
            "Setting up ssh key",
            f'touch "{self.proj_root}"/.ssh/known_hosts',
            f'touch "{self.proj_root}"/.ssh/authorized_keys',
            f"cat {HOME}/.ssh/id_ed25519.pub >> {HOME}/.ssh/authorized_keys",  # Simplify ssh-copy-id procedure
            f"chmod 600 {HOME}/.ssh/config",
            f"chmod 600 {HOME}/.ssh/id_ed25519",
            f"chmod 600 {HOME}/.ssh/authorized_keys",
            f"chmod 700 {HOME}/.ssh",
            f"chmod 700 {self.proj_root}",
        )

        auth_path = f"{HOME}/.Xauthority"
        if self.shell.env.get("DISPLAY", False) and not path.exists(auth_path):
            self.shell.exec_list(
                "Suppressing no xauth data warning while using ssh -X",
                f"touch {auth_path}",
                f"xauth add :0 . `mcookie`",
            )

        return


if __name__ == "__main__":
    SshKey(ArgumentParser().parse_args()).run()
