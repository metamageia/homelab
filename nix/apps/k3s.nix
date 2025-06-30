{ config, pkgs, ... }:
{
    networking.firewall.allowedTCPPorts = [
        6443 #k3s
    ];

    environment.systemPackages = with pkgs; [
        k3s
    ];

    services.k3s = {
        enable = true;
        role = "server";
    };
}