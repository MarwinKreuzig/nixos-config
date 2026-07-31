{ pkgs, lib, config, ... }:
{
  options.modules.xwayland.xwayland-satellite = lib.mkEnableOption "run xwayland-satellite";

  config = {
    systemd.user.services."xwayland-satellite" = lib.mkIf config.modules.xwayland.xwayland-satellite {
      Unit = {
        Description = "Xwayland outside your Wayland";
        Restart = "on-failure";
        After = [ config.wayland.systemd.target ];
        PartOf = [ config.wayland.systemd.target ];
      };
      Service = {
        Type = "notify";
        NotifyAccess = "all";
        ExecStart = lib.getExe pkgs.xwayland-satellite;
        StandardOutput = "journal";
      };
      Install = {
        WantedBy = [ config.wayland.systemd.target ];
      };
    };
  };
}
