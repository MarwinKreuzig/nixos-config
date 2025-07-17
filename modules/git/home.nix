{ ... }:
{
  programs.git = {
    enable = true;
    userName = "Marwin Kreuzig";
    userEmail = "marwin@kreuzig.info";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
