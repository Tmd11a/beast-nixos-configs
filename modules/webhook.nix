{ private, ... }:

{
  services.webhook = {
    enable = true;
    port = 9001;
    user = private.userName;
    group = "users";
    # Each hook calls a locally maintained script under /opt/webhook.
    hooks = {
      docker = {
        execute-command = "/opt/webhook/docker-hook.sh";
        response-message = "Docker repo updated";
        trigger-rule = {
          match = {
            type = "value";
            value = "refs/heads/main";
            parameter = { source = "payload"; name = "ref"; };
          };
        };
      };

      nixos = {
        execute-command = "/opt/webhook/nixos-hook.sh";
        response-message = "NixOS repo updated";
        trigger-rule = {
          match = {
            type = "value";
            value = "refs/heads/main";
            parameter = { source = "payload"; name = "ref"; };
          };
        };
      };

      localbin = {
        execute-command = "/opt/webhook/localbin-hook.sh";
        response-message = "Local Bin updated";
        trigger-rule = {
          match = {
            type = "value";
            value = "refs/heads/main";
            parameter = { source = "payload"; name = "ref"; };
          };
        };
      };

      webhook = {
        execute-command = "/opt/webhook/webhook-hook.sh";
        response-message = "Webhook repo updated";
        trigger-rule = {
          match = {
            type = "value";
            value = "refs/heads/main";
            parameter = { source = "payload"; name = "ref"; };
          };
        };
      };

      homeconfig = {
        execute-command = "/opt/webhook/homeconfig-hook.sh";
        response-message = "Home Config repo updated";
        trigger-rule = {
          match = {
            type = "value";
            value = "refs/heads/main";
            parameter = { source = "payload"; name = "ref"; };
          };
        };
      };

      # Unlike the main-branch hooks, this one accepts any branch ref.
      homepage = {
        execute-command = "/opt/webhook/homepage-hook.sh";
        response-message = "Homepage repo updated";
        pass-arguments-to-command = [
          {
            source = "payload";
            name = "ref";
          }
        ];
        trigger-rule = {
          match = {
            type = "regex";
            regex = "^refs/heads/.+$";
            parameter = { source = "payload"; name = "ref"; };
          };
        };
      };
    };
  };
  # Permit incoming webhook requests on the configured port.
  networking.firewall.allowedTCPPorts = [ 9001 ];
}
