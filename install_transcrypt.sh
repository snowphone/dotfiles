
# Currenty autocompletion is not stable
#autocomp="${HOME}/.local/share/zsh/vendor-completions"
#mkdir -p  "${autocomp}"
#curl -sfL -o "${autocomp}/_transcrypt" https://raw.githubusercontent.com/elasticdog/transcrypt/refs/heads/main/contrib/zsh/_transcrypt

manpath="${HOME}/.local/man/man1"
mkdir -p "${manpath}"
curl -sfL -o "${manpath}/transcrypt.1" https://raw.githubusercontent.com/elasticdog/transcrypt/refs/heads/main/man/transcrypt.1

binpath="$HOME/.local/bin"
mkdir -p "$binpath"
curl -sfL -o "$binpath/transcrypt" https://raw.githubusercontent.com/elasticdog/transcrypt/refs/heads/main/transcrypt
chmod +x "$binpath/transcrypt"
