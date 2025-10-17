class Vehicle {
  final String? id;
  final String marca;
  final String modelo;
  final int ano;
  final String cor;
  final double preco;
  final String descricao;
  final String? imagemUrl;
  final DateTime? dataCadastro;

  Vehicle({
    this.id,
    required this.marca,
    required this.modelo,
    required this.ano,
    required this.cor,
    required this.preco,
    required this.descricao,
    this.imagemUrl,
    this.dataCadastro,
  });

  // Converter para Map (para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'marca': marca,
      'modelo': modelo,
      'ano': ano,
      'cor': cor,
      'preco': preco,
      'descricao': descricao,
      'imagemUrl': imagemUrl,
      'dataCadastro': dataCadastro?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  // Criar a partir de Map (do Firestore)
  factory Vehicle.fromMap(Map<String, dynamic> map, String id) {
    return Vehicle(
      id: id,
      marca: map['marca'] ?? '',
      modelo: map['modelo'] ?? '',
      ano: map['ano']?.toInt() ?? 0,
      cor: map['cor'] ?? '',
      preco: map['preco']?.toDouble() ?? 0.0,
      descricao: map['descricao'] ?? '',
      imagemUrl: map['imagemUrl'],
      dataCadastro: map['dataCadastro'] != null 
          ? DateTime.parse(map['dataCadastro'])
          : null,
    );
  }

  // Criar cópia com modificações
  Vehicle copyWith({
    String? id,
    String? marca,
    String? modelo,
    int? ano,
    String? cor,
    double? preco,
    String? descricao,
    String? imagemUrl,
    DateTime? dataCadastro,
  }) {
    return Vehicle(
      id: id ?? this.id,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      ano: ano ?? this.ano,
      cor: cor ?? this.cor,
      preco: preco ?? this.preco,
      descricao: descricao ?? this.descricao,
      imagemUrl: imagemUrl ?? this.imagemUrl,
      dataCadastro: dataCadastro ?? this.dataCadastro,
    );
  }

  @override
  String toString() {
    return 'Vehicle(id: $id, marca: $marca, modelo: $modelo, ano: $ano, cor: $cor, preco: $preco)';
  }
}