# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, channels, ... }:

let

  allowAlanConfContent = pkgs.writeText "90-allow-alan.conf" ''
    <!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-Bus Bus Configuration 1.0//EN"
      "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
    <busconfig>
      <policy user="alan">


    <allow send_destination="org.freedesktop.login1"
               send_interface="org.freedesktop.login1.Manager"
               send_member="PrepareForSleep"
               send_type="signal"/>

 <allow receive_sender="org.freedesktop.login1"
             receive_interface="org.freedesktop.login1.Manager"
             receive_member="PrepareForSleep"/>
      </policy>
    </busconfig>
  '';

  allowAlanDbusPackage = pkgs.linkFarm "alan-dbus-policy" [
    {
      # This path needs to match what services.dbus.packages looks for:
      # <pkg>/etc/dbus-1/system.d/<filename>
      name = "etc/dbus-1/system.d/90-allow-alan.conf";
      # This points to the actual file content created by writeText
      path = allowAlanConfContent;
    }
  ];

  pureZshPrompt = pkgs.fetchgit {
    url = "https://github.com/sindresorhus/pure";
    rev = "e7036c43487fedf608a988dde54dd1d4c0d96823";
    sha256 = "10mdk4dn2azzrhymx0ghl8v668ydy6mz5i797nmbl2ijx9hlqb3v";
  };

  vscodeWithExtensions = import ./vscode.nix {
    pkgs = pkgs.unstable;
  };

  pythonWithPackages = import ./python.nix {
    pkgs = pkgs.unstable;
  };

  #geminiOverlay = import ./overlays/gemini-cli.nix;

  callPk = pkgs.callPackage;

