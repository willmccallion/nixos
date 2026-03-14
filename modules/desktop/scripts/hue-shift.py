"""Derive stat colors from an accent color via hue/saturation shifts.

Usage: python3 hue-shift.py R G B
Outputs: GPU_R GPU_G GPU_B CPU_R ... DIM_R DIM_G DIM_B (space-separated)
"""
import colorsys, sys

r, g, b = int(sys.argv[1]) / 255, int(sys.argv[2]) / 255, int(sys.argv[3]) / 255
h, s, v = colorsys.rgb_to_hsv(r, g, b)
grayscale = s < 0.12


def mk(sat_mul, val):
    sat = (s * sat_mul) if not grayscale else (s * sat_mul * 0.4)
    rr, gg, bb = colorsys.hsv_to_rgb(h, min(sat, 1.0), min(val, 1.0))
    return int(rr * 255), int(gg * 255), int(bb * 255)


gpu = mk(1.00, 0.85)
cpu = mk(0.70, 0.72)
mem = mk(0.85, 0.62)
net = mk(0.55, 0.78)
vol = mk(0.40, 0.68)
dim = mk(0.25, 0.50)

for c in [gpu, cpu, mem, net, vol, dim]:
    print(*c, end=" ")
