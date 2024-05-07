{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    swaynotificationcenter
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
    # file manager
    nnn

    eza
    unzip

    direnv
    nix-your-shell
    nixpkgs-fmt

    mpv
    feh
    zoom-us
    bitwarden
    krita
    discord-screenaudio
    webcord
    alsa-oss
    (firefox.override { nativeMessagingHosts = [ inputs.pipewire-screenaudio.packages.${pkgs.system}.default ]; })

    # games
    glfw-wayland-minecraft
    prismlauncher
    mindustry-wayland
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  gtk.enable = true;

  # enable command not found
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  fonts.fontconfig.enable = true;
}
