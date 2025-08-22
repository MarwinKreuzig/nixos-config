{ ... }:
{
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     # there's currently a build failure for jdk8
  #     jdk8 = prev.jdk8.overrideAttrs {
  #       separateDebugInfo = false;
  #       __structuredAttrs = false;
  #     };
  #   })
  # ];
  
  
  
  # see
  # https://github.com/ErikReider/SwayNotificationCenter/issues/619
  environment.sessionVariables = {
    GSK_RENDERER = "gl";
    GTK_DISABLE_VULKAN = 1;
  };
}
