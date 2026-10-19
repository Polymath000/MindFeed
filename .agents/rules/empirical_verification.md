---
trigger: always_on
description: Rigorous standards for empirical test verification, test count reconciliation, and control flow syntax.
---

# Empirical Verification & Assertion Rigor

- **Exact Test Counts**: Never estimate, adjust, or carry forward test counts between audit reports. Always extract exact counts directly from the latest `flutter test` terminal output. When counts change between targeted and full runs, explicitly document the breakdown.
- **Tree-Level Assertions**: Never claim visual rendering or widget presence from parser token logs or unhandled exception absence alone; verify the rendered widget tree (e.g. `find.byType(Image)`, `find.byWidgetPredicate(...)`, or mock image providers).
- **Control Flow Block Lint**: Always use braces for all `if`, `else`, `for`, and `while` blocks, including single-line statements (`curly_braces_in_flow_control_structures`).
