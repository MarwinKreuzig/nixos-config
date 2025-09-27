{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      font-awesome
      nerd-fonts.fira-code
      jetbrains-mono
      ubuntu_font_family
      roboto
      roboto-mono
      inter
    ];
  };
}
