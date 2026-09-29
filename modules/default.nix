{ lib, ... }:

{
  # Import every other regular .nix file in this directory automatically.
  imports =
    let
      moduleFiles = lib.filterAttrs (
        name: type:
          type == "regular"
          && lib.hasSuffix ".nix" name
          && name != "default.nix"
      ) (builtins.readDir ./.);
    in
    map (name: ./. + "/${name}") (lib.attrNames moduleFiles);
}
