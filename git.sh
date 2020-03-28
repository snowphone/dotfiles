#!/bin/bash
# Git must be installed already
git config --global core.autocrlf input
git config --global core.eol lf

git config --global user.name "Junoh Moon"
git config --global user.email "mjo970625@gmail.com"

git config --global merge.tool vimdiff

git config --global diff.tool vimdiff 
git config --global difftool.prompt false
