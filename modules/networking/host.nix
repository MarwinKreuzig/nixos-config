{ ... }:
{
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking = {
    networkmanager.enable = true;

    # Open ports in the firewall.
    firewall.enable = true;
    firewall.allowedTCPPortRanges = [
      # KDE Connect
      { from = 1714; to = 1764; }
    ];
    firewall.allowedUDPPortRanges = [
      # KDE Connect
      { from = 1714; to = 1764; }
    ];
  };
}
