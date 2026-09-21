// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleDto _$VehicleDtoFromJson(Map<String, dynamic> json) => VehicleDto(
      id: json['id'] as String?,
      branchId: json['branchId'] as String?,
      plate: json['plate'] as String? ?? '',
      kind: json['kind'] as String?,
      capacityKg: (json['capacityKg'] as num?)?.toInt(),
      status: json['status'] as String? ?? '',
    );

Map<String, dynamic> _$VehicleDtoToJson(VehicleDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branchId': instance.branchId,
      'plate': instance.plate,
      'kind': instance.kind,
      'capacityKg': instance.capacityKg,
      'status': instance.status,
    };

TripDto _$TripDtoFromJson(Map<String, dynamic> json) => TripDto(
      id: json['id'] as String?,
      branchId: json['branchId'] as String?,
      driverId: json['driverId'] as String?,
      vehicleId: json['vehicleId'] as String?,
      tripDate: json['tripDate'] as String?,
      status: json['status'] as String? ?? '',
    );

Map<String, dynamic> _$TripDtoToJson(TripDto instance) => <String, dynamic>{
      'id': instance.id,
      'branchId': instance.branchId,
      'driverId': instance.driverId,
      'vehicleId': instance.vehicleId,
      'tripDate': instance.tripDate,
      'status': instance.status,
    };

StopDto _$StopDtoFromJson(Map<String, dynamic> json) => StopDto(
      id: json['id'] as String?,
      tripId: json['tripId'] as String?,
      orderId: json['orderId'] as String?,
      seq: (json['seq'] as num?)?.toInt() ?? 0,
      window: json['window'] as String?,
      status: json['status'] as String? ?? '',
      proofPhoto: json['proofPhoto'] as String?,
      failReason: json['failReason'] as String?,
      deliveredAt: json['deliveredAt'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$StopDtoToJson(StopDto instance) => <String, dynamic>{
      'id': instance.id,
      'tripId': instance.tripId,
      'orderId': instance.orderId,
      'seq': instance.seq,
      'window': instance.window,
      'status': instance.status,
      'proofPhoto': instance.proofPhoto,
      'failReason': instance.failReason,
      'deliveredAt': instance.deliveredAt,
      'lat': instance.lat,
      'lng': instance.lng,
    };

TripLocationDto _$TripLocationDtoFromJson(Map<String, dynamic> json) =>
    TripLocationDto(
      tripId: json['tripId'] as String?,
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      recordedAt: json['recordedAt'] as String?,
    );

Map<String, dynamic> _$TripLocationDtoToJson(TripLocationDto instance) =>
    <String, dynamic>{
      'tripId': instance.tripId,
      'lat': instance.lat,
      'lng': instance.lng,
      'recordedAt': instance.recordedAt,
    };

DriverRatingDto _$DriverRatingDtoFromJson(Map<String, dynamic> json) =>
    DriverRatingDto(
      orderId: json['orderId'] as String?,
      driverId: json['driverId'] as String?,
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      average: (json['average'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$DriverRatingDtoToJson(DriverRatingDto instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'driverId': instance.driverId,
      'rating': instance.rating,
      'average': instance.average,
    };
