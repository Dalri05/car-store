import 'package:flutter/foundation.dart';
import '../models/vehicle.dart';

class VehicleProvider extends ChangeNotifier {
  List<Vehicle> _vehicles = [];
  bool _isLoading = false;

  List<Vehicle> get vehicles => _vehicles;
  bool get isLoading => _isLoading;

  VehicleProvider() {
    _loadInitialData();
  }

  void _loadInitialData() {
    // Dados simulados iniciais
    _vehicles = [
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
    notifyListeners();
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simular delay de rede
      await Future.delayed(const Duration(milliseconds: 500));
      
      final newVehicle = vehicle.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        dataCadastro: DateTime.now(),
      );
      
      _vehicles.insert(0, newVehicle); // Adicionar no início da lista
      
      // TODO: Implementar salvamento no Firestore
      // await vehicleService.addVehicle(newVehicle);
      
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simular delay de rede
      await Future.delayed(const Duration(milliseconds: 300));
      
      final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
      if (index != -1) {
        _vehicles[index] = vehicle;
      }
      
      // TODO: Implementar atualização no Firestore
      // await vehicleService.updateVehicle(vehicle);
      
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteVehicle(String vehicleId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simular delay de rede
      await Future.delayed(const Duration(milliseconds: 300));
      
      _vehicles.removeWhere((v) => v.id == vehicleId);
      
      // TODO: Implementar exclusão no Firestore
      // await vehicleService.deleteVehicle(vehicleId);
      
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Vehicle> getFilteredVehicles(String searchQuery, String selectedBrand) {
    return _vehicles.where((vehicle) {
      final matchesSearch = searchQuery.isEmpty ||
          vehicle.marca.toLowerCase().contains(searchQuery.toLowerCase()) ||
          vehicle.modelo.toLowerCase().contains(searchQuery.toLowerCase());
      
      final matchesBrand = selectedBrand == 'Todas' || vehicle.marca == selectedBrand;
      
      return matchesSearch && matchesBrand;
    }).toList();
  }

  List<String> get availableBrands {
    final brands = _vehicles.map((v) => v.marca).toSet().toList();
    brands.sort();
    return ['Todas', ...brands];
  }
}