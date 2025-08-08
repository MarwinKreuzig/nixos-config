{ pkgs, ... }:
{
  home.packages = with pkgs; [
    swaynotificationcenter
  ];

  xdg.configFile."swaync/style.css".source = ./catppuccin-latte.css;
}
