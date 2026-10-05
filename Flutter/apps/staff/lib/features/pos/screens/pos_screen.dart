import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../shared/enums.dart';
import '../../catalog/models/catalog_models.dart';
import '../api/pos_api.dart';
import '../models/pos_models.dart';

/// POS ticket: scan barcode → ticket rows → complete cash/card sale.
class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  final _barcode = TextEditingController();
  final _branch = TextEditingController();
  final _phone = TextEditingController();
  final _ticket = <TicketLine>[];
  bool _busy = false;
  String? _message;
  PaymentMethod _method = PaymentMethod.cash;

  @override
  void dispose() {
    _barcode.dispose();
    _branch.dispose();
    _phone.dispose();
    super.dispose();
  }

  double get _total => _ticket.fold(0, (sum, l) => sum + l.lineTotal);

  Future<void> _scan() async {
    final code = _barcode.text.trim();
    if (code.isEmpty) {
      return;
    }
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final item = await GetIt.instance<PosApi>().scan(code);
      final variantId = item.variantId;
      if (variantId == null || variantId.isEmpty) {
        setState(() => _message = 'Scanned item has no variant');
        return;
      }
      final existing = _ticket.where((l) => l.variantId == variantId);
      if (existing.isNotEmpty) {
        existing.first.qty++;
      } else {
        _ticket.add(
          TicketLine(
            variant: ProductVariant(
              id: variantId,
              sku: item.sku,
              sellingPrice: item.sellingPrice,
            ),
          ),
        );
      }
      _barcode.clear();
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _complete() async {
    if (_ticket.isEmpty) {
      return;
    }
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final order = await GetIt.instance<PosApi>().completeSale(
        branchId: _branch.text.trim().isEmpty ? null : _branch.text.trim(),
        guestPhone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
        lines: _ticket,
        paymentMethod: _method,
        paidAmount: _total,
      );
      setState(() {
        _message = 'Sold ${order.trackingNumber ?? order.id} — ${order.grandTotal}';
        _ticket.clear();
      });
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
      appBar: AppBar(title: const Text('POS')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _branch,
              decoration: const InputDecoration(labelText: 'Branch ID'),
            ),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Guest phone'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _barcode,
                    decoration: const InputDecoration(
                      labelText: 'Barcode / SKU',
                    ),
                    onSubmitted: (_) => _scan(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _busy ? null : _scan,
                ),
              ],
            ),
            DropdownButton<PaymentMethod>(
              value: _method,
              items: PaymentMethod.values
                  .map(
                    (m) => DropdownMenuItem(
                      value: m,
                      child: Text(m.value),
                    ),
                  )
                  .toList(),
              onChanged: (m) => setState(() => _method = m ?? _method),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _ticket.length,
                itemBuilder: (context, i) {
                  final line = _ticket[i];
                  return ListTile(
                    title: Text(line.variant.sku),
                    subtitle: Text(
                      '${line.variant.dimensionsLabel} × ${line.qty}',
                    ),
                    trailing: Text('${line.lineTotal}'),
                    onLongPress: () => setState(
                      () => _ticket.removeAt(i),
                    ),
                  );
                },
              ),
            ),
            if (_message != null) Text(_message!),
            Text(
              'Total: $_total',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ElevatedButton(
              onPressed: _busy || _ticket.isEmpty ? null : _complete,
              child: const Text('Complete sale'),
            ),
          ],
        ),
      ),
    );
  }
}
