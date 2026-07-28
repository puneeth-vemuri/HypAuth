import os

def process_file(filepath):
    if 'app_theme.dart' in filepath or 'app_colors.dart' in filepath:
        return
        
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
        
    if 'AppColors.' in content:
        content = content.replace('AppColors.paper', 'context.colors.paper')
        content = content.replace('AppColors.ink2', 'context.colors.ink2')
        content = content.replace('AppColors.ink3', 'context.colors.ink3')
        content = content.replace('AppColors.ink4', 'context.colors.ink4')
        content = content.replace('AppColors.ink', 'context.colors.ink')
        content = content.replace('AppColors.rule2', 'context.colors.rule2')
        content = content.replace('AppColors.rule', 'context.colors.rule')
        content = content.replace('AppColors.wash', 'context.colors.wash')
        content = content.replace('AppColors.accent', 'context.colors.accent')
        content = content.replace('AppColors.dangerRule', 'context.colors.dangerRule')
        content = content.replace('AppColors.danger', 'context.colors.danger')
        
        if 'core/theme/app_theme.dart' not in content:
            last_import = content.rfind('import ')
            if last_import != -1:
                next_line = content.find('\n', last_import)
                
                parts = filepath.replace('\\', '/').split('/')
                depth = len(parts) - 2
                prefix = '../' * depth if depth > 0 else ''
                import_stmt = f"\nimport '{prefix}core/theme/app_theme.dart';"
                
                content = content[:next_line] + import_stmt + content[next_line:]
                
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f'Updated {filepath}')

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))
