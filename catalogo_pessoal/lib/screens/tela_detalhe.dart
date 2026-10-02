import 'package:flutter/material.dart';

import '../models/item_catalogo.dart';

class TelaDetalhe extends StatefulWidget {
  const TelaDetalhe({required this.item, super.key});

  final ItemCatalogo item;

  @override
  State<TelaDetalhe> createState() => _TelaDetalheState();
}

class _TelaDetalheState extends State<TelaDetalhe> {
  late StatusItem _status;

  @override
  void initState() {
    super.initState();

    _status = widget.item.status;
  }

  void _salvar() {
    final itemAtualizado = widget.item.copyWith(status: _status);

    Navigator.pop(context, itemAtualizado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do curso')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item.titulo,
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 16),

            Text(widget.item.descricaoExibicao),

            const SizedBox(height: 24),

            Text('Status', style: Theme.of(context).textTheme.titleMedium),

            const SizedBox(height: 8),

            DropdownButtonFormField<StatusItem>(
              initialValue: _status,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Status do curso',
              ),
              items: StatusItem.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(_nomeStatus(status)),
                );
              }).toList(),
              onChanged: (novoStatus) {
                if (novoStatus == null) {
                  return;
                }

                setState(() {
                  _status = novoStatus;
                });
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _salvar,
                child: const Text('Salvar alteração'),
              ),
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
}
