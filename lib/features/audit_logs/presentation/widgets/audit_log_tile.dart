import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:ledgerly/core/theme/app_colors.dart';

import '../../domain/entities/audit_log_entity.dart';

class AuditLogTile extends StatefulWidget {
  final AuditLogEntity log;

  const AuditLogTile({super.key, required this.log});

  @override
  State<AuditLogTile> createState() => _AuditLogTileState();
}

class _AuditLogTileState extends State<AuditLogTile> {
  bool _expanded = false;

  Color get _actionColor {
    switch (widget.log.actionType) {
      case AuditAction.insert:
        return AppColors.successText;
      case AuditAction.update:
        return AppColors.primary;
      case AuditAction.delete:
        return AppColors.errorText;
      case AuditAction.unknown:
        return AppColors.textGrey;
    }
  }

  IconData get _actionIcon {
    switch (widget.log.actionType) {
      case AuditAction.insert:
        return Icons.add_circle_outline;
      case AuditAction.update:
        return Icons.edit_outlined;
      case AuditAction.delete:
        return Icons.delete_outline;
      case AuditAction.unknown:
        return Icons.help_outline;
    }
  }

  String get _relativeTime {
    final diff = DateTime.now().difference(widget.log.changedAt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d, yyyy • h:mm a').format(widget.log.changedAt);
  }

  @override
  Widget build(BuildContext context) {
    final log = widget.log;
    final hasDiff = log.fieldDiffs.isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: hasDiff
                ? () => setState(() => _expanded = !_expanded)
                : null,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: _actionColor.withValues(alpha: 0.12),
                    child: Icon(_actionIcon, color: _actionColor, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          log.description ??
                              '${log.tableName} ${log.actionType.label.toLowerCase()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textBlack87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _badge(log.tableName),
                            Text(
                              '${log.actorLabel} • $_relativeTime',
                              style: const TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (hasDiff)
                    Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.textGrey,
                    ),
                ],
              ),
            ),
          ),
          if (_expanded && hasDiff) _buildDiff(log),
        ],
      ),
    );
  }

  Widget _badge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.badgeBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, color: AppColors.textBlack87),
      ),
    );
  }

  Widget _buildDiff(AuditLogEntity log) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 1, color: AppColors.dividerColor),
          const SizedBox(height: 8),
          ...log.fieldDiffs.map(
            (diff) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textBlack87,
                  ),
                  children: [
                    TextSpan(
                      text: '${diff.field}: ',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: '${diff.oldValue ?? 'null'} ',
                      style: TextStyle(
                        color: AppColors.errorText,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const TextSpan(text: ' → '),
                    TextSpan(
                      text: '${diff.newValue ?? 'null'}',
                      style: TextStyle(color: AppColors.successText),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
