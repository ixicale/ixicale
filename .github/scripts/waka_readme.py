"""Write WakaTime language stats into the "waka" section of README.md.

The data comes from a public WakaTime share link in JSON format
(Chart Type: Languages, Date Range: Last 7 Days). No key is necessary.

Usage: python3 waka_readme.py <share-json-url> [README.md]
"""

import json
import re
import sys
import urllib.request

BLOCKS = "⣀⣄⣤⣦⣶⣷⣿"
GRAPH_LEN = 25
LANG_COUNT = 5
TIME_WIDTH = 16
START = "<!--START_SECTION:waka-->"
END = "<!--END_SECTION:waka-->"


def fetch(url: str) -> list[dict]:
    req = urllib.request.Request(url, headers={"User-Agent": "waka-readme-workflow"})
    with urllib.request.urlopen(req, timeout=30) as resp:
        body = json.load(resp)
    data = body.get("data")
    if not isinstance(data, list):
        sys.exit(f"Unexpected JSON from the share link: {json.dumps(body)[:300]}")
    return data


def graph(percent: float) -> str:
    # Same algorithm as athul/waka-readme, so the graph looks the same.
    markers = len(BLOCKS) - 1
    proportion = percent / 100 * GRAPH_LEN
    bar = BLOCKS[-1] * int(proportion + 0.5 / markers)
    rest = int((proportion - len(bar)) * markers + 0.5)
    bar += BLOCKS[rest] if rest > 0 else ""
    return bar + BLOCKS[0] * (GRAPH_LEN - len(bar))


def time_text(lang: dict) -> str:
    if lang.get("text"):
        return str(lang["text"])
    seconds = lang.get("total_seconds")
    if seconds is None and lang.get("hours") is not None:
        seconds = float(lang["hours"]) * 3600 + float(lang.get("minutes", 0)) * 60
    if seconds is None:
        return ""
    hrs, mins = divmod(int(seconds) // 60, 60)
    parts = []
    if hrs:
        parts.append(f"{hrs} hr{'s' if hrs != 1 else ''}")
    parts.append(f"{mins} min{'s' if mins != 1 else ''}")
    return " ".join(parts)


def render(data: list[dict]) -> str:
    langs = sorted(data, key=lambda x: float(x.get("percent", 0)), reverse=True)[:LANG_COUNT]
    if not langs:
        return "No activity tracked"
    pad = max(len(str(lang["name"])) for lang in langs)
    with_time = any(time_text(lang) for lang in langs)
    lines = []
    for lang in langs:
        pct = float(lang.get("percent", 0))
        line = f"{str(lang['name']).ljust(pad)}   "
        if with_time:
            line += f"{time_text(lang): <{TIME_WIDTH}}"
        line += f"{graph(pct)}   " + f"{pct:.2f}".zfill(5) + " %"
        lines.append(line)
    return "\n".join(lines)


def main() -> None:
    if len(sys.argv) < 2 or not sys.argv[1].strip():
        sys.exit("Missing share link. Set the WAKATIME_SHARE_URL repository variable.")
    readme = sys.argv[2] if len(sys.argv) > 2 else "README.md"
    content = render(fetch(sys.argv[1].strip()))
    print(content)

    with open(readme, encoding="utf-8") as f:
        old = f.read()
    pattern = re.compile(re.escape(START) + r"[\s\S]+?" + re.escape(END))
    if not pattern.search(old):
        sys.exit(f"Cannot find {START} ... {END} in {readme}")
    new = pattern.sub(lambda _: f"{START}\n\n```txt\n{content}\n```\n\n{END}", old)
    with open(readme, "w", encoding="utf-8") as f:
        f.write(new)
    print("README changed" if new != old else "README already up to date")


if __name__ == "__main__":
    main()
