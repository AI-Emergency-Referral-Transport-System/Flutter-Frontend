import 'package:equatable/equatable.dart';

class HospitalRecommendation extends Equatable {
  const HospitalRecommendation({
    required this.id,
    required this.name,
    required this.address,
    this.distanceKm,
    this.score,
    this.rating,
  });

  final String id;
  final String name;
  final String address;
  final double? distanceKm;
  final double? score;
  final double? rating;

  factory HospitalRecommendation.fromJson(Map<String, dynamic> json) {
    return HospitalRecommendation(
      id: json['id'].toString(),
      name: (json['name'] ?? '') as String,
      address: (json['address'] ?? '') as String,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      score: (json['score'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [id, name, address, distanceKm, score, rating];
}
