{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    swaynotificationcenter
    waybar
    swww
    rofi
    xwaylandvideobridge
    udiskie
    polkit-kde-agent
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    font-awesome
    # screenshots
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    # clipboard
    cliphist
    wl-clipboard
    pavucontrol
    # system management guis
    networkmanagerapplet
    pavucontrol
    # system management clis
    brightnessctl

    eza
    unzip

    direnv
    nix-your-shell
    nixpkgs-fmt

    zoom-us
    bitwarden
    krita
    discord
    glfw-wayland-minecraft
    prismlauncher
    (firefox.override { nativeMessagingHosts = [ inputs.pipewire-screenaudio.packages.${pkgs.system}.default ]; })
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # enable command not found
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  fonts.fontconfig.enable = true;
}
