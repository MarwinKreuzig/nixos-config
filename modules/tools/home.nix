{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bitwarden-desktop
    zoom-us
  ];
}
