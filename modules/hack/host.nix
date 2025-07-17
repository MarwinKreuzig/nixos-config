{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      # there's currently a build failure for jdk8
      jdk8 = prev.jdk8.overrideAttrs {
        separateDebugInfo = false;
        __structuredAttrs = false;
      };
    })
  ];
}
