import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/vehicle.dart';

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

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

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

      // TODO: Implementar atualização no Firestore
      
      if (mounted) {
        Navigator.pop(context, updatedVehicle);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar veículo: ${e.toString()}'),
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
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
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
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Editar Veículo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
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
                      TextFormField(
                        controller: _marcaController,
                        decoration: const InputDecoration(
                          labelText: 'Marca *',
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
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => _validateRequired(value, 'Descrição'),
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      
                      const SizedBox(height: 32),
                      
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Salvar Alterações',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
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