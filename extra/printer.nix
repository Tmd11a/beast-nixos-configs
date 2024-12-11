{ config, pkgs, ... }:

{
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];  
  services.printing.extraConf = ''
    DefaultEncryption Never
  '';

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
  services.printing = {
    listenAddresses = [ "*:631" ];
    allowFrom = [ "all" ];
    browsing = true;
    defaultShared = true;
    openFirewall = true;
  };
}
