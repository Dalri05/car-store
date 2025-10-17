// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/vehicle.dart';

class VehicleService {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // TODO: Implementar quando Firebase for configurado
  /*
  // Coleção de veículos no Firestore
  CollectionReference get _vehiclesCollection => 
      _firestore.collection('vehicles');

  // Adicionar novo veículo
  Future<void> addVehicle(Vehicle vehicle, {File? imageFile}) async {
    try {
      String? imageUrl;
      
      // Upload da imagem se fornecida
      if (imageFile != null) {
        imageUrl = await _uploadImage(imageFile);
      }
      
      // Criar veículo com URL da imagem
      final vehicleWithImage = vehicle.copyWith(imagemUrl: imageUrl);
      
      await _vehiclesCollection.add(vehicleWithImage.toMap());
    } catch (e) {
      print('Erro ao adicionar veículo: $e');
      rethrow;
    }
  }

  // Buscar todos os veículos
  Future<List<Vehicle>> getVehicles() async {
    try {
      final QuerySnapshot snapshot = await _vehiclesCollection
          .orderBy('dataCadastro', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return Vehicle.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      print('Erro ao buscar veículos: $e');
      rethrow;
    }
  }

  // Atualizar veículo
  Future<void> updateVehicle(Vehicle vehicle, {File? newImageFile}) async {
    try {
      String? imageUrl = vehicle.imagemUrl;
      
      // Upload nova imagem se fornecida
      if (newImageFile != null) {
        // Deletar imagem antiga se existir
        if (vehicle.imagemUrl != null) {
          await _deleteImage(vehicle.imagemUrl!);
        }
        imageUrl = await _uploadImage(newImageFile);
      }
      
      final vehicleWithImage = vehicle.copyWith(imagemUrl: imageUrl);
      
      await _vehiclesCollection
          .doc(vehicle.id)
          .update(vehicleWithImage.toMap());
    } catch (e) {
      print('Erro ao atualizar veículo: $e');
      rethrow;
    }
  }

  // Deletar veículo
  Future<void> deleteVehicle(Vehicle vehicle) async {
    try {
      // Deletar imagem se existir
      if (vehicle.imagemUrl != null) {
        await _deleteImage(vehicle.imagemUrl!);
      }
      
      await _vehiclesCollection.doc(vehicle.id).delete();
    } catch (e) {
      print('Erro ao deletar veículo: $e');
      rethrow;
    }
  }

  // Upload de imagem para Firebase Storage
  Future<String> _uploadImage(File imageFile) async {
    try {
      final String fileName = 
          'vehicles/${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      final Reference ref = _storage.ref().child(fileName);
      final UploadTask uploadTask = ref.putFile(imageFile);
      
      final TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Erro ao fazer upload da imagem: $e');
      rethrow;
    }
  }

  // Deletar imagem do Firebase Storage
  Future<void> _deleteImage(String imageUrl) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print('Erro ao deletar imagem: $e');
      // Não relançar erro para não bloquear outras operações
    }
  }

  // Stream de veículos em tempo real
  Stream<List<Vehicle>> getVehiclesStream() {
    return _vehiclesCollection
        .orderBy('dataCadastro', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Vehicle.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }
  */

  // Métodos simulados para desenvolvimento
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
    // Simular stream com dados estáticos
    return Stream.periodic(const Duration(seconds: 1), (_) => List.from(_mockVehicles));
  }
}