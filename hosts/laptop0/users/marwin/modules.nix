{ ... }:
{
  modules.desktops.niri = {
    enable = true;
    outputs = ''
      output "eDP-1" {
        mode "1920x1080"
        scale 1.25
        position x=0 y=0
        focus-at-startup
      }

      spawn-at-startup "nm-applet"
    '';
  };
}
