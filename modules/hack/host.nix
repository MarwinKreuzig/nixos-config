{ lib, config, ... }:
{
  nixpkgs.overlays = [
    (_: prev: {
      openldap = prev.openldap.overrideAttrs {
        doCheck = !prev.stdenv.hostPlatform.isi686;
      };
    })
  ];


  nixpkgs.config.permittedInsecurePackages = [
  ];
}
