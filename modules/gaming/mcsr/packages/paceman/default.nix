{ pkgs }:
with pkgs; (
  stdenv.mkDerivation (finalAttrs: rec {
    pname = "paceman-tracker";
    version = "0.7.1";

    src = fetchurl {
      url = "https://github.com/PaceMan-MCSR/PaceMan-Tracker/releases/download/v${version}/paceman-tracker-0.7.1.jar";
      hash = "sha256-xsdDvFoBpBqOEVwadQjuFpImh+6TH8XEUELAqUJvb2I=";
    };
    dontUnpack = true;

    nativeBuildInputs = [ copyDesktopItems makeWrapper ];

    buildPhase = "true";

    desktopItems = [
      (pkgs.makeDesktopItem {
        name = "paceman-tracker";
        type = "Application";
        exec = "paceman-tracker";
        comment = "A standalone application or Julti plugin to track and upload runs to PaceMan.gg.";
        desktopName = "PaceMan Tracker";
        genericName = "An application to track and upload runs";
        categories = [ "Game" ];
      })
    ];

    installPhase = ''
      install -m 644 -D $src "$out/share/modcheck/paceman-tracker-${version}.jar"

      # alternative to jetbrains jdk: use _JAVA_AWT_WM_NONREPARENTING=1
      makeWrapper ${jetbrains.jdk}/bin/java $out/bin/paceman-tracker \
        --add-flags "-jar $out/share/modcheck/paceman-tracker-${version}.jar"

      runHook postInstall
    '';

    meta.sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
    ];
  })
)
