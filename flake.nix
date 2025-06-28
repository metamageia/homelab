{
  description = "Homeserver development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    
    comin.url = "github:nlewo/comin";
    comin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, comin, ... }:
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
           comin.nixosModules.comin
          ({...}: {
            services.comin = {
              enable = true;
              remotes = [{
                name = "origin";
                url = "https://github.com/metamageia/homelab.git";
                branches.main.name = "main";
              }];
            };
          })
        ];
      };
      nixosConfigurations.homelab-control = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
                  specialArgs = {
            hostName = "homelab-control";
          };
        modules = [
          ./nix/core-configuration.nix
          ./nix/hosts/homelab-control.nix
           comin.nixosModules.comin
          ({...}: {
            services.comin = {
              enable = true;
              remotes = [{
                name = "origin";
                url = "https://github.com/metamageia/homelab.git";
                branches.main.name = "main";
              }];
            };
          })
        ];
      };
      packages.x86_64-linux.digitalOceanImage =
        self.nixosConfigurations.digitalocean.config.system.build.digitalOceanImage;
    };
}