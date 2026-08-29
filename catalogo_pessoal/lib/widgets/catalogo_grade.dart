import 'package:flutter/material.dart';

import '../models/item_catalogo.dart';
import 'item_card.dart';

class CatalogoGrade extends StatelessWidget {
  const CatalogoGrade({required this.itens, super.key});

  final List<ItemCatalogo> itens;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: itens.length,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
      itemBuilder: (context, index) {
        return ItemCard(item: itens[index]);
      },
    );
  }
}
