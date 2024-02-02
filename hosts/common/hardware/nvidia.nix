{ config, pkgs, inputs, uses-nvidia, ... }:
if uses-nvidia then {
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = [ pkgs.libvdpau-va-gl ];
  };
  environment.variables.VDPAU_DRIVER = "va_gl";
  environment.variables.LIBVA_DRIVER_NAME = "nvidia";

  hardware.nvidia = {
    modesetting.enable = true; # this is required
    powerManagement.enable = true; # this can cause issues if enabled

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
} else { }
