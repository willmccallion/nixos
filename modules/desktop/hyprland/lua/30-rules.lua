--- Input/mouse settings and opacity overrides for floating windows.

hl.config({
    input = {
        kb_layout = "us",
        kb_options = "caps:none",
        follow_mouse = 1,
        sensitivity = 0,
    },
})

hl.window_rule({
    name = "btop-float-opacity",
    match = { class = "^(btop-float)$" },
    opacity = "0.72 0.65",
})

hl.window_rule({
    name = "claude-float-opacity",
    match = { class = "^(claude-float)$" },
    opacity = "0.85 0.78",
})
