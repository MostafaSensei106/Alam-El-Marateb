import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../api/inventory_api.dart';
import '../models/inventory_models.dart';

/// Warehouse stocks: pick warehouse → levels + low-stock alerts.
class StocksScreen extends StatefulWidget {
  const StocksScreen({super.key});

  @override
  State<StocksScreen> createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen> {
  List<Warehouse> _warehouses = const <Warehouse>[];
  String? _selected;
  List<StockLevel> _levels = const <StockLevel>[];
  bool _busy = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _loadWarehouses();
  }

  Future<void> _loadWarehouses() async {
    try {
      final list = await GetIt.instance<InventoryApi>().warehouses();
      setState(() {
        _warehouses = list;
        if (list.isNotEmpty) {
          _selected ??= list.first.id;
        }
      });
      await _loadStocks();
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    }
  }

  Future<void> _loadStocks() async {
    final id = _selected;
    if (id == null) {
      return;
    }
    setState(() => _busy = true);
    try {
      _levels = await GetIt.instance<InventoryApi>().stocks(id);
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
      appBar: AppBar(title: const Text('Stocks')),
      body: Column(
        children: [
          DropdownButton<String>(
            value: _selected,
            hint: const Text('Warehouse'),
            items: _warehouses
                .map(
                  (w) => DropdownMenuItem(
                    value: w.id,
                    child: Text('${w.name} (${w.code})'),
                  ),
                )
                .toList(),
            onChanged: (id) => setState(() {
              _selected = id;
              _loadStocks();
            }),
          ),
          if (_busy) const LinearProgressIndicator(),
          if (_message != null) Text(_message!),
          Expanded(
            child: ListView.builder(
              itemCount: _levels.length,
              itemBuilder: (context, i) {
                final s = _levels[i];
                return ListTile(
                  title: Text(s.variantId),
                  subtitle: Text(
                    'On hand ${s.qty} • reserved ${s.reservedQty}',
                  ),
                  trailing: Text('${s.available} avail'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
