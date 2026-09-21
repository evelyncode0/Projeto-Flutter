import 'package:flutter/material.dart';

import '../models/item_catalogo.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    required this.item,
    required this.onFavoritoPressed,
    required this.onItemPressed,
    required this.onRemover,
    super.key,
  });

  final ItemCatalogo item;
  final VoidCallback onFavoritoPressed;
  final VoidCallback onItemPressed;
  final VoidCallback onRemover;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onItemPressed,

        leading: Semantics(
          label: item.favorito ? 'Item favorito' : 'Item não favorito',
          child: IconButton(
            tooltip: 'Alternar favorito',
            onPressed: onFavoritoPressed,
            icon: Icon(item.favorito ? Icons.favorite : Icons.bookmark_border),
          ),
        ),

        title: Text(item.titulo),

        subtitle: Text(item.descricaoExibicao),

        trailing: IconButton(
          tooltip: 'Remover item',
          onPressed: onRemover,
          icon: const Icon(Icons.delete_outline),
        ),
      ),
    );
  }
}
