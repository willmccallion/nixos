#!/usr/bin/env bash
# The OMEN 27 on HDMI-A-2 drops HDMI hotplug-detect when it enters standby.
# Hyprland treats the reconnect as a newly plugged-in display and modesets it
# back on, so it wakes by itself while HDMI-A-1 stays dark. While the screens
# are meant to be off, re-assert DPMS off every time a monitor reappears.
#
# Started by hypridle on-timeout, stopped on-resume; never runs otherwise.

set -uo pipefail

readonly SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

# A monitor can re-drop hotplug-detect the moment it returns to standby, so an
# undebounced guard would turn a firmware flap into a modeset storm.
readonly DEBOUNCE_SECONDS=2

last_reassert=$((-DEBOUNCE_SECONDS))

should_reassert() {
	((SECONDS - last_reassert >= DEBOUNCE_SECONDS))
}

@socat@ -U - "UNIX-CONNECT:$SOCKET" | while read -r event; do
	[[ $event == monitoradded">>"* ]] || continue
	should_reassert || continue

	last_reassert=$SECONDS
	@hyprctl@ dispatch 'hl.dsp.dpms({ action = "off" })'
done
