{ pkgs, unstable, private, ... }:

let
  codex = unstable.codex;
  codexConfig = pkgs.writeText "codex-config.toml" ''
    approval_policy = "on-request"
    approvals_reviewer = "user"
    sandbox_mode = "workspace-write"

    [sandbox_workspace_write]
    network_access = false
    exclude_slash_tmp = true
    exclude_tmpdir_env_var = true

    [shell_environment_policy]
    inherit = "all"
    ignore_default_excludes = false
    experimental_use_profile = false

    [shell_environment_policy.filters]
    "OPENAI_API_KEY" = "exclude"
    "AWS_*" = "exclude"
    "GITHUB_*" = "exclude"
    "*_TOKEN" = "exclude"
    "*_TOKEN_*" = "exclude"
    "*_SECRET" = "exclude"
    "*_SECRET_*" = "exclude"
    "*_PASSWORD" = "exclude"
    "*_PASSWORD_*" = "exclude"
  '';
  codexRequirements = pkgs.writeText "codex-requirements.toml" ''
    allowed_approval_policies = ["on-request"]
    allowed_sandbox_modes = ["read-only", "workspace-write"]

    [permissions.filesystem]
    # Encode Nix paths as a TOML-compatible array.
    deny_read = ${builtins.toJSON ([
      "/home/${private.userName}/.ssh"
      "/home/${private.userName}/.gnupg"
      "/home/${private.userName}/.config/rclone"
      "/home/${private.userName}/.config/gh"
      "/home/${private.userName}/.netrc"
      "/home/${private.userName}/.codex/auth.json"
    ] ++ private.codexAdditionalDenyRead)}
  '';
in
{
  users.users.${private.userName}.packages = [ codex ];

  # Codex loads these system files below user and project configuration, while
  # requirements.toml keeps the security boundaries enforceable.
  environment.etc."codex/config.toml".source = codexConfig;
  environment.etc."codex/requirements.toml".source = codexRequirements;
}
