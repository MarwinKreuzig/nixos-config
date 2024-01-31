{ pkgs, ... }:
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.dbus.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "dvp";
  };

  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  # auto mount USB drives
  services.udisks2.enable = true;

  services.kmscon = {
    enable = false;
    fonts = [
      {
        name = "Ubuntu Mono";
        package = pkgs.ubuntu_font_family;
      }
      {
        name = "FiraCode Nerd Font Mono";
        package = (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; });
      }
      {
        name = "Source Code Pro";
        package = pkgs.source-code-pro;
      }
    ];
    extraConfig = ''
      xkb-layout=us
      xkb-variant=dvp
      xkb-options=lv3:alt_switch,caps:escape
    '';
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
}
