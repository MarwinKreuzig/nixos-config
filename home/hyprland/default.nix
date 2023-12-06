{ pkgs, inputs, uses-nvidia, ... }:
{
  imports = [ 
    inputs.hyprland.homeManagerModules.default
    ./nvidia.nix 
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = (builtins.readFile ./hyprland.conf)
    + ''
     exec-once = swww init && swww img ${./wallpaper.jpg}
     exec-once = sh ${./ff-start.sh}
     exec-once = ${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
    '';
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  home.shellAliases = {
    hyrland = "Hyprland";
  };

  home.sessionVariables = {
    # make firefox run on wayland
    MOZ_ENABLE_WAYLAND = 1;
    # make chromium work on wayland
    NIXOS_OZONE_WL = 1;
  };
}
