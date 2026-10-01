import 'package:flutter/foundation.dart';
import '../models/vehicle.dart';

class VehicleProvider extends ChangeNotifier {
  final List<Vehicle> _vehicles = [];

  List<Vehicle> get vehicles => List.unmodifiable(_vehicles);
  Vehicle? get primaryVehicle => _vehicles.isEmpty ? null : _vehicles.first;

  void addVehicle(Vehicle vehicle) {
    _vehicles.add(vehicle);
    notifyListeners();
  }

  void updateVehicle(Vehicle vehicle) {
    final index = _vehicles.indexWhere((item) => item.id == vehicle.id);
    if (index == -1) return;
    _vehicles[index] = vehicle;
    notifyListeners();
  }

  void removeVehicle(int id) {
    _vehicles.removeWhere((vehicle) => vehicle.id == id);
    notifyListeners();
  }
}
