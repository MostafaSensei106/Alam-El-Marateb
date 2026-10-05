import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../api/cart_api.dart';
import '../models/cart_models.dart';

/// My orders + track by number.
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _tracking = TextEditingController();
  List<ShopOrder> _orders = const <ShopOrder>[];
  TrackingInfo? _tracked;
  String? _message;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _tracking.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final orders = await GetIt.instance<CartApi>().myOrders();
      if (mounted) {
        setState(() => _orders = orders);
      }
    } on Exception catch (e) {
      if (mounted) {
        setState(() => _message = e.toString());
      }
    }
  }

  Future<void> _track() async {
    final number = _tracking.text.trim();
    if (number.isEmpty) {
      return;
    }
    try {
      final info = await GetIt.instance<CartApi>().track(number);
      setState(() {
        _tracked = info;
        _message = null;
      });
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final tracked = _tracked;
    return Scaffold(
      appBar: AppBar(title: const Text('My orders')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tracking,
                    decoration: const InputDecoration(
                      labelText: 'Tracking number',
                    ),
                    onSubmitted: (_) => _track(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.local_shipping),
                  onPressed: _track,
                ),
              ],
            ),
            if (tracked != null)
              Card(
                child: ListTile(
                  title: Text(tracked.trackingNumber ?? '-'),
                  subtitle: Text(
                    '${tracked.status} • ${tracked.driverName ?? ''}',
                  ),
                ),
              ),
            if (_message != null) Text(_message!),
            Expanded(
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, i) {
                  final o = _orders[i];
                  return ListTile(
                    title: Text(o.trackingNumber ?? o.id ?? '-'),
                    subtitle: Text(o.status),
                    trailing: Text('${o.grandTotal}'),
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
