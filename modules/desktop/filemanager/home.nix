{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nnn
    nemo
    pcmanfm
  ];
}
