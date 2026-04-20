{ zsh }:''
# Enable both ordinary URL matching and explicit OSC 8 hyperlink previews
# so link behavior is easier to verify while testing.
link-url = true
link-previews = true

# Keep Ghostty on the window manager's simple chrome instead of the GTK
# titlebar/menu UI.
gtk-titlebar = false

# Keep Ghostty's terminal identity explicit.
term = xterm-ghostty

shell-integration = detect

command = ${zsh}/bin/zsh
''
