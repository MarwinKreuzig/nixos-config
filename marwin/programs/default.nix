{ pkgs, inputs, ... }:

{
  imports = [
    ./git.nix
    ./alacritty.nix
    ./ide.nix
    ./nvim.nix
    ./shell
    ./waybar
    ./tofi
  ];

  home.packages = with pkgs; [
    swaynotificationcenter
    swww
    xwaylandvideobridge
    udiskie
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

    nixpkgs-fmt

    # necessary for thumbnails in dolphin to work
    kdePackages.kio-extras-kf5
    dolphin

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
  ];
}
