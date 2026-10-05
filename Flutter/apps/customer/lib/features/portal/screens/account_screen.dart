import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../api/portal_api.dart';
import '../models/portal_models.dart';

/// Warranties + loyalty: balance, ledger, file claim.
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List<CustomerWarranty> _warranties = const <CustomerWarranty>[];
  LoyaltyBalance _balance = const LoyaltyBalance();
  List<LoyaltyEntry> _ledger = const <LoyaltyEntry>[];
  final _warrantyId = TextEditingController();
  final _description = TextEditingController();
  String? _message;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _warrantyId.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final api = GetIt.instance<PortalApi>();
      final warranties = await api.warranties();
      final balance = await api.loyalty();
      final ledger = await api.loyaltyLedger();
      if (mounted) {
        setState(() {
          _warranties = warranties;
          _balance = balance;
          _ledger = ledger;
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        setState(() => _message = e.toString());
      }
    }
  }

  Future<void> _fileClaim() async {
    try {
      await GetIt.instance<PortalApi>().fileClaim(
        warrantyId: _warrantyId.text.trim(),
        description: _description.text.trim(),
      );
      setState(() => _message = 'Claim filed');
      await _load();
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: ListTile(
              title: Text('Loyalty: ${_balance.points} pts'),
              subtitle: Text(_balance.tier ?? ''),
            ),
          ),
          const Divider(),
          const Text('Warranties'),
          for (final w in _warranties)
            ListTile(
              title: Text(w.serialNumber ?? '-'),
              subtitle: Text('${w.status} • until ${w.endDate ?? '-'}'),
            ),
          TextField(
            controller: _warrantyId,
            decoration: const InputDecoration(labelText: 'Warranty ID'),
          ),
          TextField(
            controller: _description,
            decoration: const InputDecoration(labelText: 'Defect'),
          ),
          ElevatedButton(
            onPressed: _fileClaim,
            child: const Text('File claim'),
          ),
          const Divider(),
          const Text('Loyalty ledger'),
          for (final e in _ledger)
            ListTile(
              title: Text('${e.points}'),
              subtitle: Text(e.reason),
            ),
          if (_message != null) Text(_message!),
        ],
      ),
    );
  }
}
