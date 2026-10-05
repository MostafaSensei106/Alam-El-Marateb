int _int(Object? value) => switch (value) {
  final num n => n.toInt(),
  final String s => int.tryParse(s) ?? 0,
  _ => 0,
};

class DeliveryTrip {
  const DeliveryTrip({
    this.id,
    this.branchId,
    this.driverId,
    this.vehicleId,
    this.tripDate,
    this.status = 'draft',
  });

  factory DeliveryTrip.fromJson(Map<String, dynamic> json) => DeliveryTrip(
    id: json['id']?.toString(),
    branchId: json['branchId']?.toString(),
    driverId: json['driverId']?.toString(),
    vehicleId: json['vehicleId']?.toString(),
    tripDate: json['tripDate']?.toString(),
    status: json['status']?.toString() ?? 'draft',
  );

  final String? id;
  final String? branchId;
  final String? driverId;
  final String? vehicleId;
  final String? tripDate;
  final String status;
}

class TripStop {
  const TripStop({
    this.id,
    this.tripId,
    this.orderId,
    this.seq = 0,
    this.status = 'pending',
    this.recipientName,
    this.addressText,
  });

  factory TripStop.fromJson(Map<String, dynamic> json) => TripStop(
    id: json['id']?.toString(),
    tripId: json['tripId']?.toString(),
    orderId: json['orderId']?.toString(),
    seq: _int(json['seq']),
    status: json['status']?.toString() ?? 'pending',
    recipientName: json['recipientName']?.toString(),
    addressText: json['addressText']?.toString(),
  );

  final String? id;
  final String? tripId;
  final String? orderId;
  final int seq;
  final String status;
  final String? recipientName;
  final String? addressText;
}
