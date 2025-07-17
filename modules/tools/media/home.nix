{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mpv
    feh
    krita
  ];
}
