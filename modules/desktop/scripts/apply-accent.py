#!@python@
"""Apply the desktop theme: regenerate waybar CSS, btop theme, fish colors,
kitty bg tint, hyprland borders/gaps/rounding, and waybar lifecycle.

State (persistent across reboots):
  ~/.local/state/desktop-theme/mode    -- "rounded" or "square"
  ~/.local/state/desktop-theme/accent  -- "R G B"

Usage:
  apply-accent              read state, apply
  apply-accent R G B        persist new accent, then apply
"""
import colorsys
import stat
import string
import subprocess
import sys
from pathlib import Path

STATE_DIR = Path.home() / ".local/state/desktop-theme"
WAYBAR_DIR = Path.home() / ".config/waybar"
TEMPLATE_DIR = WAYBAR_DIR / "templates"
STYLE_OUT = WAYBAR_DIR / "style.css"
BTOP_THEME = Path.home() / ".config/btop/themes/wallpaper.theme"

FALLBACK = (185, 185, 195)


def read_state(name, default=""):
    p = STATE_DIR / name
    return p.read_text().strip() if p.exists() else default


def write_state(name, value):
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    (STATE_DIR / name).write_text(value)


def parse_rgb(text):
    parts = text.split()
    if len(parts) != 3:
        return None
    try:
        rgb = tuple(int(x) for x in parts)
    except ValueError:
        return None
    if any(c < 0 or c > 255 for c in rgb):
        return None
    return rgb


def hue_shift(r, g, b, sat_mul, val):
    h, s, _ = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)
    grayscale = s < 0.12
    sat = (s * sat_mul * 0.4) if grayscale else (s * sat_mul)
    rr, gg, bb = colorsys.hsv_to_rgb(h, min(sat, 1.0), min(val, 1.0))
    return int(rr * 255), int(gg * 255), int(bb * 255)


def hexc(r, g, b):
    return f"{r:02x}{g:02x}{b:02x}"


