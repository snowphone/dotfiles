FROM ubuntu:20.04
MAINTAINER Junoh Moon
ENV LANG=C.UTF-8

RUN git clone 'https://snowphone:!r2xjagjgh@github.com/snowphone/dotfiles' ~/.dotfiles && \
		cd ~/.dotfiles && \
		./install.sh -d debian --all

WORKDIR /root
