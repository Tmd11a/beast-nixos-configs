{ private, ... }:

let
  stateDir = "/var/lib/authelia-main";
  usersFile = "${stateDir}/users_database.yml";
  jwtSecretFile = "${stateDir}/jwt_secret";
  storageEncryptionKeyFile = "${stateDir}/storage_encryption_key";

in
{
  services.authelia.instances.main = {
    enable = true;

    secrets = {
      inherit jwtSecretFile storageEncryptionKeyFile;
    };

    settings = {
      theme = "auto";

      server = {
        address = "tcp://localhost:9091/";
        endpoints.authz."forward-auth".implementation = "ForwardAuth";
      };

      log = {
        level = "info";
        format = "text";
      };

      authentication_backend = {
        password_reset.disable = true;
        file = {
          path = usersFile;
          watch = true;
          password.algorithm = "argon2";
        };
      };

      # Deny by default, then permit the example domain to the admins group.
      access_control = {
        default_policy = "deny";
        rules = [
          {
            domain = "*.${private.domain}";
            subject = [ "group:admins" ];
            policy = "one_factor";
          }
        ];
      };

      session = {
        name = "authelia_session";
        same_site = "lax";
        inactivity = "15m";
        expiration = "8h";
        remember_me = "1M";
        cookies = [
          {
            domain = "${private.domain}";
            authelia_url = "https://auth.${private.domain}";
            default_redirection_url = "https://${private.domain}";
          }
        ];
      };

      regulation = {
        max_retries = 5;
        find_time = "2m";
        ban_time = "5m";
      };

      storage.local.path = "${stateDir}/db.sqlite3";
      notifier.filesystem.filename = "${stateDir}/notification.txt";
    };
  };

  # Runtime credentials and the user database are provisioned manually. Skip
  # startup cleanly until all required files exist.
  systemd.services.authelia-main.unitConfig.ConditionPathExists = [
    jwtSecretFile
    storageEncryptionKeyFile
    usersFile
  ];

  systemd.services.caddy = {
    # Caddy can still start if Authelia is absent, but starts after it when present.
    after = [ "authelia-main.service" ];
    wants = [ "authelia-main.service" ];
  };
}
