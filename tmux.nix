{ zsh }:''
set -g prefix C-a
setw -g mouse on
set -g history-limit 30000
bind-key    -T copy-mode    C-w               send-keys -X copy-pipe-and-cancel "xclip -selection primary -in -f | xclip -selection clipboard -in"
bind-key    -T copy-mode    MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -selection primary -in -f | xclip -selection clipboard -in"
bind-key    -T copy-mode    M-w               send-keys -X copy-pipe-and-cancel "xclip -selection primary -in -f | xclip -selection clipboard -in"
bind-key    -T copy-mode-vi C-j               send-keys -X copy-pipe-and-cancel "xclip -selection primary -in -f | xclip -selection clipboard -in"
bind-key    -T copy-mode-vi Enter             send-keys -X copy-pipe-and-cancel "xclip -selection primary -in -f | xclip -selection clipboard -in"
bind-key    -T copy-mode-vi y                 send-keys -X copy-pipe-and-cancel "xclip -selection primary -in -f | xclip -selection clipboard -in"
''
