{ lib, pkgs, ... }:
{
  # This is probably a terrible idea, but I'm bored.
  # Setup for Minecraft Speedrunning on NixOS
  home.packages = with pkgs; [
    jre8
    # record your speedruns
    obs-studio
    # modcheck
    (callPackage ./modcheck/default.nix { })
    # ninjabrain bot
    (
      callPackage maven.buildMavenPackage rec {
        pname = "ninjabrainbot";
        version = "1.5.1";
        src = pkgs.fetchFromGitHub {
          owner = "Ninjabrain1";
          repo = "Ninjabrain-Bot";
          rev = version;
          hash = "sha256-r8TpL3VLf2QHwFS+DdjxgxyuZu167fP6/lN7a8e9opM=";
        };
        mvnHash = "sha256-zAVPH5a7ut21Ipz5BUY6cnRLT52bM8Yo2r8ClFon1p0=";

        desktopItems = [
          (makeDesktopItem {
            name = "ninjabrainbot";
            type = "Application";
            exec = "ninjabrainbot";
            comment = "An accurate stronghold calculator for Minecraft speedrunning.";
            desktopName = "Ninjabrain Bot";
            genericName = "A Minecraft stronghold calculator";
            categories = [ "Game" ];
          })
        ];

        mvnDepsParameters = "assembly:single -DskipTests=true";
        mvnParameters = "assembly:single -DskipTests=true";

        nativeBuildInputs = [ copyDesktopItems makeWrapper ];

        installPhase = ''
          runHook preInstall

          mkdir -p $out/bin $out/share/ninjabrainbot
          install -Dm644 target/ninjabrainbot-${version}-jar-with-dependencies.jar $out/share/ninjabrainbot

          makeWrapper ${jre}/bin/java $out/bin/ninjabrainbot \
            --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libxkbcommon xorg.libX11 xorg.libXt ]}" \
            --add-flags "-jar $out/share/ninjabrainbot/ninjabrainbot-${version}-jar-with-dependencies.jar"

          runHook postInstall
        '';
      }
    )
  ];
}
