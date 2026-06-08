{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/uuid-replace-me-abc-123"
      fsType = "ext4";
      label  = "rootfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/uuid-replace-me-abc-123"
      fsType = "vfat";
    };

  fileSystems."/mnt/data1" =
  # SPCC_Solid_State_Disk_2024090608008777
    { device = "/dev/disk/by-uuid/uuid-replace-me-abc-123"
      fsType = "xfs";
      options = [ "nofail" "users" "noatime" "x-systemd.automount" ];
    };

  fileSystems."/mnt/data2" =
  # SPCC_Solid_State_Disk_2024080704000029
    { device = "/dev/disk/by-uuid/uuid-replace-me-abc-123"
      fsType = "xfs";
      options = [ "nofail" "users" "noatime" "x-systemd.automount" ];
    };

  # fileSystems."/mnt/data3" =
  #   { device = "/dev/disk/by-uuid/uuid-replace-me-abc-123"
  #     fsType = "xfs";
  #     options = [ "nofail" ];
  #   };

  # fileSystems."/mnt/parity" =
  #   { device = "/dev/disk/by-uuid/uuid-replace-me-abc-123
  #     fsType = "xfs";
  #     options = [ "nofail" ];
  #   };

  fileSystems."/tmp/ramdisk" = {
      fsType = "tmpfs";
      options = [ "defaults" "size=16G" "x-gvfs-show" ];
    };

  fileSystems."/tank" = {
      fsType = "fuse.mergerfs";
      device = "/mnt/data*";
      options = [ "cache.files=partial" "dropcacheonclose=true" "category.create=mfs" "fsname=mergerfs" "minfreespace=200G" ];
    };



  swapDevices =
    [ { device = "/dev/disk/by-uuid/uuid-replace-me-abc-123"
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
