{ ... }:

{
  services.fail2ban = {
    enable = true;
    # Ban an address after repeated failed logins.
    maxretry = 5;
    # These addresses and networks bypass bans; review them for another host.
    ignoreIP = [
      "10.0.0.0/8" "172.16.0.0/12" "192.168.0.0/16"
      "8.8.8.8" # whitelist a specific IP
      "nixos.wiki" # resolve the IP via DNS
    ];
    bantime = "24h";
    bantime-increment = {
      # Repeat offenders receive longer bans, up to one week.
      enable = true;
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "168h";
      overalljails = true;
    };
  };
}
