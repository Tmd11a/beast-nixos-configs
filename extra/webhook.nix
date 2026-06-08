{ config, pkgs, ... }:

{
  services.webhook = {
    enable = true;
    package = pkgs.webhook;
    # port = ;
    user = "theuser";
    group = "users";
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
    };
  };

  # networking.firewall.allowedTCPPorts = [ ... ];
}
