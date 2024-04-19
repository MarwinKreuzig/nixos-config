{ pkgs, inputs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_vi_key_bindings
      set fish_greeting
      if command -q nix-your-shell
        nix-your-shell fish | source
      end
    '';
    shellAliases = {
      ls = "eza";
      # TODO: make these not host specific, then they can be used
      # upgrade-switch = "sudo -v; sudo nixos-rebuild switch --flake ~/nixos#desktop &| nom";
      # upgrade-boot = "sudo -v; sudo nixos-rebuild boot --flake ~/nixos#desktop &| nom";
    };
  };
  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./starship.toml);
  };

  programs.bash.enable = true;
}
