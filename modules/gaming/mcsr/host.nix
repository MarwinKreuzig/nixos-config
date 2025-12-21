{ lib, config, ... }:
{
  config = lib.mkIf config.modules.gaming.enable {
    environment.etc = {
      "libinput/local-overrides.quirks".text = ''
        [Never Debounce]
        MatchUdevType=mouse
        ModelBouncingKeys=1
      '';
    };
  };
}
