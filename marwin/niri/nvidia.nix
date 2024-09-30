{ lib, config, ... }:
{
  config = lib.mkIf (config.home.niri.enable && config.home.niri.nvidia) {
    home.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
  };
}
