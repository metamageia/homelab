{ config, pkgs, ... }:
{
    imports = [
        ./apps/k3s.nix
        #./apps/jellyfin.nix
    ];

    environment.systemPackages = with pkgs; [
    ];

}