{
	description = "NixOS Config";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
	};

	outputs = { self, nixpkgs, home-manager, neovim-nightly, ...}:
	{
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./configuration.nix
				home-manager.nixosModules.home-manager
				{
					nixpkgs.overlays = [ neovim-nightly.overlays.default ];
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.users.will = import ./home.nix;
				}
			];
		};
	};
}
