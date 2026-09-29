# Public example values only. Put real host values in ignored private.local.nix.
let
  # A matching field in private.local.nix replaces its example value below.
  local = if builtins.pathExists ./private.local.nix then import ./private.local.nix else { };
in
{
  hostName = "example";
  hostId = "00000000"; # Replace with a unique ZFS host ID on the real host.
  extraHosts = "";
  userName = "example";
  userDescription = "Example user";
  authorizedKeys = [ ]; # Add real public keys locally to allow SSH login.
  zshTheme = "robbyrussell";
  domain = "example.invalid";
  caddyEmail = "example@example.invalid";
  # Caddy routes and snippets belong in the ignored local override.
  caddyVirtualHosts = { };
  caddyExtraConfig = "";
  # Extra paths to keep outside Codex's readable workspace.
  codexAdditionalDenyRead = [ ];
  glancesAllowedHosts = "localhost,127.0.0.1,example";
} // local
