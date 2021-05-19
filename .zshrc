
unsetopt BEEP	# disable bell
setopt correct
setopt globdots
setopt histignoredups
setopt pushd_to_home
setopt pushd_silent

VI_MODE_SET_CURSOR=false
ZSH_AUTOSUGGEST_USE_ASYNC=true

export EDITOR=vim
export MANPAGER="sh -c 'col -bx | bat -l man -p'"


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export FZF_BASE=$HOME/.vim/plugged/fzf

if [[ ! $fpath =~ "$HOME/.local/share/completions" ]]; then
	fpath=($HOME/.local/share/completions $fpath)
fi


[ ! -d "${HOME}/.zgen" ] && git clone --depth 1 https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
source "${HOME}/.zgen/zgen.zsh" > /dev/null

# if the init script doesn't exist
if ! zgen saved; then

  # specify plugins here
  # If zsh-syntax-highlighting is bundled after zsh-history-substring-search,
  # they break, so get the order right.

  zgen oh-my-zsh

  zgen oh-my-zsh plugins/command-not-found
  zgen oh-my-zsh plugins/vi-mode
  zgen oh-my-zsh plugins/gradle
  zgen oh-my-zsh plugins/pip
  zgen oh-my-zsh plugins/docker

  zgen load Aloxaf/fzf-tab
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-history-substring-search
  zgen load zsh-users/zsh-autosuggestions
  zgen load unixorn/autoupdate-zgen
  zgen load zsh-users/zsh-completions src
  zgen load RobSis/zsh-completion-generator		# compgen <program> to parse, and compinit then to apply
  zgen load romkatv/powerlevel10k powerlevel10k
  zgen load IngoMeyer441/zsh-easy-motion


  # generate the init script from plugins above
  zgen save
fi

bindkey '^ ' autosuggest-accept
bindkey -M vicmd ' ' vi-easy-motion


########################
#  My Configuration    #
########################

# set PATH so it includes user's private bin if it exists
if [[ -d "$HOME/.local/bin" && ! $PATH =~ "$HOME/.local/bin" ]] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Alias's to modified commands
if rsync --version &> /dev/null; then
	alias cp='rsync -ah --info=progress2'
fi

alias ll='ls -aFlsh' # long listing format

alias cd='pushd'
alias back='popd'

alias scp='scp -r'
alias mv='mv -i'
alias rm='rm -iv'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias lessn='less -R -N'
alias cls='clear'
alias vi='vim'
alias svi='sudo vi'
alias vis='vim "+set si"'
alias tmux='tmux -2' 	#force 256 colors

alias c='clear'

alias gpull='git pull --rebase origin'
alias gpush='git push origin'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gf='git fetch'
alias gb='git branch'
alias gck='git checkout'
alias glog='git log --all --decorate --oneline --graph'
alias gd='git difftool'
alias grm='git add -u'

alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"
alias ds="du -sh * ./ | sort -rh " #diskspace
alias mountedinfo='df -hT'
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

#alias htop="htop -u $(whoami)"
alias htop="htop -s PERCENT_CPU"
palette() {
	for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}



if fdfind --version &> /dev/null; then
	alias fd=fdfind
elif fd --version &> /dev/null; then
	alias fd=fd
else
	alias fd=find
fi

alias sumatrapdf='/mnt/c/Users/mjo97/AppData/Local/SumatraPDF/SumatraPDF.exe'
alias tmux-dev='~/.dotfiles/tmux-dev.sh'
alias qq='tmux kill-window'



export FZF_DEFAULT_OPTS='-m'
if bfs --version &> /dev/null; then
	# Use bfs only if distribution is ubuntu
	export FZF_DEFAULT_COMMAND='bfs -L'
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Use fd-based completion for the better performance
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# Search all file types including pdf, ppt, and open grepped files
grepOpen() {
	RG_PREFIX="rga --files-with-matches"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
	xdg-open "$file"
}

# Search filenames and open them
findOpen() {
	local file
	file="$(fzf)" &&
	echo "opening $file" &&
	xdg-open "$file"
}


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [ -f "$HOME/.cargo/env" ]; then
	source "$HOME/.cargo/env"
fi
eval "$(dircolors ~/.dircolors)"
