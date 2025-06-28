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
        ./auto-update.sh
    '';
    serviceConfig = {
        Type = "oneshot";
    };
    path = [ pkgs.nixos-rebuild ];
    };


}
