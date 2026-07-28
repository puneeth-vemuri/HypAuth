import os
import re

def fix_file(filepath):
    if not filepath.endswith('.dart'): return
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find patterns like "const Something(..., color: context.colors...)"
    # We can just remove "const " if the line contains context.colors
    # A safer way: replace "const " with "" on any line containing "context.colors"
    
    lines = content.split('\n')
    changed = False
    for i, line in enumerate(lines):
        if 'context.colors' in line and 'const ' in line:
            # specifically replace "const " before widgets that now use context
            lines[i] = line.replace('const ', '')
            changed = True
            
    if changed:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write('\n'.join(lines))
        print(f"Fixed {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        fix_file(os.path.join(root, file))
