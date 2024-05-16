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
    user = {
      name = "caleb";
      fullName = "Caleb Stewart";
      email = "caleb.stewart94@gmail.com";
    };

    # Function to uniformly define a system based on it's hostname and
    # platform name.
    makeSystem = {hostname, system, user}:
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
                inherit user;
              };
              users.${user.name} = (./. + "/hosts/${hostname}/user.nix");
            };
          }
        ];

        specialArgs = {
          inherit inputs;
          inherit user;
        };
      };
  in {
    nixosConfigurations = {
      framework16 = makeSystem {
        inherit user;
        hostname = "framework16";
        system = "x86_64-linux";
      };
      ryzen = makeSystem {
        inherit user;
        hostname = "ryzen";
        system = "x86_64-linux";
      };
    };
  };
}
