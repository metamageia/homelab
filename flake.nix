{
  description = "Homeserver development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
 
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
        specialArgs = {
          hostName = digitalocean;
          inherit comin;
        };
        modules = [
          "${nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
          ./nix/core-configuration.nix
        ];
      };

      nixosConfigurations.homelab-control = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          hostName = "homelab-control";
          inherit comin;
        };
        modules = [
          "${nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
          ./nix/core-configuration.nix
          ./nix/homelab-control.nix
        ];
      };

      packages.x86_64-linux.digitalOceanImage =
        self.nixosConfigurations.digitalocean.config.system.build.digitalOceanImage;

    };
}