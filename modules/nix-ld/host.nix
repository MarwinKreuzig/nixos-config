{ pkgs, options, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = options.programs.nix-ld.libraries.default ++ (with pkgs; [
      # dynamic libraries for nix-ld
      libGL
    ]);
  };
}
