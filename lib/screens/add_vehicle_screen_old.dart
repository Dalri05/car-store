import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
import '../models/vehicle.dart';

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
  
  // File? _selectedImage;
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
      // TODO: Implementar seleção de imagem
      // final picker = ImagePicker();
      // final pickedFile = await picker.pickImage(
      //   source: ImageSource.gallery,
      //   maxWidth: 800,
      //   maxHeight: 600,
      //   imageQuality: 80,
      // );
      
      // if (pickedFile != null) {
      //   setState(() {
      //     _selectedImage = File(pickedFile.path);
      //   });
      // }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Funcionalidade de imagem será implementada em breve'),
          backgroundColor: Colors.orange,
        ),
      );
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

      // TODO: Implementar salvamento no Firestore
      // await vehicleService.addVehicle(vehicle);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veículo cadastrado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
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
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  String? _validateYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ano é obrigatório';
    }
    final year = int.tryParse(value.trim());
    if (year == null) {
      return 'Ano deve ser um número válido';
    }
    final currentYear = DateTime.now().year;
    if (year < 1900 || year > currentYear + 1) {
      return 'Ano deve estar entre 1900 e ${currentYear + 1}';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Preço é obrigatório';
    }
    final price = double.tryParse(value.trim().replaceAll(',', '.'));
    if (price == null || price <= 0) {
      return 'Preço deve ser um valor válido maior que zero';
    }
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
          // Header quando não há AppBar
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
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Preencha os dados do seu veículo',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          
          // Formulário
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
            // Seção da imagem
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF6A1B9A).withOpacity(0.1),
                    const Color(0xFF8E24AA).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF6A1B9A).withOpacity(0.3)),
              ),
              child: InkWell(
                onTap: _pickImage,
                borderRadius: BorderRadius.circular(16),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 48,
                      color: Color(0xFF6A1B9A),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Toque para adicionar foto',
                      style: TextStyle(
                        color: Color(0xFF6A1B9A),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Campos do formulário
            TextFormField(
              controller: _marcaController,
              decoration: const InputDecoration(
                labelText: 'Marca *',
                hintText: 'Ex: Toyota, Honda, Ford',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _validateRequired(value, 'Marca'),
              textCapitalization: TextCapitalization.words,
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _modeloController,
              decoration: const InputDecoration(
                labelText: 'Modelo *',
                hintText: 'Ex: Corolla, Civic, Focus',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _validateRequired(value, 'Modelo'),
              textCapitalization: TextCapitalization.words,
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _anoController,
                    decoration: const InputDecoration(
                      labelText: 'Ano *',
                      hintText: '2023',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateYear,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _corController,
                    decoration: const InputDecoration(
                      labelText: 'Cor *',
                      hintText: 'Ex: Branco, Preto',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => _validateRequired(value, 'Cor'),
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _precoController,
              decoration: const InputDecoration(
                labelText: 'Preço (R\$) *',
                hintText: '50000.00',
                border: OutlineInputBorder(),
                prefixText: 'R\$ ',
              ),
              validator: _validatePrice,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição *',
                hintText: 'Descreva as características do veículo',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _validateRequired(value, 'Descrição'),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            
            const SizedBox(height: 32),
            
            // Botão de salvar
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveVehicle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A1B9A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Cadastrar Veículo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              '* Campos obrigatórios',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
    );
  }
}