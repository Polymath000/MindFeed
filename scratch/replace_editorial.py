import os

LIB_DIR = "lib"

replacements = {
    "EditorialPalette.": "AppColors.",
    "EditorialRadii.": "AppBorders.",
    "EditorialSpace.": "AppConstants.",
}

def process_file(filepath):
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    modified = False
    for k, v in replacements.items():
        if k in content:
            content = content.replace(k, v)
            modified = True
            
    if modified:
        import_str = "import 'package:mind_feed/core/constants/app_colors.dart';"
        import_borders = "import 'package:mind_feed/core/constants/borders.dart';"
        import_constants = "import 'package:mind_feed/core/constants/constants.dart';"
        
        if "AppColors." in content and import_str not in content:
            content = import_str + "\n" + content
        if "AppBorders." in content and import_borders not in content:
            content = import_borders + "\n" + content
        if "AppConstants." in content and import_constants not in content:
            content = import_constants + "\n" + content
            
        with open(filepath, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"Updated {filepath}")

if __name__ == "__main__":
    for root, dirs, files in os.walk(LIB_DIR):
        for file in files:
            if file.endswith(".dart"):
                process_file(os.path.join(root, file))

