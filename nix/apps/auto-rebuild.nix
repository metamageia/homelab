{ pkgs, hostName, ... }:

{
 
    systemd.timers."auto-rebuild" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
            OnBootSec = "1m";
            OnUnitActiveSec = "1m";
        };
    };

    systemd.services."auto-rebuild" = {
        script = ''
            #!${pkgs.bash}/bin/bash
            nixos-rebuild switch --flake github:metamageia/homelab#$hostName
        '';
        serviceConfig = {
            Type = "oneshot";
        };
    };

}
