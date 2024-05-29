{ host, uses-nvidia, ... }:

{
  home.username = "marwin";
  home.homeDirectory = "/home/marwin";

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";

  imports = [
    ./xdg.nix
    ./programs
    ./hyprland
    ./services
    ./theme
  ];

  home.hyprland.enable = true;
  home.hyprland.setup = host;
  home.hyprland.nvidia = uses-nvidia;

  # make home-manager manage fonts
  fonts.fontconfig.enable = true;

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
