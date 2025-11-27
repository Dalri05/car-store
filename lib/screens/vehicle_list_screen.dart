import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/vehicle.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/vehicle_edit_modal.dart';
import '../providers/vehicle_provider.dart';
import '../services/auth_service.dart';

class VehicleListScreen extends StatefulWidget {
  final bool showAppBar;
  
  const VehicleListScreen({super.key, this.showAppBar = true});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  String _searchQuery = '';
  String _selectedBrand = 'Todas';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onBrandChanged(String? brand) {
    setState(() {
      _selectedBrand = brand ?? 'Todas';
    });
  }

  Future<void> _editVehicle(Vehicle vehicle) async {
    final result = await showModalBottomSheet<Vehicle>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VehicleEditModal(vehicle: vehicle),
    );

    if (result != null && mounted) {
      try {
        await Provider.of<VehicleProvider>(context, listen: false).updateVehicle(result);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veículo atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar veículo: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
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

    if (confirm == true && mounted) {
      try {
        await Provider.of<VehicleProvider>(context, listen: false)
            .deleteVehicle(vehicle.id!, vehicle.imagemUrl);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veículo excluído!'), backgroundColor: Colors.green),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir veículo: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
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

    if (confirm == true && mounted) {
      Provider.of<VehicleProvider>(context, listen: false).unsubscribe();
      await Provider.of<AuthService>(context, listen: false).signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VehicleProvider>(
      builder: (context, vehicleProvider, child) {
        final filteredVehicles = vehicleProvider.getFilteredVehicles(_searchQuery, _selectedBrand);
        final availableBrands = vehicleProvider.availableBrands;
        
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
              
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  children: [
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
                            items: availableBrands.map((brand) {
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
              
              Expanded(
                child: vehicleProvider.isLoading
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
                                      : 'Toque em + para adicionar seu primeiro veículo',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                            },
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
              Navigator.pushNamed(context, '/add-vehicle');
            },
            backgroundColor: const Color(0xFF6A1B9A),
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
          ) : null,
        );
      },
    );
  }
}