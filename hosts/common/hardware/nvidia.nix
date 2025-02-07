{ config, pkgs, inputs, uses-nvidia, ... }:
if uses-nvidia then {
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  hardware.graphics.extraPackages = [ pkgs.libvdpau-va-gl ];
  environment.variables.VDPAU_DRIVER = "va_gl";
  environment.variables.LIBVA_DRIVER_NAME = "nvidia";

  hardware.nvidia = {
    modesetting.enable = true; # this is required
    powerManagement.enable = true; # this can cause issues if enabled

    open = false;

    nvidiaSettings = true;

    # package = config.boot.kernelPackages.nvidiaPackages.stable;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
} else { }
