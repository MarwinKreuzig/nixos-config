{ pkgs, inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.nvim-nix-config.overlays.default
    # FIX for nixpkgs build failure
    (final: prev: {
      jdk8 = prev.jdk8.overrideAttrs {
        separateDebugInfo = false;
        __structuredAttrs = false;
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    # basic stuff
    git
    wget
    curl
    killall
    btop
    ripgrep
    fd
    trashy

    nix-output-monitor
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      font-awesome
      nerd-fonts.fira-code
      ubuntu_font_family
    ];
  };

  programs.nh = {
    enable = true;
    flake = "/home/marwin/nixos";
  };

  programs.fish.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.partition-manager.enable = true;

  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  programs.gamemode.enable = true;

  # GTK configuration
  programs.dconf.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
