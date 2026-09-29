{ pkgs, ... }:

{
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];  
  services.printing.extraConf = ''
    DefaultEncryption Never
  '';

  # Advertise the printer to clients on the local network.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
  # Listen for network print jobs; review the access scope for other hosts.
  services.printing = {
    listenAddresses = [ "*:631" ];
    allowFrom = [ "all" ];
    browsing = true;
    defaultShared = true;
    openFirewall = true;
  };
}
