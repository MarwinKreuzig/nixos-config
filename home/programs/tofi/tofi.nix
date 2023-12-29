{ pkgs, ... }:
{
  xdg.configFile."tofi/config".source = ./tofi;

  home.packages = with pkgs; [
    tofi
  ];
}
