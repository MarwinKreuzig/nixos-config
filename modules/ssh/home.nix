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
  programs.ssh.enableDefaultConfig = false;
  programs.ssh.matchBlocks."*" = {
    forwardAgent = false;
    addKeysToAgent = "no";
    compression = false;
    serverAliveInterval = 0;
    serverAliveCountMax = 3;
    hashKnownHosts = false;
    userKnownHostsFile = "~/.ssh/known_hosts";
    controlMaster = "no";
    controlPath = "~/.ssh/master-%r@%n:%p";
    controlPersist = "no";
  };
}
