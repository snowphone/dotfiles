from getpass import getuser
import os
import subprocess
from time import time
from typing import Callable, Dict, Tuple


class Shell:
	def __init__(self):
		self.sudo = "" if getuser() == "root" else "sudo "
		self.env = os.environ.copy()

	def run(self, command: str):
		return self._execute(command, env=self.env)

	def _execute(self, command: str, env: Dict[str, str]):
		proc = subprocess.run([command],
							  shell=True,
							  env=env,
							  capture_output=True)
		return proc.returncode == 0, proc.stdout.decode('utf-8').rstrip(), proc.stderr.decode('utf-8').rstrip()

	def exec(self, message: str, command: str):
		print(f"{message}... ", end='', flush=True)
		start = time()
		succeeded, out, err = self.run(command)
		if succeeded:
			result = 'done ✔'
		else:
			result = 'failed ❌'

		elapsed_time = (time() - start)
		print(f"{result} ({elapsed_time:.2f} sec)")
		return succeeded, out, err

	def sudo_exec(self, message: str, command: str):
		return self.exec(message, self.sudo + command)

	def exec_list(self, message: str, *commands: str):
		return self._run_batch(self.exec, message, *commands)

	def sudo_exec_list(self, message: str, *commands: str):
		return self._run_batch(self.sudo_exec, message, *commands)

	def _run_batch(self, func: Callable[[str, str], Tuple[bool, str, str]],
				   message: str, *commands: str):
		results = True
		sz = len(commands)
		for i, cmd in enumerate(commands, 1):
			ret, _, _ = func(f"{message} ({i}/{sz})", cmd)
			results = results and ret

		return results
