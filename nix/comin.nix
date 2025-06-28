{ config, pkgs, comin, ... }:
{
  environment.systemPackages = [
    comin.nixosModules.comin
  ];
}