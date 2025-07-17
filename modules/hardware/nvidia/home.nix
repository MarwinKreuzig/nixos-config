{ osConfig, lib, ... }:
{
  config = lib.mkIf osConfig.modules.nvidia.enable {
    home.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
  };
}
