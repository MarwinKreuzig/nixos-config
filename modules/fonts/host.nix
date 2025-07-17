{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      font-awesome
      nerd-fonts.fira-code
      ubuntu_font_family
    ];
  };
}
