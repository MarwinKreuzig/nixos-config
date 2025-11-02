{ pkgs }:
with pkgs; (stdenv.mkDerivation (finalAttrs: {
  pname = "lingle";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "Flammable-Bunny";
    repo = "Lingle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E1Kp9Cx63PTCvXI6R5NhfAPRhTJBkysMobYtSEjoZBo=";
  };

  nativeBuildInputs = [
    (gradle.override { java = jdk17; })
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "lingle";
      type = "Application";
      exec = "lingle";
      comment = "Lingle is an all purpose linux tool for mcsr, designed to setup and be used alongside Tesselslate's Waywall / Resseti";
      desktopName = "Lingle";
      genericName = "An all purpose linux tool for mcsr";
      categories = [ "Game" ];
    })
  ];

  # if the package has dependencies, mitmCache must be set
  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  # this is required for using mitm-cache on Darwin
  __darwinAllowLocalNetworking = true;

  gradleFlags = [ "-Dfile.encoding=utf-8" ];

  # defaults to "assemble"
  gradleBuildTask = "shadowJar";

  # will run the gradleCheckTask (defaults to "test")
  doCheck = true;

  installPhase = ''
    mkdir -p $out/{bin,share/lingle}
    cp build/libs/Lingle-${finalAttrs.version}.jar $out/share/lingle

    makeWrapper ${lib.getExe jetbrains.jdk} $out/bin/lingle \
      --add-flags "-jar $out/share/lingle/Lingle-${finalAttrs.version}.jar"

    runHook postInstall
  '';

  meta.sourceProvenance = with lib.sourceTypes; [
    fromSource
    binaryBytecode # mitm cache
  ];
}))
