{ pkgs, ... }:
{
  #xdg.configFile."tofi/config".text = (builtins.readFile ./tofi) + "\nfont=mono";
  xdg.configFile."tofi/config".source = ./tofi;

  home.packages = with pkgs; [
    fuzzel
    tofi
  ];
}
