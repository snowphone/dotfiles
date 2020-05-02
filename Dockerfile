FROM ubuntu:20.04
MAINTAINER Junoh Moon
ENV LANG=C.UTF-8

ENV HOME=/root/

ADD ./*  $HOME/.dotfiles/
RUN cd $HOME/.dotfiles && \
		./install.sh -d debian --all

WORKDIR $HOME
ENTRYPOINT $HOME
