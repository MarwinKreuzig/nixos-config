{ pkgs, ... }:
{
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    curl
    killall
    btop
    ripgrep
    fd
    trashy
    eza
    unzip
    unrar
  ];
}
