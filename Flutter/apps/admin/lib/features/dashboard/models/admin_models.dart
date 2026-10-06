double _money(Object? value) => switch (value) {
  final num n => n.toDouble(),
  final String s => double.tryParse(s) ?? 0,
  _ => 0,
};

int _int(Object? value) => switch (value) {
  final num n => n.toInt(),
  final String s => int.tryParse(s) ?? 0,
  _ => 0,
};

class ExecutiveSummary {
  const ExecutiveSummary({
    this.warehouses = 0,
    this.activeProducts = 0,
    this.lowStockCount = 0,
    this.pendingTransfers = 0,
    this.openAudits = 0,
    this.totalStockValue = 0,
  });

  factory ExecutiveSummary.fromJson(Map<String, dynamic> json) =>
      ExecutiveSummary(
        warehouses: _int(json['warehouses']),
        activeProducts: _int(json['activeProducts']),
        lowStockCount: _int(json['lowStockCount']),
        pendingTransfers: _int(json['pendingTransfers']),
        openAudits: _int(json['openAudits']),
        totalStockValue: _money(json['totalStockValue']),
      );

  final int warehouses;
  final int activeProducts;
  final int lowStockCount;
  final int pendingTransfers;
  final int openAudits;
  final double totalStockValue;
}

class VelocityRow {
  const VelocityRow({
    this.variantId,
    this.sold30d = 0,
    this.currentQty = 0,
    this.daysOfCover,
  });

  factory VelocityRow.fromJson(Map<String, dynamic> json) => VelocityRow(
    variantId: json['variantId']?.toString(),
    sold30d: _int(json['sold30d']),
    currentQty: _int(json['currentQty']),
    daysOfCover: json['daysOfCover'] is num
        ? (json['daysOfCover'] as num).toDouble()
        : null,
  );

  final String? variantId;
  final int sold30d;
  final int currentQty;
  final double? daysOfCover;
}

class ManagedUser {
  const ManagedUser({
    required this.fullName,
    required this.phone,
    this.id,
    this.roles = const <String>[],
    this.isActive = true,
  });

  factory ManagedUser.fromJson(Map<String, dynamic> json) => ManagedUser(
    id: json['id']?.toString(),
    fullName: json['fullName']?.toString() ?? '',
    phone: json['phoneNumber']?.toString() ?? json['phone']?.toString() ?? '',
    roles: json['roles'] is List
        ? (json['roles'] as List).map((e) => e.toString()).toList()
        : const <String>[],
    isActive: json['isActive'] as bool? ?? true,
  );

  final String? id;
  final String fullName;
  final String phone;
  final List<String> roles;
  final bool isActive;
}
