#!/usr/bin/env bash

# EDITOR로 부터 입력을 받아서 변수 ($1)에 저장하는 함수
edit_and_capture() {
	local __fallback_editor="vi"
	local temp_file
	temp_file="$(mktemp)"

	# Make sure the temporary file is deleted on exit
	trap 'rm -f "$temp_file"' EXIT

	# Open the editor for the user to edit the temporary file
	${EDITOR:-${__fallback_editor}} "$temp_file"

	# Read the content of the temporary file into the provided shell variable
	local __resultvar="$1"

	if [[ -f "$temp_file" ]]; then
		# Read the file content into the variable
		local result
		result="$(<"$temp_file")"
		# Assign to the variable name passed as argument
		declare -g "$__resultvar=$result"
	else
		echo "Temporary file was not created."
		return 1
	fi

	# Cleanup the temporary file
	rm -f "$temp_file"
	# Disable the trap for cleanup since manual cleanup is done
	trap - EXIT
	return 0
}

# Usage:
# edit_and_capture my_variable
# echo $my_variable
