{ pkgs }:

# Packages for the configured normal user, separate from system-wide tools.

with pkgs; [
  # monitoring
  glances

  # media/tools
  handbrake
  yt-dlp
  pdftk
  p7zip


  # dev
  sqlite

  # misc
  viu
  trash-cli
  icdiff
  stress-ng
  lazydocker
  fastfetch
  rclone
  megatools
  iperf3
  tldr
  tree-sitter
  jq

  # Build the local package definition alongside the packaged tools.
  (callPackage ./dops.nix {})
]
