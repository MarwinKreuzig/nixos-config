{ pkgs, config, lib, ... }:
{
  options.modules.rgb.enable = lib.mkEnableOption "hardware rgb support";

  config = lib.mkIf config.modules.rgb.enable {
    services.hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };
  };
}
