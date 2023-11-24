{ config, pkgs, inputs, ... }:
{
  imports = [ ./hardware/nvidia.nix ];

  boot.loader.systemd-boot.configurationLimit = 10;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "dvorak-programmer";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "dvp";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marwin = {
    isNormalUser = true;
    description = "Marwin Kreuzig";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
    shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # basic stuff
    git
    wget
    curl
    killall
    btop

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

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  # music player daemon
  services.mpd = {
    enable = true;
    startWhenNeeded = true;
  };
  xdg.portal.wlr.enable = true;
  xdg.portal.enable = true;
  services.dbus.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "marwin" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
