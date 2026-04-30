enum DriverStatus { available, unavailable }

class DriverModel {
  final String id;
  final String name;
  final String hospitalId;
  final DriverStatus status;
  final String phoneNumber;

  DriverModel({
    required this.id,
    required this.name,
    required this.hospitalId,
    required this.status,
    required this.phoneNumber,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'],
      name: json['name'],
      hospitalId: json['hospital_id'],
      status: DriverStatus.values.firstWhere((e) => e.toString().split('.').last == json['status']),
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hospital_id': hospitalId,
      'status': status.toString().split('.').last,
      'phone_number': phoneNumber,
    };
  }
}
