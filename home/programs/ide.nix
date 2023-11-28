{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jetbrains.clion
    jetbrains.rust-rover
    jetbrains.idea-ultimate
    jetbrains.gateway
    jetbrains-toolbox
  ];
}
