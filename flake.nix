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
	};

	outputs = { self, nixpkgs, home-manager, neovim-nightly, stylix, rust-overlay, ...}:
	{
		nixosConfigurations.nix = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./configuration.nix
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
					home-manager.users.will = import ./home.nix;
				}
			];
		};
	};
}
