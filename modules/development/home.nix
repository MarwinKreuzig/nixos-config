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
    zed-editor
  ];

  # create a path to global install npm binaries to
  # use with `npm set prefix ~/.npm-global`
  # see also https://nixos.wiki/wiki/Node.js
  home.sessionPath = [
    "$HOME/.npm-global/bin"
  ];
}
