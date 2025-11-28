
class Equipamento {
  final String id;
  final String nome;
  final String code;
  final int quantidade;
  final String marca;
  final String descricao;
  final List<String> categorias;
  final String imageUrl; // nunca nulo
  int visualizacao; 

  Equipamento({
    required this.id,
    required this.nome,
    required this.code,
    required this.quantidade,
    required this.marca,
    required this.descricao,
    required this.categorias,
    required this.imageUrl,
    this.visualizacao = 0
  });

  Map<String, dynamic> toMap() {
    return {
      'visualizacao': visualizacao,
      'nome': nome,
      'code': code,
      'quantidade': quantidade,
      'marca': marca,
      'descricao': descricao,
      'categorias': categorias,
      'imageUrl': imageUrl,
    };
  }

  Equipamento copyWith({
    String? id,
    String? nome,
    String? code,
    int? quantidade,
    String? marca,
    String? descricao,
    List<String>? categorias,
    String? imageUrl,
    int? visualizacao,
  }) {
    return Equipamento(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      code: code ?? this.code,
      quantidade: quantidade ?? this.quantidade,
      marca: marca ?? this.marca,
      descricao: descricao ?? this.descricao,
      categorias: categorias ?? this.categorias,
      imageUrl: imageUrl ?? this.imageUrl,
      visualizacao: visualizacao ?? this.visualizacao,
    );
  }

  /// 🔥 Recebe o ID do doc + o mapa dos dados
  factory Equipamento.fromFirestore(String id, Map<String, dynamic> map) {
    return Equipamento(
      id: id,
      nome: map['nome'] ?? '',
      code: map['code'] ?? '',
      visualizacao: map['visualizacao'] ?? 0,
      quantidade: map['quantidade'] ?? 0,
      marca: map['marca'] ?? '',
      descricao: map['descricao'] ?? '',
      categorias: List<String>.from(map['categorias'] ?? []),
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
