{ lib, ... }:
{
  imports = ((import ./collect-paths.nix) lib) ./. "home.nix";
}
