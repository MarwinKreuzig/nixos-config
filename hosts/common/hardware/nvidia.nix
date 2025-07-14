{ config, pkgs, inputs, uses-nvidia, ... }:
if uses-nvidia then {
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  hardware.graphics.extraPackages = [ pkgs.libvdpau-va-gl ];

  hardware.nvidia = {
    modesetting.enable = true; # this is required
    powerManagement.enable = true; # this can cause issues if enabled

    # This is preferred for newer GPUs
    open = true;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
} else { }
