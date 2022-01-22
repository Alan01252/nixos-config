# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let

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


    callPk = pkgs.callPackage ;


    flux = import ./flux.nix {
	inherit pkgs;
    };

   dotnet = import ./overlays/dotnet/default.nix {
         callPackage = callPk;
   };

   dotnetCombined = with dotnet; combinePackages [ sdk_6_0 runtime_6_0 ];



in {

 nix = {
   package = pkgs.nixFlakes;
   extraOptions = ''
     experimental-features = nix-command flakes
   '';
 };
  
 imports =
   [ # Include the results of the hardware scan.
     ./hardware-configuration.nix
     ./webhook.nix
   ];


  #nixpkgs.overlays = [ 
  #   (import ./overlays/default.nix)
  #];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "nohibernate" ];
  boot.loader.grub.copyKernels = true;
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireless.interfaces = ["wlp0s20f3"];
  networking.resolvconf.dnsExtensionMechanism = false;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;
  networking.hostId = "089f9679";
  networking.defaultGateway = "192.168.2.1";

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
    layout = "gb";
  };

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.defaultSession = "none+i3";
  services.xserver.displayManager.sddm.theme = "${(pkgs.fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-sugar-dark";
    rev = "v1.2";
    sha256 = "0gx0am7vq1ywaw2rm1p015x90b75ccqxnb1sz3wy8yjl27v82yhb";
  })}";
  services.xserver.desktopManager.wallpaper= {
	mode = "scale";
  	combineScreens = false;
  };

  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
        i3blocks
      ];
  };


 
  time.timeZone = "Europe/London";

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
     wget vim unstable.google-chrome fwupd efivar systool 
     ubridge
     gopls go-outline
     go_1_17
     silver-searcher
     zip p7zip git git-lfs qemu gnumake gcc wireshark libpcap telnet htop
     git-quick-stats
     gnumake gcc wireshark libpcap tigervnc telnet htop
     alacritty xsel i3blocks dmenu 
     dotnetCombined
     unstable.azuredatastudio
     unstable.mono
     unstable.msbuild
     xclip maim
     libkrb5
     vscodeWithExtensions unstable.omnisharp-roslyn 
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
     unstable.dbeaver
     unstable.velero
     lvm2
     icedtea_web
     unstable.podman unstable.runc unstable.conmon unstable.slirp4netns unstable.fuse-overlayfs cni-plugins
     steam
     icu
     vbetool
     xorg.xhost
     i3blocks
     unstable.teams
     tigervnc
     nixpkgs-fmt
     rofi
     qt5Full
     android-studio
     feh
     unstable.kubectl
     unstable.kustomize
     kubectx
     flux
     unstable.age
     unstable.kubeprompt
     unstable.kind
     freerdp
     unstable.packer
     bind
     killall
     file
     unstable.sops
     unstable.terraform_0_15
     aws-iam-authenticator
     unstable.awscli2
     pass
     pinentry
     pinentry-curses
     ncdu
     bfg-repo-cleaner
     zoxide
     fzf
     bluezFull
     bluez-tools
     keepass
   ];

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
    mode="0644";
    text=''
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
    mode="0644";
    text=''
      [registries.search]
      registries = ['docker.io', 'quay.io']
    '';
  };
  environment.sessionVariables.TERMINAL = [ "alacritty" ];
  environment.sessionVariables.EDITOR = [ "vim" ];
  environment.pathsToLink = [ "/libexec" ];
  environment.etc.hosts.mode = "0644";

  
  programs.tmux = {
    enable = true;
    clock24 = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
    pinentryFlavor = "curses";
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
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.sane.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
	

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts
    dina-font
    proggyfonts
  ];

 
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alan = {
     isNormalUser = true;
     uid = 1000;
     home = "/home/alan";
     extraGroups = [ "wheel" "networkmanager" "docker" "ubridge" "adbusers" "scanner" "lp"];
     shell = pkgs.zsh;
     subUidRanges = [{ startUid = 100000; count = 65536; }];
     subGidRanges = [{ startGid = 100000; count = 65536; }];
   };


  systemd.packages = [ pkgs.fwupd ];
  services.sshd.enable = true;

  services.zerotierone.enable = true;
  services.zerotierone.joinNetworks = ["1c33c1ced08e8aba"];


  virtualisation.docker = {
        enable = true;
        storageDriver = "zfs";
	logDriver = "json-file";
  };
  systemd.services.docker.path = [ pkgs.zfs ];
  systemd.services.docker.environment = {
  };
  virtualisation.docker.extraOptions = "--config-file=${pkgs.writeText "daemon.json" (builtins.toJSON { experimental = true; })}";

  virtualisation.virtualbox.host.enable = false;
  virtualisation.virtualbox.guest.enable = false;
  users.extraGroups.vboxusers.members = [ "alan" ];

  virtualisation.oci-containers = {
    containers = {
      room-assistant = {
        image = "mkerix/room-assistant";
        volumes = [
          "/var/run/dbus/:/var/run/dbus/"
          "/home/alan/Workspace/alan/room-assistant:/room-assistant/config/"
        ];
	cmd = ["--verbose"];
        extraOptions = [ 
           "--network=host"
           "--cap-add=NET_ADMIN"
           "--cap-add=NET_RAW"
        ];
      };
    };
  };

  services.nfs.server.enable = false;

  services.k3s ={
    enable = false;
    docker = true;
    extraFlags = "--no-deploy traefik --no-deploy servicelb --no-deploy coredns --no-deploy metrics-server --no-flannel" ;
  };

  programs.adb.enable = true;

  services.dnscrypt-proxy2 = {
    enable = false;
    settings = {
      listen_addresses = [ "0.0.0.0:53" ];
      ipv6_servers = true;
      block_ipv6= true;
      require_dnssec = true;

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      #server_names = [  
	#"sdns://AQcAAAAAAAAADTUxLjE1OC4xNjYuOTcgAyfzz5J-mV9G-yOB4Hwcdk7yX12EQs5Iva7kV3oGtlEgMi5kbnNjcnlwdC1jZXJ0LmFjc2Fjc2FyLWFtcy5jb20"
      #];
    };
  };

}

