{ ... }:
{
  services.ssh-agent.enable = true;

  programs.ssh.enable = true;
  programs.ssh.extraConfig = "
    Host github
      Hostname      github.com
      User git
      IdentityFile  ~/.ssh/id_ed25519

    Host github-work
      Hostname      github.com
      User git
      IdentityFile  ~/.ssh/id_ed25519_cprosoft
  ";
}
