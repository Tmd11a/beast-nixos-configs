# Reference only. Use the target machine's generated hardware configuration
# as the ignored hardware.nix before building a real system.
{ lib, ... }:

{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/REPLACE-ME";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/REPLACE-ME";
    fsType = "vfat";
  };

  # These data disks mount on first access; replace both UUIDs for a real host.
  fileSystems."/mnt/data1" = {
    device = "/dev/disk/by-uuid/REPLACE-DATA-1";
    fsType = "xfs";
    options = [ "nofail" "noatime" "x-systemd.automount" ];
  };

  fileSystems."/mnt/data2" = {
    device = "/dev/disk/by-uuid/REPLACE-DATA-2";
    fsType = "xfs";
    options = [ "nofail" "noatime" "x-systemd.automount" ];
  };

  # tmpfs uses memory; size is an upper limit, not reserved RAM.
  fileSystems."/tmp/ramdisk" = {
    fsType = "tmpfs";
    options = [ "size=4G" ];
  };

  fileSystems."/tank" = {
    # mergerfs presents the data disks as one directory tree.
    device = "/mnt/data*";
    fsType = "fuse.mergerfs";
    options = [ "nofail" "category.create=mfs" "minfreespace=20G" ];
  };

  swapDevices = [ ];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
