{ pkgs, inputs, ... }:

{
  imports = [
    inputs.mcsr.homeModules.mcsr
  ];

  home.packages = [
      pkgs.xwayland
  ];
  programs.mcsr = {
    enable = true;
  };

  xdg.configFile."waywall/overlay.png".source = ../../../assets/mcsr/overlay.png;
  xdg.configFile."waywall/init.lua".source = ./init.lua; 
}
