{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Marwin Kreuzig";
        email = "marwin@kreuzig.info";
      };
      init.defaultBranch = "main";
    };
  };
}
