#!/bin/sh

# https://github.com/Moonbase59/loudgain?tab=readme-ov-file#building

set -e

if [ "${EUID:-$(id -u)}" -ne 0 ]; then
	sudo="sudo "
else
	sudo=""
fi


$sudo apt-get install -y build-essential cmake pkg-config git \
	libavcodec-dev libavformat-dev libavutil-dev libswresample-dev libebur128-dev libtag1-dev


git clone --depth 1 https://github.com/Moonbase59/loudgain.git
cd loudgain
mkdir build && cd build
cmake ..
make
$sudo make install
