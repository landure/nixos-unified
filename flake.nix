{
  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-unified.url = "github:srid/nixos-unified";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";

    nixgl.url = "github:nix-community/nixGL";
  };

  outputs =
    inputs@{
      self,
      flake-parts,
      nixos-unified,
      disko,
      nixos-facter-modules,
      ...
    }:
    let
      inherit (flake-parts.lib) mkFlake;
    in
    mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        # "aarch64-linux"
      ];

      imports = [ nixos-unified.flakeModules.default ];

      flake = {
        # Configurations for Linux (NixOS) machines
        # nixosConfigurations = import ./hosts (inputs // { inherit myUserName; });

        nixosConfigurations = import ./nixosConfigurations inputs;

        nixosModules.default =
          { pkgs, ... }:
          {
            imports = [
              disko.nixosModules.default
              nixos-facter-modules.nixosModules.facter
            ];
          };

        # home-manager configuration goes here.
        homeModules.default =
          { pkgs, ... }:
          {
            imports = [
              # @see https://nix-community.github.io/stylix
              inputs.stylix.homeModules.stylix
            ];
            programs = {
              git.enable = true;
              starship.enable = true;
              bash.enable = true;
            };
          };
      };
    };
}