def main():
    if len(sys.argv) == 4:
        rgb = parse_rgb(" ".join(sys.argv[1:4]))
    else:
        rgb = parse_rgb(read_state("accent"))
    if rgb is None:
        rgb = FALLBACK
    R, G, B = rgb
    write_state("accent", f"{R} {G} {B}")

    mode = read_state("mode", "rounded")
    if mode not in ("rounded", "square"):
        mode = "rounded"

    GPU = hue_shift(R, G, B, 1.00, 0.85)
    CPU = hue_shift(R, G, B, 0.70, 0.72)
    MEM = hue_shift(R, G, B, 0.85, 0.62)
    NET = hue_shift(R, G, B, 0.55, 0.78)
    VOL = hue_shift(R, G, B, 0.40, 0.68)
    DIM = hue_shift(R, G, B, 0.25, 0.50)

    sat = max(R, G, B) - min(R, G, B)
    if sat < 30:
        BORDER2 = (30, 30, 32)
    else:
        BORDER2 = (R * 45 // 100, G * 45 // 100, B * 45 // 100)

    GPU_DIM = tuple(c * 35 // 100 for c in GPU)
    CPU_DIM = tuple(c * 35 // 100 for c in CPU)
    MEM_DIM = tuple(c * 35 // 100 for c in MEM)
    NET_DIM = tuple(c * 35 // 100 for c in NET)
    ACC_DIM = (R * 25 // 100, G * 25 // 100, B * 25 // 100)

    render_waybar_css(mode, R, G, B, GPU, CPU, MEM, NET, VOL, DIM)
    render_btop_theme(R, G, B, GPU, CPU, MEM, NET, DIM, CPU_DIM, MEM_DIM, NET_DIM, ACC_DIM)
    apply_fish_colors(R, G, B, GPU, CPU, MEM, NET, VOL, DIM, ACC_DIM)
    tint_kitty(R, G, B)
    apply_hyprland(mode, R, G, B, BORDER2)
    set_waybar_state(mode)


def render_waybar_css(mode, R, G, B, GPU, CPU, MEM, NET, VOL, DIM):
    template_path = TEMPLATE_DIR / f"{mode}.css.tmpl"
    if not template_path.exists():
        return
    subs = {
        "R": R, "G": G, "B": B,
        "GPU_R": GPU[0], "GPU_G": GPU[1], "GPU_B": GPU[2],
        "CPU_R": CPU[0], "CPU_G": CPU[1], "CPU_B": CPU[2],
        "MEM_R": MEM[0], "MEM_G": MEM[1], "MEM_B": MEM[2],
        "NET_R": NET[0], "NET_G": NET[1], "NET_B": NET[2],
        "VOL_R": VOL[0], "VOL_G": VOL[1], "VOL_B": VOL[2],
        "DIM_R": DIM[0], "DIM_G": DIM[1], "DIM_B": DIM[2],
    }
    rendered = string.Template(template_path.read_text()).safe_substitute(subs)
    WAYBAR_DIR.mkdir(parents=True, exist_ok=True)
    STYLE_OUT.write_text(rendered)


def render_btop_theme(R, G, B, GPU, CPU, MEM, NET, DIM, CPU_DIM, MEM_DIM, NET_DIM, ACC_DIM):
    BTOP_THEME.parent.mkdir(parents=True, exist_ok=True)
    h = hexc
    BTOP_THEME.write_text(f"""# Wallpaper-derived btop theme — auto-generated
# Accent: rgb({R}, {G}, {B})

theme[main_bg]="#0c0c12"
theme[main_fg]="#d7d7e4"
theme[title]="{h(R, G, B)}"
theme[hi_fg]="{h(*GPU)}"
theme[selected_bg]="{h(*ACC_DIM)}"
theme[selected_fg]="#d7d7e4"
theme[inactive_fg]="{h(*DIM)}"
theme[graph_text]="{h(*DIM)}"
theme[meter_bg]="#1a1a22"
theme[proc_misc]="{h(*DIM)}"
theme[cpu_box]="{h(R, G, B)}"
theme[mem_box]="{h(R, G, B)}"
theme[net_box]="{h(R, G, B)}"
theme[proc_box]="{h(R, G, B)}"
theme[div_line]="{h(*ACC_DIM)}"
theme[temp_start]="{h(*DIM)}"
theme[temp_mid]="#e1b941"
theme[temp_end]="#e14b4b"
theme[cpu_start]="{h(*CPU_DIM)}"
theme[cpu_mid]=""
theme[cpu_end]="{h(*CPU)}"
theme[free_start]="{h(*MEM_DIM)}"
theme[free_mid]=""
theme[free_end]="{h(*MEM)}"
theme[cached_start]="{h(*MEM_DIM)}"
theme[cached_mid]=""
theme[cached_end]="{h(*MEM)}"
theme[available_start]="{h(*MEM_DIM)}"
theme[available_mid]=""
theme[available_end]="{h(*MEM)}"
theme[used_start]="{h(*MEM_DIM)}"
theme[used_mid]=""
theme[used_end]="{h(*MEM)}"
theme[download_start]="{h(*NET_DIM)}"
theme[download_mid]=""
theme[download_end]="{h(*NET)}"
theme[upload_start]="{h(*NET_DIM)}"
theme[upload_mid]=""
theme[upload_end]="{h(*NET)}"
theme[process_start]="{h(*CPU_DIM)}"
theme[process_mid]=""
theme[process_end]="{h(*CPU)}"
""")


def apply_fish_colors(R, G, B, GPU, CPU, MEM, NET, VOL, DIM, ACC_DIM):
    h = hexc
    script = f"""
set -U fish_color_user {h(R, G, B)}
set -U fish_color_host {h(*CPU)}
set -U fish_color_host_remote {h(*NET)}
set -U fish_color_cwd {h(*MEM)}
set -U fish_color_cwd_root e14b4b
set -U fish_color_normal d7d7e4
set -U fish_color_command {h(*GPU)}
set -U fish_color_keyword {h(*MEM)}
set -U fish_color_quote {h(*NET)}
set -U fish_color_redirection {h(*VOL)}
set -U fish_color_end {h(*DIM)}
set -U fish_color_error e14b4b
set -U fish_color_param {h(*CPU)}
set -U fish_color_comment {h(*DIM)}
set -U fish_color_operator {h(R, G, B)}
set -U fish_color_escape {h(*NET)}
set -U fish_color_autosuggestion {h(*DIM)}
set -U fish_color_selection --background={h(*ACC_DIM)}
set -U fish_color_search_match --background={h(*ACC_DIM)}
set -U fish_pager_color_prefix {h(R, G, B)}
set -U fish_pager_color_completion d7d7e4
set -U fish_pager_color_description {h(*DIM)}
set -U fish_pager_color_selected_background --background={h(*ACC_DIM)}
"""
    subprocess.run(["@fish@", "-c", script], check=False, stderr=subprocess.DEVNULL)


def tint_kitty(R, G, B):
    bg = f"#{R*8//100:02x}{G*8//100:02x}{B*8//100:02x}"
    for sock in Path("/tmp").glob("kitty-socket*"):
        try:
            if stat.S_ISSOCK(sock.stat().st_mode):
                subprocess.run(
                    ["@kitty@", "@", "--to", f"unix:{sock}",
                     "set-colors", f"background={bg}"],
                    check=False, stderr=subprocess.DEVNULL,
                )
        except OSError:
            pass


def apply_hyprland(mode, R, G, B, BORDER2):
    if mode == "rounded":
        cmds = [
            ("general:col.active_border",
             f"rgba({hexc(R, G, B)}ee) rgba({hexc(*BORDER2)}99) 45deg"),
            ("general:col.inactive_border", "rgba(ffffff10)"),
            ("general:gaps_in", "4 4 4 4"),
            ("general:gaps_out", "8 8 8 8"),
            ("decoration:rounding", "10"),
            ("general:border_size", "2"),
        ]
    else:
        cmds = [
            ("general:gaps_in", "0"),
            ("general:gaps_out", "0"),
            ("decoration:rounding", "0"),
            ("general:border_size", "0"),
        ]
    for key, val in cmds:
        subprocess.run(["@hyprctl@", "keyword", key, val],
                       check=False, stdout=subprocess.DEVNULL)


def set_waybar_state(mode):
    action = "restart" if mode == "rounded" else "stop"
    subprocess.run(["@systemctl@", "--user", action, "waybar.service"],
                   check=False, stderr=subprocess.DEVNULL)


if __name__ == "__main__":
    main()
