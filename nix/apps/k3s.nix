{ config, pkgs, ... }:
{
    networking.firewall.allowedTCPPorts = [
        6443 #k3s
    ];

    services.k3s = {
        enable = true;
        role = "server";
    };
}