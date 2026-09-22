--- Environment variables and monitor layout.
--- Loaded first so env vars are set before the display server initializes.

hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "0x0", scale = 1 })
hl.monitor({ output = "HDMI-A-2", mode = "preferred", position = "1920x0", scale = 1 })

hl.config({
    ecosystem = {
        no_update_news = true,
    },

    cursor = {
        no_hardware_cursors = true,
    },
})
