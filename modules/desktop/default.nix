## ── Desktop Environment ───────────────────────────────────────────────────────
## Comment out any import below to disable that component.
{ ... }:

{
	imports = [
		./hyprland      # Wayland compositor
		./waybar        # Status bar
		./kitty.nix     # Terminal emulator
		./wofi.nix      # Application launcher
		./theme.nix     # GTK/Qt theming, icons, fonts
		./scripts.nix   # Dynamic theming scripts (wallpaper, toggle-theme, apply-accent)
		./gammastep.nix # Night light (warm screen colour at night)
	];
}
