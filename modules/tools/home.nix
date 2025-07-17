{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bitwarden
    zoom-us
  ];
}
