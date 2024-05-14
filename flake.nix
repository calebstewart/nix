{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors = {
      url = "github:misterio77/nix-colors";
    };
  };

  outputs = { nixpkgs, home-manager, nixvim, ... }@inputs:
  let
    # Function to uniformly define a system based on it's hostname and
    # platform name.
    makeSystem = {hostname, system, username}:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in 
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          { networking.hostName = hostname; }
          ./modules/system/configuration.nix
          (./. + "/hosts/${hostname}/hardware-configuration.nix")
          home-manager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
                inherit system;
                inherit username;
              };
              users.${username} = (./. + "/hosts/${hostname}/user.nix");
            };
          }
        ];

        specialArgs = {
          inherit inputs;
          inherit username;
        };
      };
  in {
    nixosConfigurations = {
      framework16 = makeSystem {
        hostname = "framework16";
        system = "x86_64-linux";
        username = "caleb";
      };
      ryzen = makeSystem {
        hostname = "ryzen";
        system = "x86_64-linux";
        username = "caleb";
      };
    };
  };
}
