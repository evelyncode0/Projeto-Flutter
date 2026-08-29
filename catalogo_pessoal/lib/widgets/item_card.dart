import 'package:flutter/material.dart';

import '../models/item_catalogo.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({required this.item, super.key});

  final ItemCatalogo item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Semantics(
          label: item.favorito ? 'Item favorito' : 'Item não favorito',
          child: Icon(item.favorito ? Icons.favorite : Icons.bookmark_border),
        ),
        title: Text(item.titulo),
        subtitle: Text(item.descricaoExibicao),
      ),
    );
  }
}
