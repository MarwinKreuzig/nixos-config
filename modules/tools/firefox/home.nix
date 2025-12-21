{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    (firefox.override {
      nativeMessagingHosts = [
        inputs.pipewire-screenaudio.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    })
    (pkgs.makeDesktopItem {
      name = "firefox-p";
      desktopName = "Firefox Profile";
      exec = "${pkgs.writeScriptBin "firefox-p" "firefox -P"}/bin/firefox-p";
      terminal = true;
    })
  ];
}
