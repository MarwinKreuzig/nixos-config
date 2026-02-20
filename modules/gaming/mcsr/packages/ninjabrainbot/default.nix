{ pkgs }:
pkgs.maven.buildMavenPackage rec {
  pname = "ninjabrainbot";
  version = "1.5.1";
  src = pkgs.fetchFromGitHub {
    owner = "Ninjabrain1";
    repo = "Ninjabrain-Bot";
    rev = version;
    hash = "sha256-r8TpL3VLf2QHwFS+DdjxgxyuZu167fP6/lN7a8e9opM=";
  };
  mvnHash = "sha256-2+p4ReD1M3VuyTu4TmCx9xrFf2QFm/FFBgs7a2eIpZY=";

  desktopItems = [
    (pkgs.makeDesktopItem {
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

  nativeBuildInputs = [ pkgs.copyDesktopItems pkgs.makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/ninjabrainbot
    install -Dm644 target/ninjabrainbot-${version}-jar-with-dependencies.jar $out/share/ninjabrainbot

    makeWrapper ${pkgs.jre}/bin/java $out/bin/ninjabrainbot \
      --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath (with pkgs; [ 
        libxkbcommon 
        xorg.libX11 
        xorg.libXt 
        xorg.libXtst
        xorg.libXinerama
        xorg.libxcb
      ])}" \
      --add-flags "-DSwing.aatext=TRUE -Dswing.defaultlaf=javax.swing.plaf.metal.MetalLookAndFeel -Dawt.useSystemAAFontSettings=on -jar $out/share/ninjabrainbot/ninjabrainbot-${version}-jar-with-dependencies.jar -Djava.util.prefs.userRoot=$HOME/.config/ninjabrainbot"

    runHook postInstall
  '';
}
