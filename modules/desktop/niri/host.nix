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
        binPath = "/run/current-system/sw/bin/niri-session";
      };
    };
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      command =
        "${pkgs.tuigreet}/bin/tuigreet " +
        "--time --remember --user-menu " +
        "--power-shutdown 'systemctl poweroff'" +
        "--power-reboot 'systemctl reboot' " +
        "--cmd \"uwsm start -S -F niri-uwsm.desktop\"";
      user = "marwin";
    };
  };

  xdg.portal = {
    configPackages = with pkgs; [ niri ];
    extraPortals = with pkgs; [ xdg-desktop-portal-gnome xdg-desktop-portal-gtk ];
    config.niri = {
      default = [
        "gnome"
        "gtk"
      ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      "org.freedesktop.impl.portal.Access" = [ "gtk" ];
      "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };
  };
}
