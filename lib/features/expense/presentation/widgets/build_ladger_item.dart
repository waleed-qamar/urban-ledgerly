import 'package:flutter/material.dart';

Widget buildLedgerItem(
  IconData icon,
  String title,
  String subtitle,
  String amount,
  String date,
  String headType,
  Color iconBgColor,
  Color iconColor,
) {
  return Row(
    children: [
      CircleAvatar(
        backgroundColor: iconBgColor,
        radius: 24,
        child: Icon(icon, color: iconColor),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Title: Head Name
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                // Tiny, clean badge for the Head Type
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    headType.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Subtitle: Remarks
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    ],
  );
}
