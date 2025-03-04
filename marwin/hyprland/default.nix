{ config, pkgs, lib, inputs, ... }:
let
  cfg = config.home.hyprland;
in
{
  imports = [
    ./nvidia.nix
    ./desktop.nix
    ./laptop0.nix
    ./hyprlock
  ];

  options.home.hyprland = {
    enable = lib.mkEnableOption "hyprland window manager";
    setup = lib.mkOption {
      type = lib.types.uniq lib.types.str;
      default = "";
    };
    nvidia = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      settings = {
        general = {
          layout = "master";
          border_size = 2;
          "col.active_border" = "rgb(f00040) rgb(4000f0)";
          gaps_out = 5;
        };
        # get rid of xwayland pixelated look
        xwayland.force_zero_scaling = true;
        # hyprlands explicit sync is bugged
        render.explicit_sync = true;
        monitor = [ ", preferred, auto, 1" ];

        decoration = {
          rounding = 10;
          inactive_opacity = 0.6;
          active_opacity = 0.9;
          drop_shadow = false;
          dim_inactive = false;

          blur = {
            enabled = true;
            size = 10;
            passes = 2;
            new_optimizations = true;
            ignore_opacity = true;
            noise = 0;
            brightness = 2.0;
            vibrancy = 2.0;
          };
        };
        windowrulev2 = [
          "opacity 1.0 override 0.9 override,noblur,class:^(firefox)$"
          "opacity 1.0 override 0.9 override,noblur,class:^(ff).*$"
          # "opacity 0.7 override 1.0,class:^(Alacritty)$"
          "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
          "noanim,class:^(xwaylandvideobridge)$"
          "nofocus,class:^(xwaylandvideobridge)$"
          "noinitialfocus,class:^(xwaylandvideobridge)$"
          "maxsize 1 1, class:^(xwaylandvideobridge)$"
          "noblur, class:^(xwaylandvideobridge)$"
          "float,title:^(Windowed Projector).*$,class:^(com\\.obsproject\\.Studio)$"
        ];

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        input = {
          kb_layout = "us";
          kb_variant = "dvp";
          kb_model = "";
          kb_options = "lv3:ralt_switch,caps:escape";
          kb_rules = "";

          follow_mouse = 1;
          touchpad = {
            natural_scroll = "yes";
            tap_button_map = "lmr";
          };

          sensitivity = -0.88; # -0.939 for 3600 dpi
          accel_profile = "flat";
        };

        "$mod" = "SUPER";
        "$terminal" = "alacritty";
        "$menu" = "tofi --terminal=\"$terminal -e\"";
        "$menu-drun" = "tofi-drun --terminal=\"$terminal -e\"";
        bind = [
          "$mod, F1, exec, ${./gamemode.sh}"

          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"

          ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
          ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"

          # navigation
          "$mod, K, layoutmsg, cycleprev"
          "$mod, J, layoutmsg, cyclenext"

          # workspaces
          "$mod_CONTROL, K, workspace, r+1"
          "$mod_CONTROL, J, workspace, m-1"
          "$mod, code:26, togglespecialworkspace"
          "$mod_SHIFT, code:26, movetoworkspace, special"
          "$mod_CONTROL, UP, movetoworkspace, r+1"
          "$mod_CONTROL, DOWN, movetoworkspace, m-1"

          # layout manipulation
          "$mod, UP, resizeactive, 0 -50"
          "$mod, DOWN, resizeactive, 0 50"
          "$mod, LEFT, resizeactive, -50 0"
          "$mod, RIGHT, resizeactive, 50 0"
          "$mod, E, layoutmsg, focusmaster auto"
          "$mod, M, layoutmsg, swapwithmaster auto"
          "$mod_SHIFT, J, layoutmsg, swapnext"
          "$mod_SHIFT, K, layoutmsg, swapprev"

          # utils
          "$mod_SHIFT, S, exec, grimblast copy area"
          "$mod, Q, killactive"
          "$mod, S, togglefloating, active"
          "$mod, F, fullscreen"
          "$mod_SHIFT, F, fullscreen" # should be fakefullscreen but hyprland is broken
          "$mod, T, exec, $terminal"
          "$mod_CONTROL_SHIFT, Q, exit"

          "$mod, Space, exec, $menu-drun | xargs hyprctl dispatch exec --"
          "$mod, V, exec, cliphist list | $menu | cliphist decode | wl-copy"

          "$mod, F8, submap, mcsr"
        ];
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        exec-once = [
          "swaync"
          "udiskie &"
          "waybar"
          "xwaylandvideobridge"
          "wl-clip-persist --clipboard both"
          "wl-paste --watch cliphist store"
          "swww init; swww img ${./wallpaper_dredge.jpg}"
          "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"

          "[workspace 1] firefox"
          "[workspace special silent] webcord"
        ];
      };
      extraConfig = ''
        submap = mcsr

        bind = , code:49, exec, sh ${./eyes.sh}
        bindr = ALT, Alt_L, exec, sh ${./mapless.sh}

        bind = $mod, ESCAPE, submap, reset
        submap = reset
      '';
    };
    home.packages = [
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    ];

    home.shellAliases = {
      hyprland = "Hyprland";
    };

    home.sessionVariables = {
      # make firefox run on wayland
      MOZ_ENABLE_WAYLAND = 1;
      # make QT run on wayland (might be unnecessary)
      QT_QPA_PLATFORM = "wayland;xcb";
      # make GTK run on wayland
      GDK_BACKEND = "wayland,x11";
      # make SDL2 run on wayland
      SDL_VIDEODRIVER = "wayland";
      # make clutter applications (whatever that even is) run on wayland
      CLUTTER_BACKEND = "wayland";
      # make chromium work on wayland
      NIXOS_OZONE_WL = 1;

      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";

      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    };
  };
}
