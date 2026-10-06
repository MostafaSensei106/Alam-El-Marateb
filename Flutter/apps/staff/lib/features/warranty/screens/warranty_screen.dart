import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../api/warranty_api.dart';
import '../models/warranty_models.dart';

/// Warranty lookup by serial + claims list.
class WarrantyScreen extends StatefulWidget {
  const WarrantyScreen({super.key});

  @override
  State<WarrantyScreen> createState() => _WarrantyScreenState();
}

class _WarrantyScreenState extends State<WarrantyScreen> {
  final _serial = TextEditingController();
  StaffWarranty? _warranty;
  List<WarrantyClaim> _claims = const <WarrantyClaim>[];
  String? _message;

  @override
  void dispose() {
    _serial.dispose();
    super.dispose();
  }

  Future<void> _lookup() async {
    final serial = _serial.text.trim();
    if (serial.isEmpty) {
      return;
    }
    try {
      final api = GetIt.instance<WarrantyApi>();
      final warranty = await api.lookup(serial);
      final claims = await api.claims(serial);
      setState(() {
        _warranty = warranty;
        _claims = claims;
        _message = null;
      });
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final warranty = _warranty;
    return Scaffold(
      appBar: AppBar(title: const Text('Warranty')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _serial,
              decoration: const InputDecoration(labelText: 'Serial number'),
              onSubmitted: (_) => _lookup(),
            ),
            ElevatedButton(onPressed: _lookup, child: const Text('Lookup')),
            if (_message != null) Text(_message!),
            if (warranty != null)
              Card(
                child: ListTile(
                  title: Text(warranty.serialNumber ?? '-'),
                  subtitle: Text(
                    '${warranty.status} • ${warranty.startDate ?? ''} → ${warranty.endDate ?? ''}',
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _claims.length,
                itemBuilder: (context, i) {
                  final c = _claims[i];
                  return ListTile(
                    title: Text(c.id ?? '-'),
                    subtitle: Text('${c.status} • ${c.description ?? ''}'),
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
