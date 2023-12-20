{ config, pkgs, inputs, ... }:

{
  home.username = "marwin";
  home.homeDirectory = "/home/marwin";

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";

  imports = [
    ./programs
    ./hyprland
    ./services
  ];

  # make home-manager manage fonts
  fonts.fontconfig.enable = true;

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
