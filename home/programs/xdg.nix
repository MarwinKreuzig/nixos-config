{ config, pkgs, ... }:
let
  browser = [ "firefox" ];
in
{
  home.packages = with pkgs; [ xdg-utils ];
  xdg = {
    enable = true;
    configFile."mimeapps.list".force = true;
    cacheHome = config.home.homeDirectory + "/.local/cache";
    mimeApps = {
      enable = true;
      defaultApplications = builtins.mapAttrs (_: v: (map (e: "${e}.desktop") v)) {
        "image/*" = [ "feh.desktop" ];
        "video/*" = [ "mpv.desktop" ];
        "application/x-extension-htm" = browser;
        "application/x-extension-html" = browser;
        "application/x-extension-shtml" = browser;
        "application/x-extension-xht" = browser;
        "application/x-extension-xhtml" = browser;
        "application/xhtml+xml" = browser;
        "text/html" = browser;
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/ftp" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/unknown" = browser;
        "application/json" = browser;
        "application/pdf" = browser;
        "inode/directory" = [ "nnn" ];
        "x-scheme-handler/discord" = [ "discord" ];
        "x-scheme-handler/jetbrains-gateway" = [ "jetbrains-gateway" ];
      };
    };

    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
      };
    };
  };
}
