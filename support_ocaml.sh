#!/usr/bin/env bash

## Check for root privilege
if [[ $(whoami) == "root" ]]; then
	sudo=""
else
	sudo="sudo"
fi

$sudo apt install -y opam

opam init && opam install -y \
	ocaml-lsp-server \
	merlin \
	ocamlformat
