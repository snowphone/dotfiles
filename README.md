# dotfiles

## Installation
On Ubuntu,
~~~bash
if [[ $(whoami) == "root" ]]; then
  sudo=""
else
  sudo="sudo"
fi

$sudo apt update && \
$sudo apt install -y git wget && \
git clone https://github.com/snowphone/dotfiles ~/.dotfiles && \
cd ~/.dotfiles && ./install.sh
~~~

On CentOS
~~~bash
if [[ $(whoami) == "root" ]]; then
  sudo=""
else
  sudo="sudo"
fi

$sudo yum install -y git wget && \
git clone https://github.com/snowphone/dotfiles ~/.dotfiles && \
cd ~/.dotfiles && ./install.sh
~~~
