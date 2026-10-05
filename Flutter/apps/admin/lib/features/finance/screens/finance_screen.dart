import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../shared/enums.dart';
import '../api/finance_api.dart';
import '../models/finance_models.dart';

/// Supplier finance: shipments, invoices, landed costs, statement.
class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  final _supplier = TextEditingController();
  final _shipmentNo = TextEditingController();
  final _kind = TextEditingController(text: 'FREIGHT');
  final _amount = TextEditingController();
  SupplierStatement? _statement;
  List<LandedCost> _landed = const <LandedCost>[];
  String? _shipmentId;
  String? _message;

  @override
  void dispose() {
    _supplier.dispose();
    _shipmentNo.dispose();
    _kind.dispose();
    _amount.dispose();
    super.dispose();
  }

  FinanceApi get _api => GetIt.instance<FinanceApi>();

  Future<void> _createShipment() async {
    try {
      final shipment = await _api.createShipment(
        supplierId: _supplier.text.trim(),
        shipmentNo: _shipmentNo.text.trim().isEmpty
            ? 'CNT-${DateTime.now().millisecondsSinceEpoch}'
            : _shipmentNo.text.trim(),
      );
      setState(() {
        _shipmentId = shipment.id;
        _message = 'Shipment ${shipment.shipmentNo}';
      });
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    }
  }

  Future<void> _addLanded() async {
    final id = _shipmentId;
    if (id == null) {
      return;
    }
    try {
      await _api.addLandedCost(
        shipmentId: id,
        kind: LandedKind.values
            .where((k) => k.value == _kind.text.trim().toUpperCase())
            .firstOrNull ??
        LandedKind.freight,
        amount: double.tryParse(_amount.text.trim()) ?? 0,
      );
      await _reloadLanded();
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    }
  }

  Future<void> _reloadLanded() async {
    final id = _shipmentId;
    if (id == null) {
      return;
    }
    try {
      final landed = await _api.landedCosts(id);
      setState(() => _landed = landed);
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    }
  }

  Future<void> _loadStatement() async {
    try {
      final statement = await _api.statement(_supplier.text.trim());
      setState(() {
        _statement = statement;
        _message = null;
      });
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final statement = _statement;
    return Scaffold(
      appBar: AppBar(title: const Text('Supplier finance')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          TextField(
            controller: _supplier,
            decoration: const InputDecoration(labelText: 'Supplier ID'),
          ),
          TextField(
            controller: _shipmentNo,
            decoration: const InputDecoration(
              labelText: 'Shipment no (auto if empty)',
            ),
          ),
          Wrap(
            spacing: 8,
            children: [
              ElevatedButton(
                onPressed: _createShipment,
                child: const Text('Create shipment'),
              ),
              ElevatedButton(
                onPressed: _loadStatement,
                child: const Text('Statement'),
              ),
            ],
          ),
          if (statement != null)
            Card(
              child: ListTile(
                title: Text('Owed: ${statement.totalOwed}'),
                subtitle: Text(
                  '${statement.invoices.length} invoices',
                ),
              ),
            ),
          const Divider(),
          const Text('Landed cost for current shipment'),
          TextField(
            controller: _kind,
            decoration: const InputDecoration(labelText: 'Kind'),
          ),
          TextField(
            controller: _amount,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount'),
          ),
          Wrap(
            spacing: 8,
            children: [
              ElevatedButton(
                onPressed: _shipmentId == null ? null : _addLanded,
                child: const Text('Add landed'),
              ),
              ElevatedButton(
                onPressed: _shipmentId == null ? null : _reloadLanded,
                child: const Text('Reload'),
              ),
            ],
          ),
          for (final cost in _landed)
            ListTile(
              title: Text('${cost.kind} ${cost.amount} (${cost.status})'),
              subtitle: Text(
                'Allocated ${cost.allocatedTotal} • variance ${cost.varianceAmount}',
              ),
            ),
          if (_message != null) Text(_message!),
        ],
      ),
    );
  }
}
