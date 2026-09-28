"""Check compiled ASCII STL geometry, not physical strength or print quality."""
from collections import Counter, defaultdict
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent
PARTS = {
    "pi-carrier-core-draft": 1,
    "camera-bracket": 1,
    "forward-depth-bracket": 1,
    "battery-end-stops": 2,
    "electronics-stack-adapter": 1,
    "electronics-flow-support": 1,
}


def inspect(name, expected_components):
    path = ROOT / f"{name}.stl"
    vertices = [tuple(map(float, v)) for v in re.findall(
        r"vertex\s+([-\d.eE+]+)\s+([-\d.eE+]+)\s+([-\d.eE+]+)",
        path.read_text())]
    assert vertices and len(vertices) % 3 == 0, name
    edges, directed = Counter(), Counter()
    adjacent = defaultdict(set)
    volume = 0
    for i in range(0, len(vertices), 3):
        a, b, c = vertices[i:i+3]
        assert len({a, b, c}) == 3, (name, "degenerate triangle")
        for u, v in ((a, b), (b, c), (c, a)):
            edges[tuple(sorted((u, v)))] += 1
            directed[u, v] += 1
            adjacent[u].add(v)
            adjacent[v].add(u)
        volume += (a[0]*(b[1]*c[2]-b[2]*c[1])
                   + a[1]*(b[2]*c[0]-b[0]*c[2])
                   + a[2]*(b[0]*c[1]-b[1]*c[0])) / 6
    assert all(count == 2 for count in edges.values()), (name, "open/nonmanifold edge")
    assert all(directed[u, v] == directed[v, u] for u, v in directed), (name, "inconsistent winding")
    left, components = set(adjacent), 0
    while left:
        components += 1
        todo = [left.pop()]
        while todo:
            for v in adjacent[todo.pop()]:
                if v in left:
                    left.remove(v)
                    todo.append(v)
    assert components == expected_components, (name, components)
    assert volume > 0, (name, "nonpositive volume")
    return {"name": name, "triangles": len(vertices)//3, "components": components,
            "bounds_mm": [[min(v[i] for v in vertices), max(v[i] for v in vertices)] for i in range(3)],
            "volume_mm3": round(volume, 2), "solid_petg_g_at_1_3": round(volume*.0013, 2)}


if __name__ == "__main__":
    results = [inspect(name, count) for name, count in PARTS.items()]
    total = sum(r["solid_petg_g_at_1_3"] for r in results)
    output = {"parts": results, "total_solid_petg_g": round(total, 2),
              "scope": "One of each STL; battery file contains two stops. No hardware, unmodeled mounts or flight qualification."}
    (ROOT / "mount-mesh-checks.json").write_text(json.dumps(output, indent=2)+"\n")
    print(json.dumps(output, indent=2))
