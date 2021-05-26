# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let

    unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
    unstablePkgs = unstable.pkgs;

    pureZshPrompt = pkgs.fetchgit {
      url = "https://github.com/sindresorhus/pure";
      rev = "e7036c43487fedf608a988dde54dd1d4c0d96823";
      sha256 = "10mdk4dn2azzrhymx0ghl8v668ydy6mz5i797nmbl2ijx9hlqb3v";
    };

    vscodeWithExtensions = import ./vscode.nix { 
   	 pkgs = unstablePkgs;
    };

    pythonWithPackages = import ./python.nix { 
   	 pkgs = unstablePkgs;
    };

   callPk = pkgs.callPackage;
   dotnet = import ./overlays/dotnet/default.nix {
         callPackage = callPk;
   };

   azureDataStudioLatest =  import ./overlays/azuredatastudio/default.nix {
	stdenv = pkgs.stdenv;
	lib = pkgs.lib;
	fetchurl = pkgs.fetchurl;
	makeWrapper = pkgs.makeWrapper;
	libuuid = pkgs.libuuid;
	libunwind = pkgs.libunwind;
	icu = pkgs.icu;
	openssl = pkgs.openssl;
	zlib = pkgs.zlib;
	curl = pkgs.curl;
	at-spi2-core = pkgs.at-spi2-core;
	at-spi2-atk = pkgs.at-spi2-atk;
	gnutar = pkgs.gnutar;
	atomEnv = pkgs.atomEnv;
	libkrb5 = pkgs.libkrb5;
	libdrm = pkgs.libdrm;
        mesa = pkgs.mesa;
   };

   mono6 = import ./overlays/mono/6.nix {
          callPackage = unstablePkgs.callPackage;
          Foundation = unstablePkgs.Foundation;
          libobjc = unstablePkgs.libobjc;
   };

   dotnetCombined = with dotnet; combinePackages [ sdk_5_0 net_5_0 ];



    omnisharp = import ./omnisharp.nix {
	inherit pkgs;
    };


in {

  
 imports =
   [ # Include the results of the hardware scan.
     ./hardware-configuration.nix
     ./webhook.nix
   ];

  nixpkgs.overlays = [ 
     (import ./overlays/default.nix)
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];

  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireless.networks.vodafone0E2D79.psk = "6Tqa2r9HzmenXncJ";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;
  networking.hostId = "089f9679";
  networking.defaultGateway = "192.168.1.1";
 
  boot.kernelPackages = pkgs.linuxPackages_latest; 

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
     azureDataStudioLatest
     wget vim unstable.google-chrome fwupd efivar systool 
     ubridge
     silver-searcher
     zip p7zip git git-lfs qemu gnumake gcc wireshark libpcap telnet htop
     gnumake gcc wireshark libpcap tigervnc telnet htop
     alacritty xsel i3blocks dmenu 
     dotnetCombined
     xclip maim
     vscodeWithExtensions omnisharp 
     coreutils
     pythonWithPackages 
     mono6
     lua
     mysql-workbench
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
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;
  hardware.bluetooth.enable = true;

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
     extraGroups = [ "wheel" "networkmanager" "docker" "ubridge" "adbusers"];
     shell = pkgs.zsh;
     subUidRanges = [{ startUid = 100000; count = 65536; }];
     subGidRanges = [{ startGid = 100000; count = 65536; }];
   };


  systemd.packages = [ pkgs.fwupd ];
  services.sshd.enable = true;

  services.zerotierone.enable = true;
  services.zerotierone.joinNetworks = ["1c33c1ced08e8aba"];


  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [ "br0" ];
    qemuOvmf = true;
    qemuRunAsRoot = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };


  virtualisation.docker.enable = true;
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
        ];
      };
    };
  };

  services.nfs.server.enable = false;

  services.k3s ={
    enable = true;
    docker = true;
    extraFlags = "--no-deploy traefik --no-deploy servicelb --no-deploy coredns --no-deploy metrics-server --no-flannel" ;
  };

  programs.adb.enable = true;
}

