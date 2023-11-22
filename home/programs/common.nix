{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    swaynotificationcenter
    waybar
    swww
    rofi
    xwaylandvideobridge
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    font-awesome
    # screenshots
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    # clipboard
    cliphist
    wl-clipboard

    eza

    direnv
    nix-your-shell
    nixpkgs-fmt

    steam
    discord
    glfw-wayland-minecraft
    prismlauncher
    (firefox.override { nativeMessagingHosts = [ inputs.pipewire-screenaudio.packages.${pkgs.system}.default ]; })
   ];

   programs.direnv = {
     enable = true;
     nix-direnv.enable = true;
   };
   
   fonts.fontconfig.enable = true;
}
