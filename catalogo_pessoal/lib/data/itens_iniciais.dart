import '../models/item_catalogo.dart';

const itensIniciais = <ItemCatalogo>[
  ItemCatalogo(
    id: 'livro-001',
    titulo: 'Clean Code',
    descricao: 'Praticas para codigo legivel',
    status: StatusItem.emAndamento,
    favorito: true,
  ),

  ItemCatalogo(
    id: 'item-002',
    titulo: 'Dart em Prática',
    descricao: 'Material para estudar Dart.',
    status: StatusItem.queroConhecer,
  ),

  //item sem descricao para teste
  ItemCatalogo(
    id: 'item-003',
    titulo: 'Flutter Essencial',
    status: StatusItem.concluido,
  ),

  ItemCatalogo(
    id: 'item-004',
    titulo: 'Desenvolvimento Mobile',
    descricao: 'Conteúdo da faculdade.',
    status: StatusItem.emAndamento,
  ),
];
