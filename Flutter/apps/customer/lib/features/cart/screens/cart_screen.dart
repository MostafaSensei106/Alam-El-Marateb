import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../shared/enums.dart';
import '../api/cart_api.dart';
import '../models/cart_models.dart';

/// Cart: items → preview → place COD order.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _branch = TextEditingController();
  final _phone = TextEditingController();
  CartView _cart = const CartView();
  PricePreview? _preview;
  String? _message;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _branch.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    try {
      final cart = await GetIt.instance<CartApi>().cart();
      if (mounted) {
        setState(() => _cart = cart);
      }
    } on Exception catch (e) {
      if (mounted) {
        setState(() => _message = e.toString());
      }
    }
  }

  Future<void> _loadPreview() async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final preview = await GetIt.instance<CartApi>().preview(
        _cart.items
            .map((i) => PreviewLine(variantId: i.variantId, qty: i.qty))
            .toList(),
      );
      setState(() => _preview = preview);
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _placeOrder() async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final order = await GetIt.instance<CartApi>().placeOrder(
        branchId: _branch.text.trim().isEmpty ? null : _branch.text.trim(),
        guestPhone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
        items: _cart.items
            .map((i) => PreviewLine(variantId: i.variantId, qty: i.qty))
            .toList(),
        paymentMethod: PaymentMethod.cod.value,
      );
      setState(
        () => _message = 'Order ${order.trackingNumber ?? order.id} placed',
      );
      await _reload();
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
    final preview = _preview;
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
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
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _cart.items.length,
                itemBuilder: (context, i) {
                  final item = _cart.items[i];
                  return ListTile(
                    title: Text(item.variantId),
                    subtitle: Text('Qty ${item.qty}'),
                    trailing: Text('${item.unitPrice * item.qty}'),
                  );
                },
              ),
            ),
            if (preview != null)
              Text(
                'Subtotal ${preview.subtotal} • Discount ${preview.discount} • Total ${preview.total}',
              ),
            if (_message != null) Text(_message!),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _busy || _cart.items.isEmpty ? null : _loadPreview,
                  child: const Text('Preview price'),
                ),
                ElevatedButton(
                  onPressed: _busy || _cart.items.isEmpty ? null : _placeOrder,
                  child: const Text('Place order (COD)'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
