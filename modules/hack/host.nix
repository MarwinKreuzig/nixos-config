{ lib, config, inputs, ... }:
{
  nixpkgs.overlays = [
    # https://github.com/NixOS/nixpkgs/issues/526914
    (final: prev: {
      bitwarden-desktop = prev.bitwarden-desktop.override { electron_39 = final.electron_39-bin; };
    })
    # https://github.com/niri-wm/niri/issues/844
    inputs.niri-tearing.overlays.default
  ];


  nixpkgs.config.permittedInsecurePackages = [
    # https://github.com/NixOS/nixpkgs/issues/526914
    "electron-39.8.10"
  ];
}
