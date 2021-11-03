#-- ZSH --#
ZDOTDIR=~/.config/zsh
export KEYTIMEOUT=1

#-- fzf --#
export FZF_DEFAULT_OPTS="--bind=tab:accept"
export FZF_DEFAULT_COMMAND="ag -g '' --nocolor --hidden"

#-- Colored man pages --#
export LESS_TERMCAP_mb=$'\E[00;31m'
export LESS_TERMCAP_md=$'\E[01;34m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[00;31m'

# Necessary to make colored man pages work
export GROFF_NO_SGR=1

#-- Misc. exports --#
export EDITOR="vim"
export LESS="-Frs --mouse"
export BROWSER="chromium"
export NOCOLOR_PIPE=1
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export MAILDIR="~/mail"
export MOZ_ENABLE_WAYLAND=1

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
