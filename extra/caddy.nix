{ config, pkgs, ... }:

{
  services.caddy = {
    email = "tmd11a@acu.edu";
    enable = true;

    
    virtualHosts."tmdba.com".extraConfig = ''
      reverse_proxy http://localhost:3003
    '';
    # virtualHosts."something.tmdba.com".extraConfig = ''
    #   reverse_proxy http://localhost:80
    # '';
    # virtualHosts."another.tmdba.com".extraConfig = ''
    #   reverse_proxy http://localhost:8080
    # '';
    # virtualHosts."example.tmdba.com".extraConfig = ''
    #   reverse_proxy http://localhost:8081
    # '';
    # virtualHosts."woah.tmdba.com".extraConfig = ''
    #   reverse_proxy http://localhost:8443
    # '';  
  };
}