{ private, ... }:

{
  # The public module enables Caddy; local values provide its actual routes.
  services.caddy = {
    enable = true;
    email = private.caddyEmail;
    extraConfig = private.caddyExtraConfig;
    virtualHosts = private.caddyVirtualHosts;
  };
}
