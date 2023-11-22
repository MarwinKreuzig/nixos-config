{ pkgs, inputs, uses-nvidia, ... }:
{
  imports = [ 
    inputs.hyprland.homeManagerModules.default
    ./nvidia.nix 
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland.override {
      enableNvidiaPatches = uses-nvidia;
    };
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
