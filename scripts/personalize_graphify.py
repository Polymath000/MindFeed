import os
import re
import json

HTML_PATH = os.path.join("graphify-out", "graph.html")

MINDFEED_PALETTE = [
    "#FFE8A1",
    "#10B981",
    "#E9DEFF",
    "#FFDDE0",
    "#FFE5D0",
    "#DCEEFF",
    "#FFF1C6",
    "#FBBF24",
    "#34D399",
    "#E11D48",
    "#60A5FA",
    "#A78BFA",
    "#F472B6",
    "#FCD34D",
    "#6EE7B7",
    "#DDD4C0",
    "#2563EB",
    "#059669",
    "#D97706",
    "#8B5CF6",
]

EDITORIAL_CSS = """<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Newsreader:ital,opsz,wght@0,6..72,500;0,6..72,600;1,6..72,400&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    background: #0E0D0C;
    color: #FFF8E6;
    font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    display: flex;
    height: 100vh;
    overflow: hidden;
  }
  #graph {
    flex: 1;
    background: radial-gradient(circle at 50% 50%, #161513 0%, #0E0D0C 100%);
  }
  #sidebar {
    width: 320px;
    background: #171614;
    border-left: 1px solid #383530;
    display: flex;
    flex-direction: column;
    overflow: hidden;
    box-shadow: -6px 0 30px rgba(0, 0, 0, 0.5);
  }
  #brand-header {
    padding: 16px 16px 14px 16px;
    border-bottom: 1px solid #2A2825;
    display: flex;
    align-items: center;
    justify-content: space-between;
    background: #191816;
  }
  .brand-title {
    font-family: 'Newsreader', serif;
    font-size: 21px;
    font-weight: 600;
    color: #FFF1C6;
    letter-spacing: -0.02em;
    display: flex;
    align-items: center;
    gap: 8px;
  }
  .brand-badge {
    font-size: 10px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.08em;
    padding: 3px 8px;
    border-radius: 999px;
    background: #262422;
    color: #FFE8A1;
    border: 1px solid #383530;
  }
  #search-wrap {
    padding: 14px 16px;
    border-bottom: 1px solid #2A2825;
  }
  #search {
    width: 100%;
    background: #1E1D1A;
    border: 1px solid #383530;
    color: #FFF8E6;
    padding: 9px 12px;
    border-radius: 8px;
    font-size: 13px;
    font-family: inherit;
    outline: none;
    transition: all 0.15s ease;
  }
  #search:focus {
    border-color: #FFE8A1;
    box-shadow: 0 0 0 2px rgba(255, 232, 161, 0.12);
  }
  #search-results {
    max-height: 160px;
    overflow-y: auto;
    padding: 6px 16px;
    border-bottom: 1px solid #2A2825;
    display: none;
  }
  .search-item {
    padding: 6px 8px;
    cursor: pointer;
    border-radius: 6px;
    font-size: 12px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    color: #DDD4C0;
    transition: background 0.12s ease;
  }
  .search-item:hover {
    background: #262422;
    color: #FFF1C6;
  }
  #info-panel {
    padding: 16px;
    border-bottom: 1px solid #2A2825;
    min-height: 140px;
    background: #181715;
  }
  #info-panel h3 {
    font-size: 11px;
    color: #AAA49B;
    margin-bottom: 10px;
    text-transform: uppercase;
    letter-spacing: 0.08em;
    font-weight: 700;
  }
  #info-content {
    font-size: 13px;
    color: #DDD4C0;
    line-height: 1.6;
  }
  #info-content .field { margin-bottom: 6px; }
  #info-content .field b {
    color: #FFF1C6;
    font-family: 'Newsreader', serif;
    font-size: 16px;
    font-weight: 600;
    display: block;
    margin-bottom: 2px;
  }
  #info-content .empty { color: #8E8E93; font-style: italic; }
  .neighbor-link {
    display: block;
    padding: 5px 8px;
    margin: 3px 0;
    border-radius: 6px;
    cursor: pointer;
    font-size: 12px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    border-left: 3px solid #383530;
    background: #23211F;
    color: #DDD4C0;
    transition: background 0.12s ease, transform 0.1s ease;
  }
  .neighbor-link:hover {
    background: #2A2825;
    color: #FFF8E6;
    transform: translateX(2px);
  }
  #neighbors-list { max-height: 160px; overflow-y: auto; margin-top: 6px; }
  #legend-wrap { flex: 1; overflow-y: auto; padding: 16px; }
  #legend-wrap h3 {
    font-size: 11px;
    color: #AAA49B;
    margin-bottom: 12px;
    text-transform: uppercase;
    letter-spacing: 0.08em;
    font-weight: 700;
  }
  .legend-item {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 5px 6px;
    cursor: pointer;
    border-radius: 6px;
    font-size: 12px;
    color: #DDD4C0;
    transition: background 0.12s ease;
  }
  .legend-item:hover {
    background: #262422;
    color: #FFF1C6;
  }
  .legend-item.dimmed { opacity: 0.25; }
  .legend-dot { width: 11px; height: 11px; border-radius: 50%; flex-shrink: 0; box-shadow: 0 0 6px rgba(0,0,0,0.4); }
  .legend-label { flex: 1; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
  .legend-count { color: #8E8E93; font-size: 11px; }
  #stats {
    padding: 12px 16px;
    border-top: 1px solid #2A2825;
    font-size: 11px;
    color: #AAA49B;
    background: #141311;
  }
  #legend-controls { display: flex; align-items: center; gap: 8px; margin-bottom: 12px; padding: 2px 0; }
  #legend-controls label { display: flex; align-items: center; gap: 8px; cursor: pointer; font-size: 12px; color: #AAA49B; user-select: none; }
  #legend-controls label:hover { color: #FFF8E6; }
  .legend-cb, #select-all-cb {
    appearance: none;
    -webkit-appearance: none;
    width: 15px;
    height: 15px;
    border: 1.5px solid #383530;
    border-radius: 4px;
    background: #1E1D1A;
    cursor: pointer;
    position: relative;
    flex-shrink: 0;
    transition: all 0.15s ease;
  }
  .legend-cb:checked, #select-all-cb:checked {
    background: #FFE8A1;
    border-color: #FFE8A1;
  }
  .legend-cb:checked::after, #select-all-cb:checked::after {
    content: '';
    position: absolute;
    left: 4.5px;
    top: 2px;
    width: 3.5px;
    height: 7px;
    border: solid #171614;
    border-width: 0 2px 2px 0;
    transform: rotate(45deg);
  }
  #select-all-cb:indeterminate {
    background: #FFE8A1;
    border-color: #FFE8A1;
  }
  #select-all-cb:indeterminate::after {
    content: '';
    position: absolute;
    left: 3px;
    top: 5px;
    width: 7px;
    height: 2px;
    background: #171614;
    border: none;
    transform: none;
  }
  ::-webkit-scrollbar { width: 5px; }
  ::-webkit-scrollbar-track { background: transparent; }
  ::-webkit-scrollbar-thumb { background: #383530; border-radius: 4px; }
  ::-webkit-scrollbar-thumb:hover { background: #AAA49B; }
</style>"""

