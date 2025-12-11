{ ... }:
{
  modules.desktops.niri = {
    enable = true;
    outputs = ''
      output "DP-2" {
        focus-at-startup
        mode "1920x1080@144"
        scale 1.0
        variable-refresh-rate
      }

      output "HDMI-A-2" {
        mode "1920x1080@74.97300"
        scale 1.0
        position x=0 y=0
      }
    '';
  };
}
