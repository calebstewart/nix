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

    nix-colors.url = "github:misterio77/nix-colors";
    nur.url = "github:nix-community/NUR";

    # FIXME: Remove this when this PR is merged: https://github.com/viperML/nh/pull/92
    nh-extra-privesc.url = "github:henriquekirchheck/nh/4afff0d675a78f5c10f8839ac5897eb167f07cff";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
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
  };

  outputs = {home-manager, nur, ... }@inputs:
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

    overlays = [
      # Add the Nix User Repository
      nur.overlay

      # Override pwvucontrol with the newest version which doesn't crash
      # FIXME: remove this once the packages get updated upstream
      (self: super: {
        pwvucontrol = super.pwvucontrol.overrideAttrs (old: rec {
          version = "0.4.1";

          src = super.fetchFromGitHub {
            owner = "saivert";
            repo = "pwvucontrol";
            rev = "0.4.1";
            sha256 = "sha256-soxB8pbbyYe1EXtopq1OjoklEDJrwK6od4nFLDwb8LY=";
          };

          cargoDeps = super.rustPlatform.importCargoLock {
            lockFile = "${src}/Cargo.lock";
            outputHashes = {
              "wireplumber-0.1.0" = "sha256-+LZ8xKok2AOegW8WvfrfZGXuQB4xHrLNshcTOHab+xQ=";
            };
          };
        });
      })
    ];

    # Function to uniformly define a system based on it's hostname and
    # platform name.
    makeSystem = {hostname, system, user}:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          {
            networking.hostName = hostname;
            nixpkgs.overlays = overlays;
          }
          inputs.hyprland.nixosModules.default
          ./modules/system/configuration.nix
          (./. + "/hosts/${hostname}/hardware-configuration.nix")
          (./. + "/hosts/${hostname}/configuration.nix")
        ];

        specialArgs = {
          inherit inputs;
          inherit user;
          inherit system;
        };
      };

    makeHome = {hostname, system, user}:
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs {
          inherit system;

          config = {
            allowUnfree = true;
          };
        };

        extraSpecialArgs = {
          inherit inputs;
          inherit system;
          inherit user;
        };

        modules = [
          {
            nixpkgs.overlays = overlays;
            home.username = user.name;
            home.homeDirectory = inputs.nixpkgs.lib.mkDefault "/home/${user.name}";
          }
          inputs.hyprland.homeManagerModules.default
          (./. + "/hosts/${hostname}/user.nix")
        ];
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

    homeConfigurations = {
      "${user.name}@framework16" = makeHome {
        inherit user;
        hostname = "framework16";
        system = "x86_64-linux";
      };

      "${user.name}@ryzen" = makeHome {
        inherit user;
        hostname = "ryzen";
        system = "x86_64-linux";
      };
    };
  };
}
