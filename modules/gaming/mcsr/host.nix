{ lib, config, ... }:
{
  config = lib.mkIf config.modules.gaming.enable {
    environment.etc = {
      "libinput/local-overrides.quirks".text = ''
        [EndGameGear XM1 Gaming Mouse]
        MatchName=EndGameGear XM1 Gaming Mouse
        ModelBouncingKeys=1
      '';
    };
  };
}
