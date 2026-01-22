{ pkgs, ... }:
{
  home.packages = with pkgs; [
    discord-canary
    signal-desktop-bin
  ];
}
