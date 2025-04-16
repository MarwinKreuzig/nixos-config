{ pkgs, inputs, ... }:

{
  imports = [
    ./firefox.nix
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
    kdePackages.xwaylandvideobridge
    udiskie
    nerd-fonts.fira-code
    font-awesome
    liberation-sans-narrow

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
    kdePackages.dolphin

    mpv
    feh
    zoom-us
    bitwarden
    krita
    discord-screenaudio
    vesktop
    discord-canary
    signal-desktop
    alsa-oss
    obsidian
    libreoffice

    # games
    # glfw-wayland-minecraft
    prismlauncher
  ];

  programs.thunderbird = {
    enable = true;
    profiles."Marwin Kreuzig" = {
      isDefault = true;
    };
  };
}
