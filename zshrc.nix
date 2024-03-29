{ zsh }:''
bindkey -v
bindkey '^r' history-incremental-search-backward
setopt inc_append_history
setopt share_history
#set history size
export HISTSIZE=10000
##save history after logout
export SAVEHIST=10000
##append into history file
setopt INC_APPEND_HISTORY
##save only one command if 2 common are same and consistent
setopt HIST_IGNORE_DUPS
##add timestamp for each entry
setopt EXTENDED_HISTORY  
alias history="fc -l -50" 
if [ "$TMUX" = "" ]; then tmux; fi
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)" 
xrandr --output DP-2 --auto --output DP-1 --auto --right-of DP-2
PROMPT='$(kubeprompt -f default)'$PROMPT
command -v flux >/dev/null && . <(flux completion zsh) && compdef _flux flux

if [ -n "''${commands[fzf-share]}" ]; then
        source "''$(fzf-share)/key-bindings.zsh"
        source "''$(fzf-share)/completion.zsh"
fi

''
