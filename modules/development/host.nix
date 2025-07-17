{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.nvim-nix-config.overlays.default
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
