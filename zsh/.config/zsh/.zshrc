#-- Tramp settings --#
if [[ $TERM == "dumb" ]]; then
    unsetopt zle
    PS1="> "
    return
fi

#-- Set path --#
# Keep this in .zshrc, otherwise overwritten by system zshrc
export GOPATH=~/go
export PATH="$HOME/bin:$PATH:$HOME/go/bin:$HOME/.npm/bin:$HOME/.cargo/bin:$HOME/.local/bin"

fpath=(/usr/local/share/zsh-completions $fpath)

#-- History --#
HISTFILE=$ZDOTDIR/histfile
HISTSIZE=20000
SAVEHIST=20000

#-- Some options --#
# Changing directories
setopt autocd autopushd pushdignoredups

# Expansion and globbing
setopt extendedglob globdots nomatch

# History
setopt appendhistory histfcntllock histignorealldups histnofunctions histreduceblanks sharehistory

# Input/Output
setopt correct correct_all interactivecomments

# Job control
setopt longlistjobs nohup notify

# Prompting
setopt prompt_subst

bindkey -v

#-- zstyle comletions --#
zstyle ':completion:*' completer _complete _ignored _match _correct _approximate
zstyle ':completion:*' original false
zstyle ':completion:*:match:*' original only

zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.config/zsh/cache

# Don't complete entry on line multiple times for the following
# commands
zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes

# dircolors/LS_COLORS linux-only
[[ $OSTYPE == linux* ]] && zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle :compinstall filename "$ZDOTDIR/.zshrc"
autoload -Uz compinit
compinit

#-- Autoloads --#
autoload -U colors && colors
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr  "*"
zstyle ':vcs_info:git:*' stagedstr  "+"
zstyle ':vcs_info:*' formats "%b%u%c "
zstyle ':vcs_info:*' actionformats "%b|%a%u%c "

zmodload -i zsh/complist

#-- General Keybindings --#
# This is the best thing since sliced bread
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

bindkey -a k history-beginning-search-backward
bindkey -a j history-beginning-search-forward

#-- Source additional zfiles --#
. $ZDOTDIR/functions
. $ZDOTDIR/aliases
. $ZDOTDIR/aliases_$HOST 2>/dev/null
. $ZDOTDIR/scripts/zsh-plugins/zbk/zbk.zsh
. /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

check fzf && {
    # ctrl-r is so awkward
    . /usr/share/fzf/completion.zsh
    . /usr/share/fzf/key-bindings.zsh
    bindkey "^[[Z" fzf-history-widget
}

#-- Prompt --#
if [[ -z "$SSH_CLIENT" ]]; then
    SSH_PROMPT=""
else
    SSH_PROMPT="[%{$fg[red]%}SSH%{$reset_color%}]"
fi

precmd() {
    vcs_info
}

PROMPT='%{$fg[blue]%}%n %{$reset_color%}» %{$fg[white]%}%m%{$reset_color%}$SSH_PROMPT » %{$fg[red]%}%~
%{$fg[cyan]%}${vcs_info_msg_0_}% %{$fg[magenta]%}λ '
RPROMPT="%{$(echotc UP 1)%}%{$fg[blue]%}%T%{$reset_color%}%{$(echotc DO 1)%}"
