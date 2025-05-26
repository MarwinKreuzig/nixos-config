{ pkgs, ... }:
{
  # make swaylock work
  security.pam.services.swaylock = { };

  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      niri = {
        prettyName = "Niri";
        comment = "Niri compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/niri";
      };
    };
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      command =
        "${pkgs.greetd.tuigreet}/bin/tuigreet " +
        "--time --remember --user-menu " +
        "--power-shutdown 'systemctl poweroff'" +
        "--power-reboot 'systemctl reboot' " +
        "--cmd \"uwsm start -S -F niri-uwsm.desktop\"";
      user = "marwin";
    };
  };

}
