import 'package:flutter/material.dart';

import '../data/itens_iniciais.dart';

import '../models/item_catalogo.dart';

import '../widgets/catalogo_grade.dart';

import '../widgets/resumo_catalogo.dart';

import 'tela_detalhe.dart';

class CatalogoHome extends StatefulWidget {
  const CatalogoHome({super.key});

  @override
  State<CatalogoHome> createState() => _CatalogoHomeState();
}

class _CatalogoHomeState extends State<CatalogoHome> {
  // Controller usado para controlar o campo de texto.
  final TextEditingController _tituloController = TextEditingController();

  // Lista principal de itens do catálogo.
  List<ItemCatalogo> _itens = [...itensIniciais];

  // Controla se o filtro "Favoritos" está ativado.
  bool _mostrarSomenteFavoritos = false;

  // Guarda o item que foi selecionado.
  ItemCatalogo? _itemSelecionado;

  // Valor derivado:
  // calcula a quantidade de favoritos a partir de _itens.
  int get _totalFavoritos => _itens.where((item) => item.favorito).length;

  // Alterna o favorito de um item usando o ID.
  void _alternarFavorito(String id) {
    setState(() {
      _itens = [
        for (final item in _itens)
          if (item.id == id) item.copyWith(favorito: !item.favorito) else item,
      ];

      // Mantém o item selecionado atualizado.
      if (_itemSelecionado?.id == id) {
        _itemSelecionado = _itens.firstWhere((item) => item.id == id);
      }
    });
  }

  // Ativa ou desativa o filtro de favoritos.
  void _alternarFiltroFavoritos() {
    setState(() {
      _mostrarSomenteFavoritos = !_mostrarSomenteFavoritos;
    });
  }

  // Seleciona um item do catálogo.
  void _selecionarItem(ItemCatalogo item) {
    setState(() {
      _itemSelecionado = item;
    });
  }

  // Adiciona um novo item ao catálogo.
  void _adicionarItem() {
    final titulo = _tituloController.text.trim();

    // Não adiciona se o título estiver vazio.
    if (titulo.isEmpty) {
      return;
    }

    final novoItem = ItemCatalogo(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      titulo: titulo,
      status: StatusItem.queroConhecer,
    );

    setState(() {
      _itens = [..._itens, novoItem];
    });

    // Limpa o campo depois da inclusão.
    _tituloController.clear();
  }

  // Altera o status de um item usando o ID.
  void _alterarStatus(String id, StatusItem novoStatus) {
    setState(() {
      _itens = [
        for (final item in _itens)
          if (item.id == id) item.copyWith(status: novoStatus) else item,
      ];

      // Atualiza também o item selecionado.
      if (_itemSelecionado?.id == id) {
        _itemSelecionado = _itens.firstWhere((item) => item.id == id);
      }
    });
  }

  // Remove um item usando o ID.
  void _remover(String id) {
    setState(() {
      _itens = _itens.where((item) => item.id != id).toList();

      // Se o item removido estava selecionado,
      // limpa a seleção.
      if (_itemSelecionado?.id == id) {
        _itemSelecionado = null;
      }
    });
  }

  Future<void> _abrirDetalhe(ItemCatalogo item) async {
    final resultado = await Navigator.push<ItemCatalogo>(
      context,
      MaterialPageRoute<ItemCatalogo>(
        builder: (context) {
          return TelaDetalhe(item: item);
        },
      ),
    );

    if (resultado == null) {
      return;
    }

    _substituirPorId(resultado);
  }

  void _substituirPorId(ItemCatalogo atualizado) {
    setState(() {
      _itens = _itens.map((item) {
        return item.id == atualizado.id ? atualizado : item;
      }).toList();
    });
  }

  // Libera o controller quando a tela deixa de existir.
  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Lista derivada de acordo com o filtro.
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
              onItemPressed: _abrirDetalhe,
              onRemover: _remover,
            );

            // ==========================================
            // LAYOUT PARA ESPAÇOS MENORES
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
            // LAYOUT PARA ESPAÇOS MAIORES
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
