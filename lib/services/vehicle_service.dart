import 'package:flutter/foundation.dart';
import 'dart:io';
import '../models/vehicle.dart';

class VehicleService extends ChangeNotifier {
  
  final List<Vehicle> _mockVehicles = [
    Vehicle(
      id: '1',
      marca: 'Toyota',
      modelo: 'Corolla',
      ano: 2022,
      cor: 'Branco',
      preco: 95000.00,
      descricao: 'Sedan automático, completo, baixo km, revisões em dia',
      imagemUrl: 'https://example.com/corolla.jpg',
      dataCadastro: DateTime.now(),
    ),
    Vehicle(
      id: '2',
      marca: 'Honda',
      modelo: 'Civic',
      ano: 2023,
      cor: 'Prata',
      preco: 110000.00,
      descricao: 'Sedan esportivo, turbo, multimídia, couro',
      imagemUrl: 'https://example.com/civic.jpg',
      dataCadastro: DateTime.now(),
    ),
    // ... adicione os outros veículos mocados aqui
    Vehicle(
      id: '3',
      marca: 'Volkswagen',
      modelo: 'Jetta',
      ano: 2021,
      cor: 'Preto',
      preco: 85000.00,
      descricao: 'Sedan elegante, automático, ar digital',
      imagemUrl: 'https://example.com/jetta.jpg',
      dataCadastro: DateTime.now(),
    ),
    Vehicle(
      id: '4',
      marca: 'Ford',
      modelo: 'EcoSport',
      ano: 2020,
      cor: 'Azul',
      preco: 65000.00,
      descricao: 'SUV compacto, manual, ideal para cidade',
      imagemUrl: 'https://example.com/ecosport.jpg',
      dataCadastro: DateTime.now(),
    ),
  ];
  
  Future<void> addVehicle(Vehicle vehicle, {File? imageFile}) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final newVehicle = vehicle.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      dataCadastro: DateTime.now(),
    );
    
    _mockVehicles.add(newVehicle);
    
    notifyListeners();
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
      
      notifyListeners();
    }
  }

  Future<void> deleteVehicle(Vehicle vehicle) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockVehicles.removeWhere((v) => v.id == vehicle.id);
    
    notifyListeners();
  }
  Stream<List<Vehicle>> getVehiclesStream() {
    return Stream.periodic(const Duration(seconds: 1), (_) => List.from(_mockVehicles));
  }
}