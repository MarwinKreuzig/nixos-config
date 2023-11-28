{ config, pkgs, inputs, ... }:

{
  imports = [
    ./common.nix
    ./git.nix
    ./alacritty.nix
    ./ide.nix
    ./nvim/nvim.nix
    ./shell/shell.nix
    ./waybar/waybar.nix
    ./tofi/tofi.nix
    ./ironbar/ironbar.nix
  ];
}
