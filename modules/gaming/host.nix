{ lib, pkgs, config, ... }:
{
  options.modules.gaming.enable = lib.mkEnableOption "install game launchers, games and utility for gaming";

  config = lib.mkIf config.modules.gaming.enable {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    programs.gamemode.enable = true;
  };
}
