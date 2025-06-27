{
  description = "Homeserver development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    colmena.url = "github:zhaofengli/colmena";
  };

  outputs = { self, nixpkgs, flake-utils, colmena, ... }:
    let
      supportedSystems = [ "x86_64-linux" ];
    in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [ pkgs.terraform pkgs.colmena ];
          shellHook = ''
            echo "Welcome to the Homeserver development environment!"
            set -a
            source ./secrets/.env
            set +a
          '';
        };
      }
    ) // {
      nixosConfigurations.digitalocean = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
          ./nix/hosts/digitalocean.nix
        ];
      };

      packages.x86_64-linux.digitalOceanImage =
        self.nixosConfigurations.digitalocean.config.system.build.digitalOceanImage;
    };
}