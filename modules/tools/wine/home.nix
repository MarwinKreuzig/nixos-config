{ pkgs, ... }:
{
  home.packages = [ pkgs.wineWow64Packages.waylandFull ];
  home.sessionVariables = {
    WINEPREFIX = "$XDG_DATA_HOME/wine";
  };
}
