{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        (final: prev: {
          # 50.alpha of gsd fixes resuspends after wakeups
          gnome-settings-daemon = prev.gnome-settings-daemon.overrideAttrs (old: {
            src = prev.fetchgit {
              url = "https://gitlab.gnome.org/GNOME/gnome-settings-daemon.git";
              rev = "50.alpha";
              sha256 = "151b9sdb2f4045f25ddgv896fxzwfmidy9vps03cqx62ciwglrjn";
	      fetchSubmodules = true;
            };
            version = "50.alpha";
          });
        })
      ];
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      elise = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };

          modules = [
            ./hosts/elise/configuration.nix
            { nixpkgs.pkgs = pkgs; }
          ];
        };
    };
  };
}
