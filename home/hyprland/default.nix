{ pkgs, inputs, de-config, ... }:
{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./nvidia.nix
    ./desktop.nix
    ./laptop0.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      general = {
        layout = "master";
        border_size = 2;
        "col.active_border" = "rgb(f00040) rgb(4000f0)";
      };
      # get rid of xwayland pixelated look
      xwayland.force_zero_scaling = true;

      master = {
        new_is_master = false;
      };

      decoration = {
        rounding = 10;
        inactive_opacity = 0.6;
        active_opacity = 0.9;
        drop_shadow = false;
        dim_inactive = false;

        blur = {
          enabled = true;
          size = 10;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
          noise = 0;
          brightness = 0.9;
        };
      };
      windowrulev2 = [
        "opacity 1.0 override 0.9 override,noblur,class:^(firefox)$"
        "opacity 1.0 override 0.9 override,noblur,class:^(ff).*$"
        "opacity 0.8 override 1.0,class:^(Alacritty)$"
        "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "nofocus,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
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

        sensitivity = -0.939;
        accel_profile = "flat";
      };

      "$mod" = "SUPER";
      "$terminal" = "alacritty";
      "$menu" = "tofi --terminal=\"$terminal -e\"";
      "$menu-drun" = "tofi-drun --terminal=\"$terminal -e\"";
      bind = [
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
        "$mod_SHIFT, F, fakefullscreen"
        "$mod, T, exec, $terminal"
        "$mod_CONTROL_SHIFT, Q, exit"

        "$mod, Space, exec, $menu-drun | xargs hyprctl dispatch exec --"
        "$mod, V, exec, cliphist list | $menu | cliphist decode | wl-copy"
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
        "swww init; swww img ${./wallpaper.jpg}"
        # This is horribly hacky, search.nixos.org doesn't even know that package, wtf is even going on
        "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
      ];
    };
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

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
}
