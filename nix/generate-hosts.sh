#!/usr/bin/env bash
jq -r '
  .homelab_machines.value | to_entries | map(
    "  \"" + .key + "\" = { deployment.targetHost = \"" + .value.ip + "\"; role = \"" + .value.role + "\"; };"
  ) | join("\n") | "{\n" + . + "\n}"
' terraform-hosts.json > ./terraform-hosts.nix