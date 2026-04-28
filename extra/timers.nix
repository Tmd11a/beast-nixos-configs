{ config, pkgs, ... }:

{
  services.cron = {
    enable = true;
    systemCronJobs = [
      "@reboot        root  sleep 300 && mount -a      >> ~/last-reboot.txt"
    ];
  };
}