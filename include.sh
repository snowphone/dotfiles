
# Print error message and abort
die() {
	printf "ERROR: %s\n\n" "$@"
	exit 1
}

# It measures time some commands took.
# It returns 0 if it worked well, -1 else.
# Also, print a message(done/failed)
measure() {
	SECONDS=0
	if eval $@ &> /dev/null; then
		echo "😄 ($SECONDS seconds)"
		return 0
	else
		echo "😰"
		return -1
	fi
}

# Create a border around a string
border () {
    local str="$*"      # Put all arguments into single string
    local len=${#str}
    local i
    for (( i = 0; i < len + 4; ++i )); do
        printf '#'
    done
    printf "\n# $str #\n"
    for (( i = 0; i < len + 4; ++i )); do
        printf '#'
    done
    echo
}

