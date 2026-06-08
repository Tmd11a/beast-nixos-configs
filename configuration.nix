#########################################
#########################################
#------------Personal Project-----------#
#########################################
#########################################

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware.nix
      ./fail2ban.nix
      ./extra/caddy.nix
      ./extra/samba.nix
      ./extra/printer.nix
      ./extra/timers.nix
      ./extra/webhook.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ZFS Section
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "backup" ];
  boot.zfs.forceImportRoot = false;

  networking.hostId = "189e25b2"; # Can be random string (32bit) $ head -c4 /dev/urandom | od -A none -t x4
  networking.hostName = "beast"; # Define your hostname.
  networking.extraHosts =
  ''
    192.168.86.100 beast
    192.168.86.4   host
  '';
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


  #--------------- USER SECTION ------------------#
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.theuser = {
    isNormalUser = true;
    description = "theuser";
    extraGroups = [ "networkmanager" "wheel" "docker" "sudo" "smbgrp" ];
    # Importing user pkgs
    packages = import ./extra/added-pkgs.nix {
      inherit pkgs;
    };
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 ... ..."
      "ssh-ed25519 ... ..."
      "ssh-ed25519 ... ..."
      "ssh-ed25519 ... ..."
      "ssh-ed25519 ... ..."
      "ssh-ed25519 ... ..."
      "ssh-ed25519 ... ..."
      "ssh-ed25519 ... ..."
    ];
  };

  # services.atuin.enable = true; #Atuin adding in 26.05

  services.kmscon = {
    enable = true;
    autologinUser = "theuser";
    hwRender = true;
    fonts = [ { name = "JetBrains Mono"; package = pkgs.jetbrains-mono; } ];
    extraConfig = ''
    font-size=8
    '';
    extraOptions = "--term xterm-direct";
  };


  services.getty.autologinUser = "theuser";


  # Enable zsh and oh-my-zsh
  environment.shells = [ pkgs.zsh ]; # IMPORTANT: This is needed to actaully change shells
  environment.localBinInPath = true;

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "zoxide" "fzf" "sudo" "docker-compose" "screen" "tldr"];
      custom = "$HOME/.oh-my-zsh/custom";
      theme = "theuser";
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


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # DON'T ADD PACKAGES HERE NOR REMOVE
  environment.systemPackages = with pkgs; [
    # Core system
    git
    vim
    wget
    curl
    tmux
    screen
    zsh
    python313

    # Filesystems/disks
    zfs
    xfsprogs
    exfatprogs
    e2fsprogs
    hdparm
    smartmontools
    nvme-cli
    mergerfs

    # Monitoring/troubleshooting
    htop
    btop
    lm_sensors
    pciutils
    iotop
    sysstat

    # Networking
    nmap

    # Compression/archive
    zip
    bzip2
    pigz

    # Shell
    fzf
    zoxide
    fd
    ripgrep
    bat
    eza
    atuin
    tldr

    # Recovery
    ddrescue

    # Dev tooling
    uv
    pip
    pipx
    gcc
    cargo

    # Containers
    docker-compose
  ];


  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt
    ];
  };

  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  # Adding SSH agent startup
  programs.ssh.startAgent = true;

  # Open ports in the firewall.

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 139 445 631 6414 ];
  };
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  # Sleep/Suspend configs
  systemd.sleep.extraConfig = ''
  AllowSuspend=yes
  '';
  powerManagement.resumeCommands = ''
    echo "This should show up in the journal after resuming..."
    echo "------------ Resuming ------------"
  '';

  # Cleanup /tmp on boot
  boot.tmp.cleanOnBoot = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05";
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
