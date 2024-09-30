{ ... }:
{
  programs.waybar = {
    enable = true;
    settings.mainbar =
      {
        modules-center = [ "clock" ];
        modules-left = [ "custom/media" "niri/workspaces" ];
        modules-right = [ "pulseaudio" "network" "tray" "battery" ];
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        "hyprland/workspaces" = {
          "sort-by" = "id";
        };
        backlight = {
          format = "{percent}% {icon}";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
        };
        battery = {
          format = "{capacity}% {icon}";
          format-alt = "{time} {icon}";
          format-charging = "{capacity}% ";
          format-icons = [ "" "" "" "" "" ];
          format-plugged = "{capacity}% ";
          states = {
            critical = 15;
            warning = 30;
          };
        };
        "battery#bat2" = {
          bat = "BAT2";
        };
        clock = {
          format = "{:%Y-%m-%d %H:%M}";
          format-alt = "{:%H:%M:%S}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        "custom/media" = {
          escape = true;
          exec = "$HOME/.config/waybar/mediaplayer.py 2> /dev/null";
          format = "{icon} {}";
          format-icons = {
            default = "🎜";
            spotify = "";
          };
          max-length = 40;
          return-type = "json";
        };
        "hyprland/window" = {
          separate-outputs = true;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        keyboard-state = {
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
          numlock = true;
        };
        memory = {
          format = "{}% ";
        };
        mpd = {
          consume-icons = {
            on = " ";
          };
          format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
          format-disconnected = "Disconnected ";
          format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
          interval = 2;
          random-icons = {
            off = "<span color=\"#f53c3c\"></span> ";
            on = " ";
          };
          repeat-icons = {
            on = " ";
          };
          single-icons = {
            on = "1 ";
          };
          state-icons = {
            paused = "";
            playing = "";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
          unknown-tag = "N/A";
        };
        network = {
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          format-disconnected = "Disconnected ⚠";
          format-ethernet = "{ipaddr}/{cidr} ";
          format-linked = "{ifname} (No IP) ";
          format-wifi = "{essid} ({signalStrength}%) ";
          tooltip-format = "{ifname} via {gwaddr} ";
        };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-icons = {
            car = "";
            default = [ "" "" "" ];
            hands-free = "";
            headphone = "";
            headset = "";
            phone = "";
            portable = "";
          };
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          on-click = "pavucontrol";
        };
        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };
        "sway/scratchpad" = {
          format = "{icon} {count}";
          format-icons = [ "" "" ];
          show-empty = false;
          tooltip = true;
          tooltip-format = "{app}: {title}";
        };
        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" "" "" ];
        };
        tray = {
          spacing = 10;
        };
      };
    style = builtins.readFile ./waybar.css;
  };
}
