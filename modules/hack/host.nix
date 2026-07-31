{ lib, config, inputs, pkgs-libdisplay-info, ... }:
{
  nixpkgs.overlays = [
    # https://github.com/niri-wm/niri/issues/844
    inputs.niri-tearing.overlays.default
    # build failure of niri because libdisplay-info needs to be < 0.4.0 but nixpkgs is at the time of writing 0.4.0
    (final: prev: {
      niri = prev.niri.override {
        libdisplay-info = pkgs-libdisplay-info.libdisplay-info;
      };
    })
  ];


  nixpkgs.config.permittedInsecurePackages = [
  ];
}
