{ zsh }:''
set -g prefix C-a
setw -g mouse on
set -g history-limit 100000
set -g set-clipboard external
set -s escape-time 10
set -g focus-events on
set -g renumber-windows on
set -g default-terminal "tmux-256color"
set -as terminal-features ",xterm-ghostty:RGB"
set -as terminal-features ",xterm-ghostty:clipboard"
set -as terminal-features ",xterm-256color:RGB"
set -as terminal-features ",xterm-256color:clipboard"
set -g status-keys vi
set -g mode-keys vi
bind P paste-buffer
bind-key    -T copy-mode    C-w               send-keys -X copy-pipe-and-cancel "xclip -selection primary -in -f | xclip -selection clipboard -in"
bind-key    -T copy-mode    MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "tmux-save-buffer - | xclip -selection primary -in -f | xclip -selection clipboard -in"
bind-key    -T copy-mode    M-w               send-keys -X copy-pipe-and-cancel "xclip -selection primary -in -f | xclip -selection clipboard -in"
bind-key    -T copy-mode-vi Enter             send-keys -X copy-pipe-and-cancel "xclip -selection primary -in -f | xclip -selection clipboard -in"
bind-key    -T copy-mode-vi v                 send-keys -X begin-selection
bind-key    -T copy-mode-vi y                 send-keys -X copy-pipe-and-cancel "xclip -selection primary -in -f | xclip -selection clipboard -in"
''
