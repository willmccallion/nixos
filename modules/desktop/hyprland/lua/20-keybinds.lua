--- Alt as main mod. Vim-like focus. Workspaces 1-10.
--- Dynamic theming: Alt+B toggle theme, Alt+W wallpaper picker.

local mainMod = "ALT"
local terminal = "kitty"
local menu = "wofi --show drun --prompt Search"

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + P", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle", mode = "fullscreen" }))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("kitty --class btop-float btop"))
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("kitty --class claude-float --directory ~/projects fish -c claude"))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))

hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("toggle-theme"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("wallpaper-picker"))

hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("hyprshot -m region -o ~/Downloads"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region -o ~/Downloads"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("hyprshot -m output -o ~/Downloads"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprshot -m window -o ~/Downloads"))

hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("swaync-client -d -sw"))

hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + U", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + I", hl.dsp.focus({ direction = "down" }))

for workspace = 1, 10 do
    local key = workspace % 10

    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = workspace, follow = false }))
end

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

local volumeAndBrightness = { locked = true, repeating = true }

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), volumeAndBrightness)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), volumeAndBrightness)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), volumeAndBrightness)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), volumeAndBrightness)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), volumeAndBrightness)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), volumeAndBrightness)

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
