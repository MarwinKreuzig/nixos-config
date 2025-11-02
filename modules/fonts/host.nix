{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      font-awesome
      nerd-fonts.fira-code
      jetbrains-mono
      ubuntu-classic
      roboto
      roboto-mono
      inter
    ];
  };
}
