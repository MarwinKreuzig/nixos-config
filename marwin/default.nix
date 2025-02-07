{ lib, host, uses-nvidia, pkgs, ... }:
{
  options.home.settings = {
    discord = lib.mkOption {
      type = lib.types.str;
      default = "discord";
      description = "The command used to auto-start discord.";
    };
  };
  imports = [
    ./xdg.nix
    ./programs
    ./hyprland
    ./niri
    ./services
    ./theme
  ];
  config = {
    home.username = "marwin";
    home.homeDirectory = "/home/marwin";

    xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";

    home.hyprland.enable = false;
    home.hyprland.setup = host;
    home.hyprland.nvidia = uses-nvidia;

    home.niri = {
      enable = true;
      setup = host;
      nvidia = uses-nvidia;
    };

    home.settings.discord = "discord-canary";
    
    # make home-manager manage fonts
    fonts.fontconfig.enable = true;

    home.stateVersion = "23.05";
    programs.home-manager.enable = true;
  };
}
