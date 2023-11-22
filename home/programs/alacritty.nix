{ config, pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    alacritty-theme
  ];

  xdg.configFile."alacritty/alacritty.yml".source = "${pkgs.alacritty-theme}/github_light_high_contrast.yaml";

  programs.alacritty = {
    enable = true;
  };
}
