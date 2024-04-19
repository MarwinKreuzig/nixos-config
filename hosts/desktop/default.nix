# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  services.hardware.openrgb.enable = true;
  services.hardware.openrgb.package = pkgs.openrgb-with-all-plugins;

  networking.hostName = "marwindesktopnixos";
}