in {

  nixpkgs.config = {
    allowUnfree = true;
  };

  # nixpkgs.overlays = [ geminiOverlay ];

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings."download-buffer-size" = 268435456; # 256 MiB
  };

  disabledModules = [ "services/networking/tailscale.nix" ];


  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./webhook.nix
      "${channels.nixpkgs-unstable}/nixos/modules/services/networking/tailscale.nix"
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];

  boot.kernelParams = [ "nohibernate" ];
  boot.kernelModules = [ "vivid" ];
  boot.loader.grub.copyKernels = true;

  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireless.interfaces = [ "wlp0s20f3" ];
  networking.resolvconf.dnsExtensionMechanism = false;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;
  networking.hostId = "089f9679";
  networking.defaultGateway = "192.168.1.1";

  networking.extraHosts =
    ''
      127.0.0.99 docker.internal.speik.net
      127.0.0.99 nexus.internal.speik.net
    '';
  #networking.nameservers = ["127.0.0.1"];
  #networking.dhcpcd.extraConfig = "nohook resolv.conf";

  system.userActivationScripts = {
    extraUserActivation = {
      text = ''
        ln -sfn /etc/per-user/alacritty ~/.config/
        ln -sfn /etc/per-user/i3 ~/.config/
        ln -sfn /etc/per-user/i3blocks/i3blocks.conf ~/.i3blocks.conf
        ln -sfn /etc/per-user/zsh/zshrc ~/.zshrc
        ln -sfn /etc/per-user/tmux/tmux.conf ~/.tmux.conf
        mkdir -p ~/.zfunctions
        ln -sfn ${pureZshPrompt}/pure.zsh ~/.zfunctions/prompt_pure_setup
        ln -sfn ${pureZshPrompt}/async.zsh ~/.zfunctions/async
      '';
      deps = [];
    };
  };

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb.layout = "gb";
  };

  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "none+i3";
  services.displayManager.sddm.theme = "${(pkgs.fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-sugar-dark";
    rev = "v1.2";
    sha256 = "0gx0am7vq1ywaw2rm1p015x90b75ccqxnb1sz3wy8yjl27v82yhb";
  })}";
  services.xserver.desktopManager.wallpaper = {
    mode = "scale";
    combineScreens = false;
  };

  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
      i3blocks
    ];
  };

  fileSystems."/storage" = {
    device = "storage";
    fsType = "zfs";
  };

  time.timeZone = "Europe/London";

  environment.systemPackages = with pkgs; [
    claudeDesktopFhs
    unstable.gemini-cli
    nginx
    nixfmt-rfc-style
    qt5.full
    pkg-config
    libusb1.dev
    wget vim unstable.google-chrome fwupd efivar sysfsutils ripgrep
    unstable.step-cli
    unstable.firefox
    shellcheck
    direnv
    ubridge
    gopls go-outline
    silver-searcher
    zip p7zip git git-lfs qemu gnumake gcc wireshark libpcap inetutils htop
    git-quick-stats
    gnumake gcc libpcap tigervnc htop
    unstable.ghostty
    alacritty xsel autocutsel i3blocks dmenu
    pandoc
    unstable.mono
    unstable.msbuild
    xclip maim
    libkrb5
    coreutils
    pythonWithPackages
    lua
    unstable.strongswan
    xl2tpd
    gimp
    nbd
    pcmanfm
    openssl
    libpcap
    openvpn
    unstable.velero
    lvm2
    arp-scan
    unstable.podman unstable.runc unstable.conmon unstable.slirp4netns unstable.fuse-overlayfs cni-plugins
    steam
    icu
    xorg.xhost
    tigervnc
    nixpkgs-fmt
    rofi
    feh
    unstable.ngrok
    flux
    unstable.age
    freerdp
    unstable.packer
    bind
    killall
    file
    unstable.sops
    unstable.terraform
    pass
    pinentry
    pinentry-curses
    ncdu
    bfg-repo-cleaner
    zoxide
    fzf
    bluez
    bluez-tools
    keepass
    terraform-ls
    tetex
    unstable.bcc
    unstable.tailscale
    byzanz
    slop
    ffmpeg-full
    iptables
    sqlite
    gettext
    awscli2
    ssm-session-manager-plugin
    unstable.codex
    dunst
  ];

  services.tailscale.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="usb",ATTRS{idVendor}=="1a6e",GROUP="dialout"
    SUBSYSTEM=="usb",ATTRS{idVendor}=="18d1",GROUP="dialout"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0664", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", MODE="0664", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3754", MODE="0664", GROUP="plugdev"
    ATTRS{idVendor}=="0483", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"
  '';

  security.wrappers.ubridge = {
    source  = "${pkgs.ubridge.out}/bin/ubridge";
    owner   = "nobody";
    group   = "nogroup";
    capabilities = "cap_net_admin,cap_net_raw+ep";
  };

  environment.etc = {
    "per-user/alacritty/alacritty.yml".text = import ./alacritty.nix { zsh = pkgs.zsh; };
    "per-user/tmux/tmux.conf".text = import ./tmux.nix { zsh = pkgs.zsh; };
    "per-user/i3/config".text = import ./i3.nix { zsh = pkgs.zsh; };
    "per-user/i3blocks/i3blocks.conf".text = import ./i3blocks.nix { zsh = pkgs.zsh; };
    "per-user/zsh/zshrc".text = import ./zshrc.nix { zsh = pkgs.zsh; };
  };

  environment.etc."containers/policy.json" = {
    mode = "0644";
    text = ''
      {
        "default": [
          {
            "type": "insecureAcceptAnything"
          }
        ],
        "transports":
          {
            "docker-daemon":
              {
                "": [{"type":"insecureAcceptAnything"}]
              }
          }
      }
    '';
  };

  environment.etc."containers/registries.conf" = {
    mode = "0644";
    text = ''
      [registries.search]
      registries = ['docker.io', 'quay.io']
    '';
  };

  environment.sessionVariables.TERMINAL = [ "alacritty" ];
  environment.sessionVariables.EDITOR = [ "vim" ];
  environment.pathsToLink = [ "/libexec" ];
  environment.etc.hosts.mode = "0644";

  programs.wireshark.enable = true;

  programs.tmux = {
    enable = true;
    clock24 = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  programs.ssh = {
    startAgent = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting = {
      enable = true;
    };
    promptInit = ''
      fpath=( "$HOME/.zfunctions" $fpath )
      autoload -U promptinit && promptinit && prompt pure
    '';
    interactiveShellInit = ''
      autoload -U up-line-or-beginning-search
      bindkey '^[[A' up-line-or-beginning-search
      zle -N up-line-or-beginning-search
    '';
  };

  services.openssh.enable = true;
  services.keybase.enable = true;

  system.stateVersion = "20.09"; # Did you read the comment?
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  services.pulseaudio.enable = false;
  services.pulseaudio.support32Bit = true;

  hardware.sane.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.enableAllFirmware = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    dina-font
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  #
  users.groups.plugdev = {};
  users.users.alan = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/alan";
    extraGroups = [ "wheel" "networkmanager" "docker" "ubridge" "adbusers" "scanner" "lp" "dialout" "plugdev" "messagebus" "bus" ];
    shell = pkgs.zsh;
    subUidRanges = [{ startUid = 100000; count = 65536; }];
    subGidRanges = [{ startGid = 100000; count = 65536; }];
    packages = [ vscodeWithExtensions ];
  };

  systemd.packages = [ pkgs.fwupd ];
  services.sshd.enable = true;

  services.zerotierone.enable = true;
  services.zerotierone.joinNetworks = [ "1c33c1ced08e8aba" ];

  virtualisation.docker = {
    enable = true;
    storageDriver = "zfs";
  };
  systemd.services.docker.path = [ pkgs.zfs ];
  systemd.services.docker.environment = { };
  virtualisation.docker.extraOptions = "--config-file=${pkgs.writeText "daemon.json" (builtins.toJSON { experimental = true; })}";

  virtualisation.virtualbox.host.enable = false;
  virtualisation.virtualbox.guest.enable = false;
  users.extraGroups.vboxusers.members = [ "alan" ];

  virtualisation.oci-containers = {
    containers = {

      #mi-scales = {
      #  image = "lolouk44/xiaomi-mi-scale:latest";
      #   volumes = [
      #     "/var/run/dbus/:/var/run/dbus/"
      #     "/home/alan/Workspace/alan/mi-scale/data:/data/"
      #   ];
      #   extraOptions = [
      #      "--network=host"
      #      "--cap-add=NET_ADMIN"
      #      "--cap-add=NET_RAW"
      #      "--privileged"
      #   ];
      # };

      #room-assistant = {
      #  image = "alan01252/room-assistant-fork:latest";
      #  volumes = [
      #    "/var/run/dbus/:/var/run/dbus/"
      #    "/home/alan/Workspace/alan/room-assistant:/room-assistant/config/"
      #  ];
      #       cmd = ["--verbose"];
      #        extraOptions = [
      #           "--network=host"
      #           "--cap-add=NET_ADMIN"
      #           "--cap-add=NET_RAW"
      #        ];
      #      };
    };
  };

  services.nfs.server.enable = false;

  services.zfs.autoScrub.enable = true;

  services.k3s = {
    enable = false;
    extraFlags = "--no-deploy traefik --no-deploy servicelb --no-deploy coredns --no-deploy metrics-server --no-flannel";
  };

  programs.adb.enable = true;

  services.gnome.gnome-keyring.enable = true;
  services.passSecretService.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  services.dbus.packages = [
    allowAlanDbusPackage # <-- Our custom package goes here
    pkgs.gnome-keyring # Keep this if you still need it
  ];

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      listen_addresses = [ "0.0.0.0:53" ];
      ipv6_servers = true;
      block_ipv6 = true;
      require_dnssec = true;
      #forwarding_rules = "/etc/dnscrypt-proxy/forwarding-rules.txt";
      cloaking_rules = "/etc/dnscrypt-proxy/cloaking-rules.txt";
      server_names = [ "cloudflare" ];

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      #server_names = [
      #  "sdns://AQcAAAAAAAAADTUxLjE1OC4xNjYuOTcgAyfzz5J-mV9G-yOB4Hwcdk7yX12EQs5Iva7kV3oGtlEgMi5kbnNjcnlwdC1jZXJ0LmFjc2Fjc2FyLWFtcy5jb20"
      #];
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    ConfigurationDirectory = "dnscrypt-proxy";
  };

  services.strongswan.enable = true;

  security.wrappers.arp-scan = {
    source  = "${pkgs.arp-scan.out}/bin/arp-scan";
    capabilities = "cap_net_raw,cap_net_admin=eip";
    owner = "alan";
    group = "users";
  };


}
