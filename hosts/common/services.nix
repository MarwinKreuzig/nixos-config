{ pkgs, lib, ... }:
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # printing
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.dbus.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "dvp";
  };

  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  # auto mount USB drives
  services.udisks2.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --user-menu --power-shutdown 'systemctl poweroff' --power-reboot 'systemctl reboot' --cmd \"uwsm start -S -F niri-uwsm.desktop\"";
      user = "marwin";
    };
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
}
