{ pkgs, ... }:
{
  services.swayidle = {
    enable = true;
    # the %% in the datestr format are just an escaped % because this string is put inside a systemd service and systemd has its own templating/escaping system
    events = let lock = "${pkgs.swaylock-effects}/bin/swaylock -e -K --screenshots --clock --datestr \"%%a, %%Y-%%m-%%d\" --indicator --effect-blur 14x5 --fade-in 2 --effect-vignette 0.5:0.5 --ring-color aa0000 --key-hl-color ff0000 --inside-clear-color aa0000 --ring-clear-color ff0000"; in [
      { event = "before-sleep"; command = lock; }
      { event = "lock"; command = lock; }
    ];
    timeouts = [
      { timeout = 300; command = "niri msg action power-off-monitors"; }
      { timeout = 600; command = "systemctl suspend"; }
    ];
  };
}
