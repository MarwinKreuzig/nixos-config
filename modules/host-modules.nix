{ lib, ... }:
{
  imports = ((import ./collect-paths.nix) lib) ./. "host.nix";
}
