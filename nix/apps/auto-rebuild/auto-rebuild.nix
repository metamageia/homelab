{ pkgs, config, hostName, ... }:

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
        #!/usr/bin/env bash

        REPO_DIR="/.dotfiles"
        UPDATE_COMMAND="sudo nixos-rebuild switch --flake .#"

        cd "$REPO_DIR"

        BEFORE=$(git rev-parse HEAD)

        git fetch origin
        git reset --hard origin/main

        AFTER=$(git rev-parse HEAD)

        if [[ "$BEFORE" != "$AFTER" ]]; then
            echo "Changes were pulled. Running update command..."
            $UPDATE_COMMAND
            else
            echo "No changes detected. Nothing to do."
            fi
    '';
    serviceConfig = {
        Type = "oneshot";
    };
    path = [ pkgs.nixos-rebuild pkgs.git];
    };


}
