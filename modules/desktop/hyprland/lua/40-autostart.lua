--- Processes started once per session.

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("restore-theme")
    hl.exec_cmd("swaync")
end)
