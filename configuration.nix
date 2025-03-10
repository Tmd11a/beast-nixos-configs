# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:


# Adding unstable channel for certain pkgs
let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in
{
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  imports =
    [
      ./hardware.nix
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
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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
  # services.xserver = {
  #   layout = "us";
  #   xkbVariant = "";
  # };


  #--------------- USER SECTION ------------------#
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user1 = {
    isNormalUser = true;
    description = "user1";
    extraGroups = [ "networkmanager" "wheel" "docker" "sudo" "smbgrp" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
        # ...
    ];
  };

  security.sudo.extraRules= [
    { users = [ "user1" ];
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
      theme = "user1";
    };
    shellAliases = {
      sudo = "sudo ";
      l = "eza -alh";
      ll = "eza -lh";
      cd = "z";
      nxrs = "nixos-rebuild switch";
      nxrb = "nixos-rebuild boot";
      nxrt = "nixos-rebuild test";
      dff =  "duf -hide special -output 'mountpoint, size, used, avail, usage, type'";
    };
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "user1";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    busybox
    python3
    pipx
    zsh
    zfs
    xfsprogs
    docker-compose
    samba
    snapraid
    rsnapshot
    mergerfs
    screen
    tmux
    hddtemp
    intel-gpu-tools
    pciutils
    lm_sensors
    hdparm
    cron
    btop	
    htop
    iotop
    sysstat
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
    xorg.xauth
    bat 
    ripgrep
    cups
    brlaser 
    neofetch
    eza
    fail2ban
    caddy
    ddrescue
    viu
    trash-cli
    unzip
    zip
    bzip2
    monit
    ookla-speedtest
    megatools
    libwebp 
    stress-ng
    reptyr
    icdiff
    fast-cli
    dotbot
    handbrake
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


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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
    allowedTCPPorts = [ 22 80 443 139 445 631 6414 ];
    allowedTCPPortRanges = [
      { from = 3000; to = 32469; }
    ];
    allowedUDPPortRanges = [
      { from = 1900; to = 58000; }
      ];
  };
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Monitor Services - monit
  # {
  #   imports = [
  #     (import ./monit.nix {
  #       filesystems = [ "/" "/nix" "/mnt/data*" ];
  #       drives = [ "sda" "sdb" "sdc" "sdd"  ];
  #       openPort = true;
  #     })
  #   ];
  # }

  # Sleep/Suspend configs
  systemd.sleep.extraConfig = ''
  AllowSuspend=yes
  '';
  powerManagement.resumeCommands = ''
    echo "This should show up in the journal after resuming..."
    echo "------------ Resuming ------------"
  '';
  

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; 
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
