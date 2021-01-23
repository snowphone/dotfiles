FROM ubuntu:20.04
MAINTAINER Junoh Moon
SHELL ["/bin/bash", "-c"]
ENV LANG=C.UTF-8
ENV HOME=/root

ADD .  $HOME/.dotfiles
WORKDIR $HOME/.dotfiles
RUN ./install.sh --dist debian --latex --java

RUN echo "export TERM=xterm-256color" >> $HOME/.bashrc

WORKDIR $HOME
RUN zsh $HOME/.zshrc
RUN zsh $HOME/.zgen/init.zsh 
ENTRYPOINT ["/usr/bin/zsh"]

