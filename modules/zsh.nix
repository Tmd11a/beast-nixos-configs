{ pkgs, private, ... }:

{
  environment.shells = [ pkgs.zsh ];

  programs.zsh = {
    enable = true;
    histSize = 10000;
    setOptions = [
      "AUTO_CD"
      "HIST_FCNTL_LOCK"
      "HIST_IGNORE_ALL_DUPS"
      "HIST_IGNORE_SPACE"
      "INTERACTIVE_COMMENTS"
      "NO_BEEP"
      "SHARE_HISTORY"
    ];

    autosuggestions.enable = true;

    syntaxHighlighting = {
      enable = true;
      styles = {
        path = "fg=yellow,italics";
        path_prefix = "none";
        autodirectory = "fg=green";
        precommand = "fg=magenta";
      };
    };

    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "zoxide"
        "fzf"
        "sudo"
        "docker-compose"
        "screen"
        "tldr"
      ];
      custom = "$HOME/.oh-my-zsh/custom";
      theme = private.zshTheme;
      preLoaded = ''
        # Keep pasted URLs and other bracketed text from being rewritten by
        # Oh My Zsh's magic functions.
        DISABLE_MAGIC_FUNCTIONS=true
      '';
    };

    shellAliases = {
      sudo = "sudo ";
      l = "eza -alh";
      ll = "eza -lh";
      lt = "eza --tree --level=2";
      nxrs = "sudo nixos-rebuild switch";
      nxrb = "sudo nixos-rebuild boot";
      nxrt = "sudo nixos-rebuild test";
      dff = "duf -hide special -output 'mountpoint, size, used, avail, usage, type'";
      webhook-check = "journalctl -u webhook.service -f";
      python = "python3";
    };

    interactiveShellInit = ''
      bindkey -e

      # Search history using whatever has already been typed at the prompt.
      autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey '^[[A' up-line-or-beginning-search
      bindkey '^[[B' down-line-or-beginning-search

      # Common terminal navigation keys.
      bindkey '^[[H' beginning-of-line
      bindkey '^[[F' end-of-line
      bindkey '^[[3~' delete-char
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
    '';
  };
}
