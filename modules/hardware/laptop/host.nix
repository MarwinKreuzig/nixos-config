{ lib, config, ... }:
{
  options.modules.laptop.enable = lib.mkEnableOption "laptop specific configuration";

  config = lib.mkIf config.modules.laptop.enable {
    services.logind.settings.Login = {
      # hibernate instead of shutting down
      HandlePowerKey = "hibernate";
    };

    # Gnome 40 introduced a new way of managing power, without tlp.
    # However, these 2 services clash when enabled simultaneously.
    # https://github.com/NixOS/nixos-hardware/issues/260
    services.tlp.enable = lib.mkDefault ((lib.versionOlder (lib.versions.majorMinor lib.version) "21.05") || !config.services.power-profiles-daemon.enable);
    boot = lib.mkIf config.services.tlp.enable {
      kernelModules = [ "acpi_call" ];
      extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    };
  };
}
