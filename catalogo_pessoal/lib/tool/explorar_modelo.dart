import '../data/itens_iniciais.dart';

void main() {
  final favoritos = itensIniciais
      .where((item) => item.favorito)
      .toList(growable: false);

  final titulos = favoritos.map((item) => item.titulo).toList(growable: false);

  print('Favoritos:');

  for (final titulo in titulos) {
    print('- $titulo');
  }

  print('\nDescrições:');

  for (final item in itensIniciais) {
    print('${item.titulo}: ${item.descricaoExibicao}');
  }
}
