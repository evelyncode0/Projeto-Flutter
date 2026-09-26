enum StatusItem { queroConhecer, emAndamento, concluido }

class ItemCatalogo {
  final String id;
  final String titulo;
  final String? descricao;
  final String categoria;
  final StatusItem status;
  final bool favorito;

  const ItemCatalogo({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.status,
    this.descricao,
    this.favorito = false,
  });

  ItemCatalogo copyWith({
    String? id,
    String? titulo,
    String? descricao,
    String? categoria,
    StatusItem? status,
    bool? favorito,
  }) {
    return ItemCatalogo(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      categoria: categoria ?? this.categoria,
      status: status ?? this.status,
      favorito: favorito ?? this.favorito,
    );
  }

  String get descricaoExibicao {
    final texto = descricao?.trim();

    return texto == null || texto.isEmpty ? 'Sem descricao' : texto;
  }

  bool get tituloValido => titulo.trim().length >= 2;
}
