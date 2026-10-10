import os
import re

# Directory containing the flutter code
LIB_DIR = "lib"

# Mapping from raw color strings to AppColors constants
color_mapping = {
    "Color(0xFFAAA49B)": "AppColors.greyText",
    "Color(0xFF383530)": "AppColors.borderDark",
    "Color(0xFF262422)": "AppColors.charcoal",
    "Color(0xFFFFF8E6)": "AppColors.softCream",
    "Color(0xFFDDD4C0)": "AppColors.creamDark",
    "Color(0xFF8E8E93)": "AppColors.greyIcon",
    "Color(0xFF1E88E5)": "AppColors.blue",
    "Color(0xFF171614)": "AppColors.ink",
    "Color(0xFFFFFDF9)": "AppColors.whiteLight",
    "Color(0xFFFFFDF8)": "AppColors.whiteLight",
    "Color(0xFFE5DECE)": "AppColors.creamBorder",
    "Color(0xFFE0E0E0)": "AppColors.softShadow",
    "Color(0xFFDC2626)": "AppColors.red",
    "Color(0xFF2A2825)": "AppColors.darkTile",
    "Color(0xFF111827)": "AppColors.gunmetal",
    "Color(0xFF10B981)": "AppColors.successGreen",
    "Color(0xFF0284C7)": "AppColors.lightBlue",
    "Color(0x0C30281C)": "AppColors.transparentDark",
    "Color(0xFFFFF1C6)": "AppColors.cream",
    "Color(0xFFFFE8A1)": "AppColors.butter",
    "Color(0xFFFFE5D0)": "AppColors.peach",
    "Color(0xFFFFE388)": "AppColors.yellowHighlight",
    "Color(0xFFFFDDE0)": "AppColors.blush",
    "Color(0xFFFFB300)": "AppColors.warning",
    "Color(0xFFF6F0E4)": "AppColors.creamLight",
    "Color(0xFFF5F5F5)": "AppColors.lightSurface",
    "Color(0xFFF5EEDC)": "AppColors.sand",
    "Color(0xFFF3EDE2)": "AppColors.sandLight",
    "Color(0xFFF1EBE0)": "AppColors.sandLighter",
    "Color(0xFFEF4444)": "AppColors.redHighlight",
    "Color(0xFFEDE5D4)": "AppColors.sandDark",
    "Color(0xFFE9E2D4)": "AppColors.sandDarker",
    "Color(0xFFE9DEFF)": "AppColors.lilac",
    "Color(0xFFE5E7EB)": "AppColors.lightGray",
    "Color(0xFFE2DAC8)": "AppColors.sandDarkest",
    "Color(0xFFE11D48)": "AppColors.roseRed",
    "Color(0xFFDCEEFF)": "AppColors.powder",
    "Color(0xFFD97706)": "AppColors.amberDark",
    "Color(0xFFD7F5E8)": "AppColors.mint",
    "Color(0xFFD1D5DB)": "AppColors.mediumGray",
    "Color(0xFFBCE8D3)": "AppColors.mintDark",
    "Color(0xFFB5ADA0)": "AppColors.greyBrown",
    "Color(0xFFB45309)": "AppColors.amberDarker",
    "Color(0xFF9CA3AF)": "AppColors.textGray",
    "Color(0xFF7F5112)": "AppColors.mediumBrown",
    "Color(0xFF7C3AED)": "AppColors.purple",
    "Color(0xFF55524C)": "AppColors.mutedInkDark",
    "Color(0xFF514D46)": "AppColors.mutedInk",
    "Color(0xFF4F46E5)": "AppColors.indigo",
    "Color(0xFF4B5563)": "AppColors.darkGrey",
    "Color(0xFF3B9A1E)": "AppColors.success",
    "Color(0xFF334155)": "AppColors.pickledBluewood",
    "Color(0xFF2563EB)": "AppColors.blueMain",
    "Color(0xFF24221E)": "AppColors.charcoalDark",
    "Color(0xff23262b)": "AppColors.spaceBlack",
    "Color(0xFF23211F)": "AppColors.charcoalDarker",
    "Color(0xff1F1F2E)": "AppColors.darkBg",
    "Color(0xFF1E1D1A)": "AppColors.inkDark",
    "Color(0xFF1B5E20)": "AppColors.greenDark",
    "Color(0xFF191816)": "AppColors.inkDarker",
    "Color(0xFF14B8A6)": "AppColors.topaz",
    "Color(0xFF131210)": "AppColors.inkDarkest",
    "Color(0xFF0E7490)": "AppColors.cyanDark",
    "Color(0xFF0E0D0C)": "AppColors.almostBlack",
    "Color(0xFF0864ff)": "AppColors.facebook",
    "Color(0xFF065F46)": "AppColors.greenDarker",
    "Color(0xFF059669)": "AppColors.greenMain",
    "Color(0xFF047857)": "AppColors.greenMedium",
    "Color(0x18000000)": "AppColors.transparentBlack"
}

