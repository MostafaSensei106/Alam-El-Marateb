class StaffWarranty {
  const StaffWarranty({
    this.id,
    this.serialNumber,
    this.customerId,
    this.status = 'active',
    this.startDate,
    this.endDate,
  });

  factory StaffWarranty.fromJson(Map<String, dynamic> json) =>
      StaffWarranty(
        id: json['id']?.toString(),
        serialNumber:
            json['serialNumber']?.toString() ??
            json['serial']?.toString(),
        customerId: json['customerId']?.toString(),
        status: json['status']?.toString() ?? 'active',
        startDate: json['startDate']?.toString(),
        endDate: json['endDate']?.toString(),
      );

  final String? id;
  final String? serialNumber;
  final String? customerId;
  final String status;
  final String? startDate;
  final String? endDate;
}

class WarrantyClaim {
  const WarrantyClaim({
    this.id,
    this.status = 'open',
    this.description,
  });

  factory WarrantyClaim.fromJson(Map<String, dynamic> json) =>
      WarrantyClaim(
        id: json['id']?.toString(),
        status: json['status']?.toString() ?? 'open',
        description:
            json['description']?.toString() ?? json['reason']?.toString(),
      );

  final String? id;
  final String status;
  final String? description;
}
