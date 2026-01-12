from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[3]


def load_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def load_html() -> str:
    return load_text(REPO_ROOT / "app" / "index.html")


def load_js() -> str:
    parts = [REPO_ROOT / "app" / "app.part1.js", REPO_ROOT / "app" / "app.part2.js"]
    if any(part.exists() for part in parts):
        return "\n".join(load_text(part) for part in parts if part.exists())
    return load_text(REPO_ROOT / "app" / "app.js")


def load_mobile_html() -> str:
    return load_text(REPO_ROOT / "app" / "mobile" / "index.html")


def load_mobile_js() -> str:
    return load_text(REPO_ROOT / "app" / "mobile" / "app.js")