def personalize():
    if not os.path.exists(HTML_PATH):
        print(f"Error: {HTML_PATH} not found")
        return

    with open(HTML_PATH, "r", encoding="utf-8") as f:
        html = f.read()

    html = re.sub(r"<style>.*?</style>", EDITORIAL_CSS, html, flags=re.DOTALL)

    if '<div id="brand-header">' not in html:
        brand_header = """<div id="sidebar">
  <div id="brand-header">
    <div class="brand-title">MindFeed</div>
    <div class="brand-badge">Knowledge Graph</div>
  </div>"""
        html = html.replace('<div id="sidebar">', brand_header, 1)

    nodes_match = re.search(r"const RAW_NODES = (\[.*?\]);", html, flags=re.DOTALL)
    if nodes_match:
        nodes = json.loads(nodes_match.group(1))
        for n in nodes:
            comm = n.get("community", 0)
            col = MINDFEED_PALETTE[comm % len(MINDFEED_PALETTE)]
            n["color"] = {
                "background": col,
                "border": col,
                "highlight": {
                    "background": "#FFFFFF",
                    "border": "#FFE8A1"
                }
            }
            n["font"] = {
                "size": n.get("font", {}).get("size", 12),
                "color": "#FFF8E6"
            }
        new_nodes_json = json.dumps(nodes)
        html = html[:nodes_match.start(1)] + new_nodes_json + html[nodes_match.end(1):]

    edges_match = re.search(r"const RAW_EDGES = (\[.*?\]);", html, flags=re.DOTALL)
    if edges_match:
        edges = json.loads(edges_match.group(1))
        for e in edges:
            e["color"] = {
                "color": "rgba(221, 212, 192, 0.16)",
                "highlight": "#FFE8A1",
                "hover": "#FFE8A1",
                "inherit": False
            }
        new_edges_json = json.dumps(edges)
        html = html[:edges_match.start(1)] + new_edges_json + html[edges_match.end(1):]

    html = html.replace("<title>graphify - graphify-out/graph.html</title>", "<title>MindFeed &mdash; Knowledge Graph</title>")

    with open(HTML_PATH, "w", encoding="utf-8") as f:
        f.write(html)

    print("Successfully personalized graph.html with MindFeed editorial UI styling!")

if __name__ == "__main__":
    personalize()
