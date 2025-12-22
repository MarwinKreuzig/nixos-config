{ lib, config, ... }:
{
  options.modules.gaming.mcsr.enable = lib.mkEnableOption "install and configure minecraft speedrunnig utilities";
  config = lib.mkIf config.modules.gaming.mcsr.enable {
    environment.etc = {
      "libinput/local-overrides.quirks".text = ''
        [Never Debounce]
        MatchUdevType=mouse
        ModelBouncingKeys=1
      '';
    };
  };
}
