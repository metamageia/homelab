{ config, pkgs, comin, ... }:
{
  imports = [
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