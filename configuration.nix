# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./fail2ban.nix
      # ./snapraid.nix
      # ./monit.nix
      ./extra/caddy.nix
      ./extra/samba.nix
      ./extra/printer.nix
      ./extra/timers.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ZFS Section
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "backup" ];
  boot.zfs.forceImportRoot = false;

  networking.hostId = "189e25b2";
  networking.hostName = "beast"; # Define your hostname.
  networking.extraHosts =
  ''
    192.168.86.100 beast
    192.168.86.4   phoenix
  '';

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };


  #--------------- USER SECTION ------------------#
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tyler = {
    isNormalUser = true;
    description = "tyler";
    extraGroups = [ "networkmanager" "wheel" "docker" "sudo" "smbgrp" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 ... tyler@phoenix"
      "ssh-ed25519 ... tdavis@DHMVZCL3"
      "ssh-ed25519 ...  tbag@Termius"
    ];
  };

  security.sudo.extraRules= [
    { users = [ "tyler" ];
      commands = [
        { command = "ALL" ;
          options= [ "NOPASSWD" ];
        }
      ];
    }
  ];


  # Enable zsh and oh-my-zsh
  environment.shells = [ pkgs.zsh ]; # IMPORTANT: This is needed to actaully change shells
  environment.localBinInPath = true;

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "zoxide" "fzf" "sudo" "docker-compose" "screen" ];
      custom = "$HOME/.oh-my-zsh/custom";
      theme = "tyler";
    };
    shellAliases = {
      l = "eza -alh";
      ll = "eza -lh";
      # ls = "eza --color=tty";
      cd = "z";
      nxrs = "nixos-rebuild switch";
      nxrb = "nixos-rebuild boot";
      nxrt = "nixos-rebuild test";
      dff =  "duf -hide special -output 'mountpoint, size, used, avail, usage, type'";
    };
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "tyler";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    python3
    zsh
    zfs
    xfsprogs
    docker-compose
    samba
    snapraid
    rsnapshot
    mergerfs
    screen
    hddtemp
    intel-gpu-tools
    pciutils
    lm_sensors
    cron
    btop	
    htop
    iotop
    duf 
    gdu
    nmap
    nvme-cli
    tdns-cli
    tree
    wget
    curl
    smartmontools
    e2fsprogs 
    fzf	 
    zoxide	 
    bat 
    cups
    brlaser 
    neofetch
    eza
    fail2ban
    caddy
    homepage-dashboard
    ddrescue
    viu
    trashy
    unzip
    zip
    monit
  ];

  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  # Open ports in the firewall.
  
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 139 445 631 ];
    allowedTCPPortRanges = [
      { from = 3000; to = 32469; }
    ];
    allowedUDPPortRanges = [
      { from = 1900; to = 58000; }
      ];
  };
  

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; 
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}