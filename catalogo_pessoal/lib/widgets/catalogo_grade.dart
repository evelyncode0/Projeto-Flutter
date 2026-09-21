import 'package:flutter/material.dart';

import '../models/item_catalogo.dart';
import 'item_card.dart';

class CatalogoGrade extends StatelessWidget {
  const CatalogoGrade({
    required this.itens,
    required this.onFavoritoPressed,
    required this.onItemPressed,
    required this.onRemover,
    super.key,
  });

  final List<ItemCatalogo> itens;
  final void Function(String id) onFavoritoPressed;
  final void Function(ItemCatalogo item) onItemPressed;
  final void Function(String id) onRemover;

  @override
  Widget build(BuildContext context) {
    // Estado vazio: não existem itens para mostrar.
    if (itens.isEmpty) {
      return const Center(child: Text('Nenhum item no catálogo.'));
    }

    // Lista dinâmica de itens.
    return ListView.builder(
      itemCount: itens.length,
      itemBuilder: (context, index) {
        final item = itens[index];

        return Padding(
          key: ValueKey(item.id),
          padding: const EdgeInsets.only(bottom: 12),
          child: ItemCard(
            item: item,
            onFavoritoPressed: () {
              onFavoritoPressed(item.id);
            },
            onItemPressed: () {
              onItemPressed(item);
            },
            onRemover: () {
              onRemover(item.id);
            },
          ),
        );
      },
    );
  }
}
