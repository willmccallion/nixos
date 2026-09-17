## ── Theme ─────────────────────────────────────────────────────────────────────
## GTK/Qt theming, icon theme, and fonts.
## Dracula GTK ensures dark mode in GTK/Qt applications.
## Remove this import from desktop/default.nix to disable.
{ config, pkgs, ... }:

{
	home.packages = with pkgs; [
		nerd-fonts.caskaydia-cove
		inter
	];

	gtk = {
		enable = true;
		theme = {
			name = "Dracula";
			package = pkgs.dracula-theme;
		};
		iconTheme = {
			name = "Papirus-Dark";
			package = pkgs.papirus-icon-theme;
		};
		# Pin the pre-26.05 default; the new default is null.
		gtk4.theme = config.gtk.theme;
	};

	qt = {
		enable = true;
		platformTheme.name = "gtk3";
	};
}
