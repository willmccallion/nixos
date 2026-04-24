{
	description = "NixOS Config";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

		stylix.url = "github:danth/stylix";

		rust-overlay = {
			url = "github:oxalica/rust-overlay";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		disko = {
			url = "github:nix-community/disko";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nix-index-database = {
			url = "github:nix-community/nix-index-database";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, neovim-nightly, stylix, rust-overlay, disko, nix-index-database, ...}:
	let
		username = "will";
		hostname = "nix";
	in
	{
		nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit username hostname; };
			modules = [
				./configuration.nix
				disko.nixosModules.disko
				./disko.nix
				stylix.nixosModules.stylix
				home-manager.nixosModules.home-manager
				{
					nixpkgs.overlays = [
						neovim-nightly.overlays.default
						rust-overlay.overlays.default
					];
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.backupFileExtension = "backup";
					home-manager.extraSpecialArgs = { inherit username; };
					home-manager.sharedModules = [
						nix-index-database.homeModules.nix-index
					];
					home-manager.users.${username} = import ./home.nix;
				}
			];
		};
	};
}
