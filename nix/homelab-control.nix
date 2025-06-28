{ config, pkgs, ... }:
{
    imports = [
        ./apps/k3s.nix
    ];

    environment.systemPackages = with pkgs; [
    ];

}