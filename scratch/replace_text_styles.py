import os
import re

# Directory containing the flutter code
LIB_DIR = "lib"

def process_file(filepath):
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    # Just print the files that contain TextStyle( to see how many we need to fix
    if "TextStyle(" in content:
        print(filepath)

if __name__ == "__main__":
    for root, dirs, files in os.walk(LIB_DIR):
        for file in files:
            if file.endswith(".dart"):
                process_file(os.path.join(root, file))

