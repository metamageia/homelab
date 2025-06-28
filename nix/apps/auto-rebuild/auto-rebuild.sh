#!/usr/bin/env bash
set -euo pipefail

FLAKE_URI="github:metamageia/homelab"
FLAKE_LOCAL_DIR="/var/lib/nixos/flake-homelab"
STATE_FILE="/var/lib/nixos/last-flake-commit"

mkdir -p "$FLAKE_LOCAL_DIR"

# Clone or fetch latest
if [ ! -d "$FLAKE_LOCAL_DIR/.git" ]; then
  git clone --filter=blob:none --single-branch "https://github.com/metamageia/homelab.git" "$FLAKE_LOCAL_DIR"
else
  git -C "$FLAKE_LOCAL_DIR" fetch origin
fi

# Get latest commit hash
LATEST_COMMIT=$(git -C "$FLAKE_LOCAL_DIR" rev-parse origin/main)

# Read previously deployed commit hash
PREV_COMMIT=$(cat "$STATE_FILE" 2>/dev/null || echo "none")

if [ "$LATEST_COMMIT" = "$PREV_COMMIT" ]; then
  echo "Flake is up to date. No rebuild needed."
  exit 0
fi

# Rebuild using latest flake
echo "New commit found. Rebuilding..."
nixos-rebuild switch --flake "$FLAKE_LOCAL_DIR"

# Save new commit hash
echo "$LATEST_COMMIT" > "$STATE_FILE"
