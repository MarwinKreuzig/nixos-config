{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zed-editor
    jetbrains.rust-rover
    jetbrains.idea-ultimate
    jetbrains.gateway
  ];
}
