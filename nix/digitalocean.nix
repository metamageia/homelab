{ config, pkgs, ... }:
let
  sshPubKey = builtins.readFile ../secrets/ssh.pub;
in 
{

  system.stateVersion = "24.05";

  networking.hostName = "do-nixos";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [ sshPubKey ];
}
