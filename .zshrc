unsetopt BEEP	# disable bell
setopt correct
setopt globdots
setopt histignoredups
setopt pushd_to_home
setopt pushd_silent

VI_MODE_SET_CURSOR=false
ZSH_AUTOSUGGEST_USE_ASYNC=true



# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export FZF_BASE=$HOME/.vim/plugged/fzf

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

  zgen load lukechilds/zsh-nvm
  zgen load lukechilds/zsh-better-npm-completion
  zgen load Aloxaf/fzf-tab
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-history-substring-search
  zgen load zsh-users/zsh-autosuggestions
  zgen load unixorn/autoupdate-zgen
  zgen load zsh-users/zsh-completions
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

source $HOME/.common.shrc

# Disable commit-hash-sort when completing git checkout, diff, and so one.
zstyle ':completion:*:git-*:*' sort false

alias cd='pushd'
alias back='popd'



[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [ -f "$HOME/.cargo/env" ]; then
	source "$HOME/.cargo/env"
fi
