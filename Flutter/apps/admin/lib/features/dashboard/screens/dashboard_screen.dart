import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../api/dashboard_api.dart';
import '../models/admin_models.dart';

/// Executive summary cards.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  ExecutiveSummary? _summary;
  String? _message;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final summary = await GetIt.instance<DashboardApi>().summary();
      if (mounted) {
        setState(() => _summary = summary);
      }
    } on Exception catch (e) {
      if (mounted) {
        setState(() => _message = e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = _summary;
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: summary == null
          ? Center(
              child: _message != null
                  ? Text(_message!)
                  : const CircularProgressIndicator(),
            )
          : GridView.count(
              padding: const EdgeInsets.all(12),
              crossAxisCount: 2,
              childAspectRatio: 1.6,
              children: [
                _card('Warehouses', '${summary.warehouses}'),
                _card('Products', '${summary.activeProducts}'),
                _card('Low stock', '${summary.lowStockCount}'),
                _card('Pending transfers', '${summary.pendingTransfers}'),
                _card('Open audits', '${summary.openAudits}'),
                _card('Stock value', '${summary.totalStockValue}'),
              ],
            ),
    );
  }

  Widget _card(String label, String value) => Card(
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Text(value), Text(label)],
      ),
    ),
  );
}
