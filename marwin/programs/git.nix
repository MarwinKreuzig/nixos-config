{ config, pkgs, inputs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Marwin Kreuzig";
    userEmail = "marwin@kreuzig.info";
  };
}
