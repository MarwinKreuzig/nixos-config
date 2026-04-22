{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mpv
    kdePackages.gwenview
    krita
  ];
}
