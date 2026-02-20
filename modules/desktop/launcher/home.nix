{ ... }:
{
  programs.vicinae = {
    enable = true;
    systemd.enable = true;
    settings = {
      theme = {
        light.name = "catppuccin-latte";
      };
    };
  };
}
