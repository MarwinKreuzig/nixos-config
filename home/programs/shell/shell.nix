{ pkgs, inputs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      if command -q nix-your-shell
        nix-your-shell fish | source
      end
    '';
    shellAliases = {
      ls = "eza";
    };
  };
  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./starship.toml);
  };

  programs.bash.enable = true;
}
