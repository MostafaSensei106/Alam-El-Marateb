import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../cart/api/cart_api.dart';
import '../api/catalog_api.dart';
import '../models/catalog_models.dart';

/// Product details: variants → add to cart.
class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({required this.slug, super.key});

  final String slug;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  StoreProduct? _product;
  bool _busy = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final details = await GetIt.instance<CatalogApi>().details(widget.slug);
      if (mounted) {
        setState(() => _product = details);
      }
    } on Exception catch (e) {
      if (mounted) {
        setState(() => _message = e.toString());
      }
    }
  }

  Future<void> _add(ProductVariant variant) async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final id = variant.id;
      if (id == null) {
        setState(() => _message = 'Variant has no id');
        return;
      }
      await GetIt.instance<CartApi>().addItem(variantId: id, qty: 1);
      setState(() => _message = 'Added to cart');
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
    final product = _product;
    return Scaffold(
      appBar: AppBar(title: Text(product?.name ?? 'Product')),
      body: product == null
          ? Center(
              child: _message != null
                  ? Text(_message!)
                  : const CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                if (product.description != null) Text(product.description!),
                Text('Brand: ${product.brand}'),
                if (product.warrantyYears != null)
                  Text('Warranty: ${product.warrantyYears} years'),
                const Divider(),
                for (final v in product.variants)
                  ListTile(
                    title: Text(v.dimensionsLabel),
                    subtitle: Text('SKU ${v.sku}'),
                    trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text('${v.sellingPrice}'),
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: _busy ? null : () => _add(v),
                        ),
                      ],
                    ),
                  ),
                if (_message != null) Text(_message!),
              ],
            ),
    );
  }
}
