{
  description = "Homeserver development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      supportedSystems = [ "x86_64-linux" ];
    in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [ pkgs.terraform ];
          shellHook = ''
            echo "Welcome to the Homeserver development environment!"
          '';
        };
      }
    ) 
    {
      nixosConfigurations.homelab-control = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nix/homelab-control.nix
        ];
      };

      nixosConfigurations.digitalocean = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
          ./nix/digitalocean.nix
        ];
      };

      packages.x86_64-linux.digitalOceanImage =
        self.nixosConfigurations.digitalocean.config.system.build.digitalOceanImage;
    };
}