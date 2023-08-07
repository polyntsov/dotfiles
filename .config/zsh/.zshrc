# Colors
autoload -U colors && colors

# History settings
HISTFILE=~/.cache/zsh/.histfile
HISTSIZE=20000
SAVEHIST=10000

# Bindings
bindkey -e
zstyle :compinstall filename '$HOME/.config/zsh/.zshrc'
bindkey '\e' vi-cmd-mode
export KEYTIMEOUT=1

# Aliases
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l'
alias grep='grep --color=auto'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Autocompletion
autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# partial completion suggestions
zstyle ':completion:*' list-suffixes zstyle ':completion:*' expand prefix suffix
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[6 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    #zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[6 q"
}
zle -N zle-line-init
echo -ne '\e[6 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[6 q' ;} # Use beam shape cursor for each new prompt.

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Autocorrection
setopt CORRECT
setopt CORRECT_ALL

# FZF
. /usr/share/fzf/key-bindings.zsh
. /usr/share/fzf/completion.zsh
export IGNORE_DIRS='--ignore-dir .local --ignore-dir .git --ignore-dir .mozilla --ignore-dir\
    .thunderbird --ignore-dir .dotfiles --ignore-dir .cache'
export FZF_CTRL_T_COMMAND="ag --hidden $IGNORE_DIRS -g \"\""
export FZF_ALT_C_COMMAND="ag --hidden $IGNORE_DIRS -g \"\""

# Prompt
eval "$(starship init zsh)"
