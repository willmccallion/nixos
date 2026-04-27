#!@python@
"""Interactive wallpaper picker.

Shows wofi menu of wallpapers, sets the chosen one, extracts an accent
color, persists it, then calls apply-accent to update the whole desktop.
"""
import os
import shutil
import subprocess
import sys
import time
from pathlib import Path

BG_DIR = Path.home() / ".config/hypr/backgrounds"
CURRENT = Path.home() / ".config/hypr/background.jpg"


def main():
    if not BG_DIR.is_dir():
        sys.exit(0)

    candidates = sorted(p.name for p in BG_DIR.iterdir() if p.is_file())
    if not candidates:
        sys.exit(0)

    chosen = subprocess.run(
        ["@wofi@", "--dmenu", "--prompt", "  Wallpaper",
         "--width", "380", "--height", "300", "--no-actions"],
        input="\n".join(candidates),
        capture_output=True, text=True,
    ).stdout.strip()

    if not chosen or chosen not in candidates:
        sys.exit(0)

    src = BG_DIR / chosen

    if CURRENT.exists() or CURRENT.is_symlink():
        CURRENT.unlink()
    shutil.copy(src, CURRENT)
    os.chmod(CURRENT, 0o644)

    subprocess.run(["@pkill@", "-x", "hyprpaper"], check=False)
    time.sleep(0.3)
    subprocess.Popen(
        ["@hyprpaper@"],
        stdin=subprocess.DEVNULL,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        start_new_session=True,
    )

    result = subprocess.run(
        ["@python@", "@extractAccentPy@", str(src), "@convert@"],
        capture_output=True, text=True,
    )
    parts = result.stdout.split()
    if len(parts) == 3 and all(p.isdigit() for p in parts):
        rgb = parts
    else:
        rgb = ["185", "185", "195"]

    subprocess.run(["apply-accent", *rgb], check=False)


if __name__ == "__main__":
    main()
