{ pkgs, ... }:
{
  home.packages = with pkgs; [
    discord-canary
    discord-screenaudio
    vesktop
    signal-desktop-bin
  ];
}
