{ zsh }:''
bindkey -v
bindkey '^r' history-incremental-search-backward

# History: more durable, less noisy, and shared safely across sessions.
export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE="''${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "''${HISTFILE:h}"
setopt append_history
setopt inc_append_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_reduce_blanks
setopt hist_verify
setopt hist_fcntl_lock
setopt extended_history
setopt hist_ignore_space
setopt auto_cd
setopt correct

alias history="fc -l -50"

# Clipboard helpers (xclip/xsel).
clipcopy() {
        if command -v xclip >/dev/null; then
                xclip -selection clipboard -in
        elif command -v xsel >/dev/null; then
                xsel --clipboard --input
        else
                print -u2 "clipcopy: install xclip or xsel"
                return 1
        fi
}
clippaste() {
        if command -v xclip >/dev/null; then
                xclip -selection clipboard -out
        elif command -v xsel >/dev/null; then
                xsel --clipboard --output
        else
                print -u2 "clippaste: install xclip or xsel"
                return 1
        fi
}
alias pbcopy=clipcopy
alias pbpaste=clippaste
if [[ -o interactive && -z "$TMUX" ]]; then tmux; fi
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)" 
command -v flux >/dev/null && . <(flux completion zsh) && compdef _flux flux

if [ -n "''${commands[fzf-share]}" ]; then
        source "''$(fzf-share)/key-bindings.zsh"
        source "''$(fzf-share)/completion.zsh"
fi

''
