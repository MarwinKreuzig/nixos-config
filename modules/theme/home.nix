{ pkgs, ... }:
{
  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Red-Light";
    };

    iconTheme = {
      package = pkgs.flat-remix-icon-theme;
      name = "Flat-Remix-Red-Light";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita";
    style.package = pkgs.adwaita-qt;
  };

  home.pointerCursor = {
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 32;
    gtk.enable = true;
  };

  xdg.configFile."alacritty/alacritty.toml".source = "${pkgs.alacritty-theme}/share/alacritty-theme/github_light_high_contrast.toml";

}
