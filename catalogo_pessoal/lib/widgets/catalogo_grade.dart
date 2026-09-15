import 'package:flutter/material.dart';

import '../models/item_catalogo.dart';

import 'item_card.dart';

class CatalogoGrade extends StatelessWidget {
  const CatalogoGrade({
    required this.itens,
    required this.onFavoritoPressed,
    required this.onRemover,
    required this.onItemPressed,
    super.key,
  });

  final List<ItemCatalogo> itens;

  final void Function(String id) onFavoritoPressed;

  final void Function(String id) onRemover;

  final void Function(ItemCatalogo item) onItemPressed;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: itens.length,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
      itemBuilder: (context, index) {
        final item = itens[index];

        return ItemCard(
          item: item,
          onFavoritoPressed: () {
            onFavoritoPressed(item.id);
          },
          onRemover: () {
            onRemover(item.id);
          },
          onItemPressed: () {
            onItemPressed(item);
          },
        );
      },
    );
  }
}
