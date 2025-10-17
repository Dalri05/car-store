class AppUser {
  final String id;
  final String email;
  final String? nome;
  final String? fotoUrl;
  final DateTime? ultimoLogin;

  AppUser({
    required this.id,
    required this.email,
    this.nome,
    this.fotoUrl,
    this.ultimoLogin,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'nome': nome,
      'fotoUrl': fotoUrl,
      'ultimoLogin': ultimoLogin?.toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      nome: map['nome'],
      fotoUrl: map['fotoUrl'],
      ultimoLogin: map['ultimoLogin'] != null 
          ? DateTime.parse(map['ultimoLogin'])
          : null,
    );
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? nome,
    String? fotoUrl,
    DateTime? ultimoLogin,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      nome: nome ?? this.nome,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      ultimoLogin: ultimoLogin ?? this.ultimoLogin,
    );
  }
}