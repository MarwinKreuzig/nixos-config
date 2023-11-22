{ config, inputs, ... }:
{
  programs.waybar = {
    enable = true;
    settings.mainbar = (builtins.fromJSON (builtins.readFile ./waybar));
    style = builtins.readFile ./waybar.css;
  };
}
