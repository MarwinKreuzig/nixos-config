# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./../common/default.nix
    ];

  networking.hostName = "marwin_laptop0_nixos";

  hardware.opentabletdriver.enable = true;

  services.logind.extraConfig = ''
    # hibernate instead of shutting down
    HandlePowerKey=hibernate
    '';

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Gnome 40 introduced a new way of managing power, without tlp.
  # However, these 2 services clash when enabled simultaneously.
  # https://github.com/NixOS/nixos-hardware/issues/260
  services.tlp.enable = lib.mkDefault ((lib.versionOlder (lib.versions.majorMinor lib.version) "21.05") || !config.services.power-profiles-daemon.enable);
  boot = lib.mkIf config.services.tlp.enable {
    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };
}
