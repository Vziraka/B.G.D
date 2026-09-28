"""Stdlib checks for exported ASCII OpenSCAD electronics prototypes."""
from pathlib import Path
from collections import Counter, defaultdict
import json

root = Path(__file__).parent
results = {}
for name in ("electronics-stack-adapter", "electronics-flow-support"):
    vertices = [tuple(map(float, line.split()[1:]))
                for line in (root / f"{name}.stl").read_text().splitlines()
                if line.strip().startswith("vertex ")]
    triangles = [vertices[i:i+3] for i in range(0, len(vertices), 3)]
    edges, links, volume = Counter(), defaultdict(set), 0.0
    for a, b, c in triangles:
        volume += (a[0]*(b[1]*c[2]-b[2]*c[1]) +
                   a[1]*(b[2]*c[0]-b[0]*c[2]) +
                   a[2]*(b[0]*c[1]-b[1]*c[0])) / 6
        for u, v in ((a,b),(b,c),(c,a)):
            edges[tuple(sorted((u,v)))] += 1
            links[u].add(v)
            links[v].add(u)
    unseen, components = set(vertices), 0
    while unseen:
        components += 1
        pending = [unseen.pop()]
        while pending:
            for neighbor in links[pending.pop()]:
                if neighbor in unseen:
                    unseen.remove(neighbor)
                    pending.append(neighbor)
    assert components == 1 and all(n == 2 for n in edges.values()) and volume > 0
    results[name] = dict(triangles=len(triangles), connected_components=components,
        nonmanifold_edges=sum(n != 2 for n in edges.values()),
        bounds_mm=[[min(v[i] for v in vertices), max(v[i] for v in vertices)] for i in range(3)],
        volume_mm3=round(volume, 2), solid_petg_mass_g_at_1_3=round(volume*0.0013, 2),
        physical_fit_verified=False)
(root / "electronics-mesh-check.json").write_text(json.dumps(results, indent=2)+"\n")
print(json.dumps(results, indent=2))
