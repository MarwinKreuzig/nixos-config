{ pkgs, ... }:
{
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    curl
    killall
    btop
    bottom
    ripgrep
    fd
    trashy
    eza
    unzip
    unrar
    lsd
    bat
    dust
    tldr
  ];

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };
}
