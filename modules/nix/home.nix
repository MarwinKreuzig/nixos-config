{ pkgs, ... }:
{
  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";

  home.packages = with pkgs; [
    pkgs.nixpkgs-fmt
  ];
}
