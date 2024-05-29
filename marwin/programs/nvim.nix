{ pkgs, ... }:
{
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };

  home.packages = with pkgs; [
    nvim-pkg
  ];
}
