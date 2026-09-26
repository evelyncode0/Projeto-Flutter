import 'package:flutter/material.dart';

import '../models/item_catalogo.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    required this.item,
    required this.onFavoritoPressed,
    required this.onItemPressed,
    required this.onDetalhesPressed,
    required this.onRemover,
    super.key,
  });

  final ItemCatalogo item;
  final VoidCallback onFavoritoPressed;
  final VoidCallback onItemPressed;
  final VoidCallback onDetalhesPressed;
  final VoidCallback onRemover;

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
          icon: Icon(item.favorito ? Icons.favorite : Icons.bookmark_border),
        ),

        title: Text(item.titulo),

        subtitle: Text(item.descricaoExibicao),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Ver detalhes',
              onPressed: onDetalhesPressed,
              icon: const Icon(Icons.info_outline),
            ),
            IconButton(
              tooltip: 'Remover item',
              onPressed: onRemover,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}
