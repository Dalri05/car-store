import 'dart:io';
import '../models/vehicle.dart';

class VehicleService {
  static final List<Vehicle> _mockVehicles = [];
  
  Future<void> addVehicle(Vehicle vehicle, {File? imageFile}) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final newVehicle = vehicle.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      dataCadastro: DateTime.now(),
    );
    
    _mockVehicles.add(newVehicle);
  }

  Future<List<Vehicle>> getVehicles() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockVehicles);
  }

  Future<void> updateVehicle(Vehicle vehicle, {File? newImageFile}) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final index = _mockVehicles.indexWhere((v) => v.id == vehicle.id);
    if (index != -1) {
      _mockVehicles[index] = vehicle;
    }
  }

  Future<void> deleteVehicle(Vehicle vehicle) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockVehicles.removeWhere((v) => v.id == vehicle.id);
  }

  Stream<List<Vehicle>> getVehiclesStream() {
    return Stream.periodic(const Duration(seconds: 1), (_) => List.from(_mockVehicles));
  }
}