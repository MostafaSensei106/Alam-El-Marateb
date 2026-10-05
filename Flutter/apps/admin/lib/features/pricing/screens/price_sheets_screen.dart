import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../api/pricing_api.dart';
import '../models/pricing_models.dart';

/// Price sheets: browse supplier sheets, apply to channels.
class PriceSheetsScreen extends StatefulWidget {
  const PriceSheetsScreen({super.key});

  @override
  State<PriceSheetsScreen> createState() => _PriceSheetsScreenState();
}

class _PriceSheetsScreenState extends State<PriceSheetsScreen> {
  final _supplier = TextEditingController();
  List<PriceSheet> _sheets = const <PriceSheet>[];
  String? _message;

  @override
  void dispose() {
    _supplier.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final sheets = await GetIt.instance<PricingApi>().sheets(
        supplierId: _supplier.text.trim(),
      );
      setState(() {
        _sheets = sheets;
        _message = null;
      });
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    }
  }

  Future<void> _apply(PriceSheet sheet) async {
    final id = sheet.id;
    if (id == null) {
      return;
    }
    try {
      final rows = await GetIt.instance<PricingApi>().applySheet(sheetId: id);
      setState(() => _message = 'Applied $rows price rows');
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Price sheets')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _supplier,
                    decoration: const InputDecoration(
                      labelText: 'Supplier ID',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _load,
                ),
              ],
            ),
            if (_message != null) Text(_message!),
            Expanded(
              child: ListView.builder(
                itemCount: _sheets.length,
                itemBuilder: (context, i) {
                  final sheet = _sheets[i];
                  return ListTile(
                    title: Text(sheet.sheetNo),
                    subtitle: Text(
                      '${sheet.validFrom ?? ''} → ${sheet.validUntil ?? 'open'} • ${sheet.lines.length} lines',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.rocket_launch),
                      onPressed: () => _apply(sheet),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
