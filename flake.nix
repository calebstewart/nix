{
  description = "Personal NixOS / Home-Manager / Nix-Darwin Modules";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    # nikstur-nixpkgs.url = "github:nikstur/nixpkgs?ref=systemd-256";
    nix-colors.url = "github:misterio77/nix-colors";
    nur.url = "github:nix-community/NUR";
    nix-std.url = "github:chessai/nix-std";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      # FIXME: Replace this after this PR is in nixos-unstable: https://nixpk.gs/pr-tracker.html?pr=319882
      # inputs.nixpkgs.follows = "nixpkgs";
    };


    # FIXME: Remove this when this PR is merged: https://github.com/viperML/nh/pull/92
    nh-extra-privesc.url = "github:henriquekirchheck/nh/4afff0d675a78f5c10f8839ac5897eb167f07cff";

    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      flake = false;
    };

    vfio-hooks = {
      url = "github:PassthroughPOST/VFIO-Tools";
      flake = false;
    };

    # FIXME: Remove this when this PR is merged: https://github.com/haslersn/any-nix-shell/pull/34
    any-nix-shell = {
      url = "github:calebstewart/any-nix-shell/add-nix-develop-support";
      flake = false;
    };

    rofi-libvirt-mode = {
      url = "github:calebstewart/rofi-libvirt-mode?ref=d8d4387410606570f6cc5853cad4566dc3738834";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, home-manager, nix-std, ...}@inputs:
  let
    user = {
      name = "caleb";
      fullName = "Caleb Stewart";
      email = "caleb.stewart94@gmail.com";

      aliases = {
        huntress = {
          email = "caleb.stewart@huntresslabs.com";
        };
      };
    };

    std = nix-std.lib;

    # Uniformly define a NixOS system configuration w/ home-manager
    makeNixOSSystem = {hostname, system, user}: inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        {
          networking.hostName = hostname;
          nixpkgs.overlays = import ./overlays {
            inherit inputs;
            inherit system;
          };
        }
        ./modules/nixos/configuration.nix
        (./. + "/hosts/${hostname}/hardware-configuration.nix")
        (./. + "/hosts/${hostname}/configuration.nix")
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${user.name} = (./. + "/hosts/${hostname}/user.nix");

            extraSpecialArgs = {
              inherit inputs;
              inherit system;
              inherit user;
              inherit std;
            };
          };
        }
      ];

      specialArgs = {
        inherit inputs;
        inherit system;
        inherit user;
        inherit std;
      };
    };

    # Uniformly define a Nix Darwin system configuration w/ home-manager
    makeNixDarwinSystem = {hostname, system, user}: inputs.nix-darwin.lib.darwinSystem {
      inherit system;

      modules = [
        {
          networking.hostName = hostname;
          nixpkgs.overlays = import ./overlays {
            inherit inputs;
            inherit system;
          };
        }
        ./modules/nix-darwin/configuration.nix
        (./. + "/hosts/${hostname}/configuration.nix")
        home-manager.darwinModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${user.name} = (./. + "/hosts/${hostname}/user.nix");

            extraSpecialArgs = {
              inherit inputs;
              inherit system;
              inherit user;
              inherit std;
            };
          };
        }
      ];

      specialArgs = {
        inherit inputs;
        inherit system;
        inherit user;
        inherit std;
      };
    };
  in {
    nixosConfigurations = {
      framework16 = makeNixOSSystem {
        inherit user;
        hostname = "framework16";
        system = "x86_64-linux";
      };
      ryzen = makeNixOSSystem {
        inherit user;
        hostname = "ryzen";
        system = "x86_64-linux";
      };
    };

    darwinConfigurations = {
      huntress-mbp = makeNixDarwinSystem {
        inherit user;
        hostname = "huntress-mbp";
        system = "aarch64-darwin";
      };
    };
  };
}
