
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
		echo "done 😄 ($SECONDS seconds)"
		return 0
	else
		echo "failed 😰"
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

exists() {
	if $@ --version &> /dev/null; then
		return 0
	else
		return -1
	fi
}

get_latest_from_github() {
	# $1: user/repo
	# name_tag_suffix
curl -s https://api.github.com/repos/$1/releases/latest |
	grep browser_download_url | 
	grep -Po 'https://.*?'$2  |
	xargs curl -L
}

