{ config, pkgs, hostName, ... }:
{

  networking.hostName = hostName; 
  networking.networkmanager.enable = true;
  system.stateVersion = "24.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 

  environment.systemPackages = [
    pkgs.git
    pkgs.nano
  ];

  imports = [
    ./apps/cachix.nix
  ];

}