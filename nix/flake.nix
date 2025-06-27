{
  description = "Metamageia's personal NixOS flake.";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; 

    };
    
  outputs = { self, nixpkgs, stylix, home-manager, ... }@inputs:
    let 
      system = "x86_64-linux";
      lib = inputs.nixpkgs.lib;

      pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      };

    in {
          
      # --- Host-specific Configurations --- #
      nixosConfigurations = {
        homelab-control = lib.nixosSystem {
          inherit system;
          inherit pkgs;
          specialArgs = {
            hostName = "homelab-control";
          };
          modules = [ 
            ./hosts/digitalocean.nix
            ./hosts/homelab-control.nix
          ];
        }; 
      };
    };
}
