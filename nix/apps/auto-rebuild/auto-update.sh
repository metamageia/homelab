#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="/.dotfiles"

UPDATE_COMMAND="sudo nixos-rebuild switch --flake .#"

cd "$REPO_DIR"

BEFORE=$(git rev-parse HEAD)

git pull --ff-only

AFTER=$(git rev-parse HEAD)

if [[ "$BEFORE" != "$AFTER" ]]; then
    echo "Changes were pulled. Running update command..."
    $UPDATE_COMMAND
else
    echo "No changes detected. Nothing to do."
fi
