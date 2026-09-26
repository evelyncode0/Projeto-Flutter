import 'package:flutter/material.dart';

import '../data/itens_iniciais.dart';
import '../models/item_catalogo.dart';
import '../widgets/catalogo_grade.dart';
import '../widgets/resumo_catalogo.dart';
import 'tela_detalhe.dart';
import 'tela_formulario.dart';

class CatalogoHome extends StatefulWidget {
  const CatalogoHome({super.key});

  @override
  State<CatalogoHome> createState() => _CatalogoHomeState();
}

class _CatalogoHomeState extends State<CatalogoHome> {
  // Lista principal de itens do catálogo.
  List<ItemCatalogo> _itens = [...itensIniciais];

  // Controla se o filtro "Favoritos" está ativado.
  bool _mostrarSomenteFavoritos = false;

  // Guarda o item que foi selecionado.
  ItemCatalogo? _itemSelecionado;

  // Quantidade de favoritos.
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

  // Abre o formulário para criar um novo item.
  Future<void> _abrirFormulario() async {
    final resultado = await Navigator.push<ItemCatalogo>(
      context,
      MaterialPageRoute<ItemCatalogo>(
        builder: (context) {
          return const TelaFormulario();
        },
      ),
    );

    if (!mounted || resultado == null) {
      return;
    }

    _aplicarResultado(resultado);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item adicionado com sucesso!')),
    );
  }

  // Abre o formulário para editar um item existente.
  Future<void> _editarItem(ItemCatalogo item) async {
    final resultado = await Navigator.push<ItemCatalogo>(
      context,
      MaterialPageRoute<ItemCatalogo>(
        builder: (context) {
          return TelaFormulario(itemInicial: item);
        },
      ),
    );

    if (!mounted || resultado == null) {
      return;
    }

    _aplicarResultado(resultado);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item atualizado com sucesso!')),
    );
  }

  // Aplica o resultado vindo do formulário.
  //
  // Se o ID já existir, substitui o item.
  // Se o ID não existir, adiciona um novo item.
  void _aplicarResultado(ItemCatalogo resultado) {
    final indice = _itens.indexWhere((item) => item.id == resultado.id);

    setState(() {
      if (indice == -1) {
        _itens = [..._itens, resultado];
      } else {
        _itens = [
          for (final item in _itens) item.id == resultado.id ? resultado : item,
        ];
      }

      // Mantém a seleção atualizada.
      if (_itemSelecionado?.id == resultado.id) {
        _itemSelecionado = resultado;
      }
    });
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

  // Abre a tela de detalhes de um item.
  Future<void> _abrirDetalhe(ItemCatalogo item) async {
    final resultado = await Navigator.push<ItemCatalogo>(
      context,
      MaterialPageRoute<ItemCatalogo>(
        builder: (context) {
          return TelaDetalhe(item: item);
        },
      ),
    );

    if (!mounted || resultado == null) {
      return;
    }

    _substituirPorId(resultado);
  }

  // Substitui um item existente pelo mesmo ID.
  void _substituirPorId(ItemCatalogo atualizado) {
    setState(() {
      _itens = _itens.map((item) {
        return item.id == atualizado.id ? atualizado : item;
      }).toList();

      // Mantém a seleção atualizada.
      if (_itemSelecionado?.id == atualizado.id) {
        _itemSelecionado = atualizado;
      }
    });
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
              onItemPressed: _selecionarItem,
              onDetalhesPressed: _abrirDetalhe,
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

                    // Botão para adicionar item.
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _abrirFormulario,
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar item'),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Expanded(child: lista),

                    const SizedBox(height: 16),

                    // Resumo também aparece no espaço menor.
                    SizedBox(
                      width: double.infinity,
                      child: ResumoCatalogo(
                        itemSelecionado: _itemSelecionado,
                        onStatusChanged: _alterarStatus,
                        onEditar: _editarItem,
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

                        // Botão para adicionar item.
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _abrirFormulario,
                            icon: const Icon(Icons.add),
                            label: const Text('Adicionar item'),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Expanded(child: lista),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Painel lateral.
                  SizedBox(
                    width: 320,
                    child: ResumoCatalogo(
                      itemSelecionado: _itemSelecionado,
                      onStatusChanged: _alterarStatus,
                      onEditar: _editarItem,
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
