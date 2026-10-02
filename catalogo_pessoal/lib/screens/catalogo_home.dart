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
  // Lista principal de cursos do catálogo.
  List<ItemCatalogo> _itens = [...itensIniciais];

  // Controla se o filtro "Favoritos" está ativado.
  bool _mostrarSomenteFavoritos = false;

  // Guarda o curso que foi selecionado.
  ItemCatalogo? _itemSelecionado;

  // Quantidade de favoritos.
  int get _totalFavoritos => _itens.where((item) => item.favorito).length;

  // Alterna o favorito de um curso usando o ID.
  void _alternarFavorito(String id) {
    setState(() {
      _itens = [
        for (final item in _itens)
          if (item.id == id) item.copyWith(favorito: !item.favorito) else item,
      ];

      // Mantém o curso selecionado atualizado.
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

  // Seleciona um curso do catálogo.
  void _selecionarItem(ItemCatalogo item) {
    setState(() {
      _itemSelecionado = item;
    });
  }

  // Abre o formulário para criar um novo curso.
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
      const SnackBar(content: Text('Curso adicionado com sucesso!')),
    );
  }

  // Abre o formulário para editar um curso existente.
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
      const SnackBar(content: Text('Curso atualizado com sucesso!')),
    );
  }

  // Aplica o resultado vindo do formulário.
  //
  // Se o ID já existir, substitui o curso.
  // Se o ID não existir, adiciona um novo curso.
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

  // Remove um curso usando o ID.
  void _remover(String id) {
    setState(() {
      _itens = _itens.where((item) => item.id != id).toList();

      // Se o curso removido estava selecionado,
      // limpa a seleção.
      if (_itemSelecionado?.id == id) {
        _itemSelecionado = null;
      }
    });
  }

  // Abre a tela de detalhes de um curso.
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

  // Substitui um curso existente pelo mesmo ID.
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

  // Exibe uma mensagem quando não existem cursos para mostrar.
  Widget _estadoVazio(TextTheme textTheme) {
    final nenhumCursoCadastrado = _itens.isEmpty;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school_outlined, size: 64),
          const SizedBox(height: 16),
          Text(
            nenhumCursoCadastrado
                ? 'Nenhum curso cadastrado'
                : 'Nenhum curso favorito',
            style: textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            nenhumCursoCadastrado
                ? 'Adicione seu primeiro curso para começar.'
                : 'Marque um curso como favorito para vê-lo aqui.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Lista derivada de acordo com o filtro.
    final itensVisiveis = _mostrarSomenteFavoritos
        ? _itens.where((item) => item.favorito).toList()
        : _itens;

    final lista = CatalogoGrade(
      itens: itensVisiveis,
      onFavoritoPressed: _alternarFavorito,
      onItemPressed: _selecionarItem,
      onDetalhesPressed: _abrirDetalhe,
      onRemover: _remover,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Meu catálogo de cursos')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
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
                            'Seus cursos: ${_itens.length}',
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

                    // Botão para adicionar curso.
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _abrirFormulario,
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar curso'),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Mostra a lista ou o estado vazio.
                    Expanded(
                      child: itensVisiveis.isEmpty
                          ? _estadoVazio(textTheme)
                          : lista,
                    ),

                    const SizedBox(height: 16),

                    // Resumo também aparece no espaço menor.
                    SizedBox(
                      width: double.infinity,
                      child: ResumoCatalogo(
                        itemSelecionado: _itemSelecionado,
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
                                'Seus cursos: ${_itens.length}',
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

                        // Botão para adicionar curso.
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _abrirFormulario,
                            icon: const Icon(Icons.add),
                            label: const Text('Adicionar curso'),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Mostra a lista ou o estado vazio.
                        Expanded(
                          child: itensVisiveis.isEmpty
                              ? _estadoVazio(textTheme)
                              : lista,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Painel lateral.
                  SizedBox(
                    width: 320,
                    child: ResumoCatalogo(
                      itemSelecionado: _itemSelecionado,
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
