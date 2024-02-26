{ pkgs, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # dynamic libraries for nix-ld
    ];
  };
}
