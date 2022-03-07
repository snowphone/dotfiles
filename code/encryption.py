#!/usr/bin/env python3
from argparse import ArgumentParser, Namespace
import base64
from os import environ, path
try:
	import cryptography
except ModuleNotFoundError:
	import subprocess
	from script import Script
	subprocess.run(["python3", "-m", "pip", "install", "-r", f"{Script.proj_root}/requirements.txt"])

from cryptography.fernet import Fernet
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives import hashes


class Encryption:
	'''
	Brought from https://cryptography.io/en/latest/fernet/#using-passwords-with-fernet
	'''
	plain_path = path.expandvars("$HOME/.ssh/id_ed25519")
	cipher_path = f"{plain_path}.dat"

	def __init__(self, pw: str):
		kdf = PBKDF2HMAC(
			algorithm=hashes.SHA256(),
			length=32,
			salt=b'salt',
			iterations=390_000,
		)
		key = base64.urlsafe_b64encode(kdf.derive(pw.encode()))

		self.f = Fernet(key)

	def encrypt(self):
		with open(self.plain_path, "rb") as fp:
			plain = fp.read()
		cipher =  self.f.encrypt(plain)
		with open(self.cipher_path, "wb") as fp:
			fp.write(cipher)
	
	def decrypt(self):
		with open(self.cipher_path, "rb") as fp:
			plain = self.f.decrypt(fp.read())
		with open(self.plain_path, "wb") as fp:
			fp.write(plain)

def read_password():
	environ_key = "SSH_PW"
	if environ_key not in environ:
		pw = input("Environment variable 'SSH_PW' is not set.\nPlease enter a password: ")
	else:
		pw = environ[environ_key]
	return pw


def main(args: Namespace):
	c = Encryption(read_password())

	if args.encrypt:
		c.encrypt()
	elif args.decrypt:
		c.decrypt()
	else:
		raise RuntimeError("Undefined behaviour")


if __name__ == "__main__":
	parser = ArgumentParser()

	xor_group = parser.add_mutually_exclusive_group(required=True)
	xor_group.add_argument("--encrypt", action='store_true')
	xor_group.add_argument("--decrypt", action='store_true')

	main(parser.parse_args())
