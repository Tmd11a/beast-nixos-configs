{ pkgs, ... }:

let
  # private.nix supplies public defaults and reads ignored local overrides.
  private = import ./private.nix;
  # Use a real generated hardware file when available; otherwise show the example.
  hardwareModule =
    if builtins.pathExists ./hardware.nix then ./hardware.nix else ./hardware.example.nix;
  # Codex comes from the moving unstable channel in this configuration.
  unstable = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  }) {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  _module.args = { inherit unstable private; };

  imports = [ hardwareModule ./modules ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable ZFS and import the backup pool without forcing a root-pool import.
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "backup" ];
  boot.zfs.forceImportRoot = false;

  # Networking
  networking.networkmanager.enable = true;
  networking.hostId = private.hostId;
  networking.hostName = private.hostName;
  networking.extraHosts = private.extraHosts;

  # These ranges expose application ports; narrow them for a different host.
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

  time.timeZone = "America/Samoa";

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

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # Broadwell and newer Intel GPUs
      intel-vaapi-driver # Older Intel GPUs
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

  environment.localBinInPath = true;

  environment.systemPackages = import ./pkgs/system.nix {
    inherit pkgs;
  };

  users.users.${private.userName} = {
    isNormalUser = true;
    description = private.userDescription;
    extraGroups = [ "networkmanager" "wheel" "docker" "sudo" "smbgrp" ];
    packages = import ./pkgs/user.nix { inherit pkgs; };
    shell = pkgs.zsh;
  };

  security.sudo.extraRules = [
    # The example user can run sudo without a password; review before deployment.
    {
      users = [ private.userName ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  services.getty.autologinUser = private.userName;

  # Permit suspend and record a short message when the host resumes.
  systemd.sleep.settings.Sleep.AllowSuspend = "yes";
  powerManagement.resumeCommands = ''
    echo "This should show up in the journal after resuming..."
    echo "------------ Resuming ------------"
  '';

  services.journald.extraConfig = ''
    MaxRetentionSec=30day
  '';

  # Keep this at the release used for the host's first installation.
  system.stateVersion = "26.05";
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;
}
