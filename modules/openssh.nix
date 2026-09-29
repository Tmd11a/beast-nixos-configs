{ private, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Public login keys come from the local identity override.
  users.users.${private.userName}.openssh.authorizedKeys.keys = private.authorizedKeys;
}
