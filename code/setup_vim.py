#!/usr/bin/env python3

import os
from argparse import ArgumentParser, Namespace

from script import Script


class Vim(Script):
    def __init__(self, args: Namespace):
        super().__init__(args)
        self.nvm_path = f"{self.HOME}/.nvm/nvm.sh"

    def run(self) -> None:
        for cmd in ["npm", "python3 -m pip", "vim"]:
            if not self._exists(cmd):
                raise RuntimeError(f"{cmd} is required")

        HOME = self.HOME
        proj_root = self.proj_root

        self.shell.exec(
            "Symbolic linking .vimrc", f'ln -fs "{proj_root}"/.vimrc {HOME}/.vimrc'
        )

        if not os.path.islink(f"{HOME}/.config"):
            self.shell.exec(
                f"Aliasing {HOME}/.config",
                f'ln -fs "{proj_root}"/config {HOME}/.config',
            )

        self._exec(
            "Installing vim plugins", "vim --not-a-term -c PlugInstall -c quitall"
        )

        self.shell.exec("Adding executable permission to HOME", f"chmod 755 {HOME}")

        self.shell.exec_list(
            "Symbolic linking other files",
            f'ln -sf "{proj_root}"/config/nvim/coc-settings.json {HOME}/.vim/',
            f'ln -sf "{proj_root}"/.coc.vimrc {HOME}/',
            f'ln -fs "{proj_root}"/.latexmkrc {HOME}/.latexmkrc',
        )

        self.shell.exec(
            "Installing yapf, black, rope, and coverage",
            "python3 -m pip install --user black yapf rope coverage",
        )

        if self._exists("nvim"):
            self._setup_for_nvim()

        if self.args.elixir:
            self.shell.exec_list(
                "Installing elixir-ls",

                "git clone https://github.com/elixir-lsp/elixir-ls.git ~/.elixir-ls",
                "cd ~/.elixir-ls && "
                ". $HOME/.asdf/asdf.sh && "
                "mix local.hex --force && "
                "mix local.rebar --force && "
                "mix deps.get && "
                "mix compile && "
                "mix elixir_ls.release -o release"
            )

        return

    def _setup_for_nvim(self):
        HOME = self.HOME
        proj_root = self.proj_root

        self.shell.exec(
            "Installing pyx, a python utility for neovim",
            "python3 -m pip install --user neovim",
        )
        self.shell.exec(
            "Installing plugins only for neovim",
            "nvim --headless -c PlugInstall -c quitall",
        )
        return

    def _exists(self, cmd: str) -> bool:
        return super()._exists(self._sourced_cmd(cmd))

    def _sourced_cmd(self, cmd: str):
        return f"source {self.nvm_path} && {cmd}"

    def _exec(self, message: str, cmd: str):
        if self._exists(self.nvm_path):
            return self.shell.exec(message, self._sourced_cmd(cmd))
        else:
            return self.shell.exec(message, cmd)


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("--elixir", action="store_true")
    Vim(parser.parse_args()).run()
