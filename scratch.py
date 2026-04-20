import os
import re

files_to_update = [
    '/home/waleedqamar/Documents/ledgerly/lib/features/expense/presentation/pages/expense_dashboard_view.dart',
    '/home/waleedqamar/Documents/ledgerly/lib/features/expense/presentation/pages/full_ledger_view.dart',
    '/home/waleedqamar/Documents/ledgerly/lib/features/expense/presentation/pages/manage_heads_view.dart',
    '/home/waleedqamar/Documents/ledgerly/lib/features/expense/presentation/pages/add_expense_dialog.dart',
    '/home/waleedqamar/Documents/ledgerly/lib/features/expense/presentation/pages/add_expense_head_dialog.dart',
]

replacements = {
    'const Color(0xFF006D5B)': 'AppColors.primary',
    'Color(0xFF006D5B)': 'AppColors.primary',
    'const Color(0xFF0B192C)': 'AppColors.primaryDark',
    'Color(0xFF0B192C)': 'AppColors.primaryDark',
    'const Color(0xFF0B1221)': 'AppColors.darkCardBackground',
    'Color(0xFF0B1221)': 'AppColors.darkCardBackground',
    'Colors.cyan.shade100': 'AppColors.iconBackground',
    'Colors.teal.shade800': 'AppColors.indicatorText',
    'Colors.cyan.shade50': 'AppColors.indicatorBackground',
    'const Color.fromARGB(255, 202, 241, 225)': 'AppColors.totalSummaryBackground',
    'Color.fromARGB(255, 202, 241, 225)': 'AppColors.totalSummaryBackground',
    'Colors.tealAccent': 'AppColors.positiveAccent',
    'Colors.redAccent': 'AppColors.negativeAccent',
    'Colors.blue.shade300': 'AppColors.dotActive',
    'Colors.grey.shade50': 'AppColors.lightBackground',
    'Colors.grey.shade300': 'AppColors.dividerColor',
    'Colors.white24': 'AppColors.barPlaceholder',
}

for filepath in files_to_update:
    if not os.path.exists(filepath):
        continue
    with open(filepath, 'r') as f:
        content = f.read()

    # Apply some regular string replacements
    for k, v in replacements.items():
        content = content.replace(k, v)
        
    depth = 4
    if filepath.endswith('manage_heads_view.dart') or filepath.endswith('full_ledger_view.dart') or filepath.endswith('expense_dashboard_view.dart') or filepath.endswith('add_expense_dialog.dart') or filepath.endswith('add_expense_head_dialog.dart'):
        # Usually from features/expense/presentation/pages/... to core/theme is ../../../../core/theme/app_colors.dart
        import_statement = "import '../../../../core/theme/app_colors.dart';\n"
    else:
        import_statement = "import '../../../../core/theme/app_colors.dart';\n"
        
    if 'app_colors.dart' not in content:
        content = content.replace("import 'package:flutter/material.dart';", f"import 'package:flutter/material.dart';\n{import_statement}")
    else:
        pass
    
    with open(filepath, 'w') as f:
        f.write(content)

print("Done replacing.")
