{ pkgs }:
with pkgs; (
  stdenv.mkDerivation (finalAttrs: rec {
    pname = "modcheck";
    version = "3.1.1";

    src = fetchurl {
      url = "https://github.com/tildejustin/modcheck/releases/download/${version}/modcheck-${version}.jar";
      hash = "sha256-qAMZmoW74ExQls47GE2biiibTvHyKsOpXOJWu41q10k=";
    };
    dontUnpack = true;

    nativeBuildInputs = [ copyDesktopItems makeWrapper ];

    desktopItems = [
      (pkgs.makeDesktopItem {
        name = "modcheck";
        type = "Application";
        exec = "modcheck";
        comment = "Minecraft SpeedRun Mods Auto Installer/Updater";
        desktopName = "ModCheck";
        genericName = "Minecraft SpeedRun Mods Auto Installer/Updater";
        categories = [ "Game" ];
      })
    ];

    buildPhase = "true";

    installPhase = ''
      install -m 644 -D $src "$out/share/modcheck/modcheck-${version}.jar"

      makeWrapper ${jre}/bin/java $out/bin/modcheck \
        --add-flags "-jar $out/share/modcheck/modcheck-${version}.jar"

      runHook postInstall
    '';

    meta.sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
    ];
  })
)
