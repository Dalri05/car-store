import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import '../models/vehicle.dart';
import '../providers/vehicle_provider.dart';

class AddVehicleScreen extends StatefulWidget {
  final bool showAppBar;
  
  const AddVehicleScreen({super.key, this.showAppBar = true});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _anoController = TextEditingController();
  final _corController = TextEditingController();
  final _precoController = TextEditingController();
  final _descricaoController = TextEditingController();
  
  Uint8List? _selectedImageBytes;
  bool _isLoading = false;

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
          _selectedImageBytes = bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao selecionar imagem: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveVehicle() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final vehicle = Vehicle(
        marca: _marcaController.text.trim(),
        modelo: _modeloController.text.trim(),
        ano: int.parse(_anoController.text.trim()),
        cor: _corController.text.trim(),
        preco: double.parse(_precoController.text.trim().replaceAll(',', '.')),
        descricao: _descricaoController.text.trim(),
        dataCadastro: DateTime.now(),
      );

      await Provider.of<VehicleProvider>(context, listen: false)
          .addVehicle(vehicle, imageBytes: _selectedImageBytes);
      
      if (mounted) {
        _marcaController.clear();
        _modeloController.clear();
        _anoController.clear();
        _corController.clear();
        _precoController.clear();
        _descricaoController.clear();
        setState(() {
          _selectedImageBytes = null;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veículo cadastrado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        
        if (widget.showAppBar) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao cadastrar veículo: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
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

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName é obrigatório';
    return null;
  }

  String? _validateYear(String? value) {
    if (value == null || value.trim().isEmpty) return 'Ano é obrigatório';
    final year = int.tryParse(value.trim());
    if (year == null) return 'Inválido';
    final currentYear = DateTime.now().year;
    if (year < 1900 || year > currentYear + 1) return 'Entre 1900 e ${currentYear + 1}';
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) return 'Preço obrigatório';
    final price = double.tryParse(value.trim().replaceAll(',', '.'));
    if (price == null || price <= 0) return 'Valor inválido';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: widget.showAppBar ? AppBar(
        title: const Text('Cadastrar Veículo'),
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
      ) : null,
      body: Column(
        children: [
          if (!widget.showAppBar)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cadastrar Veículo',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text('Preencha os dados do seu veículo', style: TextStyle(fontSize: 16, color: Colors.white70)),
                ],
              ),
            ),
          
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Área da Imagem
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF6A1B9A).withOpacity(0.3)),
                    ),
                    child: InkWell(
                      onTap: _pickImage,
                      borderRadius: BorderRadius.circular(16),
                      child: _selectedImageBytes != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.memory(
                                _selectedImageBytes!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate, size: 48, color: Color(0xFF6A1B9A)),
                                SizedBox(height: 8),
                                Text('Toque para adicionar foto', style: TextStyle(color: Color(0xFF6A1B9A))),
                              ],
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  // Campos...
                  TextFormField(
                    controller: _marcaController,
                    decoration: const InputDecoration(labelText: 'Marca *', border: OutlineInputBorder()),
                    validator: (v) => _validateRequired(v, 'Marca'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _modeloController,
                    decoration: const InputDecoration(labelText: 'Modelo *', border: OutlineInputBorder()),
                    validator: (v) => _validateRequired(v, 'Modelo'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _anoController,
                          decoration: const InputDecoration(labelText: 'Ano *', border: OutlineInputBorder()),
                          validator: _validateYear,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _corController,
                          decoration: const InputDecoration(labelText: 'Cor *', border: OutlineInputBorder()),
                          validator: (v) => _validateRequired(v, 'Cor'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _precoController,
                    decoration: const InputDecoration(labelText: 'Preço (R\$) *', border: OutlineInputBorder()),
                    validator: _validatePrice,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descricaoController,
                    decoration: const InputDecoration(labelText: 'Descrição *', border: OutlineInputBorder()),
                    validator: (v) => _validateRequired(v, 'Descrição'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveVehicle,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Cadastrar Veículo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}