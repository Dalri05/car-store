import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/vehicle.dart';

class VehicleProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  List<Vehicle> _vehicles = [];
  bool _isLoading = false;
  
  StreamSubscription<QuerySnapshot>? _streamSubscription;

  List<Vehicle> get vehicles => _vehicles;
  bool get isLoading => _isLoading;

  VehicleProvider();

  void subscribe() {
    if (_streamSubscription != null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _streamSubscription = _firestore
          .collection('vehicles')
          .orderBy('dataCadastro', descending: true)
          .snapshots()
          .listen(
        (snapshot) {
          _vehicles = snapshot.docs.map((doc) {
            return Vehicle.fromMap(doc.data(), doc.id);
          }).toList();
          _isLoading = false;
          notifyListeners();
        },
        onError: (error) {
          debugPrint('Erro no Stream do Firestore: $error');
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      debugPrint('Erro ao tentar subscrever: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  void unsubscribe() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _vehicles = [];
    notifyListeners();
  }

  Future<void> addVehicle(Vehicle vehicle, {Uint8List? imageBytes}) async {
    _isLoading = true;
    notifyListeners();

    try {
      String? imageUrl;
      if (imageBytes != null) {
        final fileName = 'vehicles/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final ref = _storage.ref().child(fileName);
        await ref.putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));
        imageUrl = await ref.getDownloadURL();
      }

      final newVehicle = vehicle.copyWith(
        imagemUrl: imageUrl,
        dataCadastro: DateTime.now(),
      );

      await _firestore.collection('vehicles').add(newVehicle.toMap());
    } catch (e) {
      debugPrint('Erro ao adicionar: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateVehicle(Vehicle vehicle, {Uint8List? newImageBytes}) async {
    _isLoading = true;
    notifyListeners();
    try {
      String? imageUrl = vehicle.imagemUrl;
      if (newImageBytes != null) {
        if (vehicle.imagemUrl != null) {
          try { await _storage.refFromURL(vehicle.imagemUrl!).delete(); } catch (_) {}
        }
        final fileName = 'vehicles/${DateTime.now().millisecondsSinceEpoch}_updated.jpg';
        final ref = _storage.ref().child(fileName);
        await ref.putData(newImageBytes, SettableMetadata(contentType: 'image/jpeg'));
        imageUrl = await ref.getDownloadURL();
      }
      final updatedVehicle = vehicle.copyWith(imagemUrl: imageUrl);
      await _firestore.collection('vehicles').doc(vehicle.id).update(updatedVehicle.toMap());
    } catch (e) {
      debugPrint('Erro ao atualizar: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteVehicle(String vehicleId, String? imageUrl) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (imageUrl != null) {
        try { await _storage.refFromURL(imageUrl).delete(); } catch (_) {}
      }
      await _firestore.collection('vehicles').doc(vehicleId).delete();
    } catch (e) {
      debugPrint('Erro ao deletar: $e');
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