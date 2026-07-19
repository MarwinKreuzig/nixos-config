{ lib, config, pkgs, ... }:
{
  options.modules.nvidia.enable = lib.mkEnableOption "nvidia gpu support";

  config = lib.mkIf config.modules.nvidia.enable {
    boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

    hardware.graphics.extraPackages = [ pkgs.libvdpau-va-gl ];

    hardware.nvidia = {
      modesetting.enable = true; # this is required
      powerManagement.enable = true; # this can cause issues if enabled

      # This is preferred for newer GPUs
      open = true;

      nvidiaSettings = true;

      # we use config.boot to always get the packages belonging to the current kernel
      package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.latest;
    };

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
