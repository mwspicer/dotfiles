# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' file-sort name
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' menu select=5
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl true
zstyle :compinstall filename '/home/matt/.zshrc'

# Default prompt
PS1='[\u@\h \W]\$ '

autoload -Uz compinit
compinit

# autoload -Uz promptinit
# promptinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt appendhistory nomatch notify
unsetopt autocd beep extendedglob
# sets up vi keybindings
bindkey -v
# set up backward search for Ctrl+r
bindkey '^R' history-incremental-pattern-search-backward
# End of lines configured by zsh-newuser-install

[[ -e ~/.git_prompt.sh ]] && emulate sh -c ' source ~/.git_prompt.sh'
[[ -e ~/.aliases ]] && emulate sh -c ' source ~/.aliases'
[[ -e ~/.shenv ]] && emulate sh -c ' source ~/.shenv'
precmd() { eval "$PROMPT_COMMAND" }

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo er>'

if [[ `ps -o 'cmd=' -p $(ps -o 'ppid=' -p $$)` == 'termite' ]]; then
    source /etc/profile.d/vte.sh 
fi

[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh
