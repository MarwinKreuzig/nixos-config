{ pkgs, ... }:
{
  xdg.configFile."alacritty/alacritty.toml".source = "${pkgs.alacritty-theme}/github_light_high_contrast.toml";

  programs.alacritty = {
    enable = true;
  };
}
