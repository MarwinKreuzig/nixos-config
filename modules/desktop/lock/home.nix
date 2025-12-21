{ pkgs, ... }:
{
  services.swayidle = {
    enable = true;
    # the %% in the datestr format are just an escaped % because this string is put inside a systemd service and systemd has its own templating/escaping system
    events =
      let
        text-color = "000000";
        inside-color = "ffffff";
        line-color = "ffffff";
        key-hl-color = "ff0000";
        backspace-color = key-hl-color;
        ring-color = "000000";
        separator-color = ring-color;
        clear-color = "ffffff";
        wrong-color = "ff8888";
        ver-color = "aaaaff";
        lock = "${pkgs.swaylock-effects}/bin/swaylock -e -K --screenshots --clock --datestr \"%%a, %%Y-%%m-%%d\" --indicator --effect-blur 14x5 --fade-in 2 --effect-vignette 0.5:0.5 --line-uses-inside --text-color ${text-color} --inside-color ${inside-color} --line-color ${line-color} --separator-color ${separator-color}  --key-hl-color ${key-hl-color} --bs-hl-color ${backspace-color} --ring-color ${ring-color} --inside-clear-color ${clear-color} --line-clear-color ${clear-color} --ring-clear-color ${clear-color} --inside-wrong-color ${wrong-color} --ring-wrong-color ${wrong-color} --line-wrong-color ${wrong-color} --inside-ver-color ${ver-color} --line-ver-color ${ver-color} --ring-ver-color ${ver-color}";
      in
      {
        before-sleep = lock;
        lock = lock;
      };
    timeouts = [
      { timeout = 300; command = "${pkgs.niri}/bin/niri msg action power-off-monitors"; }
      { timeout = 600; command = "${pkgs.systemd}/bin/systemctl suspend"; }
    ];
  };
}
