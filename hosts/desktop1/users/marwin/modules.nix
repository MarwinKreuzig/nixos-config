{ ... }:
{
  modules.desktops.niri = {
    enable = true;
    outputs = ''
      output "PNP(AOC) 24G2W1G4 ATNM91A026342" {
        focus-at-startup
        mode "1920x1080@144"
        scale 1.0
        variable-refresh-rate
      }

      output "Philips Consumer Electronics Company PHL 243V7 0x000010D0" {
        mode "1920x1080@74.97300"
        scale 1.0
        position x=0 y=0
      }
    '';
  };
}
