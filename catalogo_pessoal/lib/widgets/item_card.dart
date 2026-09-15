import 'package:flutter/material.dart';

import '../models/item_catalogo.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    required this.item,
    required this.onFavoritoPressed,
    required this.onRemover,
    required this.onItemPressed,
    super.key,
  });

  final ItemCatalogo item;

  final VoidCallback onFavoritoPressed;

  final VoidCallback onRemover;

  final VoidCallback onItemPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onItemPressed,

        leading: IconButton(
          tooltip: item.favorito
              ? 'Remover dos favoritos'
              : 'Adicionar aos favoritos',
          onPressed: onFavoritoPressed,
          icon: Icon(item.favorito ? Icons.favorite : Icons.favorite_border),
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
