{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zed-editor
    # jetbrains.rust-rover
    # jetbrains.idea-ultimate
    # jetbrains.gateway
  ];

  # create a path to global install npm binaries to
  # use with `npm set prefix ~/.npm-global`
  # see also https://nixos.wiki/wiki/Node.js
  home.sessionPath = [
    "$HOME/.npm-global/bin"
  ];
}
