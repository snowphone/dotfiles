#!/bin/sh

case $1 in
'')
	echo "No input given"
	echo "Usage: $0 <file_path>"
	exit 1
	;;
-h | --help)
	echo "Usage: $0 <file_path>"
	exit 0
	;;
esac

input="${1}"
abspath="$(realpath "${1}")"
folder="$(dirname "${abspath}")"
basename="$(basename "${1}")"

input="/data/${basename}"
output="/data/${basename%.*}-encoded.mp4"

echo "${input} -> ${output}"

sudo docker run \
	-it \
	--rm \
	--volume "${folder}:/data" \
	--device /dev/dri:/dev/dri \
	linuxserver/ffmpeg \
	-hide_banner \
	-v quiet \
	-stats \
	-y \
	-hwaccel vaapi \
	-vaapi_device /dev/dri/renderD128 \
	-i "${input}" \
	-c:v h264_vaapi \
	-c:a copy \
	-vf 'format=nv12|vaapi,hwupload' \
	"${output}"
