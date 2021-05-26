{ zsh }:''

separator_block_width=15

[disk-root]
instance=/
label=🖬
command=/run/current-system/sw/libexec/i3blocks/disk /
interval=30

[disk-home]
label=💾
instance=/home
command=/run/current-system/sw/libexec/i3blocks/disk $HOME
interval=30

[swap]
label=🖴
instance=swap
command=/run/current-system/sw/libexec/i3blocks/memory swap
interval=30
color=#cb416b


[wireless]
label=🌐
instance=wlo1
command=/run/current-system/sw/libexec/i3blocks/network
color=#00FF00
interval=10

[ethernet]
label=🖇
instance=eno1
command=/run/current-system/sw/libexec/i3blocks/network
color=#00FF00
interval=10

[cpu]
command=/usr/lib/i3blocks/cpu
command=/run/current-system/sw/libexec/i3blocks/cpu
interval=10

[time]
label=🕰
command=date '+%Y-%m-%d %H:%M:%S'
interval=5
color=#50C878
''
