{ config, pkgs, ... }:
let
  browser = [ "firefox" ];
  image-viewer = [ "feh" ];
  associations = builtins.mapAttrs (_: v: (map (e: "${e}.desktop") v)) {
    "image/gif" = image-viewer;
    "image/jpeg" = image-viewer;
    "image/png" = image-viewer;
    "image/vnd.adobe.photoshop" = [ "krita" ];
    "image/webp" = image-viewer;

    "video/mp4" = [ "mpv" ];
    "video/ogg" = [ "mpv" ];
    "video/webm" = [ "mpv" ];
    "video/x-flv" = [ "mpv" ];
    "video/x-matroska" = [ "mpv" ];
    "video/x-ms-wmv" = [ "mpv" ];
    "video/x-ogm+ogg" = [ "mpv" ];
    "video/x-theora+ogg" = [ "mpv" ];

    "audio/aac" = [ "mpv" ];
    "audio/flac" = [ "mpv" ];
    "audio/mp4" = [ "mpv" ];
    "audio/mpeg" = [ "mpv" ];
    "audio/ogg" = [ "mpv" ];
    "audio/x-wav" = [ "mpv" ];

    "text/plain" = [ "nvim" ];
    "text/html" = browser;
    "text/markdown" = [ "nvim" ];
    "text/uri-list" = browser;

    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/x-extension-xht" = browser;
    "application/x-extension-xhtml" = browser;
    "application/xhtml+xml" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/unknown" = browser;
    "x-scheme-handler/chrome" = browser;

    "application/json" = browser;
    "application/pdf" = browser;

    "inode/directory" = [ "nemo" ];

    "x-scheme-handler/discord" = [ "discord" ];
    "x-scheme-handler/jetbrains-gateway" = [ "jetbrains-gateway" ];
  };
in
{
  home.packages = with pkgs; [ xdg-utils ];
  xdg = {
    enable = true;
    configFile."mimeapps.list".force = true;
    cacheHome = config.home.homeDirectory + "/.local/cache";
    mimeApps = {
      enable = true;
      defaultApplications = associations;
      associations.added = associations;
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
