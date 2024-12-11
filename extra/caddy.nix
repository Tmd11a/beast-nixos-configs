{ config, pkgs, ... }:

{
  services.caddy = {
    email = "tmd11a@acu.edu";
    enable = true;

    
    virtualHosts."tmdba.com".extraConfig = ''
      reverse_proxy http://localhost:3003
    '';
    virtualHosts."monit.tmdba.com".extraConfig = ''
      reverse_proxy http://localhost:2812
    '';
    virtualHosts."radarr.tmdba.com".extraConfig = ''
      reverse_proxy http://localhost:7878
    '';
    virtualHosts."sonarr.tmdba.com".extraConfig = ''
      reverse_proxy http://localhost:8989
    '';
    virtualHosts."port.tmdba.com".extraConfig = ''
      reverse_proxy http://localhost:9000
    '';
    virtualHosts."qbt.tmdba.com".extraConfig = ''
      reverse_proxy http://localhost:8080
    '';
  };
}