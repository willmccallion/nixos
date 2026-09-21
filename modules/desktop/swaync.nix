## ── SwayNC ────────────────────────────────────────────────────────────────────
## Notification daemon + Control Center panel (macOS-style, right edge).
## Remove this import from desktop/default.nix to disable.
{ pkgs, ... }:

{
  home.packages = with pkgs; [ swaynotificationcenter ];

  xdg.configFile."swaync/config.json".text = builtins.toJSON {
    "$schema" = "/etc/xdg/swaync/configSchema.json";
    positionX = "right";
    positionY = "top";
    layer = "overlay";
    control-center-layer = "overlay";
    layer-shell = true;
    cssPriority = "user";
    control-center-margin-top = 8;
    control-center-margin-bottom = 8;
    control-center-margin-right = 8;
    control-center-margin-left = 8;
    notification-icon-size = 40;
    notification-body-image-height = 100;
    notification-body-image-width = 200;
    timeout = 6;
    timeout-low = 4;
    timeout-critical = 0;
    fit-to-screen = false;
    control-center-width = 380;
    control-center-height = 620;
    notification-window-width = 380;
    keyboard-shortcuts = true;
    image-visibility = "when-available";
    transition-time = 220;
    hide-on-clear = false;
    hide-on-action = true;
    script-fail-notify = true;
    widgets = [
      "title"
      "dnd"
      "mpris"
      "volume"
      "backlight"
      "notifications"
    ];
    widget-config = {
      title = {
        text = "Notifications";
        clear-all-button = true;
        button-text = "Clear";
      };
      dnd = {
        text = "Do Not Disturb";
      };
      mpris = {
        image-size = 96;
        image-radius = 8;
      };
      volume = {
        label = "󰕾";
        show-per-app = false;
      };
      backlight = {
        label = "󰃟";
      };
    };
  };

  xdg.configFile."swaync/style.css".text = ''
    		* {
    			font-family: "Inter", "CaskaydiaCove Nerd Font", sans-serif;
    			font-size: 13px;
    		}

    		.control-center {
    			background: rgba(18, 18, 22, 0.82);
    			border: 1px solid rgba(255, 255, 255, 0.08);
    			border-radius: 16px;
    			box-shadow: 0 12px 40px rgba(0, 0, 0, 0.45);
    			padding: 10px;
    			margin: 6px;
    		}

    		.control-center-list {
    			background: transparent;
    		}

    		.notification-row {
    			background: transparent;
    			padding: 4px 0;
    		}

    		.notification-background .notification,
    		.floating-notifications .notification {
    			background: rgba(28, 28, 34, 0.92);
    			border: 1px solid rgba(255, 255, 255, 0.06);
    			border-radius: 12px;
    			margin: 6px;
    			padding: 0;
    			box-shadow: 0 8px 24px rgba(0, 0, 0, 0.35);
    		}

    		.notification-content {
    			padding: 10px 12px;
    			color: rgba(230, 230, 240, 0.95);
    		}

    		.summary {
    			font-weight: 600;
    			color: rgba(240, 240, 250, 0.98);
    			font-size: 13px;
    		}

    		.body {
    			color: rgba(210, 210, 220, 0.78);
    			font-size: 12px;
    		}

    		.close-button {
    			background: transparent;
    			color: rgba(220, 220, 230, 0.6);
    			border-radius: 8px;
    			border: none;
    			margin: 4px;
    			padding: 2px 6px;
    		}

    		.close-button:hover {
    			background: rgba(255, 255, 255, 0.08);
    			color: rgba(255, 255, 255, 0.95);
    		}

    		.widget-title {
    			color: rgba(230, 230, 240, 0.92);
    			font-weight: 600;
    			font-size: 14px;
    			margin: 4px 6px 8px 6px;
    		}

    		.widget-title > button {
    			background: transparent;
    			border: 1px solid rgba(255, 255, 255, 0.08);
    			color: rgba(210, 210, 220, 0.85);
    			border-radius: 8px;
    			padding: 3px 10px;
    			font-size: 12px;
    		}

    		.widget-title > button:hover {
    			background: rgba(255, 255, 255, 0.06);
    		}

    		.widget-dnd {
    			color: rgba(220, 220, 230, 0.85);
    			margin: 4px 6px;
    			padding: 6px 10px;
    			border-radius: 10px;
    			background: rgba(255, 255, 255, 0.04);
    		}

    		.widget-dnd > switch {
    			background: rgba(255, 255, 255, 0.08);
    			border-radius: 12px;
    		}

    		.widget-dnd > switch:checked {
    			background: rgba(100, 160, 240, 0.75);
    		}

    		.widget-mpris {
    			background: rgba(255, 255, 255, 0.04);
    			border-radius: 12px;
    			padding: 8px;
    			margin: 4px 6px;
    			color: rgba(230, 230, 240, 0.92);
    		}

    		.widget-mpris-player {
    			padding: 4px;
    		}

    		.widget-mpris-title {
    			font-weight: 600;
    			font-size: 13px;
    		}

    		.widget-mpris-subtitle {
    			color: rgba(210, 210, 220, 0.7);
    			font-size: 11px;
    		}

    		.widget-volume,
    		.widget-backlight {
    			background: rgba(255, 255, 255, 0.04);
    			border-radius: 10px;
    			padding: 6px 10px;
    			margin: 4px 6px;
    			color: rgba(220, 220, 230, 0.88);
    		}

    		trough {
    			background: rgba(255, 255, 255, 0.08);
    			border-radius: 8px;
    			min-height: 6px;
    		}

    		highlight {
    			background: rgba(200, 200, 220, 0.85);
    			border-radius: 8px;
    			min-height: 6px;
    		}

    		slider {
    			background: rgba(240, 240, 250, 0.98);
    			border: 1px solid rgba(0, 0, 0, 0.2);
    			border-radius: 50%;
    			min-height: 14px;
    			min-width: 14px;
    			box-shadow: 0 1px 3px rgba(0, 0, 0, 0.35);
    		}

    		.notification-action {
    			background: rgba(255, 255, 255, 0.05);
    			color: rgba(220, 220, 230, 0.9);
    			border: none;
    			border-radius: 8px;
    			margin: 4px;
    			padding: 4px 10px;
    		}

    		.notification-action:hover {
    			background: rgba(255, 255, 255, 0.1);
    		}
    	'';
}
