{ config, pkgs, hostName, ... }:
{

  networking.hostName = hostName; 
  networking.networkmanager.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 

  environment.systemPackages = [
    pkgs.git
    pkgs.nano
  ];

  imports = [
    "${nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
    ./cachix.nix
    comin.nixosModules.comin
    ({...}: {
      services.comin = {
        enable = true;
        remotes = [{
          name = "origin";
          url = "https://github.com/metamageia/homelab.git";
          branches.main.name = "main";
        }];
      };
    })
  ];

}