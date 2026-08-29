import 'package:flutter/material.dart';

import '../data/itens_iniciais.dart';
import '../widgets/catalogo_grade.dart';
import '../widgets/resumo_catalogo.dart';

class CatalogoHome extends StatelessWidget {
  const CatalogoHome({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Meu catálogo')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final lista = CatalogoGrade(itens: itensIniciais);

            if (constraints.maxWidth < 900) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Seus itens', style: textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    Expanded(child: lista),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Seus itens', style: textTheme.headlineSmall),
                        const SizedBox(height: 12),
                        Expanded(child: lista),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const SizedBox(width: 320, child: ResumoCatalogo()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
