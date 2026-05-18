#!/usr/bin/env python3
"""Samodzielny generator strukturalnej mapy repo -> graph.json.

Zero zewnętrznych zależności (tylko biblioteka standardowa). Zamiast
re-czytać dziesiątki plików, Claude może odpytać graph.json.

Węzły  = pliki w repo.
Krawędzie:
  - link      : relatywny link Markdown [tekst](sciezka.md)
  - wikilink  : [[NazwaPliku]] w stylu Obsidian (po nazwie bazowej)
  - import    : import w kodzie (Python przez `ast`, reszta lekkim regex)

Użycie:
  python3 tools/generate_graph.py [root]      # zapis ROOT/graph.json
  python3 tools/generate_graph.py --stdout     # wypisz na stdout

Wyjście jest deterministyczne (posortowane) — czyste diffy w gicie.
"""
from __future__ import annotations

import ast
import json
import os
import re
import sys
from datetime import datetime, timezone

IGNORE_DIRS = {".git", "node_modules", "__pycache__", ".venv", "venv", "dist", "build"}
IGNORE_FILES = {"graph.json"}

CODE_EXT = {
    ".py": "python",
    ".js": "javascript",
    ".jsx": "javascript",
    ".ts": "typescript",
    ".tsx": "typescript",
    ".sh": "shell",
    ".bash": "shell",
}
DOC_EXT = {".md": "markdown", ".markdown": "markdown"}

MD_LINK_RE = re.compile(r"\[[^\]]*\]\(\s*<?([^)>\s]+)>?\s*(?:\"[^\"]*\")?\)")
MD_WIKILINK_RE = re.compile(r"\[\[([^\]|#]+)(?:[#|][^\]]*)?\]\]")
JS_IMPORT_RE = re.compile(
    r"""(?:import[^'"]*from\s*['"]([^'"]+)['"])"""
    r"""|(?:require\(\s*['"]([^'"]+)['"]\s*\))"""
    r"""|(?:import\s*['"]([^'"]+)['"])"""
)
SH_SOURCE_RE = re.compile(r"^\s*(?:\.|source)\s+([^\s;]+)", re.MULTILINE)


def iter_files(root: str):
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = sorted(d for d in dirnames if d not in IGNORE_DIRS)
        for name in sorted(filenames):
            if name in IGNORE_FILES:
                continue
            full = os.path.join(dirpath, name)
            rel = os.path.relpath(full, root).replace(os.sep, "/")
            yield rel, full


def classify(rel: str) -> str:
    ext = os.path.splitext(rel)[1].lower()
    if ext in DOC_EXT:
        return DOC_EXT[ext]
    if ext in CODE_EXT:
        return CODE_EXT[ext]
    return "other"


def read_text(full: str) -> str:
    try:
        with open(full, "r", encoding="utf-8") as fh:
            return fh.read()
    except (OSError, UnicodeDecodeError):
        return ""


def resolve_relative(src_rel: str, target: str, known: set[str]) -> str | None:
    target = target.split("#", 1)[0].split("?", 1)[0].strip()
    if not target or target.startswith(("http://", "https://", "mailto:")):
        return None
    base = os.path.dirname(src_rel)
    cand = os.path.normpath(os.path.join(base, target)).replace(os.sep, "/")
    if cand in known:
        return cand
    for ext in (".md", ".py", ".js", ".ts", ".tsx", ".jsx", "/README.md", "/index.md"):
        if (cand + ext) in known:
            return cand + ext
    return None


def resolve_wikilink(name: str, by_stem: dict[str, list[str]]) -> str | None:
    hits = by_stem.get(os.path.basename(name).strip().lower())
    return hits[0] if hits and len(hits) == 1 else (hits[0] if hits else None)


def resolve_py_import(module: str, src_rel: str, known: set[str]) -> str | None:
    if not module:
        return None
    parts = module.split(".")
    base = os.path.dirname(src_rel)
    for prefix in (base, ""):
        stem = "/".join([p for p in [prefix] + parts if p])
        for cand in (stem + ".py", stem + "/__init__.py"):
            cand = os.path.normpath(cand).replace(os.sep, "/")
            if cand in known:
                return cand
    return None


