{ pkgs, options, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = options.programs.nix-ld.libraries.default ++ (with pkgs; [
      # dynamic libraries for nix-ld
      libGL

      # needed for FoundryVTT
      glib
      nss
      nspr
      libx11
      libxcb
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxi
      libxrender
      libxtst
      cups
      dbus
      expat
      libxscrnsaver
      libxrandr
      alsa-lib
      pango
      cairo
      at-spi2-atk
      gtk3
      gdk-pixbuf
    ]);
  };
}
