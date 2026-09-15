import 'package:flutter/material.dart';

import '../data/itens_iniciais.dart';

import '../models/item_catalogo.dart';

import '../widgets/catalogo_grade.dart';

import '../widgets/resumo_catalogo.dart';

class CatalogoHome extends StatefulWidget {
  const CatalogoHome({super.key});

  @override
  State<CatalogoHome> createState() => _CatalogoHomeState();
}

class _CatalogoHomeState extends State<CatalogoHome> {
  final TextEditingController _tituloController = TextEditingController();

  List<ItemCatalogo> _itens = [...itensIniciais];

  bool _mostrarSomenteFavoritos = false;

  ItemCatalogo? _itemSelecionado;

  int get _totalFavoritos => _itens.where((item) => item.favorito).length;

  // ==========================================
  // FAVORITO
  // ==========================================

  void _alternarFavorito(String id) {
    setState(() {
      _itens = [
        for (final item in _itens)
          if (item.id == id) item.copyWith(favorito: !item.favorito) else item,
      ];

      if (_itemSelecionado?.id == id) {
        _itemSelecionado = _itens.firstWhere((item) => item.id == id);
      }
    });
  }

  // ==========================================
  // FILTRO
  // ==========================================

  void _alternarFiltroFavoritos() {
    setState(() {
      _mostrarSomenteFavoritos = !_mostrarSomenteFavoritos;
    });
  }

  // ==========================================
  // SELEÇÃO
  // ==========================================

  void _selecionarItem(ItemCatalogo item) {
    setState(() {
      _itemSelecionado = item;
    });
  }

  // ==========================================
  // ADICIONAR
  // ==========================================

  void _adicionarItem() {
    final titulo = _tituloController.text.trim();

    if (titulo.isEmpty) {
      return;
    }

    final novoItem = ItemCatalogo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: titulo,
      status: StatusItem.queroConhecer,
    );

    setState(() {
      _itens = [..._itens, novoItem];
    });

    _tituloController.clear();
  }

  // ==========================================
  // ALTERAR STATUS
  // ==========================================

  void _alterarStatus(String id, StatusItem novoStatus) {
    setState(() {
      _itens = [
        for (final item in _itens)
          if (item.id == id) item.copyWith(status: novoStatus) else item,
      ];

      if (_itemSelecionado?.id == id) {
        _itemSelecionado = _itens.firstWhere((item) => item.id == id);
      }
    });
  }

  // ==========================================
  // REMOVER
  // ==========================================

  void _remover(String id) {
    setState(() {
      _itens = [
        for (final item in _itens)
          if (item.id != id) item,
      ];

      if (_itemSelecionado?.id == id) {
        _itemSelecionado = null;
      }
    });
  }

  // ==========================================
  // CICLO DE VIDA
  // ==========================================

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final itensVisiveis = _mostrarSomenteFavoritos
        ? _itens.where((item) => item.favorito).toList()
        : _itens;

    return Scaffold(
      appBar: AppBar(title: const Text('Meu catálogo')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final lista = CatalogoGrade(
              itens: itensVisiveis,
              onFavoritoPressed: _alternarFavorito,
              onRemover: _remover,
              onItemPressed: _selecionarItem,
            );

            // ==========================================
            // ESPAÇO MENOR
            // ==========================================

            if (constraints.maxWidth < 900) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Seus itens: ${_itens.length}',
                            style: textTheme.headlineSmall,
                          ),
                        ),
                        Text(
                          'Favoritos: $_totalFavoritos',
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 12),
                        FilterChip(
                          label: const Text('Favoritos'),
                          selected: _mostrarSomenteFavoritos,
                          onSelected: (selecionado) {
                            _alternarFiltroFavoritos();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _tituloController,
                            decoration: const InputDecoration(
                              labelText: 'Título',
                              hintText: 'Digite o nome do item',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (_) {
                              _adicionarItem();
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _adicionarItem,
                          child: const Text('Adicionar'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Expanded(child: lista),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: 320,
                      child: ResumoCatalogo(
                        itemSelecionado: _itemSelecionado,
                        onStatusChanged: _alterarStatus,
                      ),
                    ),
                  ],
                ),
              );
            }

            // ==========================================
            // ESPAÇO MAIOR
            // ==========================================

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Seus itens: ${_itens.length}',
                                style: textTheme.headlineSmall,
                              ),
                            ),
                            Text(
                              'Favoritos: $_totalFavoritos',
                              style: textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 12),
                            FilterChip(
                              label: const Text('Favoritos'),
                              selected: _mostrarSomenteFavoritos,
                              onSelected: (selecionado) {
                                _alternarFiltroFavoritos();
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _tituloController,
                                decoration: const InputDecoration(
                                  labelText: 'Título',
                                  hintText: 'Digite o nome do item',
                                  border: OutlineInputBorder(),
                                ),
                                onSubmitted: (_) {
                                  _adicionarItem();
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _adicionarItem,
                              child: const Text('Adicionar'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Expanded(child: lista),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  SizedBox(
                    width: 320,
                    child: ResumoCatalogo(
                      itemSelecionado: _itemSelecionado,
                      onStatusChanged: _alterarStatus,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