def python_symbols_and_imports(text: str):
    symbols, imports = [], []
    try:
        tree = ast.parse(text)
    except SyntaxError:
        return symbols, imports
    for node in ast.iter_child_nodes(tree):
        if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
            symbols.append(node.name)
        elif isinstance(node, ast.ClassDef):
            symbols.append(node.name)
    for node in ast.walk(tree):
        if isinstance(node, ast.Import):
            imports += [a.name for a in node.names]
        elif isinstance(node, ast.ImportFrom) and node.module:
            imports.append(node.module)
            imports += [f"{node.module}.{a.name}" for a in node.names]
    return sorted(set(symbols)), imports


def build(root: str) -> dict:
    files = list(iter_files(root))
    known = {rel for rel, _ in files}
    by_stem: dict[str, list[str]] = {}
    for rel in sorted(known):
        by_stem.setdefault(os.path.splitext(os.path.basename(rel))[0].lower(), []).append(rel)

    nodes, edges = [], []
    for rel, full in files:
        kind = classify(rel)
        try:
            size = os.path.getsize(full)
        except OSError:
            size = 0
        node = {"id": rel, "type": kind, "size": size}
        text = read_text(full) if kind != "other" else ""

        if kind == "markdown":
            for m in MD_LINK_RE.finditer(text):
                tgt = resolve_relative(rel, m.group(1), known)
                if tgt and tgt != rel:
                    edges.append({"from": rel, "to": tgt, "kind": "link"})
            for m in MD_WIKILINK_RE.finditer(text):
                tgt = resolve_wikilink(m.group(1), by_stem)
                if tgt and tgt != rel:
                    edges.append({"from": rel, "to": tgt, "kind": "wikilink"})
        elif kind == "python":
            syms, imports = python_symbols_and_imports(text)
            if syms:
                node["symbols"] = syms
            for mod in imports:
                tgt = resolve_py_import(mod, rel, known)
                if tgt and tgt != rel:
                    edges.append({"from": rel, "to": tgt, "kind": "import"})
        elif kind in ("javascript", "typescript"):
            for m in JS_IMPORT_RE.finditer(text):
                spec = m.group(1) or m.group(2) or m.group(3)
                if spec and spec.startswith("."):
                    tgt = resolve_relative(rel, spec, known)
                    if tgt and tgt != rel:
                        edges.append({"from": rel, "to": tgt, "kind": "import"})
        elif kind == "shell":
            for m in SH_SOURCE_RE.finditer(text):
                tgt = resolve_relative(rel, m.group(1), known)
                if tgt and tgt != rel:
                    edges.append({"from": rel, "to": tgt, "kind": "import"})

        nodes.append(node)

    nodes.sort(key=lambda n: n["id"])
    seen, uniq_edges = set(), []
    for e in sorted(edges, key=lambda e: (e["from"], e["to"], e["kind"])):
        key = (e["from"], e["to"], e["kind"])
        if key not in seen:
            seen.add(key)
            uniq_edges.append(e)

    return {
        "generated": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "root": ".",
        "stats": {
            "files_scanned": len(files),
            "nodes": len(nodes),
            "edges": len(uniq_edges),
        },
        "nodes": nodes,
        "edges": uniq_edges,
    }


def main(argv: list[str]) -> int:
    args = [a for a in argv[1:] if a != "--stdout"]
    to_stdout = "--stdout" in argv[1:]
    root = os.path.abspath(args[0]) if args else os.getcwd()
    graph = build(root)
    payload = json.dumps(graph, ensure_ascii=False, indent=2) + "\n"
    if to_stdout:
        sys.stdout.write(payload)
    else:
        out = os.path.join(root, "graph.json")
        with open(out, "w", encoding="utf-8") as fh:
            fh.write(payload)
        s = graph["stats"]
        print(
            f"graph.json: {s['nodes']} węzłów, {s['edges']} krawędzi, "
            f"{s['files_scanned']} plików -> {out}"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
