import 'package:latlong2/latlong.dart';

class HospitalModel {
  final String id;
  final String name;
  final String address;
  final LatLng location;
  final String phoneNumber;

  HospitalModel({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.phoneNumber,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      location: LatLng(json['latitude'], json['longitude']),
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'phone_number': phoneNumber,
    };
  }
}