def update_app_colors():
    app_colors_path = "lib/core/constants/app_colors.dart"
    with open(app_colors_path, "r") as f:
        content = f.read()

    # Find where to insert new colors (before the last closing brace)
    insert_pos = content.rfind("}")
    
    new_colors = """
  // Refactored constants
  static const Color greyText = Color(0xFFAAA49B);
  static const Color borderDark = Color(0xFF383530);
  static const Color charcoal = Color(0xFF262422);
  static const Color softCream = Color(0xFFFFF8E6);
  static const Color creamDark = Color(0xFFDDD4C0);
  static const Color greyIcon = Color(0xFF8E8E93);
  static const Color ink = Color(0xFF171614);
  static const Color whiteLight = Color(0xFFFFFDF8);
  static const Color creamBorder = Color(0xFFE5DECE);
  static const Color darkTile = Color(0xFF2A2825);
  static const Color successGreen = Color(0xFF10B981);
  static const Color transparentDark = Color(0x0C30281C);
  static const Color cream = Color(0xFFFFF1C6);
  static const Color butter = Color(0xFFFFE8A1);
  static const Color peach = Color(0xFFFFE5D0);
  static const Color yellowHighlight = Color(0xFFFFE388);
  static const Color blush = Color(0xFFFFDDE0);
  static const Color creamLight = Color(0xFFF6F0E4);
  static const Color sand = Color(0xFFF5EEDC);
  static const Color sandLight = Color(0xFFF3EDE2);
  static const Color sandLighter = Color(0xFFF1EBE0);
  static const Color redHighlight = Color(0xFFEF4444);
  static const Color sandDark = Color(0xFFEDE5D4);
  static const Color sandDarker = Color(0xFFE9E2D4);
  static const Color lilac = Color(0xFFE9DEFF);
  static const Color sandDarkest = Color(0xFFE2DAC8);
  static const Color roseRed = Color(0xFFE11D48);
  static const Color powder = Color(0xFFDCEEFF);
  static const Color amberDark = Color(0xFFD97706);
  static const Color mint = Color(0xFFD7F5E8);
  static const Color mintDark = Color(0xFFBCE8D3);
  static const Color greyBrown = Color(0xFFB5ADA0);
  static const Color amberDarker = Color(0xFFB45309);
  static const Color mutedInkDark = Color(0xFF55524C);
  static const Color mutedInk = Color(0xFF514D46);
  static const Color blueMain = Color(0xFF2563EB);
  static const Color charcoalDark = Color(0xFF24221E);
  static const Color charcoalDarker = Color(0xFF23211F);
  static const Color darkBg = Color(0xff1F1F2E);
  static const Color inkDark = Color(0xFF1E1D1A);
  static const Color greenDark = Color(0xFF1B5E20);
  static const Color inkDarker = Color(0xFF191816);
  static const Color inkDarkest = Color(0xFF131210);
  static const Color cyanDark = Color(0xFF0E7490);
  static const Color almostBlack = Color(0xFF0E0D0C);
  static const Color greenDarker = Color(0xFF065F46);
  static const Color greenMain = Color(0xFF059669);
  static const Color greenMedium = Color(0xFF047857);
  static const Color transparentBlack = Color(0x18000000);
"""
    # Append if not already there
    if "greyText" not in content:
        content = content[:insert_pos] + new_colors + content[insert_pos:]
        with open(app_colors_path, "w") as f:
            f.write(content)
        print("Updated app_colors.dart")

def process_file(filepath):
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
    
    original = content
    modified = False
    
    # Needs import
    needs_import = False

    for color_str, app_color_ref in color_mapping.items():
        if color_str in content:
            # We only replace if we aren't in app_colors.dart or editorial_design.dart
            if "app_colors.dart" in filepath or "editorial_design.dart" in filepath:
                continue
            content = content.replace(color_str, app_color_ref)
            needs_import = True
            modified = True

    if modified:
        # Add import if missing
        import_str = "import 'package:mind_feed/core/constants/app_colors.dart';"
        if import_str not in content:
            # Insert after the last import
            imports = re.findall(r"^import\s+.*;$", content, re.MULTILINE)
            if imports:
                last_import = imports[-1]
                content = content.replace(last_import, last_import + "\n" + import_str)
            else:
                content = import_str + "\n" + content
                
        with open(filepath, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"Updated {filepath}")

if __name__ == "__main__":
    update_app_colors()
    for root, dirs, files in os.walk(LIB_DIR):
        for file in files:
            if file.endswith(".dart"):
                process_file(os.path.join(root, file))

