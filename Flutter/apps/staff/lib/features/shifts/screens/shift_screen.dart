import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../api/shift_api.dart';

/// Cash drawer shift: view current → open / drop / close with blind count.
class ShiftScreen extends StatefulWidget {
  const ShiftScreen({super.key});

  @override
  State<ShiftScreen> createState() => _ShiftScreenState();
}

class _ShiftScreenState extends State<ShiftScreen> {
  final _branch = TextEditingController();
  final _amount = TextEditingController();
  CashShift? _shift;
  bool _busy = false;
  String? _message;

  @override
  void dispose() {
    _branch.dispose();
    _amount.dispose();
    super.dispose();
  }

  double get _parsedAmount => double.tryParse(_amount.text.trim()) ?? 0;

  Future<void> _refresh() async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      _shift = await GetIt.instance<ShiftApi>().current();
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _open() async {
    setState(() => _busy = true);
    try {
      _shift = await GetIt.instance<ShiftApi>().open(
        branchId: _branch.text.trim(),
        openingBalance: _parsedAmount,
      );
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _drop() async {
    final id = _shift?.id;
    if (id == null) {
      return;
    }
    setState(() => _busy = true);
    try {
      await GetIt.instance<ShiftApi>().drop(
        shiftId: id,
        amount: _parsedAmount,
      );
      setState(() => _message = 'Dropped $_parsedAmount');
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _close() async {
    final id = _shift?.id;
    if (id == null) {
      return;
    }
    setState(() => _busy = true);
    try {
      _shift = await GetIt.instance<ShiftApi>().close(
        shiftId: id,
        actualCash: _parsedAmount,
      );
      setState(() => _message = 'Variance: ${_shift?.variance}');
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
    final shift = _shift;
    return Scaffold(
      appBar: AppBar(title: const Text('Cash shift')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (shift != null)
              Card(
                child: ListTile(
                  title: Text('Shift ${shift.id} (${shift.status})'),
                  subtitle: Text(
                    'Opening ${shift.openingBalance} • Expected ${shift.expectedCash ?? '-'}',
                  ),
                ),
              ),
            TextField(
              controller: _branch,
              decoration: const InputDecoration(labelText: 'Branch ID'),
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
                  onPressed: _busy ? null : _refresh,
                  child: const Text('Current'),
                ),
                ElevatedButton(
                  onPressed: _busy ? null : _open,
                  child: const Text('Open'),
                ),
                ElevatedButton(
                  onPressed: _busy || shift == null ? null : _drop,
                  child: const Text('Drop'),
                ),
                ElevatedButton(
                  onPressed: _busy || shift == null ? null : _close,
                  child: const Text('Close'),
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
