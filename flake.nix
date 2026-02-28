{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }@inputs:
  let
    system = "x86_64-linux";
    userSettings = {
      username = "arno";
      name = "Michael Polyntsov";
      email = "Arno9148@gmail.com";
    };
  in {
    nixosConfigurations = {
      elise = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit userSettings;
          };

          modules = [
            ./hosts/elise/configuration.nix
          ];
        };
    };
  };
}
