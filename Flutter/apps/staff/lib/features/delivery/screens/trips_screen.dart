import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../api/delivery_api.dart';
import '../models/delivery_models.dart';

/// Driver trips: my trips → stops → POD confirm / failed report.
class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  List<DeliveryTrip> _trips = const <DeliveryTrip>[];
  List<TripStop> _stops = const <TripStop>[];
  String? _selectedTrip;
  String? _message;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    try {
      final trips = await GetIt.instance<DeliveryApi>().myTrips();
      setState(() {
        _trips = trips;
        _selectedTrip ??= trips.firstOrNull?.id;
      });
      await _loadStops();
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    }
  }

  Future<void> _loadStops() async {
    final id = _selectedTrip;
    if (id == null) {
      return;
    }
    try {
      _stops = await GetIt.instance<DeliveryApi>().stops(id);
      setState(() {});
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    }
  }

  Future<void> _confirm(TripStop stop) async {
    final orderId = stop.orderId;
    if (orderId == null) {
      return;
    }
    try {
      await GetIt.instance<DeliveryApi>().confirmDelivered(orderId: orderId);
      setState(() => _message = 'Delivered $orderId');
      await _loadStops();
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    }
  }

  Future<void> _failed(TripStop stop) async {
    final orderId = stop.orderId;
    if (orderId == null) {
      return;
    }
    try {
      await GetIt.instance<DeliveryApi>().reportFailed(
        orderId: orderId,
        reason: 'closed',
      );
      setState(() => _message = 'Reported $orderId');
      await _loadStops();
    } on Exception catch (e) {
      setState(() => _message = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My trips')),
      body: Column(
        children: [
          DropdownButton<String>(
            value: _selectedTrip,
            hint: const Text('Trip'),
            items: _trips
                .map(
                  (t) => DropdownMenuItem(
                    value: t.id,
                    child: Text('${t.id} (${t.status})'),
                  ),
                )
                .toList(),
            onChanged: (id) => setState(() {
              _selectedTrip = id;
              _loadStops();
            }),
          ),
          if (_message != null) Text(_message!),
          Expanded(
            child: ListView.builder(
              itemCount: _stops.length,
              itemBuilder: (context, i) {
                final s = _stops[i];
                return ListTile(
                  title: Text('Stop ${s.seq} — ${s.orderId ?? '-'}'),
                  subtitle: Text('${s.recipientName ?? ''} • ${s.status}'),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () => _confirm(s),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => _failed(s),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
