import 'package:flutter/material.dart';

import '../data/itens_iniciais.dart';
import '../widgets/item_card.dart';

class CatalogoHome extends StatelessWidget {
  const CatalogoHome({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Meu catálogo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Seus itens', style: textTheme.headlineSmall),

            const SizedBox(height: 12),

            for (final item in itensIniciais) ItemCard(item: item),
          ],
        ),
      ),
    );
  }
}
