{ config, pkgs, ... }:

{
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 */3 * * *    tyler . /etc/profile; duckdns   > /dev/null 2>&1"
      "@reboot        root  sleep 300 && mount -a      >> ~/last-reboot.txt"
    ];
  };
}