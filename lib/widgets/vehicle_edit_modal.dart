import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import '../models/vehicle.dart';
import '../providers/vehicle_provider.dart';

class VehicleEditModal extends StatefulWidget {
  final Vehicle vehicle;

  const VehicleEditModal({super.key, required this.vehicle});

  @override
  State<VehicleEditModal> createState() => _VehicleEditModalState();
}

class _VehicleEditModalState extends State<VehicleEditModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  late TextEditingController _anoController;
  late TextEditingController _corController;
  late TextEditingController _precoController;
  late TextEditingController _descricaoController;
  
  Uint8List? _newSelectedImageBytes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _marcaController = TextEditingController(text: widget.vehicle.marca);
    _modeloController = TextEditingController(text: widget.vehicle.modelo);
    _anoController = TextEditingController(text: widget.vehicle.ano.toString());
    _corController = TextEditingController(text: widget.vehicle.cor);
    _precoController = TextEditingController(
      text: widget.vehicle.preco.toStringAsFixed(2).replaceAll('.', ','),
    );
    _descricaoController = TextEditingController(text: widget.vehicle.descricao);
  }

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _anoController.dispose();
    _corController.dispose();
    _precoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _newSelectedImageBytes = bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedVehicle = widget.vehicle.copyWith(
        marca: _marcaController.text.trim(),
        modelo: _modeloController.text.trim(),
        ano: int.parse(_anoController.text.trim()),
        cor: _corController.text.trim(),
        preco: double.parse(_precoController.text.trim().replaceAll(',', '.')),
        descricao: _descricaoController.text.trim(),
      );

      await Provider.of<VehicleProvider>(context, listen: false)
          .updateVehicle(updatedVehicle, newImageBytes: _newSelectedImageBytes);
      
      if (mounted) {
        Navigator.pop(context, updatedVehicle);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validateRequired(String? v, String f) => (v == null || v.trim().isEmpty) ? '$f obrigatório' : null;
  String? _validatePrice(String? v) => (v == null || v.isEmpty) ? 'Obrigatório' : null;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Editar Veículo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                  ],
                ),
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: _newSelectedImageBytes != null
                                ? Image.memory(_newSelectedImageBytes!, fit: BoxFit.cover)
                                : widget.vehicle.imagemUrl != null
                                    ? Image.network(widget.vehicle.imagemUrl!, fit: BoxFit.cover)
                                    : const Center(child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [Icon(Icons.add_a_photo, color: Colors.purple), Text("Trocar foto")],
                                      )),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(controller: _marcaController, decoration: const InputDecoration(labelText: 'Marca', border: OutlineInputBorder()), validator: (v) => _validateRequired(v, 'Marca')),
                      const SizedBox(height: 16),
                      TextFormField(controller: _modeloController, decoration: const InputDecoration(labelText: 'Modelo', border: OutlineInputBorder()), validator: (v) => _validateRequired(v, 'Modelo')),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: TextFormField(controller: _anoController, decoration: const InputDecoration(labelText: 'Ano', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
                          const SizedBox(width: 16),
                          Expanded(child: TextFormField(controller: _corController, decoration: const InputDecoration(labelText: 'Cor', border: OutlineInputBorder()), validator: (v) => _validateRequired(v, 'Cor'))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(controller: _precoController, decoration: const InputDecoration(labelText: 'Preço', border: OutlineInputBorder()), validator: _validatePrice, keyboardType: TextInputType.numberWithOptions(decimal: true)),
                      const SizedBox(height: 16),
                      TextFormField(controller: _descricaoController, decoration: const InputDecoration(labelText: 'Descrição', border: OutlineInputBorder()), maxLines: 3),
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveChanges,
                          child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Salvar Alterações'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}