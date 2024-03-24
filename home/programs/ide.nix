{ pkgs, nixpkgs-master, ... }:
{
  home.packages = with pkgs; [
    jetbrains.clion
    nixpkgs-master.jetbrains.rust-rover
    jetbrains.idea-ultimate
    jetbrains.gateway
    jetbrains-toolbox
  ];
}
