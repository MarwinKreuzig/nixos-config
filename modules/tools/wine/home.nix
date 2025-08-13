{ pkgs, ... }:
{
  home.packages = [ pkgs.wineWowPackages.waylandFull ];
  home.sessionVariables = {
    WINEPREFIX = "$XDG_DATA_HOME/wine";
  };
}
