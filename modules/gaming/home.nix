{ lib, pkgs, osConfig, ... }:
{
  config = lib.mkIf osConfig.modules.gaming.enable {
    home.packages = with pkgs; [ lutris ];
  };
}
