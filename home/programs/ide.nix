{ pkgs, nixpkgs-master, ... }:
{
  home.packages = with pkgs; [
    zed-editor
    nixpkgs-master.jetbrains.rust-rover
    jetbrains.idea-ultimate
    jetbrains.gateway
    jetbrains-toolbox
  ];
}
