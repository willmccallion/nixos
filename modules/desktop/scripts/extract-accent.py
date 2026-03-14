"""Extract a dominant accent color from a wallpaper image.

Usage: python3 extract-accent.py <image-path> <imagemagick-convert-bin>
Outputs: R G B (space-separated)
"""
import subprocess, re, sys

path = sys.argv[1]
convert_bin = sys.argv[2]

result = subprocess.run(
    [
        convert_bin, path,
        "-resize", "200x200^", "-gravity", "center", "-extent", "200x200",
        "+dither", "-colors", "12", "-unique-colors", "txt:-",
    ],
    capture_output=True,
    text=True,
)

colors = []
for line in result.stdout.splitlines():
    m = re.search(r"\((\d+),(\d+),(\d+)\)", line)
    if m:
        r, g, b = int(m.group(1)), int(m.group(2)), int(m.group(3))
        mx, mn = max(r, g, b), min(r, g, b)
        sat = (mx - mn) / mx if mx > 0 else 0
        brightness = mx / 255
        score = sat * (1 - abs(brightness - 0.55))
        colors.append((score, r, g, b))

colors.sort(reverse=True)
if colors and colors[0][0] > 0.25:
    _, r, g, b = colors[0]
else:
    r, g, b = 185, 185, 195  # fallback: cool silver for desaturated images

print(r, g, b)
