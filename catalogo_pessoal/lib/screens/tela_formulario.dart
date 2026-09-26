import 'package:flutter/material.dart';

import '../models/item_catalogo.dart';

class TelaFormulario extends StatefulWidget {
  const TelaFormulario({super.key, this.itemInicial});

  final ItemCatalogo? itemInicial;

  bool get editando => itemInicial != null;

  @override
  State<TelaFormulario> createState() => _TelaFormularioState();
}

class _TelaFormularioState extends State<TelaFormulario> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _tituloController;
  late final TextEditingController _categoriaController;
  late final TextEditingController _descricaoController;

  final _categoriaFocus = FocusNode();
  final _descricaoFocus = FocusNode();

  bool _submetendo = false;

  @override
  void initState() {
    super.initState();

    final item = widget.itemInicial;

    _tituloController = TextEditingController(text: item?.titulo ?? '');

    _categoriaController = TextEditingController(text: item?.categoria ?? '');
    _descricaoController = TextEditingController(text: item?.descricao ?? '');
  }

  String? _validarTitulo(String? valor) {
    final texto = valor?.trim() ?? '';

    if (texto.isEmpty) {
      return 'Informe o título';
    }

    if (texto.length < 3) {
      return 'Use pelo menos 3 caracteres';
    }

    return null;
  }

  String? _validarCategoria(String? valor) {
    final texto = valor?.trim() ?? '';

    if (texto.isEmpty) {
      return 'Informe a categoria';
    }

    if (texto.length < 3) {
      return 'Use pelo menos 3 caracteres';
    }

    return null;
  }

  ItemCatalogo _construirResultado() {
    final inicial = widget.itemInicial;

    return ItemCatalogo(
      id: inicial?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      titulo: _tituloController.text.trim(),
      categoria: _categoriaController.text.trim(),
      status: inicial?.status ?? StatusItem.queroConhecer,
      descricao: _descricaoController.text.trim().isEmpty
          ? null
          : _descricaoController.text.trim(),
      favorito: inicial?.favorito ?? false,
    );
  }

  void _salvar() {
    if (_submetendo) {
      return;
    }

    final valido = _formKey.currentState?.validate() ?? false;

    if (!valido) {
      return;
    }

    setState(() {
      _submetendo = true;
    });

    Navigator.pop(context, _construirResultado());
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _categoriaController.dispose();
    _descricaoController.dispose();
    _categoriaFocus.dispose();
    _descricaoFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editando ? 'Editar item' : 'Novo item'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _tituloController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    hintText: 'Digite o título do item',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validarTitulo,
                  onFieldSubmitted: (_) {
                    _categoriaFocus.requestFocus();
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _categoriaController,
                  focusNode: _categoriaFocus,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    hintText: 'Ex.: Livro, Filme, Série',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validarCategoria,
                  onFieldSubmitted: (_) {
                    _descricaoFocus.requestFocus();
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _descricaoController,
                  focusNode: _descricaoFocus,
                  minLines: 3,
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    hintText: 'Adicione detalhes sobre o item (opcional)',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 24),

                FilledButton.icon(
                  onPressed: _submetendo ? null : _salvar,
                  icon: const Icon(Icons.save),
                  label: Text(
                    widget.editando ? 'Salvar alterações' : 'Criar item',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
