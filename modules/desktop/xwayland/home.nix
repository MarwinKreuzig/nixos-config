{ pkgs, lib, config, ... }:
{
  options.modules.xwayland.xwayland-satellite = lib.mkEnableOption "run xwayland-satellite";

  config = {
    systemd.user.services."xwayland-satellite" = lib.mkIf config.modules.xwayland.xwayland-satellite {
      Unit = {
        Description = "Xwayland outside your Wayland";
        Restart = "on-failure";
        BindsTo = "graphical-session.target";
        PartOf = "graphical-session.target";
        After = "graphical-session.target";
        Requisite = "graphical-session.target";
      };
      Service = {
        Type = "notify";
        NotifyAccess = "all";
        ExecStart = lib.getExe pkgs.xwayland-satellite;
        StandardOutput = "journal";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
