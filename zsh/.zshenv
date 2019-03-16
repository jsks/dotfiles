#-- ZSH --#
ZDOTDIR=~/.config/zsh
export KEYTIMEOUT=1

#-- fzf --#
export FZF_DEFAULT_OPTS="--bind=tab:accept"
export FZF_DEFAULT_COMMAND="ag -g '' --nocolor --hidden"

#-- Colored man pages --#
export LESS_TERMCAP_mb=$'\E[00;31m'
export LESS_TERMCAP_md=$'\E[00;34m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[00;36m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[00;31m'

# Necessary to make colored man pages work
export GROFF_NO_SGR=1

#-- Misc. exports --#
export EDITOR="vim"
export LESS="-r"
export BROWSER="chromium"
export NOCOLOR_PIPE=1
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export MAILDIR="~/mail"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

[[ $OSTYPE == linux* ]] && eval $(dircolors ~/.dircolors)
