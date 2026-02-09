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
  in {
    nixosConfigurations = {
      elise = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };

          modules = [
            ./hosts/elise/configuration.nix
          ];
        };
    };
  };
}
