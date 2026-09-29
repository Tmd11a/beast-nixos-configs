{ pkgs, private, ... }:

let
  glancesConfig = pkgs.writeText "glances.conf" ''
    [global]
    refresh=2
    history_size=1800

    [fs]
    # The terminal collector reports mergerfs as fuse.mergerfs, while the
    # REST collector may report the same mount as generic fuse.
    allow=fuse,fuse.mergerfs
    show=^/$,^/tank$
    refresh=60

    [outputs]
    cors_origins=http://localhost:61208
    cors_credentials=False
    cors_methods=GET
    cors_headers=Accept,Content-Type
    webui_allowed_hosts=${private.glancesAllowedHosts}
  '';
in
{
  environment.etc."glances/glances.conf".source = glancesConfig;

  services.glances = {
    enable = true;
    port = 61208;
    openFirewall = false;
    extraArgs = [
      "--webserver"
      "--bind"
      "0.0.0.0"
      "--config"
      "/etc/glances/glances.conf"
      "--disable-webui"
      "--disable-autodiscover"
      "--cached-time"
      "2"
    ];
  };

  # Glances reads its filesystem filters only at startup. Tie its lifecycle to
  # the generated configuration so a NixOS switch cannot leave it using stale
  # in-memory filters.
  systemd.services.glances.restartTriggers = [ glancesConfig ];

  # A container reaches the host through its Docker bridge.
  # Limit the Glances API to Docker bridge ingress; loopback remains available.
  networking.firewall.interfaces = {
    docker0.allowedTCPPorts = [ 61208 ];
    "br-+".allowedTCPPorts = [ 61208 ];
  };
}
