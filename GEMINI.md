## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).
- A committed graphify-out/graph.json is rewritten whole on every build, so a large diff to it in a pull request is expected. Do not flag it as churn or suggest skipping the graph rebuild or its hooks.

## Empirical Verification & Assertion Rigor

- **Exact Test Counts**: Never estimate, adjust, or carry forward test counts between audit reports. Always extract exact counts directly from the latest `flutter test` terminal output. When counts change between targeted and full runs, explicitly document the breakdown.
- **Tree-Level Assertions**: Never claim visual rendering or widget presence from parser token logs or unhandled exception absence alone; verify the rendered widget tree (e.g. `find.byType(Image)`, `find.byWidgetPredicate(...)`, or mock image providers).
- **Control Flow Block Lint**: Always use braces for all `if`, `else`, `for`, and `while` blocks, including single-line statements (`curly_braces_in_flow_control_structures`).
