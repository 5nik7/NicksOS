{
  description = "NicksOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.Zoo = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        modules/systems
	      home-manager.nixosModules.home-manager {
	   home-manager.useGlobalPkgs = true;
	   home-manager.useUserPackages = true;
	   home-manager.users.snikt = {config, pkgs, lib, ...}: {
	     imports = [
	     	./modules/systems
	     ];
	   };
	}
      ];
    };
  };
}