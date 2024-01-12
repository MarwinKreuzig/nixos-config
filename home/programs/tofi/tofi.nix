{ pkgs, ... }:
{
  #  xdg.configFile."tofi/config".text = (builtins.readFile ./tofi) + "\nfont=${pkgs.noto-fonts}/share/fonts/noto/NotoSansMono[wdth,wght].ttf";
  xdg.configFile."tofi/config".text = (builtins.readFile ./tofi) + "\nfont=mono";

  home.packages = with pkgs; [
    tofi
  ];
}
