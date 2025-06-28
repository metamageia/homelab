{
  description = "Metamageia's personal NixOS flake.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; 
    colmena.url = "github:zhaofengli/colmena";
  };

  outputs = { self, nixpkgs, colmena, ... }@inputs:
    let 
      system = "x86_64-linux";
      lib = nixpkgs.lib;

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      generatedHosts = import ./terraform-hosts.nix;
    in {
      nixosConfigurations = {
        homelab-control = lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            hostName = "homelab-control";
          };
          modules = [ 
            ./hosts/digitalocean.nix
            ./hosts/homelab-control.nix
          ];
        }; 
      };

      colmena = {
        type = "colmena";
        meta.nixpkgs = nixpkgs;
        nodes = generatedHosts;
      };
    };
}
