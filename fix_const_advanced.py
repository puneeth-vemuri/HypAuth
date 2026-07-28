import os
import re

def fix_file(filepath):
    if not filepath.endswith('.dart'): return
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original = content

    # aggressively strip const from specific widget instantiations
    content = re.sub(r'const\s+Text\(', 'Text(', content)
    content = re.sub(r'const\s+BorderSide\(', 'BorderSide(', content)
    content = re.sub(r'const\s+TextStyle\(', 'TextStyle(', content)
    content = re.sub(r'const\s+Icon\(', 'Icon(', content)
    content = re.sub(r'const\s+Divider\(', 'Divider(', content)
    content = re.sub(r'const\s+HypAuthLogoMark\(', 'HypAuthLogoMark(', content)
    content = re.sub(r'const\s+Color\(', 'Color(', content)
    
    if content != original:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Fixed {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        fix_file(os.path.join(root, file))
