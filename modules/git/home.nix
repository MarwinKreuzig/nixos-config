{ ... }:
{
  programs.git = {
    enable = true;
    includes = [
      {
        path = ./work.gitconfig;
        condition = "gitdir:~/Projects/CProSoft";
      }
    ];
    signing.format = "openpgp";
    settings = {
      user = {
        name = "Marwin Kreuzig";
        email = "marwin@kreuzig.info";
      };
      github = {
        user = "MarwinKreuzig";
      };
      init.defaultBranch = "main";
    };
  };
}
