{ zsh }:''
# Show previews only for explicit OSC 8 hyperlinks so hyperlink-capable apps
# are visible without adding hover UI to every plain URL match.
link-previews = osc8

# Keep Ghostty on the window manager's simple chrome instead of the GTK
# titlebar/menu UI.
gtk-titlebar = false

# Keep Ghostty's terminal identity explicit.
term = xterm-ghostty

shell-integration = detect

command = ${zsh}/bin/zsh
''
