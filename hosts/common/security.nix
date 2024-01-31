{ ... }:
{
  # make swaylock work, see https://nixos.wiki/wiki/Hyprland
  security.pam.services.swaylock = { };

  security.rtkit.enable = true;
}
