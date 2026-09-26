import 'package:flutter/material.dart';

import '../models/item_catalogo.dart';

class ResumoCatalogo extends StatelessWidget {
  const ResumoCatalogo({
    required this.itemSelecionado,
    required this.onEditar,
    super.key,
  });

  final ItemCatalogo? itemSelecionado;
  final void Function(ItemCatalogo item) onEditar;

  String _nomeStatus(StatusItem status) {
    switch (status) {
      case StatusItem.queroConhecer:
        return 'Quero conhecer';
      case StatusItem.emAndamento:
        return 'Em andamento';
      case StatusItem.concluido:
        return 'Concluído';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumo', style: textTheme.titleLarge),
            const SizedBox(height: 8),

            if (itemSelecionado == null) ...[
              const Text('Selecione um item para ver os detalhes.'),
            ] else ...[
              Text(itemSelecionado!.titulo, style: textTheme.titleMedium),

              const SizedBox(height: 8),

              Text(itemSelecionado!.descricaoExibicao),

              const SizedBox(height: 16),

              Text('Status: ${_nomeStatus(itemSelecionado!.status)}'),

              const SizedBox(height: 8),

              Text(
                itemSelecionado!.favorito ? '❤️ Favorito' : '♡ Não favorito',
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    onEditar(itemSelecionado!);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar item'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
