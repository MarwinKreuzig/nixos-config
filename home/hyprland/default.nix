{ pkgs, inputs, uses-nvidia, display-mode, ... }:
{
  imports = [ 
    inputs.hyprland.homeManagerModules.default
    ./nvidia.nix 
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      general = {
        layout = "master";
	border_size = 2;
	"col.active_border" = "rgb(f00040) rgb(4000f0)";
      };

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
	"noinitalfocus,class:^(xwaylandvideobridge)$"
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
	kb_options = "lv3:alt_switch, caps:escape";
	kb_rules = "";

	follow_mouse = 1;
	touchpad = {
	  natural_scroll = "no";
	};

	sensitivity = -1.0;
	accel_profile = "flat";
      };

      "$mod" = "SUPER";
      bind = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
	
	# navigation
	"$mod, K, layoutmsg, cycleprev"
	"$mod, J, layoutmsg, cyclenext"

	# workspaces
	"$mod_CONTROL, K, workspace, m+1"
	"$mod_CONTROL, J, workspace, m-1"
	"$mod, code:26, togglespecialworkspace"
	"$mod_SHIFT, code:26, movetoworkspace, special"

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
	"$mod, F, fullscreen"
	"$mod_SHIFT, F, fakefullscreen"
	"$mod, T, exec, alacritty"
	"$mod_CONTROL_SHIFT, Q, exit"

	"$mod, Space, exec, rofi -show drun"
	"$mod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
	"$mod, mouse:273, resizewindow"
      ];

      exec-once = [
        "swaync"
	"udiskie &"
	"waybar"
	"noisetorch"
	"wl-clip-persist --clipboard both"
	"wl-paste --watch cliphist store"
        "swww init && swww img ${./wallpaper.jpg}"
	"sh ${./ff-start.sh}"
	"${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
      ];
    } // import ./${display-mode}.nix;
    extraConfig = (builtins.readFile ./hyprland.conf);
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  home.shellAliases = {
    hyprland = "Hyprland";
  };

  home.sessionVariables = {
    # make firefox run on wayland
    MOZ_ENABLE_WAYLAND = 1;
    # make chromium work on wayland
    NIXOS_OZONE_WL = 1;
  };
}
