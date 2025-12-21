{ ... }:
{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    # FIXME: @wheel should be all that is needed, but it doesn't seem to work?
    settings.trusted-users = [ "@wheel marwin root" ];
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.nh = {
    enable = true;
    flake = "/home/marwin/nixos";
  };
}
