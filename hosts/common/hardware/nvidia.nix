{ config, pkgs, inputs, uses-nvidia, ... }:
if uses-nvidia then {
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = [ pkgs.libvdpau-va-gl ]; # Fix for nvidia
  hardware.opengl.driSupport = true;
  hardware.nvidia = {
    modesetting.enable = true; # this is required
    powerManagement.enable = false; # this can cause issues if enabled

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
} else { }
