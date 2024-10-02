{ lib, pkgs, ... }:
{
  # This is probably a terrible idea, but I'm bored.
  # Setup for Minecraft Speedrunning on NixOS
  home.packages = with pkgs; [
    jre8
    # record your speedruns
    obs-studio
    # modcheck
    (callPackage ./modcheck/default.nix {})
    # wall resetting macro
    (callPackage buildGoModule rec {
      pname = "resetti";
      version = "0.6.0";
      src = fetchFromGitHub {
        owner = "tesselslate";
        repo = "resetti";
        rev = "v${version}";
        hash = "sha256-wST5vGEhQvO2YBYydYKPb22qotS2NWlgySE1Z9Dx2TU=";
      };
      vendorHash = "sha256-syCGAlmiXXrubmPdipi3pJP1mXgpPFVr8N7Tgu16d+E=";
      meta = {
        description = "resetti is a Linux-compatible reset macro for Minecraft speedruns. It supports a variety of different resetting styles, categories, and Minecraft versions.";
        homepage = "https://github.com/tesselslate/resetti";
        license = lib.licenses.gpl3Only;
      };
    })
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
