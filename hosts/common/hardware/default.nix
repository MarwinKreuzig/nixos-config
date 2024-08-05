{ ... }:
{
  imports = [
    ./nvidia.nix
    ./ssd.nix
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
