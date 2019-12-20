{ zsh }:''
bindkey -v
bindkey '^r' history-incremental-search-backward
setopt inc_append_history
setopt share_history
if [ "$TMUX" = "" ]; then tmux; fi
xrandr --output HDMI1 --auto --output HDMI2 --auto --right-of HDMI1
''
