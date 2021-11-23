#!/usr/bin/env python3
from argparse import ArgumentParser, Namespace
from sys import exit

from installer import make


def main(args: Namespace):
	installer = make(args)
	installer.install()
	return


def parse_args():
	parser = ArgumentParser()

	def add_flag(long: str, short: str, helpstr: str):
		parser.add_argument(long,
							short,
							help=helpstr,
							action="store_true",
							default=False)
		return

	parser.add_argument("--dist",
						"-d",
						help="select distribution",
						choices=["debian", "redhat", "darwin"],
						required=True)

	add_flag("--latex", "-l", "install texlive-full")
	add_flag("--boost", "-b", "install libboost-all-dev")
	add_flag("--java", "-j", "install maven, gradle, and openjdk")
	add_flag("--rust", "-r", "install rust")
	add_flag("--golang", "-g", "install golang")
	add_flag("--misc", "-m", "install some miscellaneous stuffs")
	add_flag("--all", "-a", "enable all flags above")

	return parser.parse_args()


if __name__ == "__main__":
	args = parse_args()

	exit(main(args))
