{ lib, config, inputs, pkgs-libdisplay-info, ... }:
{
  nixpkgs.overlays = [
    # https://github.com/niri-wm/niri/issues/844
    inputs.niri-tearing.overlays.default
  ];


  nixpkgs.config.permittedInsecurePackages = [
  ];
}
