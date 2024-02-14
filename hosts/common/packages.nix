{ pkgs, ... }:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # basic stuff
    git
    wget
    curl
    killall
    btop

    nix-output-monitor

    # needs to be a system package for some reason
    noisetorch

    # run non-native binaries
    (
      let base = pkgs.appimageTools.defaultFhsEnvArgs; in
      pkgs.buildFHSUserEnv (base // {
        name = "fhs";
        targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [ pkgs.pkg-config ];
        profile = "export FHS=1";
        runScript = "fish";
        extraOutputsToInstall = [ "dev" ];
      })
    )
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      font-awesome
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      ubuntu_font_family
    ];
  };



  programs.noisetorch.enable = true;

  programs.fish.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
