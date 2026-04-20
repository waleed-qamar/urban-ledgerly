import os
import re

content = ""
filepath = '/home/waleedqamar/Documents/ledgerly/lib/features/expense/presentation/pages/expense_by_head_view.dart'
with open(filepath, 'r') as f:
    content = f.read()

replacements = {
    'Colors.white': 'AppColors.textWhite',
    'Colors.cyan.shade50': 'AppColors.indicatorBackground',
    'Colors.teal': 'AppColors.iconColor',
    'const Color(0xFFFAEDE3)': 'AppColors.totalSummaryBackground',
    'Color(0xFFFAEDE3)': 'AppColors.totalSummaryBackground',
    'Colors.grey.shade300': 'AppColors.dividerColor',
    'Colors.grey': 'AppColors.textGrey',
    'const Color(0xFF006D5B)': 'AppColors.primary',
    'Color(0xFF006D5B)': 'AppColors.primary',
}

for k, v in replacements.items():
    content = content.replace(k, v)

import_statement = "import '../../../../core/theme/app_colors.dart';\n"
if 'app_colors.dart' not in content:
    content = content.replace("import 'package:flutter/material.dart';", f"import 'package:flutter/material.dart';\n{import_statement}")

with open(filepath, 'w') as f:
    f.write(content)
print("Done fixing expense_by_head_view.dart")
