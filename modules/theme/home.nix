{ pkgs, config, lib, ... }:
{
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.flat-remix-icon-theme;
      name = "Flat-Remix-Red-Light";
    };
  };

  qt = {
    enable = true;
  };

  home.pointerCursor = {
    enable = true;
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 32;
    gtk.enable = true;
  };

  stylix = {
    enable = true;
    polarity = "light";

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
    image = ../../assets/ViktoriaLuiseWallpaper.jpg;
  };
}
