import 'package:geolocator/geolocator.dart';

import '../../ai_chat/domain/models/hospital_recommendation.dart';

class NearbyHospitalsRepository {
  static const List<HospitalRecommendation> _seed = [
    HospitalRecommendation(
      id: 'h1',
      name: 'St. Mary Trauma Center',
      address: 'Bole Rd, Addis Ababa',
      distanceKm: 1.2,
      score: 0.94,
      rating: 4.8,
    ),
    HospitalRecommendation(
      id: 'h2',
      name: 'Unity Cardiac Hospital',
      address: 'Kazanchis, Addis Ababa',
      distanceKm: 2.4,
      score: 0.91,
      rating: 4.6,
    ),
    HospitalRecommendation(
      id: 'h3',
      name: 'Hope Pediatric & ER',
      address: 'Piassa, Addis Ababa',
      distanceKm: 3.1,
      score: 0.88,
      rating: 4.5,
    ),
    HospitalRecommendation(
      id: 'h4',
      name: 'Metro Neuro & ICU',
      address: 'CMC, Addis Ababa',
      distanceKm: 4.0,
      score: 0.86,
      rating: 4.4,
    ),
  ];

  Future<List<HospitalRecommendation>> nearby({
    String? emergencyType,
  }) async {
    Position? pos;
    try {
      final service = await Geolocator.isLocationServiceEnabled();
      if (!service) {
        return _ranked(_seed, emergencyType);
      }
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return _ranked(_seed, emergencyType);
      }
      pos = await Geolocator.getCurrentPosition();
    } catch (_) {
      pos = null;
    }
    if (pos == null) return _ranked(_seed, emergencyType);

    final userPos = pos;
    final adjusted = _seed
        .map(
          (h) => HospitalRecommendation(
            id: h.id,
            name: h.name,
            address: h.address,
            distanceKm: _jitterKm(h.distanceKm ?? 2, userPos.latitude),
            score: h.score,
            rating: h.rating,
          ),
        )
        .toList();
    adjusted.sort(
      (a, b) => (a.distanceKm ?? 99).compareTo(b.distanceKm ?? 99),
    );
    return _ranked(adjusted, emergencyType);
  }

  double _jitterKm(double base, double lat) {
    final delta = (lat % 1) * 0.2;
    return double.parse((base + delta).toStringAsFixed(1));
  }

  List<HospitalRecommendation> _ranked(
    List<HospitalRecommendation> rows,
    String? emergencyType,
  ) {
    final t = (emergencyType ?? '').toLowerCase();
    if (t.contains('cardio') || t.contains('heart')) {
      final copy = [...rows];
      copy.sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
      return copy;
    }
    if (t.contains('child') || t.contains('pediatric')) {
      return rows.where((e) => e.id == 'h3').followedBy(rows).toList();
    }
    final copy = [...rows];
    copy.sort((a, b) => (a.distanceKm ?? 99).compareTo(b.distanceKm ?? 99));
    return copy;
  }
}
