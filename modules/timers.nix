{ pkgs, private, ... }:

{
  services.cron = {
    enable = true;
    # These commands live outside this repository and must exist on the host.
    systemCronJobs = [
      "0 */3 * * *    ${private.userName} . /etc/profile; duckdns   > /dev/null 2>&1"
      "0 4 * * *      ${private.userName} . /etc/profile; plex2-stop"
      "@reboot        root  sleep 300 && mount -a      >> ~/last-reboot.txt"
    ];
  };

  # Run a local script on a daily timer without copying it into the Nix store.
  systemd.services.pagerduty-afk = {
    description = "PagerDuty AFK";
    serviceConfig = {
      Type = "simple";
      User = private.userName;
      ExecStart = "${pkgs.bash}/bin/bash /home/${private.userName}/.local/bin/pagerduty-afk";
      RuntimeMaxSec = "12h";
    };
  };

  systemd.timers.pagerduty-afk = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 07:00:00";
      Persistent = true;
      Unit = "pagerduty-afk.service";
    };
  };
}
