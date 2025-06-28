{
  description = "Homeserver development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    
    comin.url = "github:nlewo/comin";
    comin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, comin, ... }@inputs:
    let
      system = "x86_64-linux";
    
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

    in {
      devShells.${system}.default = pkgs.mkShell {
      inherit system;
      buildInputs = [ pkgs.terraform ];
      shellHook = ''
        echo "Welcome to the Homeserver development environment!"
        set -a
        source ./secrets/.env
        set +a
      '';
      };

      nixosConfigurations.digitalocean = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        inherit pkgs;
        modules = [
          ./core-configuration.nix
        ];
      };

      nixosConfigurations.homelab-control = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        inherit pkgs;
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