## ── Night Light ──────────────────────────────────────────────────────────────
## Gammastep gradually shifts the screen colour temperature from cool (daytime)
## to warm (night-time), similar to iPhone Night Shift.
{ ... }:

{
	services.gammastep = {
		enable = true;

		latitude = 53.55;
		longitude = -113.49;

		temperature = {
			day = 6500;     # neutral daylight (Kelvin)
			night = 3400;   # warm / amber
		};

		settings.general = {
			fade = 1;                # smooth transition (1 = on)
			adjustment-method = "wayland";
		};
	};
}
