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

# Vim keybindings
bindkey -v

#-- zstyle comletions --#
zstyle ':completion:*' completer _extensions _complete  _approximate
zstyle ':completion:*' use-cache on

zstyle ':completion:*:descriptions' format '-- %d --'
zstyle ':completion:*:-tilde-:*' group-order named-directories path-directories users
zstyle ':completion:*' group-name ''
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -al --group-directories-first $realpath'


# Don't complete entry on line multiple times for the following
# commands
zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes

zstyle ':completion:*:default' list-colors ''

zstyle :compinstall filename "$ZDOTDIR/.zshrc"
autoload -Uz compinit
compinit

# Use fzf for tab menu completion
. $ZDOTDIR/scripts/fzf-tab/fzf-tab.plugin.zsh

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
. $ZDOTDIR/completions
. $ZDOTDIR/aliases
. $ZDOTDIR/aliases_$HOST 2>/dev/null
. $ZDOTDIR/scripts/zsh-plugins/zbk/zbk.zsh

check fzf && {
    . /usr/share/fzf/completion.zsh
    . /usr/share/fzf/key-bindings.zsh

    # ctrl-r is so awkward
    bindkey "^[[Z" fzf-history-widget
}

. /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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
