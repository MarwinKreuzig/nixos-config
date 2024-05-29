{ pkgs, ... }:
{
  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Red-Light";
    };

    iconTheme = {
      package = pkgs.pop-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk3";
    style.name = "Flat-Remix-GTK-Red-Light";
  };
}
