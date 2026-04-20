import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF006D5B); // Primary teal color
  static const Color primaryDark = Color(0xFF0B192C); // Dark blue for export button
  
  // Backgrounds
  static const Color darkCardBackground = Color(0xFF0B1221); // Monthly insights background
  static const Color totalSummaryBackground = Color.fromARGB(255, 202, 241, 225); // Total summary bottom bar
  static Color iconBackground = Colors.cyan.shade100; // Ledger icon background
  static Color indicatorBackground = Colors.cyan.shade50; // Text indicator background
  static Color lightBackground = Colors.grey.shade50; // Head item background
  static Color badgeBackground = Colors.grey.shade200; // Type badge background
  
  // Text & Icon Colors
  static const Color iconColor = Colors.teal; // Ledger icon
  static Color indicatorText = Colors.teal.shade800; // Indicator text inside full ledger
  static const Color textBlack = Colors.black;
  static const Color textBlack87 = Colors.black87;
  static const Color textGrey = Colors.grey;
  static const Color textWhite = Colors.white;
  
  // Status Colors / Accents
  static const Color positiveAccent = Colors.tealAccent; // Positive trend
  static const Color negativeAccent = Colors.redAccent; // Negative trend
  static Color errorBackground = Colors.red.shade400; // Delete background
  static const Color errorText = Colors.red;
  static const Color successText = Colors.green;
  static Color dotActive = Colors.blue.shade300; // Expense head dot
  
  // Misc
  static const Color barPlaceholder = Colors.white24; // Static bar placeholder
  static Color dividerColor = Colors.grey.shade300; // Dividers
}
