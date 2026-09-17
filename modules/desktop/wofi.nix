## ── Wofi ──────────────────────────────────────────────────────────────────────
## Application launcher for Wayland.
## Remove this import from desktop/default.nix to disable.
{ pkgs, ... }:

{
	home.packages = with pkgs; [ wofi ];

	xdg.configFile."wofi/config".text = ''
		width=520
		height=360
		location=center
		yoffset=-120
		show=drun
		prompt=Search
		allow_markup=true
		insensitive=true
		no_actions=true
		hide_scroll=true
		dynamic_lines=false
		image_size=28
	'';

	xdg.configFile."wofi/style.css".text = ''
		* {
			outline: none;
			box-shadow: none;
			border: none;
		}

		window {
			background: rgba(20, 20, 24, 0.85);
			border-radius: 16px;
			border: 1px solid rgba(255, 255, 255, 0.08);
			font-family: "Inter", "CaskaydiaCove Nerd Font", sans-serif;
			font-size: 14px;
		}

		#input {
			background: transparent;
			border: none;
			border-bottom: 1px solid rgba(255, 255, 255, 0.06);
			border-radius: 16px 16px 0 0;
			color: rgba(235, 235, 245, 0.95);
			padding: 16px 20px;
			font-size: 16px;
			font-family: "Inter", "CaskaydiaCove Nerd Font", sans-serif;
			font-weight: 400;
			caret-color: rgba(235, 235, 245, 0.95);
		}

		#input image {
			-gtk-icon-transform: scale(0.85);
			color: rgba(180, 180, 190, 0.6);
		}

		#input::placeholder {
			color: rgba(150, 150, 160, 0.45);
		}

		#inner-box, #outer-box, #scroll {
			background: transparent;
			padding: 0;
			margin: 0;
		}

		#inner-box {
			padding: 8px 10px;
		}

		#entry {
			background: transparent;
			border-radius: 10px;
			padding: 10px 14px;
			color: rgba(215, 215, 225, 0.85);
			min-height: 32px;
			margin: 1px 0;
		}

		#entry image {
			margin-right: 12px;
		}

		#entry:selected,
		#entry:focus,
		#entry:selected label,
		#entry:focus label {
			background: rgba(255, 255, 255, 0.08);
			color: rgba(245, 245, 255, 0.98);
			outline: none;
			border: none;
			box-shadow: none;
		}

		#text {
			color: inherit;
			font-weight: 500;
		}

		#text:selected {
			color: rgba(245, 245, 255, 0.98);
		}
	'';
}
