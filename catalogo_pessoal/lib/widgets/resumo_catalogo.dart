import 'package:flutter/material.dart';

class ResumoCatalogo extends StatelessWidget {
  const ResumoCatalogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumo', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text('Confira seus itens do catálogo.'),
          ],
        ),
      ),
    );
  }
}
