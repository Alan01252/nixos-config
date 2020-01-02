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
   	 inherit pkgs;
       };


    pythonWithPackages = import ./python.nix { 
   	 inherit pkgs;
    };

    bcc-12 = import ./bcc.nix { 
   	 inherit pkgs;
    };

   dotnet = import ./dotnet.nix {
	inherit pkgs;
   };




in {

  
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  boot.kernelPackages = let
    linux_fixed_pkg = { fetchurl, buildLinux, ... } @args:
	buildLinux (args // rec {
	      version = "5.4.6"; 
	      modDirVersion = version; 

	      src = fetchurl {
		    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
		    sha256 = "fda561bcdea397ddd59656319c53871002938b19b554f30efed90affa30989c8";
	      }; 
	      kernelPatches = [];
	} // (args.argsOverride or {}));
    linux_fixed = pkgs.callPackage linux_fixed_pkg{};
  in
   pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_fixed);


  boot.kernelParams = [ 
        "pci=noaer i915.enable_guc=3 acpi=off" 
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ bcc-12 ];

  system.userActivationScripts = {
   extraUserActivation = {
       text = ''
        ln -sfn /etc/per-user/alacritty ~/.config/
        ln -sfn /etc/per-user/i3 ~/.config/
        ln -sfn /etc/per-user/i3blocks/i3blocks.conf ~/.i3blocks.conf
         ~/.i3blocks.conf
        ln -sfn /etc/per-user/zsh/zshrc ~/.zshrc
        ln -sfn /etc/per-user/tmux/tmux.conf ~/.tmux.conf
        mkdir -p ~/.zfunctions
        ln -sfn ${pureZshPrompt}/pure.zsh ~/.zfunctions/prompt_pure_setup
        ln -sfn ${pureZshPrompt}/async.zsh ~/.zfunctions/async
      '';
      deps = [];
    };
  };


  boot.kernelModules = ["kvm-intel"];
  
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;

  networking.hostName = "PLUSNET-QXGK"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;


  environment.systemPackages = with pkgs; [
     wget vim google-chrome fwupd efivar systool gns3-gui gns3-server 
     zip p7zip git qemu gnumake gcc wireshark libpcap tigervnc telnet htop
     alacritty xsel i3blocks dmenu dotnet xclip maim
     vscodeWithExtensions omnisharp-roslyn 
     coreutils
     pythonWithPackages 
     bcc-12
     ruby-zoom z-lua
     pjsip
   ];

   environment.etc = {
    "per-user/alacritty/alacritty.yml".text = import ./alacritty.nix { zsh = pkgs.zsh; };
    "per-user/tmux/tmux.conf".text = import ./tmux.nix { zsh = pkgs.zsh; };
    "per-user/i3/config".text = import ./i3.nix { zsh = pkgs.zsh; };
    "per-user/i3blocks/i3blocks.conf".text = import ./i3blocks.nix { zsh = pkgs.zsh; };
    "per-user/zsh/zshrc".text = import ./zshrc.nix { zsh = pkgs.zsh; };
  };
  environment.sessionVariables.TERMINAL = [ "alacritty" ];
  environment.sessionVariables.EDITOR = [ "vim" ];
  environment.pathsToLink = [ "/libexec" ];

  
  programs.tmux = {
    enable = true;
    clock24 = true;
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

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

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "gb";
    #videoDrivers = [ "intel" ]; 
    displayManager.slim.enable = true;
  };
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.desktopManager = {
    default = "none";
    xterm.enable = false;
  };
  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
        i3blocks
      ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alan = {
     isNormalUser = true;
     uid = 1000;
     home = "/home/alan";
     extraGroups = [ "wheel" "networkmanager" "docker"];
     shell = pkgs.zsh;
   };


  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
  systemd.packages = [ pkgs.fwupd ];
  services.sshd.enable = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

}
