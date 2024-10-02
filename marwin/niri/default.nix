{ config, pkgs, lib, ... }:
let
  cfg = config.home.niri;
in
{
  imports = [
    ./nvidia.nix
  ];

  options.home.niri = {
    enable = lib.mkEnableOption "niri window manager";
    setup = lib.mkOption {
      type = lib.types.uniq lib.types.str;
      default = "";
    };
    nvidia = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    extraConfig = lib.mkOption {
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      niri
      xwayland-satellite
      fuzzel
    ];
    services.gnome-keyring.enable = true;
    xdg.configFile."niri/config.kdl.test".text =
      let
        config = {
          test = {
            key = 0;
            key2 = "hey";
            keywithargs = [ "first" "second" 0 1 ];
            subsection = {
              subkey = 0;
              subkey2 = "hello";
            };
          };
        };
        indentPad = number: builtins.concatStringsSep "" (builtins.genList (x: "  ") number);
        toKdlValue = value:
          if builtins.typeOf value == "string"
          then "\"${builtins.toString value}\""
          else builtins.toString value;
        toKdlNode = indent: name: value:
          let type = builtins.typeOf value; in
          if type == "set"
          then "${indentPad indent}${name} {\n${setToKdl (indent + 1) value}\n${indentPad indent}}"
          else if type == "list"
          then "${indentPad indent}${name} ${builtins.concatStringsSep " " (builtins.map (arg: (toKdlValue arg)) value)}"
          else "${indentPad indent}${name} ${toKdlValue value}";
        setToKdl = indent: set:
          builtins.concatStringsSep "\n" (builtins.map (name: toKdlNode indent name (builtins.getAttr name set)) (builtins.attrNames set));
      in
      setToKdl 0 config;

    xdg.configFile."niri/config.kdl".text = lib.mkMerge [
      ''
        // This config is in the KDL format: https://kdl.dev
        // "/-" comments out the following node.
        // Check the wiki for a full description of the configuration:
        // https://github.com/YaLTeR/niri/wiki/Configuration:-Overview

        // Input device configuration.
        // Find the full list of options on the wiki:
        // https://github.com/YaLTeR/niri/wiki/Configuration:-Input
        input {
            keyboard {
                xkb {
                  layout "us"
                  variant "dvp"
                  options "lv3:ralt_switch,caps:escape"
                    // You can set rules, model, layout, variant and options.
                    // For more information, see xkeyboard-config(7).

                    // For example:
                    // layout "us,ru"
                    // options "grp:win_space_toggle,compose:ralt,ctrl:nocaps"
                }
            }

            // Next sections include libinput settings.
            // Omitting settings disables them, or leaves them at their default values.
            touchpad {
                // off
                tap
                // dwt
                // dwtp
                natural-scroll
                // accel-speed 0.2
                // accel-profile "flat"
                scroll-method "two-finger"
                tap-button-map "left-middle-right"
                // disabled-on-external-mouse
            }

            mouse {
                // off
                // natural-scroll
                accel-speed -0.88
                accel-profile "flat"
                // scroll-method "no-scroll"
            }

            // Uncomment this to make the mouse warp to the center of newly focused windows.
            warp-mouse-to-focus

            // Focus windows and outputs automatically when moving the mouse into them.
            // Setting max-scroll-amount="0%" makes it work only on windows already fully on screen.
            focus-follows-mouse max-scroll-amount="99%"

            workspace-auto-back-and-forth
        }

        // Settings that influence how windows are positioned and sized.
        // Find more information on the wiki:
        // https://github.com/YaLTeR/niri/wiki/Configuration:-Layout
        layout {
            // Set gaps around windows in logical pixels.
            gaps 16

            // When to center a column when changing focus, options are:
            // - "never", default behavior, focusing an off-screen column will keep at the left
            //   or right edge of the screen.
            // - "always", the focused column will always be centered.
            // - "on-overflow", focusing a column will center it if it doesn't fit
            //   together with the previously focused column.
            center-focused-column "never"

            // You can customize the widths that "switch-preset-column-width" (Mod+R) toggles between.
            preset-column-widths {
                // Proportion sets the width as a fraction of the output width, taking gaps into account.
                // For example, you can perfectly fit four windows sized "proportion 0.25" on an output.
                // The default preset widths are 1/3, 1/2 and 2/3 of the output.
                proportion 0.33333
                proportion 0.5
                proportion 0.66667

                // Fixed sets the width in logical pixels exactly.
                // fixed 1920
            }

            // You can change the default width of the new windows.
            default-column-width { proportion 0.5; }
            // If you leave the brackets empty, the windows themselves will decide their initial width.
            // default-column-width {}

            // By default focus ring and border are rendered as a solid background rectangle
            // behind windows. That is, they will show up through semitransparent windows.
            // This is because windows using client-side decorations can have an arbitrary shape.
            //
            // If you don't like that, you should uncomment `prefer-no-csd` below.
            // Niri will draw focus ring and border *around* windows that agree to omit their
            // client-side decorations.
            //
            // Alternatively, you can override it with a window rule called
            // `draw-border-with-background`.

            // You can change how the focus ring looks.
            focus-ring {
                // Uncomment this line to disable the focus ring.
                // off

                // How many logical pixels the ring extends out from the windows.
                width 4

                // Colors can be set in a variety of ways:
                // - CSS named colors: "red"
                // - RGB hex: "#rgb", "#rgba", "#rrggbb", "#rrggbbaa"
                // - CSS-like notation: "rgb(255, 127, 0)", rgba(), hsl() and a few others.

                // Color of the ring on the active monitor.
                active-color "#bc0000"

                // Color of the ring on inactive monitors.
                inactive-color "#505050"

                // You can also use gradients. They take precedence over solid colors.
                // Gradients are rendered the same as CSS linear-gradient(angle, from, to).
                // The angle is the same as in linear-gradient, and is optional,
                // defaulting to 180 (top-to-bottom gradient).
                // You can use any CSS linear-gradient tool on the web to set these up.
                // Changing the color space is also supported, check the wiki for more info.
                //
                // active-gradient from="#80c8ff" to="#bbddff" angle=45

                // You can also color the gradient relative to the entire view
                // of the workspace, rather than relative to just the window itself.
                // To do that, set relative-to="workspace-view".
                //
                // inactive-gradient from="#505050" to="#808080" angle=45 relative-to="workspace-view"
            }

            // You can also add a border. It's similar to the focus ring, but always visible.
            border {
                // The settings are the same as for the focus ring.
                // If you enable the border, you probably want to disable the focus ring.
                off

                width 4
                active-color "#ffc87f"
                inactive-color "#505050"

                // active-gradient from="#ffbb66" to="#ffc880" angle=45 relative-to="workspace-view"
                // inactive-gradient from="#505050" to="#808080" angle=45 relative-to="workspace-view"
            }

            // Struts shrink the area occupied by windows, similarly to layer-shell panels.
            // You can think of them as a kind of outer gaps. They are set in logical pixels.
            // Left and right struts will cause the next window to the side to always be visible.
            // Top and bottom struts will simply add outer gaps in addition to the area occupied by
            // layer-shell panels and regular gaps.
            struts {
                // left 64
                // right 64
                // top 64
                // bottom 64
            }
        }

        // Add lines like this to spawn processes at startup.
        // Note that running niri as a session supports xdg-desktop-autostart,
        // which may be more convenient to use.
        // See the binds section below for more spawn examples.
        spawn-at-startup "xwayland-satellite"
        spawn-at-startup "swaync"
        spawn-at-startup "udiskie"
        spawn-at-startup "waybar"
        spawn-at-startup "xwaylandvideobridge"
        spawn-at-startup "wl-clip-persist" "--clipboard" "both"
        spawn-at-startup "wl-paste" "--watch" "cliphist" "store"
        spawn-at-startup "sh" "-c" "swww init; swww img ${../../assets/wallpaper_dredge.jpg}"
        spawn-at-startup "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
        spawn-at-startup "webcord"

        // Uncomment this line to ask the clients to omit their client-side decorations if possible.
        // If the client will specifically ask for CSD, the request will be honored.
        // Additionally, clients will be informed that they are tiled, removing some rounded corners.
        prefer-no-csd

        // You can change the path where screenshots are saved.
        // A ~ at the front will be expanded to the home directory.
        // The path is formatted with strftime(3) to give you the screenshot date and time.
        screenshot-path "~/Pictures/Screenshots/Screenshot_%Y-%m-%d_%H-%M-%S.png"

        // You can also set this to null to disable saving screenshots to disk.
        // screenshot-path null

        // Animation settings.
        // The wiki explains how to configure individual animations:
        // https://github.com/YaLTeR/niri/wiki/Configuration:-Animations
        animations {
            // Uncomment to turn off all animations.
            // off

            // Slow down all animations by this factor. Values below 1 speed them up instead.
            // slowdown 3.0
        }

        // Window rules let you adjust behavior for individual windows.
        // Find more information on the wiki:
        // https://github.com/YaLTeR/niri/wiki/Configuration:-Window-Rules

        // Work around WezTerm's initial configure bug
        // by setting an empty default-column-width.
        window-rule {
            // This regular expression is intentionally made as specific as possible,
            // since this is the default config, and we want no false positives.
            // You can get away with just app-id="wezterm" if you want.
            match app-id=r#"^org\.wezfurlong\.wezterm$"#
            default-column-width {}
        }

        // Example: block out two password managers from screen capture.
        // (This example rule is commented out with a "/-" in front.)
        /-window-rule {
            match app-id=r#"^org\.keepassxc\.KeePassXC$"#
            match app-id=r#"^org\.gnome\.World\.Secrets$"#

            block-out-from "screen-capture"

            // Use this instead if you want them visible on third-party screenshot tools.
            // block-out-from "screencast"
        }

        window-rule {
          match at-startup=true app-id=r#"^WebCord$"#
          open-on-workspace "scratch"
        }

        workspace "scratch" {
          open-on-output "DP-1"
        }

        binds {
            // Keys consist of modifiers separated by + signs, followed by an XKB key name
            // in the end. To find an XKB name for a particular key, you may use a program
            // like wev.
            //
            // "Mod" is a special modifier equal to Super when running on a TTY, and to Alt
            // when running as a winit window.
            //
            // Most actions that you can bind here can also be invoked programmatically with
            // `niri msg action do-something`.

            Mod+T { spawn "alacritty"; }
            Mod+Space { spawn "fuzzel"; }
            Mod+V { spawn "sh" "-c" "cliphist list | fuzzel -d | cliphist decode | wl-copy"; }

            // You can also use a shell. Do this if you need pipes, multiple commands, etc.
            // Note: the entire command goes as a single argument in the end.
            // Mod+T { spawn "bash" "-c" "notify-send hello && exec alacritty"; }

            // Example volume keys mappings for PipeWire & WirePlumber.
            // The allow-when-locked=true property makes them work even when the session is locked.
            XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+"; }
            XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-"; }
            XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
            XF86AudioMicMute     allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }
            XF86MonBrightnessUp   { spawn "brightnessctl" "set" "5%+"; }
            XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }

            Mod+Q { close-window; }

            // focus commands
            Mod+E     { focus-column-left; }
            Mod+J     { focus-window-down-or-column-left; }
            Mod+K     { focus-window-up-or-column-right; }
            Mod+U     { focus-column-right; }

            Mod+O     { focus-monitor-left; }
            Mod+I     { focus-monitor-right; }

            Mod+Period { focus-workspace "scratch"; }

            Mod+Ctrl+J { focus-workspace-down; }
            Mod+Ctrl+K { focus-workspace-up; }

            // move commands
            Mod+Shift+E { consume-or-expel-window-left; }
            Mod+Shift+J { move-window-down; }
            Mod+Shift+K { move-window-up; }
            Mod+Shift+U { consume-or-expel-window-right; }

            Mod+Shift+O { move-window-to-monitor-left; }
            Mod+Shift+I { move-window-to-monitor-right; }

            Mod+Shift+Period { move-window-to-workspace "scratch"; }
            // Mod+Comma  { consume-window-into-column; }
            Mod+Comma { expel-window-from-column; }

            Mod+Shift+Ctrl+J { move-window-to-workspace-down; }
            Mod+Shift+Ctrl+K { move-window-to-workspace-up; }

            Mod+M { maximize-column; }
            Mod+F { fullscreen-window; }
            Mod+C { center-column; }



            Mod+R { switch-preset-column-width; }
            Mod+Shift+R { reset-window-height; }


            // Finer width adjustments.
            // This command can also:
            // * set width in pixels: "1000"
            // * adjust width in pixels: "-5" or "+5"
            // * set width as a percentage of screen width: "25%"
            // * adjust width as a percentage of screen width: "-10%" or "+10%"
            // Pixel sizes use logical, or scaled, pixels. I.e. on an output with scale 2.0,
            // set-column-width "100" will make the column occupy 200 physical screen pixels.
            Mod+Left { set-column-width "-10%"; }
            Mod+Right { set-column-width "+10%"; }
            Mod+Down { set-window-height "-10%"; }
            Mod+Up { set-window-height "+10%"; }

            // Actions to switch layouts.
            // Note: if you uncomment these, make sure you do NOT have
            // a matching layout switch hotkey configured in xkb options above.
            // Having both at once on the same hotkey will break the switching,
            // since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
            // Mod+Space       { switch-layout "next"; }
            // Mod+Shift+Space { switch-layout "prev"; }

            Mod+Shift+S { screenshot; }

            // The quit action will show a confirmation dialog to avoid accidental exits.
            Mod+Ctrl+Shift+Q { quit; }
        }

        environment {
          MOZ_ENABLE_WAYLAND "1"
          QT_QPA_PLATFORM "wayland;xcb"
          GDK_BACKEND "wayland,x11"
          SDL_VIDEODRIVER "wayland"
          CLUTTER_BACKEND "wayland"
          NIXOS_OZONE_WL "1"
          QT_WAYLAND_DISABLE_WINDOWDECORATION "1"
          DISPLAY ":0"
        }
      ''
      (lib.mkIf (cfg.setup == "desktop") (builtins.readFile ./desktop.kdl))
    ]
    ;

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      QT_QPA_PLATFORM = "wayland;xcb";
      GDK_BACKEND = "wayland,x11";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      NIXOS_OZONE_WL = 1;
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    };
  };
}
