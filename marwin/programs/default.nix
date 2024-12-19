{ pkgs, inputs, ... }:

{
  imports = [
    ./mcsr
    ./wlogout.nix
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
    nerd-fonts.fira-code
    font-awesome
    # clipboard
    cliphist
    wl-clipboard
    # system management guis
    networkmanagerapplet
    pavucontrol
    # screen keyboard
    onboard
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
    vesktop
    signal-desktop
    alsa-oss
    (firefox.override { nativeMessagingHosts = [ inputs.pipewire-screenaudio.packages.${pkgs.system}.default ]; })
    obsidian

    # games
    # glfw-wayland-minecraft
    prismlauncher
  ];
}
