import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../api/inventory_api.dart';
import '../models/inventory_models.dart';

/// Transfers: create draft → dispatch → keeper confirms → approve.
/// Warehouse pickers reuse the stocks warehouse list.
class TransfersScreen extends StatefulWidget {
  const TransfersScreen({super.key});

  @override
  State<TransfersScreen> createState() => _TransfersScreenState();
}

class _TransfersScreenState extends State<TransfersScreen> {
  final _from = TextEditingController();
  final _to = TextEditingController();
  final _variant = TextEditingController();
  final _qty = TextEditingController(text: '1');
  final _transferId = TextEditingController();
  String? _message;
  bool _busy = false;

  @override
  void dispose() {
    _from.dispose();
    _to.dispose();
    _variant.dispose();
    _qty.dispose();
    _transferId.dispose();
    super.dispose();
  }

  InventoryApi get _api => GetIt.instance<InventoryApi>();

  Future<void> _run(Future<StockTransfer> Function() call) async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final t = await call();
      _transferId.text = t.id ?? '';
      setState(() => _message = 'Transfer ${t.id} → ${t.status.value}');
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transfers')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            TextField(
              controller: _from,
              decoration: const InputDecoration(labelText: 'From warehouse ID'),
            ),
            TextField(
              controller: _to,
              decoration: const InputDecoration(labelText: 'To warehouse ID'),
            ),
            TextField(
              controller: _variant,
              decoration: const InputDecoration(labelText: 'Variant ID'),
            ),
            TextField(
              controller: _qty,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Qty'),
            ),
            TextField(
              controller: _transferId,
              decoration: const InputDecoration(labelText: 'Transfer ID'),
            ),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _busy
                      ? null
                      : () => _run(
                          () => _api.createTransfer(
                            fromWarehouseId: _from.text.trim(),
                            toWarehouseId: _to.text.trim(),
                            lines: [
                              TransferLine(
                                variantId: _variant.text.trim(),
                                qty: int.tryParse(_qty.text) ?? 0,
                              ),
                            ],
                          ),
                        ),
                  child: const Text('Create'),
                ),
                ElevatedButton(
                  onPressed: _busy
                      ? null
                      : () =>
                            _run(() => _api.dispatch(_transferId.text.trim())),
                  child: const Text('Dispatch'),
                ),
                ElevatedButton(
                  onPressed: _busy
                      ? null
                      : () => _run(
                          () => _api.confirmReceipt(
                            transferId: _transferId.text.trim(),
                            lines: [
                              TransferLine(
                                variantId: _variant.text.trim(),
                                qty: int.tryParse(_qty.text) ?? 0,
                              ),
                            ],
                          ),
                        ),
                  child: const Text('Confirm receipt'),
                ),
                ElevatedButton(
                  onPressed: _busy
                      ? null
                      : () => _run(() => _api.approve(_transferId.text.trim())),
                  child: const Text('Approve'),
                ),
              ],
            ),
            if (_message != null) Text(_message!),
          ],
        ),
      ),
    );
  }
}
