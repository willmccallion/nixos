## ── Hyprland ──────────────────────────────────────────────────────────────────
## Wayland compositor configuration, written in Hyprland's Lua config format.
## Split into: core, appearance, keybinds, rules, autostart (see ./lua).
## Dynamic theming via toggle-theme (Alt+B) and wallpaper picker (Alt+W).
{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
  };

  home.packages = with pkgs; [
    grim
    slurp
    hyprshot
    wl-clipboard
    hyprpaper
    playerctl
    brightnessctl
  ];

  # ── Wallpapers ─────────────────────────────────────────────────────────
  xdg.configFile."hypr/backgrounds".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/modules/desktop/hyprland/backgrounds";

  home.activation.deployDefaultWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    		BG_DEFAULT="$HOME/.config/hypr/background.jpg"
    		if [ ! -f "$BG_DEFAULT" ]; then
    			cp "${./backgrounds}/default.jpg" "$BG_DEFAULT"
    			chmod u+w "$BG_DEFAULT"
    		fi
    	'';

  xdg.configFile."hypr/hyprpaper.conf".text =
    let
      bg = "${config.home.homeDirectory}/.config/hypr/background.jpg";
    in
    ''
      preload = ${bg}

      wallpaper {
          monitor =
          path = ${bg}
      }

      splash = false
      	'';

  # ── Compositor ─────────────────────────────────────────────────────────
  wayland.windowManager.hyprland = {
    enable = true;

    configType = "lua";

    extraLuaFiles = {
      "00-core" = ./lua/00-core.lua;
      "10-appearance" = ./lua/10-appearance.lua;
      "20-keybinds" = ./lua/20-keybinds.lua;
      "30-rules" = ./lua/30-rules.lua;
      "40-autostart" = {
        content = ./lua/40-autostart.lua;
        autoLoad = false;
      };
    };

    # restore-theme restarts waybar.service, so autostart is required after
    # Home Manager's own hyprland.start hook brings up the session target.
    extraConfig = ''
      require("40-autostart")
    '';
  };
}
