{
  description = "NixOS Unified-based provisionning, with Flake parts";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixos-unified.url = "github:srid/nixos-unified";

    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";

    nixgl.url = "github:nix-community/nixGL";
  };

  outputs =
    {
      self,
      flake-parts,
      nixos-unified,
      disko,
      nixos-facter-modules,
      ...
    }@inputs:
    let
      inherit (flake-parts.lib) mkFlake;
    in
    mkFlake { inherit inputs; } {

      imports = [
        nixos-unified.flakeModules.default

        # See https://flake.parts/options/disko.html
        inputs.disko.flakeModules.default
      ];

      # Declared systems that your flake supports. These will be enumerated in perSystem
      systems = [
        "x86_64-linux"
        # "aarch64-linux" "x86_64-darwin" "aarch64-darwin"
      ];

      # perSystem = { config, self', inputs', pkgs, system, ... }: {
      # Allows definition of system-specific attributes
      # without needing to declare the system explicitly!
      #
      # Quick rundown of the provided arguments:
      # - config is a reference to the full configuration, lazily evaluated
      # - self' is the outputs as provided here, without system. (self'.packages.default)
      # - inputs' is the input without needing to specify system (inputs'.foo.packages.bar)
      # - pkgs is an instance of nixpkgs for your specific system
      # - system is the system this configuration is for

      # This is equivalent to packages.<system>.default
      # packages.default = pkgs.hello;
      # };

      perSystem =
        { config, self, ... }:
        {
          # alias `nix run .#activate` to `nix run`
          packages.default = self.packages.activate;
        };

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

              ./nixosModules
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
