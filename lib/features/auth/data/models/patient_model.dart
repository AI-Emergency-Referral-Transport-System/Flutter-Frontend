class PatientModel {
  final String fullName;
  final String phoneNumber;
  final String bloodType;
  final String emergencyContact;
  final String location;
  final String? allergy;

  const PatientModel({
    required this.fullName,
    required this.phoneNumber,
    required this.bloodType,
    required this.emergencyContact,
    required this.location,
    this.allergy,
  });
}