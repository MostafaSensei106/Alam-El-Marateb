import 'package:json_annotation/json_annotation.dart';

part 'delivery_dto.g.dart';

/// Backend `VehicleView`.
@JsonSerializable()
final class VehicleDto {
  const VehicleDto({
    this.id,
    this.branchId,
    this.plate = '',
    this.kind,
    this.capacityKg,
    this.status = '',
  });

  factory VehicleDto.fromJson(Map<String, dynamic> json) =>
      _$VehicleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleDtoToJson(this);

  final String? id;
  final String? branchId;
  final String plate;
  final String? kind;
  final int? capacityKg;
  final String status;
}

/// Backend `TripView`.
@JsonSerializable()
final class TripDto {
  const TripDto({
    this.id,
    this.branchId,
    this.driverId,
    this.vehicleId,
    this.tripDate,
    this.status = '',
  });

  factory TripDto.fromJson(Map<String, dynamic> json) =>
      _$TripDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TripDtoToJson(this);

  final String? id;
  final String? branchId;
  final String? driverId;
  final String? vehicleId;
  final String? tripDate;
  final String status;
}

/// Backend `StopView`.
@JsonSerializable()
final class StopDto {
  const StopDto({
    this.id,
    this.tripId,
    this.orderId,
    this.seq = 0,
    this.window,
    this.status = '',
    this.proofPhoto,
    this.failReason,
    this.deliveredAt,
    this.lat,
    this.lng,
  });

  factory StopDto.fromJson(Map<String, dynamic> json) =>
      _$StopDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StopDtoToJson(this);

  final String? id;
  final String? tripId;
  final String? orderId;
  final int seq;
  final String? window;
  final String status;
  final String? proofPhoto;
  final String? failReason;
  final String? deliveredAt;
  final double? lat;
  final double? lng;
}

/// Backend `TripLocationView`.
@JsonSerializable()
final class TripLocationDto {
  const TripLocationDto({
    this.tripId,
    this.lat = 0.0,
    this.lng = 0.0,
    this.recordedAt,
  });

  factory TripLocationDto.fromJson(Map<String, dynamic> json) =>
      _$TripLocationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TripLocationDtoToJson(this);

  final String? tripId;
  final double lat;
  final double lng;
  final String? recordedAt;
}

/// Backend `DriverRatingView`.
@JsonSerializable()
final class DriverRatingDto {
  const DriverRatingDto({
    this.orderId,
    this.driverId,
    this.rating = 0,
    this.average = 0.0,
  });

  factory DriverRatingDto.fromJson(Map<String, dynamic> json) =>
      _$DriverRatingDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DriverRatingDtoToJson(this);

  final String? orderId;
  final String? driverId;
  final int rating;
  final double average;
}
