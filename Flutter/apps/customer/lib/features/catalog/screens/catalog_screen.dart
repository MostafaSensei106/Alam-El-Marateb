import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../api/catalog_api.dart';
import '../models/catalog_models.dart';

/// Browse + search public catalog; tap a product to see its variants.
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _search = TextEditingController();
  late Future<List<StoreProduct>> _future;

  @override
  void initState() {
    super.initState();
    _future = GetIt.instance<CatalogApi>().browse();
  }

  void _runSearch() {
    final q = _search.text.trim();
    setState(() {
      _future = q.isEmpty
          ? GetIt.instance<CatalogApi>().browse()
          : GetIt.instance<CatalogApi>().search(q);
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catalog')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _runSearch,
                ),
              ),
              onSubmitted: (_) => _runSearch(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<StoreProduct>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text('Error: ${snap.error}'));
                }
                final items = snap.data ?? const <StoreProduct>[];
                if (items.isEmpty) {
                  return const Center(child: Text('No products'));
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final p = items[i];
                    return ListTile(
                      title: Text(p.name),
                      subtitle: Text('${p.brand} • ${p.variants.length} sizes'),
                      onTap: () => context.go('/home/product/${p.slug}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
