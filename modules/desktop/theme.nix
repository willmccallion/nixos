## ── Theme ─────────────────────────────────────────────────────────────────────
## GTK/Qt theming, icon theme, and fonts.
## Dracula GTK ensures dark mode in GTK/Qt applications.
## Remove this import from desktop/default.nix to disable.
{ pkgs, ... }:

{
	home.packages = with pkgs; [
		dracula-theme
		papirus-icon-theme
		nerd-fonts.caskaydia-cove
		nerd-fonts.jetbrains-mono
		nerd-fonts.fira-code
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
	};

	qt = {
		enable = true;
		platformTheme.name = "gtk";
	};
}
