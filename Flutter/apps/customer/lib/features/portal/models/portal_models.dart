int _int(Object? value) => switch (value) {
  final num n => n.toInt(),
  final String s => int.tryParse(s) ?? 0,
  _ => 0,
};

class ShipAddress {
  const ShipAddress({
    this.id,
    this.phone = '',
    this.governorate = '',
    this.addressText = '',
    this.isDefault = false,
  });

  factory ShipAddress.fromJson(Map<String, dynamic> json) => ShipAddress(
    id: json['id']?.toString(),
    phone: json['phone']?.toString() ?? '',
    governorate: json['governorate']?.toString() ?? '',
    addressText:
        json['addressText']?.toString() ?? json['address']?.toString() ?? '',
    isDefault: json['isDefault'] as bool? ?? false,
  );

  final String? id;
  final String phone;
  final String governorate;
  final String addressText;
  final bool isDefault;
}

class CustomerWarranty {
  const CustomerWarranty({
    this.id,
    this.serialNumber,
    this.status = 'active',
    this.endDate,
  });

  factory CustomerWarranty.fromJson(Map<String, dynamic> json) =>
      CustomerWarranty(
        id: json['id']?.toString(),
        serialNumber:
            json['serialNumber']?.toString() ??
            json['serial']?.toString(),
        status: json['status']?.toString() ?? 'active',
        endDate: json['endDate']?.toString(),
      );

  final String? id;
  final String? serialNumber;
  final String status;
  final String? endDate;
}

class LoyaltyBalance {
  const LoyaltyBalance({this.points = 0, this.tier});

  factory LoyaltyBalance.fromJson(Map<String, dynamic> json) =>
      LoyaltyBalance(
        points: _int(json['points'] ?? json['balance']),
        tier: json['tier']?.toString(),
      );

  final int points;
  final String? tier;
}

class LoyaltyEntry {
  const LoyaltyEntry({
    this.id,
    this.points = 0,
    this.reason = '',
    this.createdAt,
  });

  factory LoyaltyEntry.fromJson(Map<String, dynamic> json) => LoyaltyEntry(
    id: json['id']?.toString(),
    points: _int(json['points'] ?? json['delta']),
    reason: json['reason']?.toString() ?? '',
    createdAt: json['createdAt']?.toString(),
  );

  final String? id;
  final int points;
  final String reason;
  final String? createdAt;
}
