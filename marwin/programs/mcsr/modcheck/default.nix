{ pkgs }:
with pkgs; (
      let self = stdenv.mkDerivation (finalAttrs: rec {
        pname = "modcheck";
        version = "3.0.1";

        src = fetchurl {
          url = "https://github.com/tildejustin/modcheck/releases/download/${version}/modcheck-${version}.jar";
          hash = "sha256-PD3F/xN/ZtE6GqW++fS7Kr9hyYv0IKIaXsRta5rt2/s=";
        };
        dontUnpack = true;

        nativeBuildInputs = [ makeWrapper ];

        buildPhase = "true";

        installPhase = ''
          install -m 644 -D $src "$out/share/modcheck/modcheck-${version}.jar"

          makeWrapper ${jre}/bin/java $out/bin/modcheck \
            --add-flags "-jar $out/share/modcheck/modcheck-${version}.jar"
        '';

        meta.sourceProvenance = with lib.sourceTypes; [
          binaryBytecode
        ];
      }); in
      self
    )
