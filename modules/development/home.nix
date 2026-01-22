{ pkgs, ... }:
{
  home.sessionVariables = {
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=\"$XDG_CONFIG_HOME\"/java";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.zed-editor = {
    enable = true;
    userSettings = {
      vim_mode = true;
      load_direnv = "shell_hook";
      soft_wrap = "editor_width";
      relative_line_numbers = true;
      inlay_hints = {
        enabled = true;
      };
      features = {
        copilot = false;
      };
      show_copilot_suggestions = false;
      agent = {
        enabled = false;
      };
      telemetry = {
        metrics = false;
      };
    };
  };

  programs.helix = {
    enable = true;
  };

  # create a path to global install npm binaries to
  # use with `npm set prefix ~/.npm-global`
  # see also https://nixos.wiki/wiki/Node.js
  home.sessionPath = [
    "$HOME/.npm-global/bin"
  ];
}
