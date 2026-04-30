import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../models/hospital_model.dart';
import '../models/driver_model.dart';
import '../services/api_service.dart';

class HospitalProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<HospitalModel> _hospitals = [];
  List<DriverModel> _drivers = [];
  bool _isLoading = false;

  List<HospitalModel> get hospitals => _hospitals;
  List<DriverModel> get drivers => _drivers;
  bool get isLoading => _isLoading;

  Future<void> fetchHospitals() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/hospitals/list/');
      if (response != null) {
        _hospitals = (response as List).map((e) => HospitalModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Fetch hospitals error: $e');
      // Mock fallback
      _hospitals = [
        HospitalModel(
          id: 'hosp_1',
          name: 'City Central Hospital',
          address: 'Addis Ababa, Piazza',
          location: LatLng(9.035, 38.75),
          phoneNumber: '0111223344',
        ),
        HospitalModel(
          id: 'hosp_2',
          name: 'Black Lion Hospital',
          address: 'Addis Ababa, Tikur Anbessa',
          location: LatLng(9.02, 38.745),
          phoneNumber: '0111556677',
        ),
        HospitalModel(
          id: 'hosp_3',
          name: 'St. Paul Hospital',
          address: 'Addis Ababa, Wingate',
          location: LatLng(9.05, 38.73),
          phoneNumber: '0111889900',
        ),
      ];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchDrivers(String hospitalId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/hospitals/$hospitalId/drivers/');
      if (response != null) {
        _drivers = (response as List).map((e) => DriverModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Fetch drivers error: $e');
      // Mock fallback
      _drivers = [
        DriverModel(
          id: 'dr_1',
          name: 'Abebe Bikila',
          hospitalId: hospitalId,
          status: DriverStatus.available,
          phoneNumber: '0911001122',
        ),
        DriverModel(
          id: 'dr_2',
          name: 'Haile Gebrselassie',
          hospitalId: hospitalId,
          status: DriverStatus.available,
          phoneNumber: '0922334455',
        ),
      ];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addHospital(HospitalModel hospital) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiService.post('/hospitals/create/', hospital.toJson());
      _hospitals.add(hospital);
    } catch (e) {
      debugPrint('Add hospital error: $e');
      _hospitals.add(hospital);
    }
    _isLoading = false;
    notifyListeners();
  }
}
