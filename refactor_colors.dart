import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    if (file.path.contains('app_theme.dart') || file.path.contains('app_colors.dart')) continue;
    
    var content = file.readAsStringSync();
    
    if (content.contains('AppColors.')) {
      content = content.replaceAll('AppColors.paper', 'context.colors.paper');
      content = content.replaceAll('AppColors.ink2', 'context.colors.ink2');
      content = content.replaceAll('AppColors.ink3', 'context.colors.ink3');
      content = content.replaceAll('AppColors.ink4', 'context.colors.ink4');
      content = content.replaceAll('AppColors.ink', 'context.colors.ink');
      content = content.replaceAll('AppColors.rule2', 'context.colors.rule2');
      content = content.replaceAll('AppColors.rule', 'context.colors.rule');
      content = content.replaceAll('AppColors.wash', 'context.colors.wash');
      content = content.replaceAll('AppColors.accent', 'context.colors.accent');
      content = content.replaceAll('AppColors.dangerRule', 'context.colors.dangerRule');
      content = content.replaceAll('AppColors.danger', 'context.colors.danger');
      
      // Also add the extension import if not present
      if (!content.contains('core/theme/app_theme.dart')) {
        // find a good place to import
        final importsEnd = content.lastIndexOf('import ');
        if (importsEnd != -1) {
          final nextLine = content.indexOf('\n', importsEnd);
          
          // figure out relative path to core/theme/app_theme.dart
          // Count directory depth
          final depth = file.path.split(Platform.pathSeparator).length - 2; // -1 for 'lib', -1 for filename
          final relativePrefix = depth == 0 ? '' : List.filled(depth, '../').join('');
          final importStmt = "import '${relativePrefix}core/theme/app_theme.dart';\n";
          
          content = content.substring(0, nextLine + 1) + importStmt + content.substring(nextLine + 1);
        }
      }
      
      file.writeAsStringSync(content);
      print('Updated \${file.path}');
    }
  }
}
