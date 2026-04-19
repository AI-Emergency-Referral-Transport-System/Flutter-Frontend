import 'package:equatable/equatable.dart';

/// Ambulance crew / driver suggested alongside hospitals during emergencies.
class TransportRecommendation extends Equatable {
  const TransportRecommendation({
    required this.id,
    required this.name,
    required this.detail,
    this.etaMinutes,
    this.distanceKm,
    this.availableNow = true,
  });

  final String id;
  final String name;
  final String detail;
  final int? etaMinutes;
  final double? distanceKm;
  final bool availableNow;

  factory TransportRecommendation.fromJson(Map<String, dynamic> json) {
    return TransportRecommendation(
      id: json['id'].toString(),
      name: (json['name'] ?? json['crew_name'] ?? '') as String,
      detail: (json['detail'] ?? json['vehicle'] ?? json['unit'] ?? '') as String,
      etaMinutes: (json['eta_minutes'] as num?)?.toInt(),
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      availableNow: json['available_now'] != false,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    detail,
    etaMinutes,
    distanceKm,
    availableNow,
  ];
}
