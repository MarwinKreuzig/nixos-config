{ pkgs, ... }: {
  imports = [
    ./modules.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "marwinlaptop0nixos";

  users.users.marwin = {
    isNormalUser = true;
    description = "Marwin Kreuzig";
    extraGroups = [ "networkmanager" "wheel" "tty" "audio" "video" ];
    packages = [ ];
    shell = pkgs.fish;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05";
}
