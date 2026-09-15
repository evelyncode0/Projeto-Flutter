import 'package:flutter/material.dart';

import '../models/item_catalogo.dart';

class ResumoCatalogo extends StatelessWidget {
  const ResumoCatalogo({
    required this.itemSelecionado,
    required this.onStatusChanged,
    super.key,
  });

  final ItemCatalogo? itemSelecionado;

  final void Function(String id, StatusItem novoStatus) onStatusChanged;

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

              Text('Status:', style: textTheme.titleSmall),

              const SizedBox(height: 4),

              DropdownButton<StatusItem>(
                value: itemSelecionado!.status,
                isExpanded: true,
                items: StatusItem.values.map((status) {
                  return DropdownMenuItem<StatusItem>(
                    value: status,
                    child: Text(_nomeStatus(status)),
                  );
                }).toList(),
                onChanged: (novoStatus) {
                  if (novoStatus == null) {
                    return;
                  }

                  onStatusChanged(itemSelecionado!.id, novoStatus);
                },
              ),

              const SizedBox(height: 8),

              Text(
                itemSelecionado!.favorito ? '❤️ Favorito' : '♡ Não favorito',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
