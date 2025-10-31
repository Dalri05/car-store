import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/vehicle_service.dart';

import '../models/vehicle.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/vehicle_edit_modal.dart';

class VehicleListScreen extends StatefulWidget {
  final bool showAppBar;
  
  const VehicleListScreen({super.key, this.showAppBar = true});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  List<Vehicle> vehicles = [];
  List<Vehicle> filteredVehicles = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedBrand = 'Todas';
  final TextEditingController _searchController = TextEditingController();

  late VehicleService _vehicleService;
  
  bool _isListenerInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVehicles();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (!_isListenerInitialized) {
      // Obtenha a instância do serviço
      _vehicleService = Provider.of<VehicleService>(context, listen: false);
      
      // Adicione um ouvinte
      _vehicleService.addListener(_onVehicleListChanged);
      
      _isListenerInitialized = true; // Marque como inicializado
    }
  }

  @override
  void dispose() {
    if (_isListenerInitialized) {
      _vehicleService.removeListener(_onVehicleListChanged);
    }
    _searchController.dispose();
    super.dispose();
  }

  void _onVehicleListChanged() {
    if (mounted) {
      _loadVehicles();
    }
  }


  Future<void> _loadVehicles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final vehicleService = context.read<VehicleService>();
      vehicles = await vehicleService.getVehicles();
      
      _applyFilters();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar veículos: ${e.toString()}'),
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

  void _applyFilters() {
    filteredVehicles = vehicles.where((vehicle) {
      final matchesSearch = _searchQuery.isEmpty ||
          vehicle.marca.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          vehicle.modelo.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesBrand = _selectedBrand == 'Todas' || vehicle.marca == _selectedBrand;
      
      return matchesSearch && matchesBrand;
    }).toList();
    
    setState(() {}); // Aplica o filtro na UI
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  void _onBrandChanged(String? brand) {
    setState(() {
      _selectedBrand = brand ?? 'Todas';
    });
    _applyFilters();
  }

  List<String> get _availableBrands {
    final brands = vehicles.map((v) => v.marca).toSet().toList();
    brands.sort();
    return ['Todas', ...brands];
  }

  Future<void> _editVehicle(Vehicle vehicle) async {
    final bool? vehicleWasUpdated = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VehicleEditModal(vehicle: vehicle),
    );

    if (mounted && (vehicleWasUpdated == true || vehicleWasUpdated == null)) { 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lista de veículos atualizada!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _deleteVehicle(Vehicle vehicle) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja excluir o ${vehicle.marca} ${vehicle.modelo}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final vehicleService = context.read<VehicleService>();
        await vehicleService.deleteVehicle(vehicle);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Veículo excluído com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir veículo: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // TODO: Implementar logout do Firebase com AuthService
      // final authService = context.read<AuthService>();
      // await authService.signOut();
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: widget.showAppBar ? AppBar(
        title: const Text('Meus Veículos'),
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ) : null,
      body: Column(
        children: [
          // Header com título quando não há AppBar
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Meus Veículos',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: _logout,
                        icon: const Icon(Icons.logout, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${filteredVehicles.length} veículos encontrados',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          
          // Barra de pesquisa e filtros
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Campo de pesquisa
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Buscar por marca ou modelo...',
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF6A1B9A)),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF6A1B9A)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Filtro por marca
                Row(
                  children: [
                    const Icon(Icons.filter_list, color: Color(0xFF6A1B9A)),
                    const SizedBox(width: 8),
                    const Text(
                      'Marca:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6A1B9A),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedBrand,
                        onChanged: _onBrandChanged,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: _availableBrands.map((brand) {
                          return DropdownMenuItem(
                            value: brand,
                            child: Text(brand),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Lista de veículos
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredVehicles.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _searchQuery.isNotEmpty || _selectedBrand != 'Todas'
                                  ? Icons.search_off
                                  : Icons.directions_car_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isNotEmpty || _selectedBrand != 'Todas'
                                  ? 'Nenhum veículo encontrado'
                                  : 'Nenhum veículo cadastrado',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _searchQuery.isNotEmpty || _selectedBrand != 'Todas'
                                  ? 'Tente ajustar os filtros'
                                  : 'Toque em "Cadastrar" para adicionar seu primeiro veículo',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadVehicles,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredVehicles.length,
                          itemBuilder: (context, index) {
                            final vehicle = filteredVehicles[index];
                            return VehicleCard(
                              vehicle: vehicle,
                              onEdit: () => _editVehicle(vehicle),
                              onDelete: () => _deleteVehicle(vehicle),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: widget.showAppBar ? FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-vehicle').then((_) {
          });
        },
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ) : null,
    );
  }
}