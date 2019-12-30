{ zsh }:''
bindkey -v
bindkey '^r' history-incremental-search-backward
setopt inc_append_history
setopt share_history
if [ "$TMUX" = "" ]; then tmux; fi
xrandr --output HDMI-2 --auto --output DP-1 --auto --right-of HDMI-2
''
