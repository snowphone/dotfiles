FROM ubuntu:20.04
MAINTAINER Junoh Moon
ENV LANG=C.UTF-8

RUN apt update && apt install -y git

RUN git clone 'https://snowphone:***REMOVED***@github.com/snowphone/dotfiles' ~/.dotfiles && \
		cd ~/.dotfiles && \
		./install.sh -d debian --all

WORKDIR /root
