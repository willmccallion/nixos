## ── Wofi ──────────────────────────────────────────────────────────────────────
## Application launcher for Wayland.
## Remove this import from desktop/default.nix to disable.
{ pkgs, ... }:

{
	home.packages = with pkgs; [ wofi ];

	xdg.configFile."wofi/config".text = ''
		width=380
		height=300
		location=center
		show=drun
		prompt=
		allow_markup=true
		insensitive=true
		no_actions=true
		hide_scroll=true
		dynamic_lines=false
	'';

	xdg.configFile."wofi/style.css".text = ''
		window {
			background: rgba(15, 15, 18, 0.82);
			border-radius: 14px;
			border: 1px solid rgba(255, 255, 255, 0.07);
			font-family: "CaskaydiaCove Nerd Font", monospace;
			font-size: 14px;
		}

		#input {
			background: transparent;
			border: none;
			border-bottom: 1px solid rgba(255, 255, 255, 0.06);
			border-radius: 14px 14px 0 0;
			color: rgba(230, 230, 235, 0.92);
			padding: 14px 18px;
			font-size: 15px;
			font-family: "CaskaydiaCove Nerd Font", monospace;
			outline: none;
		}

		#input::placeholder {
			color: rgba(150, 150, 160, 0.45);
		}

		#inner-box {
			background: transparent;
			padding: 6px 8px;
		}

		#outer-box {
			background: transparent;
			padding: 0;
		}

		#scroll {
			background: transparent;
			margin: 0;
			padding: 0;
		}

		#entry {
			background: transparent;
			border-radius: 8px;
			padding: 8px 12px;
			color: rgba(200, 200, 210, 0.78);
			transition: all 0.1s ease;
		}

		#entry:selected {
			background: rgba(255, 255, 255, 0.07);
			color: rgba(235, 235, 245, 0.97);
		}

		#text {
			color: inherit;
		}
	'';
}
