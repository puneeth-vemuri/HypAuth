import os
import re

def fix_file(filepath):
    if not filepath.endswith('.dart'): return
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
        
    # We only care about files that use context.colors
    if 'context.colors' not in content:
        return

    original = content

    # Replace 'const ' with '' when it's preceding a widget or a structural class.
    # We will remove const before common widgets to fix the compiler errors.
    # The compiler errors happen because parent widgets (like Padding, SizedBox, Column, Row, Container, Center, Expanded, Align, Stack, Positioned, ListView, Scaffold, SafeArea, Text, Icon, TextStyle, BorderSide, InputDecoration, etc) are declared as const, but their children use context.colors.
    
    widgets = ['Padding', 'SizedBox', 'Column', 'Row', 'Container', 'Center', 'Expanded', 'Align', 'Stack', 'Positioned', 'ListView', 'Scaffold', 'SafeArea', 'Text', 'Icon', 'TextStyle', 'BorderSide', 'InputDecoration', 'OutlineInputBorder', 'BoxDecoration', 'EdgeInsets', 'BorderRadius', 'Radius', 'TextSpan', 'RichText', 'Spacer', 'HypAuthLogoMark']
    
    for w in widgets:
        # replace "const WidgetName(" or "const WidgetName."
        content = re.sub(r'const\s+' + w + r'\(', w + '(', content)
        content = re.sub(r'const\s+' + w + r'\.', w + '.', content)

    # For ImportSuccessScreen: "Error: The getter 'context' isn't defined for the type 'ImportSuccessScreen'."
    # This happens if context is used inside a method that doesn't have it, or a static context, or in a StatefulWidget state where context is implicitly available but maybe the class is StatelessWidget and we forgot to pass it.
    # Let's just fix the generic "const " issues first, then we will manually inspect ImportSuccessScreen.
    
    if content != original:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Fixed {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        fix_file(os.path.join(root, file))
