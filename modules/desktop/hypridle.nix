## ── Idle ─────────────────────────────────────────────────────────────────────
## Screen dim + DPMS on idle.
{ pkgs, ... }:

let
  dpmsHotplugGuard = pkgs.writeShellScript "dpms-hotplug-guard" (
    builtins.readFile (
      pkgs.replaceVars ./scripts/dpms-hotplug-guard.sh {
        socat = "${pkgs.socat}/bin/socat";
        hyprctl = "${pkgs.hyprland}/bin/hyprctl";
      }
    )
  );

  dpms = action: "hyprctl dispatch 'hl.dsp.dpms({ action = \"${action}\" })'";
in
{
  # The OMEN 27 on HDMI-A-2 re-announces itself over HDMI shortly after going
  # into standby, and Hyprland powers the fresh connector on. Held off here
  # until real input arrives, otherwise it wakes alone while HDMI-A-1 stays off.
  systemd.user.services.dpms-hotplug-guard = {
    Unit = {
      Description = "Hold DPMS off across self-inflicted monitor hotplugs";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${dpmsHotplugGuard}";
      TimeoutStopSec = 5;
    };
  };

  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "";
        before_sleep_cmd = "";
        after_sleep_cmd = "";
      };

      listener = [
        {
          timeout = 120;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 300;
          on-timeout = "${dpms "off"}; systemctl --user --no-block start dpms-hotplug-guard.service";
          on-resume = "systemctl --user stop dpms-hotplug-guard.service; ${dpms "on"}";
        }
      ];
    };
  };
}
