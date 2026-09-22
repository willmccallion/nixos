{ ... }:

{
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
          on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = \"off\" })'";
          on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = \"on\" })'";
        }
      ];
    };
  };
}
