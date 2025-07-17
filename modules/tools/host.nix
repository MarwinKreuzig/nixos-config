{ ... }:
{
  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };

  programs.partition-manager.enable = true;
}
