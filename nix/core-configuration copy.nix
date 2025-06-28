{ config, pkgs, hostName, comin, ... }:
{

  networking.hostName = hostName; 
  networking.networkmanager.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 

  environment.systemPackages = [
    pkgs.git
    pkgs.nano
  ];

  imports = [
    ./cachix.nix
    comin.nixosModules.comin
  ];

  services.comin = {
    enable = true;
    remotes = [{
      name = "origin";
      url = "https://github.com/metamageia/homelab.git";
      branches.main.name = "main";
    }];
  };
}