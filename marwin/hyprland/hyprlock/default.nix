{ lib, config, pkgs, ... }:
{
  config = lib.mkIf config.home.hyprland.enable {
    home.packages = [ pkgs.hyprlock ];
    xdg.configFile."hypr/hyprlock.conf".source = ./hyprlock.conf;
  };
}
