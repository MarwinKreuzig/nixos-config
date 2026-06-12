{ lib, config, inputs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      openldap = prev.openldap.overrideAttrs {
        doCheck = !prev.stdenv.hostPlatform.isi686;
      };

      bitwarden-desktop = prev.bitwarden-desktop.override { electron_39 = final.electron_39-bin; };
    })
    inputs.niri-tearing.overlays.default
  ];


  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];
}
