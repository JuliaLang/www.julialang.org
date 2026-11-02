# Generate the interlocking-gears pattern for the Apps slide of the Ecosystem
# carousel (after the JuliaInterop logo), as an SVG in the Julia colours:
#
#   python3 tools/ecosystem-images/gears.py
#
# Equal gears on a square lattice mesh when their pitch circles touch and the
# tooth phase alternates like a checkerboard (every gear turns against its four
# neighbours). The four colours alternate so touching gears never match, and the
# centre holes are cut out, so the pattern works on a light or dark background.
import math, os

W, H = 760, 640                    # viewBox; the slide shows it at about 380x320
N = 12                             # teeth per gear (a multiple of 4, for the lattice)
R = 48.0                           # pitch radius; neighbours are 2R apart
M = 2 * R / N                      # module (tooth size)
COLORS = ["#389826", "#CB3C33", "#9558B2", "#4063D8"]   # Julia green, red, purple, blue

def shade(hexcol, k):  # k<1 darkens, k>1 lightens towards white
    r, g, b = (int(hexcol[i:i+2], 16) for i in (1, 3, 5))
    f = (lambda c: c * k) if k <= 1 else (lambda c: c + (255 - c) * (k - 1))
    return "#%02x%02x%02x" % tuple(int(max(0, min(255, f(c)))) for c in (r, g, b))

def circle(cx, cy, r):  # as a path subpath, for even-odd cut-outs
    return "M%.1f %.1f A%.1f %.1f 0 1 0 %.1f %.1f A%.1f %.1f 0 1 0 %.1f %.1f Z" % (
        cx + r, cy, r, r, cx - r, cy, r, r, cx + r, cy)

def gear_symbol(name, phase, colour):  # a gear centred on (0, 0)
    ra, rf, p = R + M, R - 1.25 * M, 2 * math.pi / N
    pts = []
    for k in range(N):
        t = phase + k * p
        for rad, da in ((rf, -p * 0.27), (rf, -p * 0.2), (ra, -p * 0.11), (ra, p * 0.11), (rf, p * 0.2), (rf, p * 0.27)):
            pts.append((rad * math.cos(t + da), rad * math.sin(t + da)))
    outline = "M" + " L".join("%.1f %.1f" % q for q in pts) + " Z"
    hole = circle(0, 0, R * 0.2)
    return (
        '<g id="%s">' % name
        + '<path d="%s %s" fill="%s" fill-rule="evenodd" stroke="%s" stroke-width="2.5" stroke-linejoin="round"/>'
        % (outline, hole, colour, shade(colour, 0.72))
        + '<path d="%s %s" fill="%s" fill-rule="evenodd"/>' % (circle(0, 0, R * 0.5), hole, shade(colour, 1.35))
        + "</g>"
    )

s = 2 * R
out = ['<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 %d %d" role="img" aria-label="A lattice of interlocking gears in the Julia colours">' % (W, H), "<defs>"]
for c, colour in enumerate(COLORS):
    for ph in (0, 1):   # tooth phase: 0 on even lattice cells, half a pitch on odd ones
        out.append(gear_symbol("g%d%d" % (c, ph), ph * math.pi / N, colour))
out.append("</defs>")
for j in range(-1, int(H / s) + 2):
    for i in range(-1, int(W / s) + 2):
        out.append('<use href="#g%d%d" x="%.1f" y="%.1f"/>' % ((i + 2 * j) % 4, (i + j) % 2, s * (i + 0.3), s * (j + 0.3)))
out.append("</svg>")
path = os.path.join(os.path.dirname(__file__), "..", "..", "_assets", "infra", "ecosystem", "apps.svg")
open(path, "w").write("\n".join(out))
print("wrote", os.path.relpath(path), "%d gears, %.1f KB" % (sum(1 for l in out if l.startswith("<use")), os.path.getsize(path) / 1024))
