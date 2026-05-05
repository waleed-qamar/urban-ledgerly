import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/dps_providers.dart';
import 'add_dps_report_page.dart';

class DpsDashboard extends ConsumerWidget {
  const DpsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsyncValue = ref.watch(dpsReportsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Production System'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(dpsReportsProvider);
            },
          )
        ],
      ),
      body: reportsAsyncValue.when(
        data: (reports) {
          if (reports.isEmpty) {
            return const Center(child: Text('No reports found.'));
          }

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    'Report Date: ${DateFormat('yyyy-MM-dd').format(report.reportDate)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: ${report.status}'),
                      if (report.notes != null && report.notes!.isNotEmpty)
                        Text('Notes: ${report.notes}'),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to details if needed in the future
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDpsReportPage()),
          );
          if (result == true) {
            ref.invalidate(dpsReportsProvider);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Report'),
      ),
    );
  }
}
