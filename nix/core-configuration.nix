{ config, pkgs, hostName, ... }:
{

  networking.hostName = hostName; 
  networking.networkmanager.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 


}